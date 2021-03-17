// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief 6502 CPU attempt
/// opcodes: INX, LDX #, LDX ZP, JMP ABS, BEQ
/// flags: Z
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
  output addr_t clocks,
  output data_t S
  );

  bit Z;
  assign S = {6'b0, Z, 1'b0};
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
  parameter memory_file="test/cpumemory_test.mem";
  data_t memory_table[512];

  initial begin
    $display("Loading rom ...");
    $readmemh(memory_file, memory_table);
  end


  // Debug
  always_ff @ (posedge clk) begin
   $display("clock: %d, PC: %h, IR %h alo %h ahi %h [X:%h S:%h] (state: %-6s, opcode %3s, mode %5s)",
            clocks, PC, IR, addrlo, addrhi,
            X, S, state.name(), opc.name(), addmode.name());
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
            else begin
              X <= memory_table[PC[8:0] + 1];
              Z <= memory_table[PC[8:0] + 1] == 0 ? 1 : 0;
            end

          common_types::INX: begin
            X <= X + 8'd1;
            Z <= X == 8'hff ? 1 : 0;
            end

          default: nop <= nop;
        endcase

      common_types::memlo:
        if (opc == common_types::LDX) begin
          X <= memory_table[{1'b0, addrlo}];
          Z <= memory_table[{1'b0, addrlo}] == 8'b0 ? 1 : 0;
          end
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
          common_types::REL:
            if (opc == common_types::BEQ && ~S[1])
              PC <= PC + 16'd2;
            else if (opc == common_types::BEQ && S[1])
              PC <= PC + {8'b0, memory_table[PC[8:0] + 1]} + 16'd2;

          common_types::IMP: PC <= PC + 16'd1;

          common_types::IMM: PC <= PC + 16'd2;

          default: PC <= PC;
        endcase

      common_types::memlo:
        if (addmode == common_types::ZP)
          PC <= PC + 16'd2;
        else if (addmode == common_types::ABS)
          PC <= {addrhi, addrlo};

      default: PC <= PC;
    endcase
    clocks <= clocks + 1'd1;
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
