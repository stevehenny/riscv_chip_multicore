# Define variables
VERILATOR = verilator
VERILATOR_FLAGS = -cc -I./include/ --Mdir $(ALU_OBJ_DIR)
TRACE_FLAGS = --trace --exe --build
ALU_SRC = src/alu.sv
TB_ALU_CPP = verification/tb_alu.cpp
ALU_OBJ_DIR = obj_alu
ALU_EXECUTABLE = $(ALU_OBJ_DIR)/Vtb_alu

# Default target
.PHONY: all
all: alu_sim

# Target for building the Verilator executable
alu_sim: $(ALU_EXECUTABLE)

$(ALU_EXECUTABLE): $(ALU_SRC) $(TB_ALU_CPP)
	$(VERILATOR) $(VERILATOR_FLAGS) $(TRACE_FLAGS) $(ALU_SRC) $(TB_ALU_CPP)

# Clean target
.PHONY: clean
clean:
	@rm -rf $(ALU_OBJ_DIR)
	@rm -f alu_sim

