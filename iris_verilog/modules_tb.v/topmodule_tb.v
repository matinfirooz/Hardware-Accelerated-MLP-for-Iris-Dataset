module topmodule_tb;
  reg clk;
  reg rst;
  reg init;
  reg operate;
  reg [2:0] num_layers;
  reg [31:0] layer_sizes;
  reg [31:0] input_shift_in;
  reg [255:0] wb_shift_in;

  topmodule #(.PORTS (8)) mut (
    .clk (clk),
    .rst (rst),
    .init (init),
    .operate (operate),
    .num_layers (num_layers),
    .layer_sizes (layer_sizes),
    .input_shift_in (input_shift_in),
    .wb_shift_in (wb_shift_in)
  );

  // clock generation
  initial clk = 1'b0;
  always #5 clk = ~clk;

  reg [8*32-1:0] dram [64:0];

  // read the mempage
  initial $readmemh("mem.page", dram);

  integer i;

  initial begin
    rst = 1'b1;
    @(posedge clk);
    rst = 1'b0;
    operate = 1'b0; // don't operate yet
    init = 1'b1; // init
    num_layers = 3'b010; // we have 3 layers 0, 1, 2
    layer_sizes = 32'h00000344; // neural network has 4, 4, 3 neurons in each layer
    for (i = 0;i < 24;i = i + 1) begin
      @(posedge clk);
      wb_shift_in = dram[i];
    end
    init = 1'b0; @(posedge clk);
    operate = 1'b1; @(posedge clk);
    // input_shift_in = dram[64][31:0]; @(posedge clk);
    // input_shift_in = dram[64][63:32]; @(posedge clk);
    // input_shift_in = dram[64][95:64]; @(posedge clk);
    // input_shift_in = dram[64][127:96]; @(posedge clk);
    input_shift_in = dram[64][255:224]; @(posedge clk);
    input_shift_in = dram[64][223:192]; @(posedge clk);
    input_shift_in = dram[64][191:160]; @(posedge clk);
    input_shift_in = dram[64][159:128]; @(posedge clk);
    #450;
    $stop();
  end
endmodule