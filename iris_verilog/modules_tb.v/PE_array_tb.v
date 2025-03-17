`timescale 1ns/1ns
//////////////////////////////////////////////////////////////////////////////////
// Course: Hardware-Accelerators
// Engineer: Matin Firoozbakht
// Module Name: PE_array_tb
// Project Name: Hardware-Accelerated MLP for Iris Dataset
//////////////////////////////////////////////////////////////////////////////////
module PE_array_tb;
  reg clk, rst, buffered;
  reg [7:0] ens;
  reg [31:0] left_input;
  reg [255:0] up_input;
  wire [31:0] right_output;
  wire [255:0] down_output;
  wire [255:0] cell_vals;

  PE_array #(.PORTS (8)) mut (
    .clk (clk),
    .rst (rst),
    .buffered (buffered),
    .ens (ens),
    .left_input (left_input),
    .up_input (up_input),
    .right_output (right_output),
    .down_output (down_output),
    .cell_vals (cell_vals)
  );

  // clock generation
  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    rst = 1'b1;
    @(posedge clk);
    rst = 1'b0; buffered = 1'b0;
    ens = 8'b11111111;
    left_input = 32'h04000000;
    up_input = 256'h0080000001000000008000000200000000800000040000000800000000f00000;
    #45;
    $stop();
  end
endmodule