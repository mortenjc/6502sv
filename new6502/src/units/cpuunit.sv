// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief 6502 CPU attempt
/// opcodes: INX, DEX, LDX #, LDX ZP, JMP ABS, BEQ, BNE
/// flags: Z
//===----------------------------------------------------------------------===//

import common_types::addr_t;
import common_types::data_t;
import common_types::state_t;
import common_types::addmod_t;
import common_types::opc_t;

module cpuunit(
  input bit clk,
  input bit rst,
  input bit debug,

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

  // status flags
  bit Z;
  assign S = {6'b0, Z, 1'b0};

  // local variables
  data_t lIR, lOP1, lOP2;
  assign lIR = memory_table[PC[8:0]];
  assign lOP1 = memory_table[PC[8:0] + 1];
  assign lOP2 = memory_table[PC[8:0] + 2];


  // always updated, will be stored during fetch
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
    if (debug)
     $display("Loading rom ...");
    $readmemh(memory_file, memory_table);
  end


  // Debug
  always_ff @ (posedge clk) begin
   if (debug)
    $display("clock: %d, PC: %h, IR %h [X:%h S:%h] (state: %-6s, opcode %3s, mode %5s)",
             clocks, PC, IR, X, S, state.name, opc.name, addmode.name);
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
              addrlo <= lOP1;

          common_types::LDX:
            if (addmode == common_types::ZP)
              addrlo <= lOP1;
            else begin
              X <= lOP1;
              Z <= lOP1 == 0 ? '1 : '0;
            end

          common_types::INX: begin
            X <= X + 8'd1;
            Z <= X == 8'hff ? '1 : '0;
            end

          common_types::DEX: begin
            X <= X - 8'd1;
            Z <= X == 8'h01 ? '1 : '0;
            end

          default: nop <= nop;
        endcase

      common_types::memlo:
        if (opc == common_types::LDX) begin
          X <= memory_table[{1'b0, addrlo}];
          Z <= memory_table[{1'b0, addrlo}] == 8'b0 ? '1 : '0;
          end
        else if (opc == common_types::JMP)
          addrhi <= lOP2;

      default: nop <= nop;
    endcase
  end


  // PC and clocks handling
  always_ff @ (posedge clk) begin
    if (rst == 0)
	   PC <= 16'h00A0;
    else if (opc == common_types::HLT)
      PC <= PC;
	  else begin
      case (state)
        common_types::fetch: begin
          opc <= decode_opcode;
          addmode <= decode_addmode;
          // no change on PC
        end

        common_types::decode:
          case (addmode)
            common_types::REL:
              if ((opc == common_types::BEQ && ~S[1]) || (opc == common_types::BNE && S[1]))
                PC <= PC + 16'd2;
              else if ((opc == common_types::BEQ && S[1]) || (opc == common_types::BNE && ~S[1]))
                if (lOP1[7]) // negative
                  PC <= PC - (16'h0100 - {8'b0, lOP1});
                else
                  PC <= PC + {8'b0, lOP1} + 16'd2;

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
  end


  // next state
  always_ff @ (posedge clk) begin
    if (rst == 0)
	   state <= common_types::fetch;
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
