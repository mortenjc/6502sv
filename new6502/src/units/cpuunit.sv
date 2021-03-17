// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief 6502 CPU attempt
//===----------------------------------------------------------------------===//

import common_types::addr_t;
import common_types::data_t;
import common_types::state_t;
import common_types::addmod_t;
import common_types::opc_t;

module cpuunit(
  input bit clk,

  output data_t X,
  // debug
  output state_t state,
  output addr_t PC,
  output data_t IR,
  // output data_t OP1,
  output addr_t clocks
  );

  opc_t opcode;
  addmod_t addmode;
  //

  // always updated will be stored during fetch
  opc_t decode_opcode;
  addmod_t decode_addmode;
  decode decode_i(
    .instr(IR),
    .opcode(decode_opcode),
    .mode(decode_addmode)
    );


  // memory
  parameter memory_file="cpumemory_test.mem";
  data_t memory_table[512];

  initial begin
    $display("Loading rom ...");
    $readmemh(memory_file, memory_table);
  end



  data_t nop;
  // Registers and memory
  always_ff @ (posedge clk) begin
    case (state)
      common_types::fetch:
        IR <= memory_table[PC[8:0]];

      common_types::decode:
        case (opcode)
          common_types::LDX: X <= memory_table[PC[8:0] + 1];
          common_types::INX: X <= X + 1;
          default: nop <= nop;
        endcase
      default: nop <= nop;
    endcase
  end

  // PC and clocks handling
  always_ff @ (posedge clk) begin
  $display("clock: %d, PC: %h, IR %h [X:%h] (state: %-6s, opcode %3s, mode %5s)",
           clocks, PC, IR,
           X, state.name(), opcode.name(), addmode.name());

    case (state)
      common_types::fetch: begin
        opcode <= decode_opcode;
        addmode <= decode_addmode;
        // no change on PC
      end
      common_types::decode:
        case (addmode)
          common_types::IMP: PC <= PC + 1;
          common_types::IMM: PC <= PC + 2;
          default PC <= PC;
        endcase
      default: PC <= PC;
    endcase
    clocks <= clocks + 1;
  end


  // next state
  always_ff @ (posedge clk) begin
    case (state)
      common_types::fetch: state <= common_types::decode;
      common_types::decode: state <= common_types::fetch;
      default: state <= state;
    endcase
  end

endmodule
