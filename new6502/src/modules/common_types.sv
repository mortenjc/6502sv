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

typedef enum logic [3:0] {
  BRK, NOP, LDX, INC,   BNE, ORA, AND, EOR,
  ADC, STA, LDA, CMP,   SBC
} opc_t /* verilator public */ ;


endpackage : common_types
