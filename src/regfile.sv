`timescale 1ns / 1ps

module regfile (
    input wire logic clk,
    input wire logic write,
    input wire logic [4:0] readReg1,
    input wire logic [4:0] readReg2,
    input wire logic [4:0] writeReg,
    input wire logic [31:0] readData,
    input wire logic [31:0] writeData,
    output logic [31:0] readData1,
    output logic [31:0] readData2
);

  // Declare a register file logical array (32 words of 32 bit length)
  logic [31:0] register[32];


  // Init the 32 words with 0
  integer i;
  initial begin
    for (i = 0; i < 32; i++) begin
      register[i] = 0;
    end
  end


  // synchronous read and write regfile
  always_ff @(clk) begin : regfile
    readData1 <= register[readReg1];
    readData2 <= register[readReg2];

    // going to keep important data in r0
    if (write && writeReg != 0) begin
      register[writeReg] <= writeData;
      if (readReg1 == writeReg) readData1 <= writeData;
      if (readReg2 == writeReg) readData2 <= writeData;
    end
  end

endmodule

