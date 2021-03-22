
# 
set_time_format -unit ns -decimal_places 3

# clk_fpga is 50MHz
create_clock -name clk_fpga -period 20.000 [get_ports clk_fpga]

# clk is slow (1Hz) but lets try with 50MHz anyway 
create_clock -name clk -period 20.000 [get_ports clk]

derive_pll_clocks -create_base_clocks
derive_clock_uncertainty
