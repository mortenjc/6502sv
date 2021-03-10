// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief 6502 CPU attempt
//===----------------------------------------------------------------------===//

import common_types::addr_t;
import common_types::data_t;
import common_types::state_t;

module cpu(
  input bit clk,
  input bit rst,

  output state_t state,
  output addr_t PC,
  output data_t IR
  );


  // memory
  parameter memory_file="cpumemory_test.data";
  data_t memory_table[512];

  initial begin
    $display("Loading rom.");
    $readmemh(memory_file, memory_table);
  end

  // PC handling
  always_ff @ (posedge clk) begin
    case (state)
      common_types::rst0: PC <= 0;
      //common_types::fetch: PC <= 0;
      common_types::decode: PC <= PC + 1;
      default: PC <= PC;
    endcase
  end

  // memory
  always_ff @ (posedge clk) begin
    case (state)
      common_types::fetch: IR <= memory_table[PC];
      default: IR <= IR;
    endcase
  end


  always_ff @ (posedge clk or posedge rst) begin
    $display("State: %d, PC: %d, IR %d", state, PC, IR);
    if (rst) begin
      state <= common_types::rst0;
    end else begin
      case (state)
        common_types::rst0: state <= common_types::fetch;
        common_types::fetch: state <= common_types::decode;
        common_types::decode: state <= common_types::fetch;
        default: state <= common_types::rst0;
      endcase
    end
  end

endmodule
