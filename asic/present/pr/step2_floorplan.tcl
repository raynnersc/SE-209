# Get global variables from shell environment
set PRJ_DIR [file normalize [file dirname [info script]]]/..
source ${PRJ_DIR}/design/design_conf/design_def.tcl


###########################################################################################
#
# Floorplan, power route
#
###########################################################################################
# Utility procedures
source ${TOOLS_DIR}/pr/tpt_gen_dummy_ioring.tcl

# Restore the initial design
read_db step1_init.innovus

# Compute the space needed for power rings
set ring_stripe_size 2
set ring_stripe_space 0.5 
set core_to_edge [expr 2*$ring_stripe_size+3*$ring_stripe_space]

# Automatic floorplaning
#   -flip f or s  the first or  second row flip in order to have nwell at the bottom and 
#   the top of the macro. It will be easier to add a nwell ring in case of deep well 
#   isolation
set FPflip f

create_floorplan -flip $FPflip \
          -site $TECHNO_CORE_SITE \
          -stdcell_density_size 1.41 0.8 $core_to_edge $core_to_edge $core_to_edge $core_to_edge \

# Adjust the flooplan in order to have an odd number of rows
# TODO: Il doit y avoir moyen de faire plus simple
set delta_x 0
set delta_y 0
set num_rows [get_db design:${TOP_MODULE} .num_core_rows]
if {[expr {($num_rows % 2) == 1}]} { # Even number of rows
  set core_bbox [split [lindex [get_db design:${TOP_MODULE} .core_bbox] 0]]
  set box_x [expr [lindex $core_bbox 2] - [lindex $core_bbox 0]]
  set box_y [expr [lindex $core_bbox 3] - [lindex $core_bbox 1]]
  set core_site [split [lindex [get_db site:${TECHNO_CORE_SITE} .size] 0]]
  set delta_y [lindex $core_site 1]
  set delta_x [expr -int(($delta_y * $box_x)/$box_y)]
}
set_db resize_floorplan_snap_to_track true
# Pas de commande équivalente à resizeFP sous Innovus/Stylus
# TODO : faire cela de façon différente
eval_legacy "resizeFP -ySize $delta_y -xSize $delta_x"

# Generate I/O placement file with dummy pins evenely spaced around the core
#                    <Top/Bottom layer> <Left/Right layer> <IOFile>
tpt_gen_dummy_ioring ${TOP_MODULE} 3 4 step2_IoPlan.io
read_io_file step2_IoPlan.io
# Align pins on tracks
legalize_pins -move_fixed_pins

###########################################################################################
# configure/connect all special nets
# first, declare vdd/gnd pin's for all std-cells / fillers and welltaps
# second limit vdds ans gnds pin to std-cells and fillers 
# WARNING : for LL vdds should be shorted with gnds. In order to suppress the polarity
# mismatch we must set:
# "set init_ignore_pgpin_polarity_check vdds" during initialisation to allow
###########################################################################################
# All cells have vdd pins (dont forget clk buffers..)
connect_global_net VDD -type pgpin -pin {VDD} -auto_tie -all -verbose
# All cells have gnd pins
connect_global_net VSS -type pgpin -pin {VSS} -auto_tie -all -verbose

# declare 0/1 vhdl/verilog constants to be on VDD/GND supplys
# INNOVUS: Inutile ? car déjà fait précédemment
#connect_global_net VDD -type tiehi -module {} -verbose
#connect_global_net VSS -type tielo -module {} -verbose
# execute command
commit_global_net_rules

# Add power ring
# If we want explicit IO pins for VDD and GND.
# doesn't work if all rings have the same metal level
add_rings \
        -type core_rings \
        -around default_power_domain \
        -jog_distance 0.45 \
        -threshold 0.45  \
        -spacing $ring_stripe_space \
        -width $ring_stripe_size \
        -layer {top M6 bottom M6 left M5 right M5}  \
        -offset $ring_stripe_space \
        -nets {VDD VSS}  \
        -extend_corner {tl br}

## And add power stripes
## TODO : Convertir en INNOVUS/STYLUS
#setAddStripeMode -stacked_via_top_layer M6
#setAddStripeMode -stacked_via_bottom_layer M1
#
#addStripe -nets {GND VDD} \
#-number_of_sets 3 \
#-layer M3  \
#-width 2  \
#-spacing 1 \
#-xleft_offset 20 \
#-xright_offset 20 \
#-block_ring_top_layer_limit B1 \
#-block_ring_bottom_layer_limit M2 \
#-padcore_ring_top_layer_limit B1 \
#-padcore_ring_bottom_layer_limit M2 \
#-max_same_layer_jog_length 8 \
#-merge_stripes_value 0.068 \
#-direction vertical  \
#-orthogonal_only false 

###########################################################################################
# Connect ring stripes and standard cells to VDD/GND via special route
###########################################################################################
set_db route_special_split_long_via  { 2 0 -1 }
route_special  \
       -nets { VSS VDD } \
       -connect { corePin } \
       -core_pin_target ring \
       -layer_change_range { 1 6} \
       -allow_jogging 1 \
       -crossover_via_layer_range { 1 6 } \
       -target_via_layer_range {1  6 }  \
       -allow_layer_change 1 
# TODO : vérifier si cette ancienne option est utile 
#       -viaConnectToShape { ring stripe } 


## check that we are clean till now
check_drc -out_file step2_floorplan.drc
delete_drc_markers

# And save the placed design
write_db step2_floorplan.innovus

# All is ok
exec touch .step2_floorplan.ok
exit
