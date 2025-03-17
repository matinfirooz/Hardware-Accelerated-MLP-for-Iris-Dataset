`timescale 1ns/1ns
//////////////////////////////////////////////////////////////////////////////////
// Course: Hardware-Accelerators
// Engineer: Matin Firoozbakht
// Module Name: comp_8
// Project Name: Hardware-Accelerated MLP for Iris Dataset
//////////////////////////////////////////////////////////////////////////////////
module comp_8 (
  input [8*32-1:0] inputs,
  output [31:0] max
);

  wire [31:0] comp_l0 [7:0];
  wire [31:0] comp_l1 [3:0];
  wire [31:0] comp_l2 [1:0];

  assign {comp_l0[7],comp_l0[6],comp_l0[5],comp_l0[4],comp_l0[3],comp_l0[2],comp_l0[1],comp_l0[0]} = inputs;

  // level 1-4 cmop modules
  genvar i;
  generate
    for (i = 0;i < 4;i = i + 1) begin
      comp comp_inst_l0 (
        .left_input (comp_l0[i*2]),
        .right_output (comp_l0[i*2+1]),
        .bigger_one (comp_l1[i])
      );
    end
  endgenerate

  // level 2-2 cmop modules
  genvar j;
  generate
    for (j = 0;j < 2;j = j + 1) begin
      comp comp_inst_l1 (
        .left_input (comp_l1[j*2]),
        .right_output (comp_l1[j*2+1]),
        .bigger_one (comp_l2[j])
      );
    end
  endgenerate

  // level 3-1 cmop modules
  comp comp_inst_l2 (
    .left_input (comp_l2[0]),
    .right_output (comp_l2[1]),
    .bigger_one (max)
  );

endmodule