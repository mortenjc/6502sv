// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief chose button clock or 10Hz
//===----------------------------------------------------------------------===//

module clockunit(
  input bit clk_btn,
  input bit clk_fpga,
  input bit clk_sel,
  output bit clk_out
  );


  bit clk_auto;
  clockdivparm #(5000000) fpga_to_10hz(
    .clk(clk_fpga),
    .clk_out(clk_auto)
  );
  
  always_comb begin
    if (clk_sel == 1'b0)
      clk_out = clk_btn;
    else
      clk_out = clk_auto;
  end

endmodule