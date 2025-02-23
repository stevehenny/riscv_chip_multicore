module l1_cache (
    input logic clk,
    reset,
    input logic [31:0] addr,
    input logic [31:0] wdata,
    input logic rd,
    wr,
    output logic [31:0] rdata,
    output logic hit
);

  `define CACHE_SETS 32
  `define BLOCK_SIZE 64
  `define ASSOCIATIVITY 2

  localparam byte INDEX_BITS = 5;
  localparam byte OFFSET_BITS = 6;
  localparam byte TAG_BITS = 32 - INDEX_BITS - OFFSET_BITS;

  logic [`CACHE_SETS-1:0][`ASSOCIATIVITY-1:0][TAG_BITS-1:0] tag_array;
  logic [`CACHE_SETS-1:0][`ASSOCIATIVITY-1:0][31:0] data_array;
  logic [`CACHE_SETS-1:0][`ASSOCIATIVITY-1:0] valid_bits;
  logic [`CACHE_SETS-1:0] lru_bit;

  wire [TAG_BITS-1:0] tag = addr[31-:TAG_BITS];
  wire [INDEX_BITS-1:0] index = addr[INDEX_BITS+OFFSET_BITS-1-:INDEX_BITS];
  wire [OFFSET_BITS-1:0] offset = addr[OFFSET_BITS-1-:OFFSET_BITS];

  integer i;
  integer replace_way;
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      for (i = 0; i < `CACHE_SETS; i++) begin
        valid_bits[i] <= 0;
        lru_bit[i] <= 0;
      end
    end
  end
endmodule
