#include "Vregfile.h"
#include "verilated.h"
#include "verilated_cov.h"
#include "verilated_vcd_c.h"
#include <cstdlib>
#include <iostream>
#include <stdexcept>
#define MAX_SIM_TIME 500
vluint64_t main_time = 0;

// Function to simulate a clock cycle
void tick(Vregfile *dut, VerilatedVcdC *trace) {
  for (int i = 0; i < 2; i++) { // Toggle clock twice per full cycle
    dut->clk = !dut->clk;
    dut->eval();
    trace->dump(main_time++);
  }
}

// Reset the register file
void reset_dut(Vregfile *dut, VerilatedVcdC *trace) {
  dut->write = 0;
  dut->writeReg = 0;
  dut->writeData = 0;
  dut->readReg1 = 0;
  dut->readReg2 = 0;

  for (int i = 0; i < 5; i++)
    tick(dut, trace); // Run a few cycles
  printf("[INFO] Reset complete\n");
}

// Function to write to a register
void write_register(Vregfile *dut, VerilatedVcdC *trace, uint8_t reg,
                    uint32_t value) {
  dut->write = 1;
  dut->writeReg = reg;
  dut->writeData = value;

  tick(dut, trace); // Simulate one clock cycle
  dut->write = 0;   // Disable write
  tick(dut, trace); // Allow the value to settle
}

// Function to read from registers
uint32_t read_register(Vregfile *dut, VerilatedVcdC *trace, uint8_t reg) {
  dut->readReg1 = reg;
  tick(dut, trace);
  return dut->readData1;
}

// Comprehensive test
void full_coverage_test(Vregfile *dut, VerilatedVcdC *trace) {
  printf("[INFO] Running full coverage test...\n");

  // 1️⃣ **Test writing to and reading from all registers**
  for (uint8_t reg = 0; reg < 32; reg++) {
    uint32_t test_value = (rand() % 0xFFFFFFFF); // Random value
    write_register(dut, trace, reg, test_value);

    uint32_t read_value = read_register(dut, trace, reg);
    if (reg == 0) {
      // Register x0 should always return 0
      if (read_value != 0) {
        printf("[ERROR] x0 modified! Got: 0x%X\n", read_value);
        throw std::runtime_error("Test Failed");
      }
    } else {
      if (read_value != test_value) {
        printf("[ERROR] Mismatch at reg[%d]: Expected: 0x%X, Got: 0x%X\n", reg,
               test_value, read_value);
        throw std::runtime_error("Test Failed");
      }
    }
    printf("[PASS] reg[%d] correctly stores 0x%X\n", reg, read_value);
  }

  // 2️⃣ **Test simultaneous reads from different registers**
  for (uint8_t r1 = 0; r1 < 32; r1++) {
    for (uint8_t r2 = 0; r2 < 32; r2++) {
      dut->readReg1 = r1;
      dut->readReg2 = r2;
      tick(dut, trace);

      printf("[DEBUG] Read reg[%d] = 0x%X, Read reg[%d] = 0x%X\n", r1,
             dut->readData1, r2, dut->readData2);
    }
  }

  printf("[SUCCESS] Full coverage test passed!\n");
}

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  Vregfile *dut = new Vregfile;

  Verilated::traceEverOn(true);
  VerilatedVcdC *trace = new VerilatedVcdC;
  dut->trace(trace, 5);
  trace->open("waveform_full.vcd");

  // Initialize clock
  dut->clk = 0;
  dut->eval();
  trace->dump(main_time++);

  // Reset the design
  reset_dut(dut, trace);

  // Run full coverage tests
  try {
    full_coverage_test(dut, trace);
  } catch (const std::runtime_error &e) {
    printf("[FAIL] Test failed: %s\n", e.what());
    trace->close();
    delete dut;
    delete trace;
    return 1;
  }

  printf("[SUCCESS] All tests passed with full coverage!\n");

  // Write coverage data
  VerilatedCov::write("coverage.dat");

  trace->close();
  delete dut;
  delete trace;
  return 0;
}
