set clk_period 10
create_clock -name clk -period $clk_period  [get_ports clk]
set_input_delay -max [expr .2*$clk_period] -clock [get_clocks clk] [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay -max [expr .2*$clk_period] -clock [get_clocks clk] [all_outputs]
set_clock_uncertainty [expr .05*$clk_period] [get_clocks]
set_false_path -hold -from [remove_from_collection [all_inputs] [get_ports clk]]
set_false_path -hold -to [all_outputs]

set_input_delay -max [expr .4*$clk_period]  -clock clk [get_ports rx]
set_output_delay -max [expr .4*$clk_period]  -clock clk [get_ports tx]
