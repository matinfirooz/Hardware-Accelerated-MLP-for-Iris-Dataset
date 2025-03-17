`timescale 1ns/1ns
//////////////////////////////////////////////////////////////////////////////////
// Course: Hardware-Accelerators
// Engineer: Matin Firoozbakht
// Module Name: topmodule
// Project Name: Hardware-Accelerated MLP for Iris Dataset
//////////////////////////////////////////////////////////////////////////////////
module topmodule #(
  parameter PORTS = 8
) (
  input clk,
  input rst,
  input init,
  input operate,
  input [2:0] num_layers,
  input [31:0] layer_sizes,
  input [31:0] input_shift_in,
  input [PORTS*32-1:0] wb_shift_in
);

  wire [7:0] mem_page_ens;
  wire [31:0] left_input;
  wire [31:0] right_output;
  wire [31:0] input_shift_out;
  wire [PORTS*32-1:0] mem_page_out;
  wire [PORTS*32-1:0] shift_in_wires [7:0];
  wire [PORTS*32-1:0] shift_out_wires [7:0];
  wire [PORTS*32-1:0] cell_vals;
  wire [PORTS*32-1:0] down_output;

  reg PEA_rst;
  reg load_wb;
  reg input_en;
  reg load_inputs;
  reg PEA_en;
  reg LP_external;

  reg [31:0] internal_shift_in;

  wire [31:0] LP_shift_in = LP_external == 1'b1 ? input_shift_in : internal_shift_in;

  reg [2:0] now_input;
  reg [2:0] now_page;
  reg [2:0] now_row;

  // operation state
  reg [3:0] operation_state;

  // counter
  reg [3:0] internal_counter;

  // neural network parameters
  reg [3:0] layer_count;
  reg [3:0] neuron_count [7:0];

  reg [31:0] tmp_out [7:0];
  // tmp_out wires
  wire [8*32-1:0] tmp_out_wires = {tmp_out[7],tmp_out[6],tmp_out[5],tmp_out[4],tmp_out[3],tmp_out[2],tmp_out[1],tmp_out[0]};
  wire [31:0] tmp_max;

  // decoder for en page
  decoder #(.INPUT_LEN (3)) mut (
    .in_port (now_page),
    .out_port (mem_page_ens)
  );

  // gerating the pages
  genvar i;
  generate
    for (i = 0;i < 8;i = i + 1) begin
      assign shift_in_wires[i] = i == 0 ? wb_shift_in : shift_out_wires[i-1];
      mem_page #(
        .ADR_LEN (3),
        .OUT_PORTS (8),
        .WIDTH (32)
      ) TP (
        .clk (clk),
        .load (load_wb),
        .address (now_row),
        .en (mem_page_ens[i]),
        .shift_in (shift_in_wires[i]),
        .shift_out (shift_out_wires[i]),
        .data_out (mem_page_out)
      );
    end
  endgenerate

  // input buffer
  mem_page #(
    .ADR_LEN (3),
    .OUT_PORTS (1),
    .WIDTH (32)
  ) LP (
    .clk (clk),
    .load (load_inputs),
    .address (now_input),
    .en (input_en),
    .shift_in (LP_shift_in),
    .shift_out (input_shift_out),
    .data_out (left_input)
  );

  assign left_input = input_en == 1'b0 ? 32'h3f800000 : 32'bZZZZZZZZ;

  // processing array
  PE_array #(.PORTS (8)) PEA (
    .clk (clk),
    .rst (PEA_rst),
    .buffered (1'b0),
    .ens ({8{PEA_en}}),
    .left_input (left_input),
    .up_input (mem_page_out),
    .right_output (right_output),
    .down_output (down_output),
    .cell_vals (cell_vals)
  );

  // comparator
  comp_8 comp_inst (
    .inputs (tmp_out_wires),
    .max (tmp_max)
  );

  always @(posedge clk) begin
    PEA_rst <= 1'b0;
    load_wb <= 1'b0;
    input_en <= 1'b0;
    load_inputs <= 1'b0;
    PEA_en <= 1'b0;
    if (init) begin
      layer_count <= num_layers;
      {neuron_count[7],neuron_count[6],neuron_count[5],neuron_count[4],neuron_count[3],
       neuron_count[2],neuron_count[1],neuron_count[0]} <= layer_sizes;
      load_wb <= 1'b1; // we want to load the weights and biases
      PEA_rst <= 1'b1; // we want to reset the processing array (we want to cell values to be zero)
      // set all now values to zero
      now_input <= 3'b0;
      now_page <= 3'b0;
      now_row <= 3'b0;
      operation_state <= 4'b0000; // reset the operation state
      internal_counter <= 4'b0; // reset the internal counter
    end else begin
      if (operate == 1'b1) begin
        // switch case for operation state
        case (operation_state)
          4'b0000: begin // we want to load the inputs for the first layer
            load_inputs <= 1'b1;
            LP_external <= 1'b1;
            PEA_rst <= 1'b1;
            now_row <= 3'b0; // reset the row for loading the bias
            if (internal_counter == neuron_count[0]-1) begin
              operation_state <= 4'b0001;
              internal_counter <= 4'b0;
            end
            internal_counter <= internal_counter+1;
          end
          4'b0001: begin // we want to load the bias to the processing array
            PEA_en <= 1'b1; // enable the processing array
            operation_state <= 4'b0010; // go to the next state
            now_row <= 3'b001; // set the row to 1 the row 0 is the bias
            now_input <= 3'b0; // reset the input
          end
          4'b0010: begin // after loading the bias we want to multiply the inputs with the weights
            PEA_en <= 1'b1; // enable the processing array
            input_en <= 1'b1; // enable the input buffer
            if (now_page == 0) begin
              if (now_row == neuron_count[now_page]) begin
                operation_state <= 4'b0011; // go to the next state
                internal_counter <= 4'b0; // reset the internal counter
              end
            end else begin
              if (now_row == neuron_count[now_page-1]) begin
                operation_state <= 4'b0011; // go to the next state
                internal_counter <= 4'b0; // reset the internal counter
              end
            end
            now_row <= now_row+1; // go to the next row
            now_input <= now_input+1; // go to the next input
          end
          4'b0011: begin // we want to load the results to the tmp_out
            if (internal_counter == 4'b0001) begin
              {tmp_out[7],tmp_out[6],tmp_out[5],tmp_out[4],tmp_out[3],tmp_out[2],tmp_out[1],tmp_out[0]} <= cell_vals;
              if (now_page != layer_count) operation_state <= 4'b0100; // go to the next state
              else operation_state <= 4'b0110; // go to the next state
              internal_counter <= 4'b0; // reset the internal counter
            end else internal_counter <= internal_counter+1;
          end
          4'b0100: begin // we want to apply relu to the tmp_out
            if (internal_counter == 4'b0001) begin
              {tmp_out[7],tmp_out[6],tmp_out[5],tmp_out[4],tmp_out[3],tmp_out[2],tmp_out[1],tmp_out[0]} <= {
                tmp_out[7][31] == 1'b1 ? 32'b0 : tmp_out[7],
                tmp_out[6][31] == 1'b1 ? 32'b0 : tmp_out[6],
                tmp_out[5][31] == 1'b1 ? 32'b0 : tmp_out[5],
                tmp_out[4][31] == 1'b1 ? 32'b0 : tmp_out[4],
                tmp_out[3][31] == 1'b1 ? 32'b0 : tmp_out[3],
                tmp_out[2][31] == 1'b1 ? 32'b0 : tmp_out[2],
                tmp_out[1][31] == 1'b1 ? 32'b0 : tmp_out[1],
                tmp_out[0][31] == 1'b1 ? 32'b0 : tmp_out[0]
              };
              operation_state <= 4'b0101; // go to the next state
            end else internal_counter <= internal_counter+1;
          end
          4'b0101: begin // we want to load the results to the input buffet from internal resorces
            load_inputs <= 1'b1;
            LP_external <= 1'b0;
            PEA_rst <= 1'b1;
            now_row <= 3'b0; // goto the first row
            internal_shift_in <= tmp_out[internal_counter+(7-neuron_count[now_page])];
            if (internal_counter == neuron_count[now_page]) begin
              now_page <= now_page+1; // go to the next page
              operation_state <= 4'b0001; // goback to the first state for loading new layer bias
              internal_counter <= 4'b0; // reset the internal counter
            end else internal_counter <= internal_counter+1;
          end
          4'b0110: begin // we want to apply hardmax to the tmp_out
            if (internal_counter == 4'b0001) begin
              {tmp_out[7],tmp_out[6],tmp_out[5],tmp_out[4],tmp_out[3],tmp_out[2],tmp_out[1],tmp_out[0]} <= {
                tmp_out[7] == tmp_max ? 32'h3f800000 : 32'h00000000,
                tmp_out[6] == tmp_max ? 32'h3f800000 : 32'h00000000,
                tmp_out[5] == tmp_max ? 32'h3f800000 : 32'h00000000,
                tmp_out[4] == tmp_max ? 32'h3f800000 : 32'h00000000,
                tmp_out[3] == tmp_max ? 32'h3f800000 : 32'h00000000,
                tmp_out[2] == tmp_max ? 32'h3f800000 : 32'h00000000,
                tmp_out[1] == tmp_max ? 32'h3f800000 : 32'h00000000,
                tmp_out[0] == tmp_max ? 32'h3f800000 : 32'h00000000
              };
              operation_state <= 4'b0111; // go to the next state
            end else internal_counter <= internal_counter+1;
          end
          default: begin
          end 
        endcase
      end
    end
  end
  
endmodule