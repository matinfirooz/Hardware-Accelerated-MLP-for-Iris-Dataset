`timescale 1ns/1ns
//////////////////////////////////////////////////////////////////////////////////
// Course: Hardware-Accelerators
// Engineer: Matin Firoozbakht
// Module Name: mult
// Project Name: Hardware-Accelerated MLP for Iris Dataset
//////////////////////////////////////////////////////////////////////////////////
module mult #(
  parameter WIDTH = 8
) (
  input signed [WIDTH-1:0] a,
  input signed [WIDTH-1:0] b,
  output signed [2*WIDTH-2:0] c
);
  
  wire [2*WIDTH-3:0] res_num = a[WIDTH-2:0]*b[WIDTH-2:0];
  wire res_sign = a[WIDTH-1]^b[WIDTH-1];

  assign c = {res_sign,res_num};

endmodule