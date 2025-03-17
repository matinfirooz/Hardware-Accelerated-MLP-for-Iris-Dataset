`timescale 1ns/1ns
//////////////////////////////////////////////////////////////////////////////////
// Course: Hardware-Accelerators
// Engineer: Matin Firoozbakht
// Module Name: add
// Project Name: Hardware-Accelerated MLP for Iris Dataset
//////////////////////////////////////////////////////////////////////////////////
module add #(
  parameter WIDTH = 8
) (
  input [WIDTH-1:0] a,
  input [WIDTH-1:0] b,
  output [WIDTH-1:0] c
);
  
  wire [WIDTH-2:0] res_num = a[WIDTH-1]^b[WIDTH-1] == 1'b0 ? a[WIDTH-2:0] + b[WIDTH-2:0] : 
                             a[WIDTH-2:0] > b[WIDTH-2:0]   ? a[WIDTH-2:0] - b[WIDTH-2:0] : 
                             b[WIDTH-2:0] - a[WIDTH-2:0];

  wire sign_bit = a[WIDTH-2:0] > b[WIDTH-2:0] ? a[WIDTH-1] : b[WIDTH-1];

  assign c = {sign_bit, res_num};

endmodule