
`timescale 1ns / 1ps

import uvm_pkg::*;

class alu_test extends uvm_test;
  `uvm_component_utils(alu_test)

  // UVM configuration objects
  logic [31:0] op1;
  logic [31:0] op2;
  logic [31:0] result;
  logic [6:0] opcode;
  logic [2:0] funct3;
  logic [6:0] funct7;
  logic zero;

  alu dut;  // Instantiate the ALU

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Instantiate the ALU module
    dut = alu::type_id::create("dut", this);
  endfunction

  virtual function void run_phase(uvm_phase phase);
    // Test various ALU operations
    opcode = OP;  // Set opcode for R-type instructions
    op1 = 32'h00000005;  // Example operands
    op2 = 32'h00000003;

    // Test ADD operation
    funct3 = ADDFUNCT3;
    funct7 = ADDFUNCT7;
    #10;  // Wait for ALU to compute
    assert (dut.result == 32'h00000008)
    else $fatal("ADD failed!");

    // Add more tests for other operations...

    // Indicate completion
    $display("All tests passed!");
  endfunction
endclass

// Testbench top module
module alu_tb;
  initial begin
    alu_test t = alu_test::type_id::create("t");
    t.start(null);
  end
endmodule
