module alu #(
    parameter WIDTH = 32
) (
    input logic [WIDTH-1:0] op1,
    input logic [WIDTH-1:0] op2,
    output logic [WIDTH-1:0] result,
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    output logic zero,
    output logic status
);

  `include "include/opcode_constants.sv"

  localparam SHIFTWIDTH = $clog2(WIDTH);


  always_comb begin
    result = {WIDTH{1'b0}};  // Default value
    zero   = 1'b0;
    status = 1'b0;  // Default unused status

    case (opcode)
      OP: begin
        case (funct3)
          ADDFUNCT3: begin
            case (funct7)
              ADDFUNCT7: result = op1 + op2;
              SUBFUNCT7: result = op1 - op2;
              default:   result = {WIDTH{1'b0}};
            endcase
          end
          ANDFUNCT3: result = op1 & op2;
          ORFUNCT3: result = op1 | op2;
          XORFUNCT3: result = op1 ^ op2;
          SLLFUNCT3: result = op1 << op2[SHIFTWIDTH-1:0];
          SRLFUNCT3: begin
            case (funct7)
              SRLFUNCT7: result = op1 >> op2[SHIFTWIDTH-1:0];
              SRAFUNCT7: result = $signed(op1) >>> op2[SHIFTWIDTH-1:0];
              default:   result = {WIDTH{1'b0}};
            endcase
          end
          SLTFUNCT3: result = ($signed(op1) < $signed(op2)) ? {1'b1} : {WIDTH{1'b0}};
          SLTUFUNCT3: result = (op1 < op2) ? {1'b1} : {WIDTH{1'b0}};
          MULFUNCT3: begin
            case (funct7)  // NOTE: doesn't seem to ever hit this case which is why I get 0
              MULFUNCT7: result = $signed(op1) * $signed(op2);
              default:   result = {WIDTH{1'b0}};
            endcase
          end
          DIVFUNCT3: begin
            case (funct7)
              DIVFUNCT7: result = op1 / op2;  // Integer division
              default:   result = {WIDTH{1'b0}};
            endcase
          end
          REMFUNCT3: begin
            case (funct7)
              REMFUNCT7: result = op1 % op2;  // Remainder
              default:   result = {WIDTH{1'b0}};
            endcase
          end
          default: result = {WIDTH{1'b0}};
        endcase
      end

      OPIMM: begin
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
          SLTFUNCT3: result = ($signed(op1) < $signed(op2)) ? {1'b1} : {WIDTH{1'b0}};
          SLTUFUNCT3: result = (op1 < op2) ? {1'b1} : {WIDTH{1'b0}};
          default: result = {WIDTH{1'b0}};
        endcase
      end

      default: result = {WIDTH{1'b0}};
    endcase

    zero = (result == {WIDTH{1'b0}});
  end
endmodule
