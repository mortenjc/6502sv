// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief common definitions used across modules
//===----------------------------------------------------------------------===//

package common_types;

typedef logic[15:0] addr_t /* verilator public */ ;
typedef logic[7:0] data_t /* verilator public */ ;

// enums
typedef enum logic [1:0] {
  fetch, decode,
  memlo // used for ZP
} state_t /* verilator public */ ;


// Opcodes
// Mostly from http://nparker.llx.com/a2/opcodes.html
typedef enum logic [5:0] {
  _uopc_,
  ORA, AND, EOR, ADC,   STA, LDA, CMP, SBC,
  ASL, ROL, LSR, ROR,   STX, LDX, DEC, INC,
  BIT, JMP, STY, LDY,   CPY, CPX,
  BPL, BMI, BVC, BVS,   BCC, BCS, BNE, BEQ,
  BRK, JSR, RTI, RTS,
  PHP, PLP, PHA, PLA,   DEY, TAY, INY, INX,
  CLC, SEC, CLI, SEI,   TYA, CLV, CLD, SED,
  TXA, TXS, TAX, TSX,   DEX, NOP,
  HLT
} opc_t /* verilator public */ ;


// Addressing modes
// http://nparker.llx.com/a2/opcodes.html
typedef enum logic [3:0] {
  _uaddmod_,
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
  REL,       // Relative
  IMP       // Implied
} addmod_t /* verilator public */ ;

// Selector for displaying data on the 7 segment display
typedef enum logic [2:0] {
  CC,
  PC,
  INSTR,
  X,
  OP,
  STATE,
  ADDR
} dispsel_t /* verilator public */ ;

endpackage : common_types
