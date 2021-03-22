// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief a mod N clock divider
//===----------------------------------------------------------------------===//

module clockdivparm #(
  parameter DIVIDER=10)(
  input bit clk,
  output bit clk_out
  );

  parameter MAX_COUNT = DIVIDER - 1;

  bit [31:0] counter;

  always_ff @(posedge clk) begin
		if (counter >= MAX_COUNT) begin
		  counter <= 0;
		end else begin
		  counter <= counter + 1;
		end
		clk_out <= (counter < DIVIDER/2) ? 1'b1 : 1'b0;
  end

endmodule
