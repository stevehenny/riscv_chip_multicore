`timescale 1ns / 1ps

// Remove the import for uvm_pkg as Verilator doesn't support UVM
// import uvm_pkg::*; // Remove this line

module tb_alu;

  // Parameters and signals
  parameter WIDTH = 32;
  logic [WIDTH-1:0] op1, op2, result;
  logic [6:0] opcode;
  logic [2:0] funct3;
  logic [6:0] funct7;
  logic zero, status;

  // Instantiate the ALU
  alu #(WIDTH) dut (
      .op1(op1),
      .op2(op2),
      .result(result),
      .opcode(opcode),
      .funct7(funct7),
      .funct3(funct3),
      .zero(zero),
      .status(status)
  );

  // Main test procedure
  initial begin
    // Initialize values
    opcode = 7'b0000000;  // Example opcode
    op1    = 32'h00000005;  // Example operand 1
    op2    = 32'h00000003;  // Example operand 2

    // Test ADD operation
    funct3 = 3'b000;  // Example funct3 for ADD
    funct7 = 7'b0000000;  // Example funct7 for ADD
    #10;  // Wait for ALU to compute
    assert (result == 32'h00000008)
    else $fatal("ADD failed!");

    // Add more tests for other operations here...

    // Indicate completion
    $display("All tests passed!");
    $finish;  // End the simulation
  end

endmodule
