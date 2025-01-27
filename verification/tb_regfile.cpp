#include "../obj_regfile/Vregfile.h"
#include "verilatedos.h"
#include <cmath>
#include <iostream>
#include <stdexcept>
#include <verilated.h>
#include <verilated_vcd_c.h>

static vluint64_t main_time = 0;

void test_input(Vregfile *dut, VerilatedVcdC *trace, vluint8_t writeReg,
                vluint8_t readReg1, vluint8_t readReg2, vluint8_t write,
                vluint32_t writeData, vluint32_t correct_data1,
                vluint32_t correct_data2) {

  dut->write = write;
  dut->writeReg = writeReg;
  dut->writeData = writeData;
  dut->readReg1 = readReg1;
  dut->readReg2 = readReg2;
  dut->clk = 0;

  for (int i = 0; i < 4; i++) {
    dut->clk = !dut->clk;
    dut->eval();
    trace->dump(main_time);
    main_time++;
  }

  if (dut->readData1 != correct_data1) {
    std::cerr << "[ERROR] Test failed when reading from readReg1: "
              << dut->readReg1 << std::endl;
    std::cerr << "Expected: " << correct_data1 << ", Got: " << dut->readData1
              << std::endl;
    throw std::runtime_error("Test Failed");
  }

  if (dut->readData2 != correct_data2) {
    std::cerr << "[ERROR] Test failed when reading from readReg1: "
              << dut->readReg2 << std::endl;
    std::cerr << "Expected: " << correct_data2 << ", Got: " << dut->readData2
              << std::endl;
    throw std::runtime_error("Test Failed");
  }
  std::cout << "Register: " << readReg1 << ", DATA1: " << dut->readData1
            << std::endl;
  std::cout << "Register: " << readReg2 << ", DATA2: " << dut->readData2
            << std::endl;
}

int main(int argc, char *argv[]) {

  Verilated::commandArgs(argc, argv);
  Vregfile *dut = new Vregfile("tb_regfile");

  // Enable tracing
  Verilated::traceEverOn(true);
  VerilatedVcdC *trace = new VerilatedVcdC;

  // Open trace
  dut->trace(trace, 99); // Increase depth if needed
  trace->open("regfile.vcd");

  // Run tests
  try {
    test_input(dut, trace, 0x00, 0x00, 0x01, 1, 0xffffffff, 0x00000000,
               0x00000000);
    test_input(dut, trace, 0x01, 0x01, 0x02, 1, 0xffffffff, 0xffffffff,
               0x00000000);
    test_input(dut, trace, 0x02, 0x01, 0x02, 1, 0x0000cccc, 0xffffffff,
               0x0000cccc);
    test_input(dut, trace, 0x03, 0x02, 0x03, 1, 0x00000001, 0x0000cccc,
               0x00000001);
  } catch (const std::exception &e) {
    std::cerr << "Simulation failed: " << e.what() << std::endl;
  }

  // Finalize and close trace
  trace->flush();
  trace->close();

  delete trace;
  delete dut;
  return 0;
}
