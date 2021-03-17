// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief Control via buttons and switches
//===----------------------------------------------------------------------===//

module control(
  input bit clk,
  input bit[1:0] switch,
  output bit [1:0] ledsel
  );
  
  assign ledsel = switch;
  
endmodule