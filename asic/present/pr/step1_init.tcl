# Get global variables from shell environment
set PRJ_DIR [file normalize [file dirname [info script]]]/..
source ${PRJ_DIR}/design/design_conf/design_def.tcl

# Tell the tool that we are working with a 45nm technology in order
# to adapt algorithms parameters to such a node.
set_db design_process_node 45
# ??? nouveau paramètre d'Innovus, pas vraiment documenté
set_db design_tech_node unspecified

# Creates mmmc views and constraints
# Get constraints  synthesis results
# A FAIRE : attention il devrait y avoir des constraintes dépendantes des conditions de caractérisation et non pas uniques
create_constraint_mode -name default_constraint_mode -sdc_files [list ${SYN_DIR}/results/${TOP_MODULE}.sdc]
# Valeurs génériques liées a la technologie
read_mmmc ${VIEW_DEFINITION_FILE}
# Les abstracts des cellules
read_physical -lefs $LEF_FILES
# The design netlist
read_netlist ${SYN_DIR}/results/${TOP_MODULE}.v
# Defines power and ground nets
set_db  init_power_nets {VDD}
set_db  init_ground_nets {VSS}

# load the design: # here the init_* variables are used
init_design

# Get an initial activity file in order to drive eventual power optimisation
#source ${SIM_PSYN_DIR}/results/${TOP_MODULE}_vcd_info.tcl
#read_activity_file -format VCD -scope present_tb/dut -start ${vcd_start}ps -end ${vcd_stop}ps ${SIM_PSYN_DIR}/results/${TOP_MODULE}.vcd


# And save the initial design
write_db step1_init.innovus

# All is ok
exec touch .step1_init.ok
exit
