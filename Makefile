# Verilator settings
VERILATOR = verilator
VFLAGS = -Wall -Wno-fatal --binary --exe --build --trace --timing --timescale "1ns/1ps" -sv

# UVM settings
# UVM_DIR = ./uvm_src/src
# UVM_FILES = $(UVM_DIR)/uvm_pkg.sv $(UVM_DIR)/uvm_macros.svh
# UVM_INCLUDE = -I$(UVM_DIR)

# Source files
SRC_DIR = ./src
TB_DIR = ./verification
INCLUDE_DIR = ./include

TB_FILES = $(TB_DIR)/tb_alu.sv
SRC_FILES = $(SRC_DIR)/alu.sv

# Output settings
OUTPUT_DIR = ./obj_dir
TOP_MODULE = tb_alu
EXE_NAME = simv

# Default target
.PHONY: all
all: $(EXE_NAME)

# Build the Verilator executable
$(EXE_NAME): $(SRC_FILES) $(TB_FILES)
	$(VERILATOR) $(VFLAGS)  \
		--Mdir $(OUTPUT_DIR) -I$(INCLUDE_DIR) \
		--top-module $(TOP_MODULE) \
		-o $(EXE_NAME)  $(SRC_FILES) $(TB_FILES)

# Clean build files
.PHONY: clean
clean:
	rm -rf $(OUTPUT_DIR) $(EXE_NAME)

# Run the simulation
.PHONY: run
run: $(EXE_NAME)
	./$(EXE_NAME)
