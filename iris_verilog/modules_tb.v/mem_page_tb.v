`timescale 1ns/1ns
//////////////////////////////////////////////////////////////////////////////////
// Course: Hardware-Accelerators
// Engineer: Matin Firoozbakht
// Module Name: mem_page_tb
// Project Name: Hardware-Accelerated MLP for Iris Dataset
//////////////////////////////////////////////////////////////////////////////////
module mem_page_tb;
reg en, clk, load;
reg [2:0] address;
reg [255:0] shift_in;
wire [255:0] shift_out, data_out;

reg [255:0] mem [7:0];

mem_page #(
  .ADR_LEN (3),
  .OUT_PORTS (8),
  .WIDTH (32)
) mut (
  .en (en),
  .clk (clk),
  .load (load),
  .address (address),
  .shift_in (shift_in),
  .shift_out (shift_out),
  .data_out (data_out)
);

// clock generation
initial clk = 1'b0;
always #5 clk = ~clk;

// reading page data
initial $readmemh("mem.page", mem);

integer i;

initial begin
  en = 1'b1;
  load = 1'b1;
  for (i = 0; i < 8; i = i + 1) begin
    shift_in = mem[7 - i];
    @(posedge clk); #1;
  end
  load = 1'b0; @(posedge clk); #9;
  address = 3'b000; #11;
  address = 3'b011; #10;
  address = 3'b100; #10;
  $stop();
end
endmodule