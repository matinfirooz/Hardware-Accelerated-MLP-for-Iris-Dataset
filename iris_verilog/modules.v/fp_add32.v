`timescale 1ns/1ns
//////////////////////////////////////////////////////////////////////////////////
// Course: Hardware-Accelerators
// Engineer: Matin Firoozbakht
// Module Name: fp_add32
// Project Name: Hardware-Accelerated MLP for Iris Dataset
//////////////////////////////////////////////////////////////////////////////////
module fp_add32 (
  input [31:0] a,
  input [31:0] b,
  output [31:0] c
);
  
  // sign bit
  wire sig0 = a[31];
  wire sig1 = b[31];
  
  // exponent
  wire [7:0] exp0 = a[30:23];
  wire [7:0] exp1 = b[30:23];
  
  // mantissa
  wire [23:0] man0 = {1'b1, a[22:0]};
  wire [23:0] man1 = {1'b1, b[22:0]};
  
  // bigger number
  wire bigger = exp0 == exp1 ? (man0 > man1 ? 1'b0 : 1'b1) : exp0 > exp1 ? 1'b0 : 1'b1;
  
  // wire bigger exp
  wire [7:0] bigger_exp = bigger == 1'b0 ? exp0 : exp1;
  // smaller exp
  wire [7:0] smaller_exp = bigger == 1'b0 ? exp1 : exp0;
  
  // bigger mantissa
  wire [47:0] bigger_man = bigger == 1'b0 ? {1'b0, man0, 23'b0} : {1'b0, man1, 23'b0};
  // smaller mantissa
  wire [47:0] smaller_man_ = bigger == 1'b0 ? {1'b0, man1, 23'b0} : {1'b0, man0, 23'b0};
  wire [47:0] smaller_man  = smaller_man_ >> (bigger_exp - smaller_exp);
  
  // the resualt of addition
  wire [47:0] res = sig0 == sig1 ? bigger_man + smaller_man : bigger_man - smaller_man;
  
  // first one index with priority encoder or some logic gate
  wire [5:0] f_one = res[47] == 1'b1 ? 6'b111111:
                     res[46] == 1'b1 ? 6'b000000:
                     res[45] == 1'b1 ? 6'b000001:
                     res[44] == 1'b1 ? 6'b000010:
                     res[43] == 1'b1 ? 6'b000011:
                     res[42] == 1'b1 ? 6'b000100:
                     res[41] == 1'b1 ? 6'b000101:
                     res[40] == 1'b1 ? 6'b000110:
                     res[39] == 1'b1 ? 6'b000111:
                     res[38] == 1'b1 ? 6'b001000:
                     res[37] == 1'b1 ? 6'b001001:
                     res[36] == 1'b1 ? 6'b001010:
                     res[35] == 1'b1 ? 6'b001011:
                     res[34] == 1'b1 ? 6'b001100:
                     res[33] == 1'b1 ? 6'b001101:
                     res[32] == 1'b1 ? 6'b001110:
                     res[31] == 1'b1 ? 6'b001111:
                     res[30] == 1'b1 ? 6'b010000:
                     res[29] == 1'b1 ? 6'b010001:
                     res[28] == 1'b1 ? 6'b010010:
                     res[27] == 1'b1 ? 6'b010011:
                     res[26] == 1'b1 ? 6'b010100:
                     res[25] == 1'b1 ? 6'b010101:
                     res[24] == 1'b1 ? 6'b010110:
                     res[23] == 1'b1 ? 6'b010111:
                     res[22] == 1'b1 ? 6'b011000:
                     res[21] == 1'b1 ? 6'b011001:
                     res[20] == 1'b1 ? 6'b011010:
                     res[19] == 1'b1 ? 6'b011011:
                     res[18] == 1'b1 ? 6'b011100:
                     res[17] == 1'b1 ? 6'b011101:
                     res[16] == 1'b1 ? 6'b011110:
                     res[15] == 1'b1 ? 6'b011111:
                     res[14] == 1'b1 ? 6'b100000:
                     res[13] == 1'b1 ? 6'b100001:
                     res[12] == 1'b1 ? 6'b100010:
                     res[11] == 1'b1 ? 6'b100011:
                     res[10] == 1'b1 ? 6'b100100:
                     res[9]  == 1'b1 ? 6'b100101:
                     res[8]  == 1'b1 ? 6'b100110:
                     res[7]  == 1'b1 ? 6'b100111:
                     res[6]  == 1'b1 ? 6'b101000:
                     res[5]  == 1'b1 ? 6'b101001:
                     res[4]  == 1'b1 ? 6'b101010:
                     res[3]  == 1'b1 ? 6'b101011:
                     res[2]  == 1'b1 ? 6'b101100:
                     res[1]  == 1'b1 ? 6'b101101:
                     res[0]  == 1'b1 ? 6'b101110:
                                       6'b111000;
  
  // wire output sign
  wire out_sig = bigger ? sig1 : sig0;
  
  // exponent output
  wire [7:0] out_exp = f_one == 6'b111111 ? bigger_exp + 1 : f_one != 6'b111000 ? bigger_exp - f_one : 8'b0;
  
  // shifted result
  wire [47:0] res_shift = f_one == 6'b111111 ? res << 1 : res << f_one + 2;
  
  // mantissa output
  wire [22:0] out_man = res_shift[24] == 1'b1 ? res_shift[47:25] + 1 : res_shift[47:25];
  
  assign c = (a == 32'b0 && b == 32'b0) ? 32'b0:{out_sig, out_exp, out_man};
  
endmodule 
// module fp_add32(
//   input [31:0] a,
//   input [31:0] b,
//   output [31:0] c
// );

//   add #(.WIDTH (32)) ad (
//     .a (a),
//     .b (b),
//     .c (c)
//   );

// endmodule