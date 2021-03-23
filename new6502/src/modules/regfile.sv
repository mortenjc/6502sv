// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief 6502 register file
//===----------------------------------------------------------------------===//

import common_types::data_t;
import common_types::regf_t;
import common_types::rw_t;

module control(
  input bit clk,
  input rw_t rw1,
  input regf_t sel1, // register select 1
  input data_t in1,  // data1
  output data_t out1
  );

  data_t R[8];

  always_ff @ (posedge clk) begin
  if (rw1 == Read)
    out1 <= R[sel1];
  else
    R[sel1] <= in1;
  end

endmodule
