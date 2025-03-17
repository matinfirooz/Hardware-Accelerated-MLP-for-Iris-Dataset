`timescale 1ns/1ns
//////////////////////////////////////////////////////////////////////////////////
// Course: Hardware-Accelerators
// Engineer: Matin Firoozbakht
// Module Name: comp
// Project Name: Hardware-Accelerated MLP for Iris Dataset
//////////////////////////////////////////////////////////////////////////////////
module comp (
  input [31:0] left_input,
  input [31:0] right_output,
  output [31:0] bigger_one
);
  
  wire l_is_bigger = left_input[31]==1'b0 && right_output[31]==1'b1 ? 1'b1 :
                     left_input[31]==1'b1 && right_output[31]==1'b0 ? 1'b0 :
                     left_input[31]==1'b0 && left_input[30:23]>right_output[30:23] ? 1'b1 :
                     left_input[31]==1'b0 && left_input[30:23]<right_output[30:23] ? 1'b0 :
                     left_input[31]==1'b1 && left_input[30:23]>right_output[30:23] ? 1'b0 :
                     left_input[31]==1'b1 && left_input[30:23]<right_output[30:23] ? 1'b1 :
                     left_input[31]==1'b0 && left_input[22:0]>right_output[22:0] ? 1'b1 :
                     left_input[31]==1'b0 && left_input[22:0]<right_output[22:0] ? 1'b0 :
                     left_input[31]==1'b1 && left_input[22:0]>right_output[22:0] ? 1'b0 :
                     left_input[31]==1'b1 && left_input[22:0]<right_output[22:0] ? 1'b1 : 1'b0;

  assign bigger_one = l_is_bigger ? left_input : right_output;

endmodule