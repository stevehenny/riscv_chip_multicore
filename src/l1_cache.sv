
/************************************************************
* This is a simple l1_cache for the main cpu pipeline
* Author: Stephen Henstrom
*************************************************************/

`define CACHE_SETS 64
`define BLOCK_SIZE 32
`define ASSOCIATIVITY 2

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

  localparam byte INDEX_BITS = 6;
  localparam byte OFFSET_BITS = 5;
  localparam byte TAG_BITS = 32 - INDEX_BITS - OFFSET_BITS;


  logic [CACHE_SETS-1:0][ASSOCIATIVITY-1:0][TAG_BITS-1:0] tag_array;
  logic [CACHE_SETS-1:0][ASSOCIATIVITY-1:0][31:0] data_array;
  logic [CACHE_SET-1:0][ASSOCIATIVITY-1:0] valid_bits;
  logic [CACHE_SET-1:0] lru_bit;

  wire [TAG_BITS-1:0] tag = addr[31:INDEX_BITS+OFFSET_BITS];
  wire [INDEX_BITS-1:0] index = addr[INDEX_BITS+OFFSET_BITS-1:OFFSET_BITS];
  wire [OFFSET_BITS-1:0] offset = addr[OFFSET_BITS-1:0];

  integer i;

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      for (i = 0; i < `CACHE_SETS; i++) begin
        valid_bits[i] <= 0;
        lru_bit[i] <= 0;
      end
    end else begin
      logic hit_way0, hit_way1;
      hit_way0 = (valid_bits[index][0] && tag_array[index][0] == tag);
      hit_way1 = (valid_bits[index][1] && tag_array[index][1] == tag);

      if (rd) begin
        if (hit_way0) begin
          rdata <= data_array[index][0];
          hit <= 1;
          lru_bit[index] <= 1;  // Way 0 was used, mark Way 1 for replacement
        end else if (hit_way1) begin
          rdata <= data_array[index][1];
          hit <= 1;
          lru_bit[index] <= 0;  // Way 1 was used, mark Way 0 for replacement
        end else begin
          hit <= 0;  // Cache miss
        end
      end

      if (wr) begin
        if (hit_way0) begin
          data_array[index][0] <= wdata;
          hit <= 1;
        end else if (hit_way1) begin
          data_array[index][1] <= wdata;
          hit <= 1;
        end else begin
          hit <= 0;  // Cache miss
          int replace_way = lru_bit[index];  // Use LRU to replace
          data_array[index][replace_way] <= wdata;
          tag_array[index][replace_way] <= tag;
          valid_bits[index][replace_way] <= 1;
          lru_bit[index] <= ~replace_way;  // Swap LRU bit
        end
      end
    end
  end
endmodule
