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
  input bit rst,

  output data_t X,
  //output data_t Y,
  output data_t A,
  // debug
  output state_t state,
  output addr_t PC,
  output data_t IR,
  output addr_t clocks
  );


  opc_t cpu_opcode;
  addmod_t cpu_addmode;
  //


  opc_t opcode;
  addmod_t mode;
  decode decode_i(
    .instr(IR),
    .opcode(opcode),
    .mode(mode)
    );


  // memory
  parameter memory_file="cpumemory_test.data";
  data_t memory_table[512];

  initial begin
    $display("Loading rom.");
    $readmemh(memory_file, memory_table);
  end

  // X register
  always_ff @ (posedge clk) begin
    if (state == common_types::decode)
      case (opcode)
        common_types::TAX: X <= A;
        common_types::TXA: A <= X;
        common_types::INX: X <= X + 1;
        common_types::DEX: X <= X - 1;
        default: X <= X;
      endcase
    else
      X <= X;
  end

  // PC and clocks handling
  always_ff @ (posedge clk) begin
    case (state)
      common_types::rst0: PC <= 0;
      common_types::decode: begin
        cpu_opcode <= opcode;
        cpu_addmode <= mode;

        case (opcode)
          common_types::BRK: PC <= 0;
          default :PC <= PC + 1;
        endcase
        $display("clock: %d, PC: %d, IR %d [X%d A%d] (state: %-6s, opcode %3s, mode %5s)",
                 clocks, PC, IR,
                 X, A,
                 state.name(), cpu_opcode.name(), cpu_addmode.name());
      end
      default: PC <= PC;
    endcase
    clocks <= clocks + 1;
  end

  // memory
  always_ff @ (posedge clk) begin
    case (state)
      common_types::fetch: IR <= memory_table[PC[8:0]];
      default: IR <= IR;
    endcase
  end


  always_ff @ (posedge clk or posedge rst) begin
    if (rst) begin
      state <= common_types::rst0;
    end else begin
      case (state)
        common_types::rst0: state <= common_types::fetch;
        common_types::fetch: state <= common_types::decode;
        common_types::decode: state <= common_types::fetch;
        default: state <= common_types::rst0;
      endcase
    end
  end

endmodule
