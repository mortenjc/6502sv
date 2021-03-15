// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief 7 segment LED display for DE10-lite version supporting some letters
//===----------------------------------------------------------------------===//

module ledctrl(
   input bit[7:0] value,
	 output bit[7:0] led
	);

  bit [6:0] disp;
	always_comb begin
		unique case (value)
      // Hexadecimal digits
			0  : disp = 7'b1000000;
			1  : disp = 7'b1111001;
			2  : disp = 7'b0100100;
			3  : disp = 7'b0110000;
			4  : disp = 7'b0011001;
			5  : disp = 7'b0010010;
			6  : disp = 7'b0000010;
			7  : disp = 7'b1111000;
			8  : disp = 7'b0000000;
			9  : disp = 7'b0010000;
			10 : disp = 7'b0001000;
			11 : disp = 7'b0000011;
			12 : disp = 7'b1000110;
			13 : disp = 7'b0100001;
			14 : disp = 7'b0000110;
			15 : disp = 7'b0001110;

      // Characters - needed to spell
      // CC - Clock Cycle
      // PC - Program Counter
      // AD - ADdress
      // IN - INstruction
      // ST - STate
      // OP - OPcode
      65: disp = 7'b0001000; // A
      67: disp = 7'b1000110; // C
      68: disp = 7'b1000001; // d
      73: disp = 7'b1111001; // I
      78: disp = 7'b1001000; // N
      79: disp = 7'b1000000; // O
      80: disp = 7'b0000100; // P
      83: disp = 7'b0010010; // S
      84: disp = 7'b0000111; // T

      127: disp = 7'b1111111; // OFF
	   default:
	      disp = 7'b1111111;
	   endcase

     led = {1'b1, disp};
	end

endmodule
