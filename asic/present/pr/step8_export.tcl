# Get global variables from shell environment
set PRJ_DIR [file normalize [file dirname [info script]]]/..
source ${PRJ_DIR}/design/design_conf/design_def.tcl

# Restore the placed design
read_db step7_power.innovus


####################################################################################################
#
# netlist: physical cells and power/ground for electrical simulation
#
####################################################################################################
write_netlist -include_pg_ports ${PR_DIR}/results/${TOP_MODULE}_phys.v

####################################################################################################
#
# Layout : generates DEF file
#
####################################################################################################
write_def  -routing  ${PR_DIR}/results/${TOP_MODULE}.def

####################################################################################################
#
# Layout : generates LEF file
# Check process antenna before lef output in order to add antenna info in the lef output
####################################################################################################
check_process_antenna -out_file ${TOP_MODULE}.antenna.rpt -detailed -error 1000
write_lef_abstract -cut_obs_min_spacing -stripe_pins -extract_block_obs -extract_block_pg_pin_layers {5 6} -pg_pin_layers {5 6} -top_layer 6 ../results/${TOP_MODULE}.lef

####################################################################################################
##
## ILM : generates Interface logic files for bottom up hierarchical p & r
##
#####################################################################################################
write_ilm -to_dir  ../results/${TOP_MODULE}_ilm

####################################################################################################
#
# Timing : generates LIB file
#
####################################################################################################
set_analysis_view -setup SS_view  -hold SS_view
write_timing_model -greybox -view SS_view ../results/${TOP_MODULE}_SS_view.lib
set_analysis_view -setup FF_view  -hold FF_view
write_timing_model -greybox -view FF_view ../results/${TOP_MODULE}_FF_view.lib

 

###################################################################################################
#
# Layout : generates GDS for virtuoso. Needs somme patch in order to get a DRC clean layout
# in Virtuoso
# INUTILE : on utilise la version DEF
#
####################################################################################################
#puts "--> step8_power extract: extract  GDS cell" 
##
## 1/Add metal type under IO pins in order to respect DRC : all pin shall be entirely covered by
## Metal/Drawing layer
#source ${TOOLS_DIR}/pr/tpt_extend_IOpins_for_gds.tcl
#tpt_extend_IOpins_for_gds
#
#
## 2/ Generates a first GDS version
#set_db write_stream_stream_version  4
## Unique names for vias
#set_db write_stream_via_names true
#set_db write_stream_define_via_name %t_%v_%l(l)
#set_db write_stream_pin_text_orientation automatic
#set_db write_stream_text_size 0.1
#set GDSUnits 2000
#write_stream ${PR_DIR}/results/${TOP_MODULE}.gds \
#          -map_file ${EDI_GDSII_mapfile} \
#          -lib_name ${TOP_MODULE}_lib \
#          -structure_name ${TOP_MODULE} \
#          -unit ${GDSUnits} \
#          -mode ALL
#
## 5/ Third  patch of the GDS using calibredrv
## Correct Power/Ground pin: It seems that Encounter add a colon (:) char at
## the end of the Power/Ground pin labels (VDD->VDD:). This is no coherent with
## the physical netlist (VDD...). The following script will "legalize" the 
## power/ground pin names by removing the colon char.
#if {${LEGALIZE_PG_PINS} == 1} {
#  puts "--> step8_power extract: Removing the colon char at the end of the Power/Gnd pin labels"
#  
#  # Uses catch because calibre send messages to std_error, thus ending
#  # always by an error even if the exec gives no error.
#  if { [catch { \
#          exec calibredrv ${TOOLS_DIR}/pr/tpt_legalize_pg_pins.tcl  \
#                  ${PR_DIR}/results/${TOP_MODULE}.gds \
#                  ${PR_DIR}/results/${TOP_MODULE}.gds \
#                  $VIRTUOSO_GDSII_mapfile
#    } msg] } {
#     puts $msg
#  }
#}


# All is ok
exec touch .step8_export.ok
exit
