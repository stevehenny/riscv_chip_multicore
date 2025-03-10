`timescale 1ns / 1ps
`include "../include/opcode_constants.sv"
module alu #(
    parameter WIDTH = 32
) (
    input wire logic [WIDTH-1:0] op1,
    input wire logic [WIDTH-1:0] op2,
    output logic [WIDTH-1:0] result,
    input wire logic [6:0] opcode,
    input wire logic [2:0] funct3,
    input wire logic [6:0] funct7,
    output logic zero,
    output logic status
);


  localparam SHIFTWIDTH = $clog2(WIDTH);


  always_comb begin
    result = {WIDTH{1'b0}};  // Default value
    zero   = 1'b0;
    status = 1'b0;  // Default unused status

    case (opcode)
      RTYPEOP: begin
        case (funct3)
          ADDFUNCT3: begin
            case (funct7)
              ADDFUNCT7: result = op1 + op2;
              SUBFUNCT7: result = op1 - op2;
              MULFUNCT7: result = $signed(op1) * $signed(op2);
              default:   result = {WIDTH{1'b0}};
            endcase
          end
          ANDFUNCT3: result = op1 & op2;
          ORFUNCT3: begin
            case (funct7)
              ORFUNCT7:  result = op1 | op2;
              REMFUNCT7: result = op1 % op2;
              default:   result = {WIDTH{1'b0}};
            endcase
          end
          XORFUNCT3: begin
            case (funct7)
              XORFUNCT7: result = op1 ^ op2;
              DIVFUNCT7: result = op1 / op2;
              default:   result = {WIDTH{1'b0}};
            endcase
          end
          SLLFUNCT3: result = op1 << op2[SHIFTWIDTH-1:0];
          SRLFUNCT3: begin
            case (funct7)
              SRLFUNCT7: result = op1 >> op2[SHIFTWIDTH-1:0];
              SRAFUNCT7: result = $signed(op1) >>> op2[SHIFTWIDTH-1:0];
              default:   result = {WIDTH{1'b0}};
            endcase
          end
          SLTFUNCT3:
          result = ($signed(op1) < $signed(op2)) ? {{WIDTH - 1{1'b0}}, 1'b1} : {WIDTH{1'b0}};
          SLTUFUNCT3: result = (op1 < op2) ? {{WIDTH - 1{1'b0}}, 1'b1} : {WIDTH{1'b0}};
          default: result = {WIDTH{1'b0}};
        endcase
      end

      ITYPEOP: begin
        case (funct3)
          ADDFUNCT3: result = op1 + op2;
          ANDFUNCT3: result = op1 & op2;
          ORFUNCT3: result = op1 | op2;
          XORFUNCT3: result = op1 ^ op2;
          SLLFUNCT3: result = op1 << op2[SHIFTWIDTH-1:0];
          SRLFUNCT3: begin
            case (funct7)
              7'b0000000: result = op1 >> op2[SHIFTWIDTH-1:0];
              7'b0100000: result = $signed(op1) >>> op2[SHIFTWIDTH-1:0];
              default: result = {WIDTH{1'b0}};
            endcase
          end
          SLTFUNCT3:
          result = ($signed(op1) < $signed(op2)) ? {{WIDTH - 1{1'b0}}, 1'b1} : {WIDTH{1'b0}};
          SLTUFUNCT3: result = (op1 < op2) ? {{WIDTH - 1{1'b0}}, 1'b1} : {WIDTH{1'b0}};
          default: result = {WIDTH{1'b0}};
        endcase
      end

      default: result = {WIDTH{1'b0}};
    endcase

    zero = (result == {WIDTH{1'b0}});
  end
endmodule
