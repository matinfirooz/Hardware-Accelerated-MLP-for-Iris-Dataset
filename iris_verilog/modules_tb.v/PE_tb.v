`timescale 1ns/1ns
//////////////////////////////////////////////////////////////////////////////////
// Course: Hardware-Accelerators
// Engineer: Matin Firoozbakht
// Module Name: PE_tb
// Project Name: Hardware-Accelerated MLP for Iris Dataset
//////////////////////////////////////////////////////////////////////////////////
module PE_tb;
  reg en,clk,rst,passthrough;
  reg [31:0] up_in,left_in;
  wire [31:0] down_out,right_out,cell_val;

  PE mut (
    .en (en),
    .clk (clk),
    .rst (rst),
    .passthrough (passthrough),
    .up_in (up_in),
    .left_in (left_in),
    .down_out (down_out),
    .right_out (right_out),
    .cell_val (cell_val)
  );

  // clock generation
  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    en = 1'b1;
    rst = 1'b1; #12;
    rst = 1'b0;
    passthrough = 1'b1;
    up_in = 32'b00000000100000000000000000000000;
    left_in = 32'b00000000100000000000000000000000;
    #45; rst = 1'b1; #12; rst = 1'b0;
    passthrough = 1'b0;
    #45;
    $stop();
  end
endmodule