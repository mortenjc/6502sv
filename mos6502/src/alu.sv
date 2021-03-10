// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief ALU
//===----------------------------------------------------------------------===//

import common_types::data_t;
import common_types::alu_t;

module alu(
    input alu_t func,
    input data_t a_in,
    input data_t b_in,
    input bit c_in,
    output data_t out,
    output bit c_out
  );

/* verilator lint_off UNUSED */
bit tmp;
/* verilator lint_on UNUSED */

always_comb begin
  c_out = c_in;
  unique case(func)
    common_types::AINC: out = a_in + 1;
    /* verilator lint_off WIDTH */
    common_types::AADD: {c_out, out} = a_in + b_in + c_in;
    common_types::ASUB: {c_out, out }= a_in - b_in - c_in;
    /* verilator lint_on WIDTH */
    common_types::AAND: out = a_in & b_in;
    common_types::AORA: out = a_in | b_in;
    common_types::AEOR: out = a_in ^ b_in;
    default: begin
      out = 8'b0;
      c_out = 1'b0;
    end
  endcase

end

endmodule
