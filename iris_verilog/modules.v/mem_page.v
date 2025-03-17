`timescale 1ns/1ns
//////////////////////////////////////////////////////////////////////////////////
// Course: Hardware-Accelerators
// Engineer: Matin Firoozbakht
// Module Name: mem_page
// Project Name: Hardware-Accelerated MLP for Iris Dataset
//////////////////////////////////////////////////////////////////////////////////
module mem_page #(
  parameter ADR_LEN = 3,
  parameter OUT_PORTS = 8,
  parameter WIDTH = 32
) (
  input en,
  input clk,
  input load,
  input [ADR_LEN-1:0] address,
  input [WIDTH*OUT_PORTS-1:0] shift_in,
  output [WIDTH*OUT_PORTS-1:0] shift_out,
  output [WIDTH*OUT_PORTS-1:0] data_out
);
  
  // Memory page
  reg [WIDTH*OUT_PORTS-1:0] mem [2**ADR_LEN-1:0];

  // Output register
  reg [WIDTH*OUT_PORTS-1:0] out_port;

  // i for looping
  integer i;
  // reads from memory in the colck
  always @(posedge clk) begin
    if (load == 1'b1) begin
      for (i = 1; i < 2**ADR_LEN; i = i + 1) begin
        mem[i] <= mem[i-1];
      end
      mem[0] <= shift_in;
    end else out_port = mem[address];
  end

  // If enabled, gets value from output register else it's 'z' floating for other values to assign to
  assign data_out = en ? out_port : {WIDTH*OUT_PORTS{1'bz}};

  // this is for load data in and to the next page
  assign shift_out = mem[2**ADR_LEN-1];

endmodule