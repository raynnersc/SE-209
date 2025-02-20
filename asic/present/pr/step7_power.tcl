# Get global variables from shell environment
set PRJ_DIR [file normalize [file dirname [info script]]]/..
source ${PRJ_DIR}/design/design_conf/design_def.tcl

# Restore the initial design
read_db step6_timing.innovus

# generate power report
set_db power_method dynamic_vectorbased
set_db power_view SS_view
set_db power_corner max
set_db power_write_db false
set_db power_write_static_currents false
set_db power_honor_negative_energy true
set_db power_ignore_control_signals true

set_power_output_dir ./step7_power_reps
# Get an initial activity file in order to drive eventual power optimisation
source ${SIM_PPR_DIR}/results/${TOP_MODULE}_vcd_info.tcl
read_activity_file -format VCD -scope present_tb/dut -start ${vcd_start}ps -end ${vcd_stop}ps ${SIM_PPR_DIR}/results/${TOP_MODULE}.vcd
# generate report
report_power -out_file instances_power_rep -hierarchy all -sort { total }
# And save the design
write_db step7_power.innovus

# All is ok
exec touch .step7_power.ok
exit
