`timescale 1ns / 1ps

`include "opcode_constants.sv"

module tb_alu;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_alu);
  end
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

  // Updated perform_test task with opcode as an argument
  task perform_test(input [WIDTH-1:0] test_op1, input [WIDTH-1:0] test_op2, input [2:0] test_funct3,
                    input [6:0] test_funct7, input [6:0] test_opcode,
                    input [WIDTH-1:0] expected_result, input string operation_name);
    begin
      // Set inputs
      op1 = test_op1;
      op2 = test_op2;
      funct3 = test_funct3;
      funct7 = test_funct7;
      opcode = test_opcode;  // Use passed opcode
      #10;  // Allow time for ALU to compute

      // Debugging outputs
      $display("Testing %s operation", operation_name);
      $display("Inputs: op1 = %h, op2 = %h", op1, op2);
      $display("Opcode: %b, Funct3: %b, Funct7: %b", opcode, funct3, funct7);
      $display("Result: %h, Expected: %h", result, expected_result);

      // Check result
      if (result !== expected_result) begin
        #100;
        $error("Test FAILED for %s operation!\nExpected: %h, Got: %h", operation_name,
               expected_result, result);
      end else begin
        $display("Test PASSED for %s operation.\nOperands: %h, %h\nResult: %h", operation_name,
                 test_op1, test_op2, result);
      end
    end
    $display("\n\n");
  endtask

  // Main test procedure
  initial begin
    $display("Starting ALU Tests...");

    // Perform test cases with opcode as an argument
    perform_test(32'h00000005, 32'h00000003, ADDFUNCT3, ADDFUNCT7, RTYPEOP, 32'h00000008, "ADD");
    #10;
    perform_test(32'h00000005, 32'h00000003, SUBFUNCT3, SUBFUNCT7, RTYPEOP, 32'h00000002, "SUB");
    #10;
    perform_test(32'h00001001, 32'hffffffff, ANDFUNCT3, ANDFUNCT7, RTYPEOP, 32'h00001001, "AND");
    #10;
    perform_test(32'h11111111, 32'h22222222, ORFUNCT3, ORFUNCT7, RTYPEOP, 32'h33333333, "OR");
    #10;
    perform_test(32'h11110000, 32'h11101000, XORFUNCT3, XORFUNCT7, RTYPEOP, 32'h00011000, "XOR");
    #10;
    perform_test(32'h00000001, 32'h00000002, SLLFUNCT3, SLLFUNCT7, RTYPEOP, 32'h00000004, "SLL");
    #10;
    perform_test(32'h00001000, 32'h00000002, SRLFUNCT3, SRLFUNCT7, RTYPEOP, 32'h00000400, "SRL");
    #10;
    perform_test(32'h0000000f, 32'h00000003, SRAFUNCT3, SRAFUNCT7, RTYPEOP, 32'h00000001, "SRA");
    #10;
    perform_test(-32'h00000004, 32'h00000003, SLTFUNCT3, SLTFUNCT7, RTYPEOP, 32'h00000001, "SLT");
    #10;
    perform_test(32'h00000008, 32'h00000002, MULFUNCT3, MULFUNCT7, RTYPEOP, 32'h00000010, "MUL");

    $display("All tests completed successfully!");
    #100;
    $finish;  // End the simulation
  end

endmodule
