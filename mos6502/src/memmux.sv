// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief memory address mux
//===----------------------------------------------------------------------===//

import common_types::addr_t;
import common_types::mm_t;

module memmux(
    input mm_t mm,
    input addr_t pc_in,
    input addr_t addr_in,
    output addr_t addr_out
  );

always_comb begin
  if (mm == common_types::PC_ADDR)
    addr_out = pc_in;
  else
    addr_out = addr_in;
end

endmodule
