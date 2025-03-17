`timescale 1ns/1ns
//////////////////////////////////////////////////////////////////////////////////
// Course: Hardware-Accelerators
// Engineer: Matin Firoozbakht
// Module Name: decoder_tb
// Project Name: Hardware-Accelerated MLP for Iris Dataset
//////////////////////////////////////////////////////////////////////////////////
module decoder_tb;
reg [3:0] in_port;
wire [15:0] out_port;

decoder #(.INPUT_LEN (4)) mut (
  .in_port (in_port),
  .out_port (out_port)
);

initial begin
  in_port = 4'b0000; #5;
  in_port = 4'b0001; #5;
  in_port = 4'b0101; #5;
  in_port = 4'b1111; #5;
end
endmodule