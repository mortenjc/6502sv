// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief instruction decode
//===----------------------------------------------------------------------===//


module new6502(
  input bit clk,
  input bit [1:0] sw,
  output [7:0] hex5,
  output [7:0] hex4,
  output [7:0] hex3
  );


  data_t IR;
  addr_t PC;
  addr_t clocks; 
  cpuunit cpuunit_i(
  .clk(clk),
  .PC(PC),
  .clocks(clocks),
  .IR(IR)
  );
  
  
  ledctrl led_hex5(
    .value({1'b1, clocks[3:0]}),
    .led(hex5)
  );

  ledctrl led_hex4(
    .value({1'b1, PC[3:0]}),
    .led(hex4)
  );

  ledctrl led_hex3(
    .value({1'b1, IR[3:0]}),
    .led(hex3)
  );
  

  
endmodule

