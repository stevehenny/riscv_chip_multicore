
// General opcode constants for register-register and immediate instructions
localparam logic [6:0] OP = 7'b0110011;  // Main opcode for register-register instructions
localparam logic [6:0] OPIMM = 7'b0010011;  // Opcode for immediate arithmetic instructions

// Arithmetic and logic operations using general opcode
localparam logic [2:0] ADDFUNCT3 = 3'b000;  // funct3: 000
localparam logic [6:0] ADDFUNCT7 = 7'b0000000;  // funct7: 0000000

localparam logic [2:0] SUBFUNCT3 = 3'b000;  // funct3: 000
localparam logic [6:0] SUBFUNCT7 = 7'b0100000;  // funct7: 0100000

localparam logic [2:0] ANDFUNCT3 = 3'b111;  // funct3: 111
localparam logic [6:0] ANDFUNCT7 = 7'b0000000;  // funct7: 0000000

localparam logic [2:0] ORFUNCT3 = 3'b110;  // funct3: 110
localparam logic [6:0] ORFUNCT7 = 7'b0000000;  // funct7: 0000000

localparam logic [2:0] XORFUNCT3 = 3'b100;  // funct3: 100
localparam logic [6:0] XORFUNCT7 = 7'b0000000;  // funct7: 0000000

localparam logic [2:0] SLLFUNCT3 = 3'b001;  // funct3: 001
localparam logic [6:0] SLLFUNCT7 = 7'b0000000;  // funct7: 0000000

localparam logic [2:0] SRLFUNCT3 = 3'b101;  // funct3: 101
localparam logic [6:0] SRLFUNCT7 = 7'b0000000;  // funct7: 0000000

localparam logic [2:0] SRAFUNCT3 = 3'b101;  // funct3: 101
localparam logic [6:0] SRAFUNCT7 = 7'b0100000;  // funct7: 0100000

localparam logic [2:0] SLTFUNCT3 = 3'b010;  // funct3: 010
localparam logic [6:0] SLTFUNCT7 = 7'b0000000;  // funct7: 0000000

localparam logic [2:0] SLTUFUNCT3 = 3'b011;  // funct3: 011
localparam logic [6:0] SLTUFUNCT7 = 7'b0000000;  // funct7: 0000000

// Multiplication and Division (M Extension)
localparam logic [2:0] MULFUNCT3 = 3'b000;  // funct3: 000
localparam logic [6:0] MULFUNCT7 = 7'b0000001;  // funct7: 0000001

localparam logic [2:0] DIVFUNCT3 = 3'b100;  // funct3: 100
localparam logic [6:0] DIVFUNCT7 = 7'b0000001;  // funct7: 0000001

localparam logic [2:0] REMFUNCT3 = 3'b110;  // funct3: 110
localparam logic [6:0] REMFUNCT7 = 7'b0000001;  // funct7: 0000001



