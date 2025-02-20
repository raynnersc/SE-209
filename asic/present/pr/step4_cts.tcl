# Get global variables from shell environment
set PRJ_DIR [file normalize [file dirname [info script]]]/..
source ${PRJ_DIR}/design/design_conf/design_def.tcl

###########################################################################################
#
#placement
#
###########################################################################################

# Restore the placed design
read_db step3_place.innovus


####################################################################################################
#
# Clock Tree Synthesis (placement of buffers and routing of the clk net)
#
####################################################################################################
# Add this command to restrict the tool to use the 5 first metal layers for the routing
# Allready down during the place phase
#set_db design_top_routing_layer 5
set_db route_design_selected_net_only  false
set_db route_design_with_timing_driven true
set_db route_design_with_si_driven true
set_db route_design_detail_fix_antenna true
set_db route_design_with_via_only_for_stdcell_pin false
set_db route_design_reserve_space_for_multi_cut true
set_db route_design_detail_use_multi_cut_via_effort high

# Defines the rules for clock tree creation. Use the DBLCUT_DBlSPACE_RULE from the i"clock_tree.lef" file
create_route_type -name leaf_rule  -top_preferred_layer 3 -bottom_preferred_layer 2
set_db cts_route_type_leaf leaf_rule

create_route_type -name trunk_rule -top_preferred_layer 4 -bottom_preferred_layer 3
set_db cts_route_type_trunk trunk_rule

# Note that top routing rules will not be used unless the routing_top_min_fanout property is also set
create_route_type -name top_rule  -top_preferred_layer  5 -bottom_preferred_layer 4
set_db cts_route_type_top  top_rule

# Choose the buffer cells. Do not use polybias cells
set_db cts_buffer_cells ${CLK_BUFFER_CELLS}

# Choose the buffer cells. Do not use polybias cells
set_db cts_inverter_cells ${CLK_INVERTER_CELLS}

# Include this setting to use inverters in preference to buffers.
#set_db cts_use_inverters true

# Configure the maximum transition target.
set_db cts_target_max_transition_time ${CLK_MAX_TRANS}ps

# Configure a skew target for CCOpt-CTS
set_db cts_target_skew ${CLK_SKEW}ps

# Create a clock tree specification by analyzing the timing graph structure of all active setup and hold analysis views
create_clock_tree_spec

# Synthesize
ccopt_design

# Remove routes regenerated during CTS
delete_routes -type regular

## DRC
delete_drc_markers
check_place step4_checkPlace.rpt
check_drc -out_file step4_geom.drc
delete_drc_markers

# And save the placed design
write_db step4_cts.innovus

# All is ok
exec touch .step4_cts.ok
exit
