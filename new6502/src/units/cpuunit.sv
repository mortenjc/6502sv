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
  output opc_t opc,
  output addmod_t addmode,
  output data_t addrlo,
  output data_t addrhi,
  output addr_t clocks
  );

  data_t lIR;
  assign lIR = memory_table[PC[8:0]];

  // always updated will be stored during fetch
  opc_t decode_opcode;
  addmod_t decode_addmode;
  decode decode_i(
    .instr(lIR),
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


  // Debug
  always_ff @ (posedge clk) begin
    $display("clock: %d, PC: %h, IR %h alo %h ahi %h [X:%h] (state: %-6s, opcode %3s, mode %5s)",
             clocks, PC, IR, addrlo, addrhi,
             X, state.name(), opc.name(), addmode.name());
  end


  data_t nop;
  // Registers and memory
  always_ff @ (posedge clk) begin
    case (state)
      common_types::fetch:
        IR <= lIR;

      common_types::decode:
        case (opc)
          common_types::JMP:
            if (addmode == common_types::ABS)
              addrlo <= memory_table[PC[8:0] + 1];
          common_types::LDX:
            if (addmode == common_types::ZP)
              addrlo <= memory_table[PC[8:0] + 1];
            else
              X <= memory_table[PC[8:0] + 1];

          common_types::INX: X <= X + 1;

          default: nop <= nop;
        endcase

      common_types::memlo:
        if (opc == common_types::LDX)
          X <= memory_table[{1'b0, addrlo}];
        else if (opc == common_types::JMP)
          addrhi <= memory_table[PC[8:0] + 2];

      default: nop <= nop;
    endcase
  end

  // PC and clocks handling
  always_ff @ (posedge clk) begin
    case (state)
      common_types::fetch: begin
        opc <= decode_opcode;
        addmode <= decode_addmode;
        // no change on PC
      end

      common_types::decode:
        case (addmode)
          common_types::IMP: PC <= PC + 1;
          common_types::IMM: PC <= PC + 2;
          default: PC <= PC;
        endcase

      common_types::memlo:
        if (addmode == common_types::ZP)
          PC <= PC + 2;
        else if (addmode == common_types::ABS)
          PC <= {addrhi, addrlo};

      default: PC <= PC;
    endcase
    clocks <= clocks + 1;
  end


  // next state
  always_ff @ (posedge clk) begin
    case (state)
      common_types::fetch: state <= common_types::decode;
      common_types::decode:
        if (addmode == common_types::ZP || addmode == common_types::ABS)
          state <= common_types::memlo;
        else
          state <= common_types::fetch;
      common_types::memlo: state <= common_types::fetch;
      default: state <= state;
    endcase
  end

endmodule
