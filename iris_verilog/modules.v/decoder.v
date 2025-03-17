`timescale 1ns/1ns
//////////////////////////////////////////////////////////////////////////////////
// Course: Hardware-Accelerators
// Engineer: Matin Firoozbakht
// Module Name: decoder
// Project Name: Hardware-Accelerated MLP for Iris Dataset
//////////////////////////////////////////////////////////////////////////////////
module decoder #(
  parameter INPUT_LEN = 2
) (
  input [INPUT_LEN-1:0] in_port,
  output reg [2**INPUT_LEN-1:0] out_port
);

  // Assigns the output register to the input port
  always @(*) begin
    out_port = {2**INPUT_LEN{1'b0}};
    out_port[in_port] = 1'b1;
  end

endmodule