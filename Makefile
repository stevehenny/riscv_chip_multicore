
# Define variables
VERILATOR = verilator
VERILATOR_FLAGS = --sv --trace -Iinclude -Ienv
SRC_DIR = src
TB_DIR = verification
BUILD_DIR = build

# Source and testbench files
ALU_SRC = $(SRC_DIR)/alu.sv
TB_SRC = $(TB_DIR)/alu_tb.sv

# Output executable name
OUTPUT = alu_tb

# Default target
all: $(OUTPUT)

# Rule to build the testbench
$(OUTPUT): $(ALU_SRC) $(TB_SRC)
	$(VERILATOR) $(VERILATOR_FLAGS) --cc $(TB_SRC) $(ALU_SRC) --build -o $(OUTPUT)

# Check if tb_alu.sv exists
$(TB_SRC):
	@echo "Error: Testbench file $(TB_SRC) not found!"
	@exit 1

# Clean rule
clean:
	rm -rf $(OUTPUT) obj_dir

.PHONY: all clean

