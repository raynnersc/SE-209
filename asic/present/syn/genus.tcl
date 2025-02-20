# Get global variables from shell environment
set PRJ_DIR [file normalize [file dirname [info script]]]/..
source  ${PRJ_DIR}/design/design_conf/design_def.tcl


# Put all the elaboration steps in one procedure

# Default instances names in generate blocks use a "." as
# a separator. In Verilog the name is "escaped" (\) in order
# to support this ".". The generated Verilog netlist may be
# difficult to handle with third parties tools (mixed simulations,
# sdf backannotation,...)
set_db hdl_generate_separator  "__"
# Default arrays of instances names uses a vectorized style  %s\[%d\]
# that can cause problems to third parties tools when trying to
# apply script commands (modelsim SE). BO means "bracket open"
# BC means "bracket close"
set_db hdl_array_naming_style %soB%dBo

# Get all conditions (technology, temperature, voltage, timing constraints)
create_constraint_mode -name default_constraint_mode  -sdc_files  ${CNF_DIR}/design.sdc
read_mmmc ${VIEW_DEFINITION_FILE}

# Load (Layout Extraction Format) lef files
set_db lef_library $LEF_FILES

# read RTL
set_db init_hdl_search_path $SRC_DIR
# -sv    -> SystemVerilog
# -v2001 -> Verilog 2001
# -vhd   -> VHDL
foreach f $SV_PKGS  {read_hdl -define "UNROLL_FCTR=${UNROLL_FCTR}" -sv $f}
foreach f $SV_FILES {read_hdl -sv $f}
foreach f $V_FILES  {read_hdl -v2001 $f}

# elaborate the design
elaborate $TOP_MODULE

# Optional configs, examples
# flatten hierarchy
#ungroup -all -flatten -verbose
# set the preserve attribute on the nets that we want to keep
# set_db preserve true [get_net -hierarchical prn_*]

# Limit the number of routing layers to 8 in order to correct
# an unsupported construct in the lef technology file (to succesive
# layers with the same prefered direction .. (layer 8 and layer 9)...
#set_db number_of_routing_layers 8 /designs/${TOP_MODULE}

# Create a generic netlist
write_hdl -generic > ${SYN_DIR}/results/${TOP_MODULE}_generic_netlist.v

# Avoid usage scan flipflop during synthesis
set_dont_use [get_lib_cells *SDF*]

# Avoid optimisation of the boundary of all submodule
set_db [get_db design:${TOP_MODULE} .modules *] .boundary_opto false

# keep DRC clean
set_db drc_max_cap_first true
# on ne cherche pas a respecte le max fanout
#set_db drc_max_fanout_first true
set_db drc_max_trans_first  true
set_db drc_first true
check_design

# synthesize (effort low, medium, high)
set_db syn_global_effort high
init_design
syn_gen
syn_map
syn_opt
#syn_opt -spatial

# generate reports (not yet power)
check_design  > ${SYN_DIR}/reports/${TOP_MODULE}.check.rpt
report gates  > ${SYN_DIR}/reports/${TOP_MODULE}.gates.rpt
report area   > ${SYN_DIR}/reports/${TOP_MODULE}.area.rpt
report timing > ${SYN_DIR}/reports/${TOP_MODULE}.timing.rpt
report timing -lint >> ${SYN_DIR}/reports/${TOP_MODULE}.timing_lint.rpt
report qor    > ${SYN_DIR}/reports/${TOP_MODULE}.qor.rpt
#
# save netlist
write_netlist > ${SYN_DIR}/results/${TOP_MODULE}.v
# save sdf for post syn simulation and power analysis
write_sdf -setuphold split  -recrem split -edges check_edge > ${SYN_DIR}/results/${TOP_MODULE}.sdf
# write spef for ams sim
# Bizarre dans Genus, les fichiers générés contiennent soient les capacités, soit les résistances
# mais pas les deux... le simulateur AMS devra utiliser une fusion des deux fichiers
write_parasitics -power -cap_unit fF -res_unit ohm >  ${SYN_DIR}/results/${TOP_MODULE}_power.spef
write_parasitics -ilm -cap_unit fF -res_unit ohm >  ${SYN_DIR}/results/${TOP_MODULE}_ilm.spef
# save constraints for P&R
# WARNING: it seems that we need an ideal clock for the P&R step, otherwise timing analysis will
# include clock skew even with the final synthesised tree
write_sdc -constraint_mode default_constraint_mode -exclude "set_clock_latency set_clock_uncertainty" > ${SYN_DIR}/results/${TOP_MODULE}.sdc
# save the database in case you want to reopen it
write_db -to_file ${TOP_MODULE}_syn.db
exit
