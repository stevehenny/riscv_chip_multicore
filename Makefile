# Verilator settings
VERILATOR = verilator
VERILATOR_FLAGS = -cc -I./include --trace --exe --build --coverage -o simv

# ALU simulation settings
ALU_SRC = src/alu.sv
TB_ALU_CPP = verification/tb_alu.cpp
ALU_OBJ_DIR = obj_alu
ALU_EXECUTABLE = $(ALU_OBJ_DIR)/Vtb_alu

# Register file simulation settings
REGFILE_SRC = src/regfile.sv
TB_REGFILE_CPP = verification/tb_regfile.cpp
REGFILE_OBJ_DIR = obj_regfile
REGFILE_EXECUTABLE = $(REGFILE_OBJ_DIR)/Vtb_regfile

L1_CACHE_SRC = src/l1_cache.sv 
TB_L1_CACHE_CPP = verification/tb_l1_cache.cpp
L1_CACHE_OBJ_DIR = obj_l1_cache
L1_CACHE_EXECUTABLE = $(L1_CACHE_OBJ_DIR)/Vtb_l1_cache

# Default target
.PHONY: all
all: alu_sim regfile_sim l1_cache_sim

# ALU simulation target
alu_sim: $(ALU_EXECUTABLE)

$(ALU_EXECUTABLE): $(ALU_SRC) $(TB_ALU_CPP)
	$(VERILATOR) $(VERILATOR_FLAGS) --Mdir $(ALU_OBJ_DIR) $(ALU_SRC) $(TB_ALU_CPP)

# Register file simulation target
regfile_sim: $(REGFILE_EXECUTABLE)

$(REGFILE_EXECUTABLE): $(REGFILE_SRC) $(TB_REGFILE_CPP)
	$(VERILATOR) $(VERILATOR_FLAGS) --Mdir $(REGFILE_OBJ_DIR) $(REGFILE_SRC) $(TB_REGFILE_CPP)

l1_cache_sim: $(L1_CACHE_EXECUTABLE)

$(L1_CACHE_EXECUTABLE): $(L1_CACHE_SRC) $(TB_L1_CACHE_CPP)
	$(VERILATOR) $(VERILATOR_FLAGS) --Mdir $(L1_CACHE_OBJ_DIR) $(L1_CACHE_SRC) $(TB_L1_CACHE_CPP)

# Clean target
.PHONY: clean
clean:
	@rm -rf $(ALU_OBJ_DIR) $(REGFILE_OBJ_DIR)
	@rm -f alu_sim regfile_sim

