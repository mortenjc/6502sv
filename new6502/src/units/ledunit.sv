// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief 7 segment LED display for DE10-lite version supporting some letters
//===----------------------------------------------------------------------===//

import common_types::dispsel_t;
import common_types::data_t;
import common_types::addr_t;
import common_types::opc_t;
import common_types::state_t;

module ledunit(
  input dispsel_t sel,
  input addr_t cycles,
  input addr_t pc,
  input addr_t addr,
  input opc_t opc,
  input data_t instr,
  input state_t state,
  input data_t X,
  output bit [7:0] hex5,
  output bit [7:0] hex4,
  output bit [7:0] hex3,
  output bit [7:0] hex2,
  output bit [7:0] hex1,
  output bit [7:0] hex0
	);

  bit [31:0] word;
  bit [7:0] byte5, byte4, byte3, byte2, byte1, byte0;  
  always_comb begin
    case (sel)
      common_types::CC:    word = {8'd67, 8'd67,        cycles};
      common_types::PC:    word = {8'd80, 8'd67,        pc    };
		common_types::INSTR: word = {8'd73, 8'd78, 8'd78, instr };
		common_types::X:     word = {8'd88, 8'h7f, 8'b0,  X};
      common_types::OP:    word = {8'd79, 8'd80, 8'b0,  data_t'(opc)};
      common_types::STATE: word = {8'd83, 8'd84, 8'b0,  data_t'(state)};
		common_types::ADDR:  word = {8'd65, 8'd68,        addr  };
      default:             word = {8'h7f, 8'h7f, 8'h7f, 8'h7f };
    endcase

    byte5 = word[31:24];
    byte4 = word[23:16];
	 if (sel == common_types::CC || sel == common_types::PC || sel == common_types::ADDR) begin
      byte3 = {4'b0, word[15:12]};
      byte2 = {4'b0, word[11:8]};
	 end else begin
	   byte3 = 8'h7f;
		byte2 = 8'h7f;
	 end
    byte1 = {4'b0, word[7:4]};
    byte0 = {4'b0, word[3:0]};
  end

  ledctrl ledctrl_5(
    .value(byte5),
    .led(hex5)
    );

  ledctrl ledctrl_4(
    .value(byte4),
    .led(hex4)
    );

  ledctrl ledctrl_3(
    .value(byte3),
    .led(hex3)
    );

  ledctrl ledctrl_2(
    .value(byte2),
    .led(hex2)
    );

  ledctrl ledctrl_1(
    .value(byte1),
    .led(hex1)
    );

  ledctrl ledctrl_0(
    .value(byte0),
    .led(hex0)
    );
endmodule
