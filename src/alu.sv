module alu (
    input logic [31:0] op1,
    input logic [31:0] op2,
    output logic [31:0] result,
    input logic [6:0] opcode,  // 7-bit opcode field
    input logic [2:0] funct3,  // 3-bit funct3 field
    input logic [6:0] funct7,  // 7-bit funct7 field for some instructions
    output logic zero,
    output logic status
);

  `include "riscv_alu_constants.sv"

  always_comb begin : ALULOGIC
    case (opcode)
      //arithmetic and Logic instructions (OP -> REGISTER-REGISTER)
      OP: begin
        case (funct3)
          ADDFUNCT3:
          result = (funct7 == ADDFUNCT7) ? op1 + op2 :  // ADD
          (funct7 == SUBFUNCT7) ? op1 - op2 :  // SUB
          32'b0;  //ADD;
          ANDFUNCT3: result = op1 & op2;
          ORFUNCT3: result = op1 | op2;
          XORFUNCT3: result = op1 ^ op2;
          SLLFUNCT3: result = op1 << op2[4:0];  // SLL (SHIFT LEFT LOGICAL)
          SRLFUNCT3:
          result = (funct7 == SRLFUNCT7) ? op1 >> op2[4:0] :  //SRL (SHIFT RIGHT LOGICAL)
              (funct7 == SRAFUNCT7) ? $signed(op1) >>> op2[4:0] :
              32'b0;  //SRA (SHIFT RIGHT ARITHMATIC)
          SLTFUNCT3: result = ($signed(op1) < $signed(op2)) ? {32{1'b1}} : 32'b0;  // SLL
          SLTUFUNCT3: result = (op1 < op2) ? {32{1'b1}} : 32'b0;
          default: result = 32'b0;  // Unknown funct3
        endcase
      end

      OP_IMM: begin
        case (funct3)
          ADDFUNCT3: result = op1 + op2;  // ADDI
          ANDFUNCT3: result = op1 & op2;  // ANDI
          ORFUNCT3: result = op1 | op2;  // ORI
          XORFUNCT3: result = op1 ^ op2;  // XORI
          SLLFUNCT3: result = op1 << op2[4:0];  // SLLI
          SRLFUNCT3:
          result = (funct7 == 7'b0000000) ? op1 >> op2[4:0] :  // SRLI
              (funct7 == 7'b0100000) ? $signed(op1) >>> op2[4:0] :  // SRAI
              32'b0;
          SLTFUNCT3: result = ($signed(op1) < $signed(op2)) ? {32{1'b1}} : 32'b0;  // SLTI
          SLTUFUNCT3: result = (op1 < op2) ? {32{1'b1}} : 32'b0;  // SLTIU
          default: result = 32'b0;  // Unknown funct3
        endcase
      end
      default: result = 32'b0;
    endcase

    zero = (result == 32'b0);
  end

endmodule
