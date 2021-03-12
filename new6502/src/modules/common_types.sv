// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief common definitions used across modules
//===----------------------------------------------------------------------===//

package common_types;

typedef logic[8:0] addr_t /* verilator public */ ;
typedef logic[7:0] data_t /* verilator public */ ;

// enums
typedef enum logic [1:0] {
  rst0, fetch, decode
} state_t /* verilator public */ ;


// Opcodes
// Mostly from http://nparker.llx.com/a2/opcodes.html
typedef enum logic [5:0] {
  U,
  ORA, AND, EOR, ADC,   STA, LDA, CMP, SBC,
  ASL, ROL, LSR, ROR,   STX, LDX, DEC, INC,
  BIT, JMP, STY, LDY,   CPY, CPX,
  BPL, BMI, BVC, BVS,   BCC, BCS, BNE, BEQ,
  BRK, JSR, RTI, RTS,
  PHP, PLP, PHA, PLA,   DEY, TAY, INY, INX,
  CLC, SEC, CLI, SEI,   TYA, CLV, CLD, SED,
  TXA, TXS, TAX, TSX,   DEX, NOP
} opc_t /* verilator public */ ;


// Addressing modes
// http://nparker.llx.com/a2/opcodes.html
typedef enum logic [5:0] {
  IXID,      // ZP indexed indirect - ($xx, X)
  ZP,        // Zero Page - $xx
  IMM,       // immediate - #$xx
  ABS,       // absolute - $abcd
  INDY,      //
  IDIX,      // ZP indirect indexed - ($xx),Y
  ZPX,       // Zero Page X - $xx,X
  ZPY,       // Zero Page Y - $xx,Y
  ABSX,      // Absolute X - $xxxx,X
  ABSY,      // Absolute Y - $xxxx,Y
  ACC,       // Accumulator
  // IMP,       // Implied
  // REL        // Relative
  UNKN       // Unknown - unassigned
} addmod_t /* verilator public */ ;

endpackage : common_types
