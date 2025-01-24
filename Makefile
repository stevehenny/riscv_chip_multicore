VERILATOR = verilator
VERILATOR_FLAGS = -Wall -Wno-UNUSED --trace --timing -I./include

SRC_FILES = src/alu.sv verification/tb_alu.sv
WRAP_FILE = verification/tb_alu_wrap.cpp

EXECUTABLE = alu_sim

all: $(EXECUTABLE)

$(EXECUTABLE): $(SRC_FILES) $(WRAP_FILE)
	$(VERILATOR) $(VERILATOR_FLAGS) --cc --exe --build -j 0 -top-module tb_alu $(SRC_FILES) $(WRAP_FILE)
	cp obj_dir/Vtb_alu $(EXECUTABLE)

run: $(EXECUTABLE)
	./$(EXECUTABLE)

clean:
	rm -rf obj_dir $(EXECUTABLE) *.vcd

.PHONY: all run clean
