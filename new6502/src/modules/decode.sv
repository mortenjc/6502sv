// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief instruction decode
//===----------------------------------------------------------------------===//

import common_types::data_t;
import common_types::opc_t;

module decode(
  input data_t instr,
  output opc_t opcode
  //output addrmode_t mode
  );

  always_comb begin
  case (instr)
    //
    8'h00: opcode = common_types::BRK;
    8'h20: opcode = common_types::JSR;
    8'h40: opcode = common_types::RTI;
    8'h60: opcode = common_types::RTS;
    // branch
    8'h10: opcode = common_types::BPL;
    8'h30: opcode = common_types::BMI;
    8'h50: opcode = common_types::BVC;
    8'h70: opcode = common_types::BVS;
    8'h90: opcode = common_types::BCC;
    8'hB0: opcode = common_types::BCS;
    8'hD0: opcode = common_types::BNE;
    8'hF0: opcode = common_types::BEQ;
    //
    8'h18: opcode = common_types::CLC;
    8'h38: opcode = common_types::SEC;
    8'h58: opcode = common_types::CLI;
    8'h78: opcode = common_types::SEI;
    8'h98: opcode = common_types::TYA;
    8'hB8: opcode = common_types::CLV;
    8'hD8: opcode = common_types::CLD;
    8'hF8: opcode = common_types::SED;
    //
    8'h08: opcode = common_types::PHP;
    8'h28: opcode = common_types::PLP;
    8'h48: opcode = common_types::PHA;
    8'h68: opcode = common_types::PLA;
    8'h88: opcode = common_types::DEY;
    8'hA8: opcode = common_types::TAY;
    8'hC8: opcode = common_types::INY;
    8'hE8: opcode = common_types::INX;
    //
    8'h8A: opcode = common_types::TXA;
    8'h9A: opcode = common_types::TXS;
    8'hAA: opcode = common_types::TAX;
    8'hBA: opcode = common_types::TSX;
    8'hCA: opcode = common_types::DEX;
    8'hEA: opcode = common_types::NOP;

    default: // pattern matched instructions
      casez (instr)
        // The cc = 01 opcodes
        8'b000???01:  begin
                      opcode = common_types::ORA;
                      end
        8'b001???01:  begin
                      opcode = common_types::AND;
                      end
        8'b010???01:  begin
                      opcode = common_types::EOR;
                      end
        8'b011???01:  begin
                      opcode = common_types::ADC;
                      end
        8'b100???01:  begin
                      opcode = common_types::STA;
                      end
        8'b101???01:  begin
                      opcode = common_types::LDA;
                      end
        8'b110???01:  begin
                      opcode = common_types::CMP;
                      end
        8'b111???01:  begin
                      opcode = common_types::SBC;
                      end
        // The cc = 10 opcodes
        8'b000???10:  begin
                      opcode = common_types::ASL;
                      end
        8'b001???10:  begin
                      opcode = common_types::ROL;
                      end
        8'b010???10:  begin
                      opcode = common_types::LSR;
                      end
        8'b011???10:  begin
                      opcode = common_types::ROR;
                      end
        8'b100???10:  begin
                      opcode = common_types::STX;
                      end
        8'b101???10:  begin
                      opcode = common_types::LDX;
                      end
        8'b110???10:  begin
                      opcode = common_types::DEC;
                      end
        8'b111???10:  begin
                      opcode = common_types::INC;
                      end
        // The cc = 00 opcodes
        8'b001???00:  begin
                      opcode = common_types::BIT;
                      end
        8'b010???00:  begin
                      opcode = common_types::JMP;
                      end
        8'b011???00:  begin
                      opcode = common_types::JMP; // ABS
                      end
        8'b100???00:  begin
                      opcode = common_types::STY;
                      end
        8'b101???00:  begin
                      opcode = common_types::LDY;
                      end
        8'b110???00:  begin
                      opcode = common_types::CPY;
                      end
        8'b111???00:  begin
                      opcode = common_types::CPX;
                      end
        default:      begin
                      opcode = common_types::NOP;
                      end
      endcase

    endcase // exact match on instruction codes
  end

endmodule
