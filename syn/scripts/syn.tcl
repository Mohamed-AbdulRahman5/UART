set design UART

set_app_var search_path "/home/standard_cell_libraries/NangateOpenCellLibrary_PDKv1_3_v2010_12/lib/Front_End/Liberty/NLDM"

set_app_var link_library "* NangateOpenCellLibrary_ss0p95vn40c.db"
set_app_var target_library "NangateOpenCellLibrary_ss0p95vn40c.db"

sh rm -rf work
sh mkdir -p work
define_design_lib work -path /home/ahesham/Desktop/Teaching/sources_2/syn


analyze  -format verilog /home/ahesham/Desktop/Teaching/sources_2/RTL/${design}.v
elaborate $design -lib work
current_design 

source /home/ahesham/Desktop/Teaching/sources_2/syn/cons/cons.tcl
set_max_area 0 
replace_synthetic -ungroup
check_design

link

compile  -map_effort medium

report_area > /home/ahesham/Desktop/Teaching/sources_2/syn/report/synth_area.rpt
report_cell > /home/ahesham/Desktop/Teaching/sources_2/syn/report/synth_cells.rpt
report_qor  > /home/ahesham/Desktop/Teaching/sources_2/syn/report/synth_qor.rpt
report_resources > /home/ahesham/Desktop/Teaching/sources_2/syn/report/synth_resources.rpt
report_timing -max_paths 10 > /home/ahesham/Desktop/Teaching/sources_2/syn/report/synth_timing.rpt 
 
write_sdc  /home/ahesham/Desktop/Teaching/sources_2/syn/output/${design}.sdc 

define_name_rules  no_case -case_insensitive
change_names -rule no_case -hierarchy
change_names -rule verilog -hierarchy
set verilogout_no_tri	 true
set verilogout_equation  false

write -hierarchy -format verilog -output /home/ahesham/Desktop/Teaching/sources_2/syn/output/${design}.v 
write -f ddc -hierarchy -output /home/ahesham/Desktop/Teaching/sources_2/syn/output/${design}.ddc   


