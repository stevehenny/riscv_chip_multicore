# Define variables
VERILATOR = verilator
VERILATOR_FLAGS = -cc -I./include/
TRACE_FLAGS = -Wall -Wno-UNUSED --trace --exe --build
SRC = src/alu.sv
TB_CPP = verification/tb_alu.cpp
EXECUTABLE = obj_dir/Vtb_alu

# Default target
.PHONY: all
all: alu_sim

# Target for building the Verilator executable
alu_sim: $(EXECUTABLE)

$(EXECUTABLE): $(SRC) $(TB_CPP)
	$(VERILATOR) $(VERILATOR_FLAGS) $(SRC)
	$(VERILATOR) $(TRACE_FLAGS) -cc $(TB_CPP) $(SRC)

# Clean target
.PHONY: clean
clean:
	@rm -rf obj_dir
	@rm -f alu_sim
