#include "Vl1_cache.h" // Updated to match your module name
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>

#define CLK_PERIOD 10

// Simulation time tracking
vluint64_t main_time = 0;
double sc_time_stamp() { return main_time; }

// Clock cycle simulation
void tick(Vl1_cache *cache, VerilatedVcdC *vcd) {
  cache->clk = 0;
  cache->eval();
  if (vcd)
    vcd->dump(main_time);
  main_time += CLK_PERIOD / 2;

  cache->clk = 1;
  cache->eval();
  if (vcd)
    vcd->dump(main_time);
  main_time += CLK_PERIOD / 2;
}

void reset_cache(Vl1_cache *cache, VerilatedVcdC *vcd) {
  cache->reset = 1;
  tick(cache, vcd);
  cache->reset = 0;
  tick(cache, vcd);
}

void write_data(Vl1_cache *cache, uint32_t addr, uint32_t data,
                VerilatedVcdC *vcd) {
  cache->addr = addr;
  cache->wdata = data;
  cache->wr = 1;
  cache->rd = 0;
  tick(cache, vcd);
  cache->wr = 0;
}

void read_data(Vl1_cache *cache, uint32_t addr, VerilatedVcdC *vcd) {
  cache->addr = addr;
  cache->rd = 1;
  tick(cache, vcd);
  std::cout << "Read addr: 0x" << std::hex << addr << " Data: 0x"
            << cache->rdata << " Hit: " << static_cast<int>(cache->hit)
            << std::endl;
  ;

  cache->rd = 0;
}

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  Verilated::traceEverOn(true); // Enable tracing

  Vl1_cache *cache = new Vl1_cache;
  VerilatedVcdC *vcd = new VerilatedVcdC;

  cache->trace(vcd, 99);     // Trace all signals
  vcd->open("l1_cache.vcd"); // Output file

  // Reset cache before running tests
  reset_cache(cache, vcd);

  // Addresses mapping to different sets (assuming 32-byte blocks)
  uint32_t addrA1 = 0x1000; // Set index 0, tag = 1
  uint32_t addrA2 = 0x1800; // Set index 0, tag = 3 (conflict with A1)
  uint32_t addrB1 = 0x1040; // Set index 1, tag = 1
  uint32_t addrB2 = 0x1840; // Set index 1, tag = 3 (conflict with B1)

  // ✅ **Basic Functionality**
  write_data(cache, addrA1, 0xDEADBEEF, vcd);
  read_data(cache, addrA1, vcd); // Hit

  write_data(cache, addrB1, 0xCAFEBABE, vcd);
  read_data(cache, addrB1, vcd); // Hit

  // ✅ **Cache Conflict (LRU Replacement)**
  write_data(cache, addrA2, 0xBEEFCAFE, vcd); // Replaces A1 or B1
  read_data(cache, addrA1, vcd);              // Miss if A1 was evicted

  write_data(cache, addrB2, 0x12345678, vcd); // Replaces B1 or B2
  read_data(cache, addrB1, vcd);              // Miss if B1 was evicted

  // ✅ **Read Miss Test**
  read_data(cache, 0x2000, vcd); // First access, should MISS

  // ✅ **Multiple Consecutive Reads/Writes**
  write_data(cache, 0x3000, 0xAABBCCDD, vcd);
  write_data(cache, 0x3040, 0x11223344, vcd);
  read_data(cache, 0x3000, vcd); // Hit
  read_data(cache, 0x3040, vcd); // Hit

  // ✅ **Reset Test**
  reset_cache(cache, vcd);
  read_data(cache, addrA1, vcd); // Should MISS after reset

  // Close VCD
  vcd->close();
  delete cache;
  delete vcd;
  return 0;
}
