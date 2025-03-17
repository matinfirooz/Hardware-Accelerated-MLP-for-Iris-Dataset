`timescale 1ns/1ns
//////////////////////////////////////////////////////////////////////////////////
// Course: Hardware-Accelerators
// Engineer: Matin Firoozbakht
// Module Name: fp_add32_tb
// Project Name: Hardware-Accelerated MLP for Iris Dataset
//////////////////////////////////////////////////////////////////////////////////
module fp_add32_tb;
  reg [31:0] a,b;
  wire [31:0] c;

  fp_add32 mut (
    .a (a),
    .b (b),
    .c (c)
  );

  initial begin
    a = 32'b00000000100000000000000000000000;
    b = 32'b00000000100000000000000000000000;
    #5;
    a = 32'b00000001000000000000000000000000;
    b = 32'b00000001000000000000000000000000;
    #5;
    a = 32'b00000010000000000000000000000000;
    b = 32'b00000010000000000000000000000000;
    #5;
    $stop();
  end
endmodule