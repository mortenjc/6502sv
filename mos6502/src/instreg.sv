// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief cpu instruction register
//===----------------------------------------------------------------------===//

import common_types::data_t;
import common_types::il_t;

module instreg(
    input il_t il,
    input data_t data_in,
    output data_t opc_out
  );

data_t opcode;

always_comb begin
  if (il == common_types::LOAD) begin
    opcode = data_in;
  end

  opc_out = opcode;
end

endmodule
