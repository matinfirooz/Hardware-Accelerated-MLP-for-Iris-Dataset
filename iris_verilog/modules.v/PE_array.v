`timescale 1ns/1ns
//////////////////////////////////////////////////////////////////////////////////
// Course: Hardware-Accelerators
// Engineer: Matin Firoozbakht
// Module Name: PE_array
// Project Name: Hardware-Accelerated MLP for Iris Dataset
//////////////////////////////////////////////////////////////////////////////////
module PE_array #(
  parameter PORTS = 8
) (
  input clk,
  input rst,
  input buffered,
  input [7:0] ens,
  input [31:0] left_input,
  input [PORTS*32-1:0] up_input,
  output [31:0] right_output,
  output [PORTS*32-1:0] down_output,
  output [PORTS*32-1:0] cell_vals
);
  
  wire [PORTS*32-1:0] up_wires;
  wire [PORTS*32-1:0] down_wires;
  wire [PORTS*32-1:0] left_wires;
  wire [PORTS*32-1:0] right_wires;

  assign down_output = down_wires;
  assign up_wires = up_input;
  assign right_output = right_wires[PORTS*32-1:PORTS*32-32];

  genvar i;
  generate
    for (i = 0; i < PORTS; i = i + 1) begin
      if (i == 0) assign left_wires[i*32+31:i*32] = left_input;
      else assign left_wires[i*32+31:i*32] = right_wires[(i-1)*32+31:(i-1)*32];

      PE p0 (
        .clk (clk),
        .rst (rst),
        .en (ens[i]),
        .up_in (up_wires[i*32+31:i*32]),
        .down_out (down_wires[i*32+31:i*32]),
        .left_in (left_wires[i*32+31:i*32]),
        .right_out (right_wires[i*32+31:i*32]),
        .cell_val (cell_vals[i*32+31:i*32]),
        .passthrough (~buffered)
      );
    end
  endgenerate

endmodule