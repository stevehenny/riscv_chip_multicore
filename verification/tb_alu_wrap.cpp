#include "../obj_dir/Vtb_alu.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

vluint64_t main_time = 0;
double sc_time_stamp() { return main_time; }

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  Vtb_alu *tb = new Vtb_alu("tb");

  Verilated::traceEverOn(true);
  VerilatedVcdC *tfp = new VerilatedVcdC;
  tb->trace(tfp, 99);
  tfp->open("dump.vcd");

  while (!Verilated::gotFinish() && main_time < 1000000) {
    tb->eval();
    tfp->dump(main_time);
    main_time++;
  }

  tfp->close();
  delete tb;
  return 0;
}
