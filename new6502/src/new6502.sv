// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief instruction decode
//===----------------------------------------------------------------------===//


module new6502(
  input bit clk,
  input bit clk_fpga,
  input bit rst,
  input bit [3:0] sw,
  output [7:0] hex5,
  output [7:0] hex4,
  output [7:0] hex3,
  output [7:0] hex2,
  output [7:0] hex1,
  output [7:0] hex0
  );

  bit clk_sel;
  assign clk_sel = sw[3];
  bit [2:0] disp_sel;
  assign disp_sel = sw[2:0];

  data_t IR;
  addr_t PC;
  addr_t clocks;
  opc_t opc;
  data_t X;
  state_t state;

  bit cpu_clk;
  clockunit clockunit_i(
    .clk_btn(clk),
	 .clk_fpga(clk_fpga),
	 .clk_sel(clk_sel),
	 .clk_out(cpu_clk)
  );  

  
  cpuunit cpuunit_i(
  .clk(cpu_clk),
  .rst(rst),
  .PC(PC),
  .clocks(clocks),
  .IR(IR),
  .opc(opc),
  .X(X),
  .state(state)
  );
  
  
  ledunit ledunit_i(
    .sel(dispsel_t'(disp_sel)),
	 .cycles(clocks),
	 .pc(PC),
	 .opc(opc),
	 .X(X),
	 .state(state),
	 .instr(IR),
	 .hex5(hex5),
	 .hex4(hex4),
	 .hex3(hex3),
	 .hex2(hex2),
	 .hex1(hex1),
	 .hex0(hex0)
  );
  
endmodule

