# Get global variables from shell environment
set PRJ_DIR [file normalize [file dirname [info script]]]/..
source ${PRJ_DIR}/design/design_conf/design_def.tcl

###########################################################################################
#
#placement
#
###########################################################################################
# Restore the floorplanned  design
read_db step2_floorplan.innovus

####################################################################################################
#
# Placer and Router configuration
#
####################################################################################################
# Force place and route optimisation to respect the max fanout of gates (this is not de default)
#set_db opt_fix_fanout_load true

# Add this command to restrict the tool to use the 5 first metal layers for the routing
# Done at the placement step in order to have relatively accurate results
set_db design_top_routing_layer 5
set_db design_bottom_routing_layer 1


####################################################################################################
#
# Standard Cells Placement Phase
#
####################################################################################################
# Fixing a Warning from the place phase
# Try to distribute the cells evenly (SPECIAL for Present)
set_db place_global_uniform_density true
# Then place the design
place_design
# Refine Placement (if there are any violations)
place_detail
## Optimize the design before clock tree synthesis (only fanout, load and transitions violations)
## Timing infos are extracted and saved
opt_design -pre_cts -drv -report_dir step3_pre_cts_opt_phase1
# And then reoptimize in order do adjust all cell sizes
opt_design -pre_cts -incremental -report_dir step3_pre_cts_opt_phase2

# Remove trial route performed during placement and design optimisation
#deleteTrialRoute
# TODO: Innovus/Voltus pas de commande équivalente, on tente une 
# commande générale (on déroute tous les signaux normaux)
delete_routes -type regular

## DRC
delete_drc_markers
check_place step3_check_place.rpt
check_drc -out_file step3_place.drc
delete_drc_markers

# And save the placed design
write_db step3_place.innovus


# All is ok
exec touch .step3_place.ok
exit
