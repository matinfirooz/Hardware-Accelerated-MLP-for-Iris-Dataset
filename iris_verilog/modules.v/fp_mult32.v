
`timescale 1ns/1ns
//////////////////////////////////////////////////////////////////////////////////
// Course: Hardware-Accelerators
// Engineer: Matin Firoozbakht
// Module Name: fp_mult32
// Project Name: Hardware-Accelerated MLP for Iris Dataset
//////////////////////////////////////////////////////////////////////////////////
module fp_mult32 (
  input [31:0] a,
  input [31:0] b,
  output [31:0] c
);

  // sign bit
  wire out_sign = a[31] ^ b[31];
  
  wire have_zero = a[30:0] == 31'b0 || b[30:0] == 31'b0;

  // output exponent
  wire [8:0] per_exponent_ = a[30:23] + b[30:23];
  wire [7:0] per_exponent  = per_exponent_ - 127;
  
  // mantissa
  wire [23:0] man0 = {1'b1,a[22:0]};
  wire [23:0] man1 = {1'b1,b[22:0]};

  wire [47:0] res = (man0 * man1) + 1;
  
  // output exponent
  wire [7:0] out_exp = res[47] == 1'b1 ? per_exponent + 1 : per_exponent;
  
  // output mantissa
  wire [22:0] out_man = res[47] == 1'b1 ? res[46:24] : res[45:23];
  
  assign c = have_zero ? {out_sign, 31'b0} : {out_sign, out_exp, out_man};

endmodule 
// module fp_mult32(
//   input [31:0] a,
//   input [31:0] b,
//   output [31:0] c
// );

//   wire [62:0] mult_res;

//   mult #(.WIDTH (32)) ml (
//     .a (a),
//     .b (b),
//     .c (mult_res)
//   );

//   assign c = {mult_res[62], mult_res[54:48], mult_res[47:24]};

// endmodule