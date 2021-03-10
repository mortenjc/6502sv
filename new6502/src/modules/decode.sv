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
    casez (instr)
      8'b00000000:  begin
                    opcode = common_types::BRK;
                    end
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
      default:      begin
                    opcode = common_types::NOP;
                    end
    endcase
  end

endmodule
