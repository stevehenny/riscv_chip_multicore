module regfile (
    input wire logic clk,
    input wire logic write,
    input wire logic [4:0] readReg1,
    input wire logic [4:0] readReg2,
    input wire logic [4:0] writeReg,
    input wire logic [31:0] writeData,
    output logic [31:0] readData1,
    output logic [31:0] readData2
);

  // Declare a register file logical array (32 words of 32 bit length)
  logic [31:0] register[31:0];

  // Init the 32 words with 0
  integer i;
  initial begin
    for (i = 0; i < 32; i++) begin
      register[i] = 0;
    end
  end

  // **Combinational Read Logic** (reads happen immediately)
  always_comb begin
    readData1 = register[readReg1];
    readData2 = register[readReg2];
  end

  // **Synchronous Write Logic**
  always_ff @(posedge clk) begin
    if (write && writeReg != 0) begin
      register[writeReg] <= writeData;
    end
  end

endmodule
