// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief cpu instruction register
//===----------------------------------------------------------------------===//

import common_types::state_t;
import common_types::data_t;
import common_types::il_t;
import common_types::mm_t;
import common_types::mw_t;
import common_types::ps_t;

/* verilator lint_off UNUSED */

module control(
    input clk,
    input data_t inst,
	 output state_t stateo,
    output il_t il,
    output mw_t mw,
    output mm_t mm,
    output ps_t ps
  );

state_t state;
state_t new_next_state;

always_comb begin
  unique case(state)
    common_types::INF: begin
      il = common_types::LOAD;
      mm = common_types::PC_ADDR;
      mw = common_types::READ;
      ps = common_types::INC;
      new_next_state = common_types::EX0;
    end

    common_types::EX0: begin
      il = common_types::NOLOAD;
      mm = common_types::PC_ADDR;
      mw = common_types::READ;
      ps = common_types::INC;
      new_next_state = common_types::INF;
    end

    default: begin
      il = common_types::LOAD;
      mm = common_types::PC_ADDR;
      mw = common_types::READ;
      ps = common_types::HOLD;
      new_next_state = common_types::INF;
    end

  endcase
end


  always_ff @(posedge clk) begin
    state <= new_next_state;
	 stateo <= new_next_state;
  end
/* verilator lint_on UNUSED */
endmodule
