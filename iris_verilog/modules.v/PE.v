`timescale 1ns/1ns
//////////////////////////////////////////////////////////////////////////////////
// Course: Hardware-Accelerators
// Engineer: Matin Firoozbakht
// Module Name: PE
// Project Name: Hardware-Accelerated MLP for Iris Dataset
//////////////////////////////////////////////////////////////////////////////////
module PE(
  input en,
  input clk,
  input rst,
  input passthrough,
  input [31:0] up_in,
  input [31:0] left_in,
  output [31:0] down_out,
  output [31:0] right_out,
  output [31:0] cell_val
);

  reg [31:0] cell_reg;

  reg [31:0] down_reg;
  reg [31:0] right_reg;

  wire [31:0] mult_res;
  wire [31:0] add_res;

  fp_mult32 mul (
    .a (up_in),
    .b (left_in),
    .c (mult_res)
  );

  fp_add32 adder (
    .a (mult_res),
    .b (cell_reg),
    .c (add_res)
  );

  always @(posedge clk or posedge rst) begin
    if (rst == 1'b1) begin
      cell_reg <= 32'b0;
      down_reg <= 32'b0;
      right_reg <= 32'b0;
    end else if (en == 1'b1) begin
      cell_reg <= add_res;
      down_reg <= up_in;
      right_reg <= left_in;
    end
  end

  assign down_out = (en == 1'b0) ? 32'b0 : (passthrough == 1'b0) ? down_reg : up_in;
  assign right_out = (en == 1'b0) ? 32'b0 : (passthrough == 1'b0) ? right_reg : left_in;
  assign cell_val = cell_reg;

endmodule