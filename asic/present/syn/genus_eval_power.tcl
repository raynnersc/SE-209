# Catch errors
set_db fail_on_error_mesg true

# Get global variables from shell environment
set PRJ_DIR [file normalize [file dirname [info script]]]/..
source ${PRJ_DIR}/design/design_conf/design_def.tcl

# Restore elaborated database
read_db ${TOP_MODULE}_syn.db


# Read the vcd dump from simulation in order to obtain a final activity information
source ${SIM_PSYN_DIR}/results/${TOP_MODULE}_vcd_info.tcl
read_stimulus -start ${vcd_start}ps -end ${vcd_stop}ps -format vcd -allow_n_nets -disable_rtlstim2gate -file ${SIM_PSYN_DIR}/results/${TOP_MODULE}.vcd

# generate reports (power)
report_power > ${SYN_DIR}/reports/${TOP_MODULE}.power_flat.rpt
report_power -by_hierarchy -unit uw > ${SYN_DIR}/reports/${TOP_MODULE}.power_hierarchy.rpt
report_power -by_leaf_instance -sort_by total -unit uw > ${SYN_DIR}/reports/${TOP_MODULE}.power_lead_instance.rpt
report_power -by_libcell -sort_by total -unit uw > ${SYN_DIR}/reports/${TOP_MODULE}.power_libcell.rpt

#save the database in case you want to reopen it
write_db -to_file ${TOP_MODULE}_post_power.db
exit
