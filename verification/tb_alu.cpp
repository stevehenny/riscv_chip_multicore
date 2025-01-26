#include "../include/opcode_constants.h" // Include the new header file
#include "../obj_dir/Valu.h"
#include <iostream>
#include <stdexcept>
#include <verilated.h>
#include <verilated_vcd_c.h>

static vluint64_t main_time = 0;
double sc_time_stamp() { return main_time; }

void set_dut_values(Valu *dut, vluint32_t op1, vluint32_t op2, vluint8_t opcode,
                    vluint8_t funct3, vluint8_t funct7) {
  dut->op1 = op1;
  dut->op2 = op2;
  dut->funct3 = funct3;
  dut->funct7 = funct7;
  dut->opcode = opcode;
}

void test_operation(Valu *dut, VerilatedVcdC *trace, vluint32_t op1,
                    vluint32_t op2, vluint8_t opcode, vluint8_t funct3,
                    vluint8_t funct7, const char *desc,
                    vluint32_t expected_result) {
  std::cout << "Testing: " << desc << "\n";

  // Set the inputs
  set_dut_values(dut, op1, op2, opcode, funct3, funct7);

  // Evaluate the DUT for several cycles
  for (int i = 0; i < 5; i++) {
    dut->eval();
    trace->dump(main_time);
    main_time++;
  }

  // Verify the result
  if (dut->result != expected_result) {
    std::cerr << "[ERROR] Test failed for " << desc << "\n";
    std::cerr << "Expected: " << expected_result << ", Got: " << dut->result
              << "\n";
    throw std::runtime_error("Test failed");
  }

  std::cout << "Result: " << dut->result << " (PASS)\n";
}

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  Valu *dut = new Valu("tb_alu");

  Verilated::traceEverOn(true);
  VerilatedVcdC *trace = new VerilatedVcdC;
  dut->trace(trace, 5);
  trace->open("waveform.vcd");

  try {
    // Test ADD operation
    test_operation(dut, trace, 5, 10, RTYPEOP, ADDFUNCT3, ADDFUNCT7, "ADD", 15);

    // Test SUB operation
    test_operation(dut, trace, 15, 5, RTYPEOP, SUBFUNCT3, SUBFUNCT7, "SUB", 10);

    // Test AND operation
    test_operation(dut, trace, 0xF0F0F0F0, 0x0F0F0F0F, RTYPEOP, ANDFUNCT3,
                   ANDFUNCT7, "AND", 0x00000000);

    // Test OR operation
    test_operation(dut, trace, 0xF0F0F0F0, 0x0F0F0F0F, RTYPEOP, ORFUNCT3,
                   ORFUNCT7, "OR", 0xFFFFFFFF);

    // Test XOR operation
    test_operation(dut, trace, 0xF0F0F0F0, 0x0F0F0F0F, RTYPEOP, XORFUNCT3,
                   XORFUNCT7, "XOR", 0xFFFFFFFF);

    // Test SLL operation
    test_operation(dut, trace, 0x1, 2, RTYPEOP, SLLFUNCT3, SLLFUNCT7, "SLL",
                   0x4);

    // Test SRL operation
    test_operation(dut, trace, 0x10, 2, RTYPEOP, SRLFUNCT3, SRLFUNCT7, "SRL",
                   0x4);

    // Test SRA operation
    test_operation(dut, trace, 0x80000000, 2, RTYPEOP, SRAFUNCT3, SRAFUNCT7,
                   "SRA", 0xE0000000);

    // Test MUL operation
    test_operation(dut, trace, 6, 7, RTYPEOP, MULFUNCT3, MULFUNCT7, "MUL", 42);

    // Test DIV operation
    test_operation(dut, trace, 42, 7, RTYPEOP, DIVFUNCT3, DIVFUNCT7, "DIV", 6);
  } catch (const std::runtime_error &e) {
    std::cerr << e.what() << "\n";
  }

  trace->close();
  delete dut;

  return 0;
}
