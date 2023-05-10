###################################################################

# Created by write_sdc on Wed May 10 09:10:57 2017

###################################################################
set sdc_version 1.9

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
set_max_area 0
create_clock [get_ports clk]  -period 10  -waveform {0 5}
set_clock_uncertainty 0.5  [get_clocks clk]
set_false_path -hold   -from [list [get_ports reset_n] [get_ports wr_uart] [get_ports {data_w[7]}]   \
[get_ports {data_w[6]}] [get_ports {data_w[5]}] [get_ports {data_w[4]}]        \
[get_ports {data_w[3]}] [get_ports {data_w[2]}] [get_ports {data_w[1]}]        \
[get_ports {data_w[0]}] [get_ports rx] [get_ports rd_uart] [get_ports          \
{baud_final[9]}] [get_ports {baud_final[8]}] [get_ports {baud_final[7]}]       \
[get_ports {baud_final[6]}] [get_ports {baud_final[5]}] [get_ports             \
{baud_final[4]}] [get_ports {baud_final[3]}] [get_ports {baud_final[2]}]       \
[get_ports {baud_final[1]}] [get_ports {baud_final[0]}]]
set_false_path -hold   -to [list [get_ports tx] [get_ports tx_full] [get_ports {data_r[7]}]          \
[get_ports {data_r[6]}] [get_ports {data_r[5]}] [get_ports {data_r[4]}]        \
[get_ports {data_r[3]}] [get_ports {data_r[2]}] [get_ports {data_r[1]}]        \
[get_ports {data_r[0]}] [get_ports rx_empty] [get_ports rx_err] [get_ports     \
rx_done] [get_ports fr_err]]
set_input_delay -clock clk  -max 2  [get_ports reset_n]
set_input_delay -clock clk  -max 2  [get_ports wr_uart]
set_input_delay -clock clk  -max 2  [get_ports {data_w[7]}]
set_input_delay -clock clk  -max 2  [get_ports {data_w[6]}]
set_input_delay -clock clk  -max 2  [get_ports {data_w[5]}]
set_input_delay -clock clk  -max 2  [get_ports {data_w[4]}]
set_input_delay -clock clk  -max 2  [get_ports {data_w[3]}]
set_input_delay -clock clk  -max 2  [get_ports {data_w[2]}]
set_input_delay -clock clk  -max 2  [get_ports {data_w[1]}]
set_input_delay -clock clk  -max 2  [get_ports {data_w[0]}]
set_input_delay -clock clk  -max 4  [get_ports rx]
set_input_delay -clock clk  -max 2  [get_ports rd_uart]
set_input_delay -clock clk  -max 2  [get_ports {baud_final[9]}]
set_input_delay -clock clk  -max 2  [get_ports {baud_final[8]}]
set_input_delay -clock clk  -max 2  [get_ports {baud_final[7]}]
set_input_delay -clock clk  -max 2  [get_ports {baud_final[6]}]
set_input_delay -clock clk  -max 2  [get_ports {baud_final[5]}]
set_input_delay -clock clk  -max 2  [get_ports {baud_final[4]}]
set_input_delay -clock clk  -max 2  [get_ports {baud_final[3]}]
set_input_delay -clock clk  -max 2  [get_ports {baud_final[2]}]
set_input_delay -clock clk  -max 2  [get_ports {baud_final[1]}]
set_input_delay -clock clk  -max 2  [get_ports {baud_final[0]}]
set_output_delay -clock clk  -max 4  [get_ports tx]
set_output_delay -clock clk  -max 2  [get_ports tx_full]
set_output_delay -clock clk  -max 2  [get_ports {data_r[7]}]
set_output_delay -clock clk  -max 2  [get_ports {data_r[6]}]
set_output_delay -clock clk  -max 2  [get_ports {data_r[5]}]
set_output_delay -clock clk  -max 2  [get_ports {data_r[4]}]
set_output_delay -clock clk  -max 2  [get_ports {data_r[3]}]
set_output_delay -clock clk  -max 2  [get_ports {data_r[2]}]
set_output_delay -clock clk  -max 2  [get_ports {data_r[1]}]
set_output_delay -clock clk  -max 2  [get_ports {data_r[0]}]
set_output_delay -clock clk  -max 2  [get_ports rx_empty]
set_output_delay -clock clk  -max 2  [get_ports rx_err]
set_output_delay -clock clk  -max 2  [get_ports rx_done]
set_output_delay -clock clk  -max 2  [get_ports fr_err]
