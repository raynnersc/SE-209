# Get global variables from shell environment
set PRJ_DIR [file normalize [file dirname [info script]]]/..
source ${PRJ_DIR}/design/design_conf/design_def.tcl

# Restore the placed + cts design
read_db step4_cts.innovus

# execute command
commit_global_net_rules

# Define a margin for the hold time optimisation
set_db opt_hold_target_slack [expr $HOLD_SLACK/1000.0] 

# Reoptimize the design taking into account the clock tree
# and save timing infos
# WARNING: this optimization can modify clock tree buffers size
# and placement. The clock tree routing has then to be adjusted.
# Adjustement will be performed by the overal design routing.
# A verifyGeometry command just after this step should give
# errors....
opt_design -post_cts -incremental -report_dir step5_post_cts_opt
opt_design -post_cts -hold -incremental -report_dir step5_post_cts_hold_opt

####################################################################################################
#
# Route the design
#
####################################################################################################
# Allready defined in the cts step
#set_max_route_layer 5
#set_db route_design_selected_net_only  false
#set_db route_design_with_timing_driven true
#set_db route_design_with_si_driven true
#set_db route_design_detail_fix_antenna true
#set_db route_design_with_via_only_for_stdcell_pin false
#set_db route_design_reserve_space_for_multi_cut true
#set_db route_design_detail_use_multi_cut_via_effort high

route_design

# Reoptimize the design taking into account the final routing
# and save timing infos. AnalysisMode as to be set to OCV ( **ERROR: (ENCOPT-6080):	AAE-SI Optimization can only be turned on when the timing analysis mode is set to OCV)
set_db timing_analysis_type  ocv
opt_design -post_route -incremental -report_dir step5_post_route_opt
opt_design -post_route -hold -incremental -report_dir step5_post_route_opt


####################################################################################################
#
# Layout finishing
#
####################################################################################################

# Adding fillers in decreasing size order
# SPECIFIC TO PRESENT V1 : add a lot of decap cells
#addFiller -cell  ${DECAP_CELLS} -prefix DECAP
# Adding fillers in decreasing size order
add_fillers -base_cells  ${FILLER_CELLS} -prefix FILLER

# Optimization for DRC correction post filler insrtion
set_db route_design_with_timing_driven false
set_db route_design_with_si_driven false
route_design -global_detail
route_design

####################################################################################################
#
# Drcs
#
####################################################################################################
delete_drc_markers
check_place step5_checkPlace.rpt
check_drc -out_file step5_geom.drc
delete_drc_markers
check_connectivity -type all -error 1000 -warning 50 -out_file step5_connectivity.rpt
check_process_antenna -out_file step5_antenna.rpt -error 1000
delete_drc_markers

####################################################################################################
#
# Reports
#
####################################################################################################
report_area -out_file step5_area.rpt
####################################################################################################
#
# Save the final design
#
####################################################################################################
write_db step5_route.innovus

# All is ok
exec touch .step5_route.ok
exit
