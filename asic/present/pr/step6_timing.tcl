# Get global variables from shell environment
set PRJ_DIR [file normalize [file dirname [info script]]]/..
source ${PRJ_DIR}/design/design_conf/design_def.tcl

# Restore the initial design
read_db step5_route.innovus 


####################################################################################################
#
# save Verilog netlist & sdf for post simulation
#
####################################################################################################
# netlist :Pure verilog for post simulation
write_netlist ${PR_DIR}/results/${TOP_MODULE}.v
# physical netlist
write_netlist -include_pg_ports -exclude_leaf_cells ${PR_DIR}/results/${TOP_MODULE}_phys.v

# Extract spef info
set_db extract_rc_engine post_route
set_db extract_rc_effort_level medium
extract_rc
write_parasitics -view SS_view -spef_file ${PR_DIR}/results/${TOP_MODULE}.spef


# Extract sdf for timed simulation
write_sdf -process bc:tc:wc \
          -min_view SS_view \
          -typical_view SS_view \
          -max_view SS_view \
          -map_setuphold split  \
          -map_recrem split \
          -edges check_edge \
          -recompute_parallel_arcs \
          ${PR_DIR}/results/${TOP_MODULE}.sdf

# And generate timing report
set_db timing_analysis_type  ocv


# Signoff extraction doesn't work with the current technology file
time_design  -post_route -num_paths 50 -report_prefix ${TOP_MODULE}_postroute -report_dir step6_timing_rep
time_design  -post_route -num_paths 50 -hold -report_prefix ${TOP_MODULE}_postroute -report_dir  step6_timing_rep

# And save the design
write_db step6_timing.innovus

# All is ok
exec touch .step6_timing.ok
exit
