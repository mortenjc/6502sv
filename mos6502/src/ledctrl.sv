// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief 7 segment LED display for DE10-lite
//===----------------------------------------------------------------------===//

module ledctrl(
   input bit[4:0] value, // bit 4 is sign  0 == pos 1 == neg
	output bit[7:0] led
	);

	bit [6:0] led_dig_0 = 'b1000000;
	bit [6:0] led_dig_1 = 'b1111001;
	bit [6:0] led_dig_2 = 'b0100100;
	bit [6:0] led_dig_3 = 'b0110000;
	bit [6:0] led_dig_4 = 'b0011001;
	bit [6:0] led_dig_5 = 'b0010010;
	bit [6:0] led_dig_6 = 'b0000010;
	bit [6:0] led_dig_7 = 'b1111000;
	bit [6:0] led_dig_8 = 'b0000000;
	bit [6:0] led_dig_9 = 'b0010000;
	bit [6:0] led_dig_A = 'b0001000;
	bit [6:0] led_dig_B = 'b0000011;
	bit [6:0] led_dig_C = 'b1000110;
	bit [6:0] led_dig_D = 'b0100001;
	bit [6:0] led_dig_E = 'b0000110;
	bit [6:0] led_dig_F = 'b0001110;

	bit [7:0] led_off =   'b11111111; // including dot
	bit dot;

	always_comb begin
	   dot = ~value[4];
		unique case (value[3:0])
			0  : led = {dot, led_dig_0};
			1  : led = {dot, led_dig_1};
			2  : led = {dot, led_dig_2};
			3  : led = {dot, led_dig_3};
			4  : led = {dot, led_dig_4};
			5  : led = {dot, led_dig_5};
			6  : led = {dot, led_dig_6};
			7  : led = {dot, led_dig_7};
			8  : led = {dot, led_dig_8};
			9  : led = {dot, led_dig_9};
			10 : led = {dot, led_dig_A};
			11 : led = {dot, led_dig_B};
			12 : led = {dot, led_dig_C};
			13 : led = {dot, led_dig_D};
			14 : led = {dot, led_dig_E};
			15 : led = {dot, led_dig_F};
	   default:
	      led = led_off;
	   endcase
	end

endmodule
