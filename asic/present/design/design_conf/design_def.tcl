####################################################################
#  Design configuration
####################################################################

####################################################################
# Utility routine. Do not suppress
####################################################################
# Procedure for global variable declaration.
# A list of all the definitions are stored in the
# GlobalVarList variable and may be used for shell 
# definitions in a Makefile
# replaces "set aa ff" by "defGlobalVar aa ff"
proc defGlobalVar {var val} {
    global $var
    global GlobalVarList
    if {[info exists GlobalVarList]} {
        set GlobalVarList "$GlobalVarList $var:[string map {" " ";"} $val]"
    } else {
        set GlobalVarList "$var:[string map {" " ";"} $val]"
    }
    set $var $val
}


####################################################################
# Directories : Do not suppress or adapt to the real configuration
# of directories
####################################################################
# Defines is the full path of the directory of this script
defGlobalVar CNF_DIR  [file normalize [file dirname [info script]]]
# Defines the full path of the project directory (the current subdirectory should be design/design_conf
defGlobalVar PRJ_DIR [string range ${CNF_DIR} 0 [expr [string first /design/design_conf ${CNF_DIR}]-1]]

# Defines all other subdirectories
defGlobalVar SYN_DIR ${PRJ_DIR}/syn
defGlobalVar PR_DIR ${PRJ_DIR}/pr
defGlobalVar BACKEND_DIR ${PRJ_DIR}/backend
defGlobalVar SIM_DIR ${PRJ_DIR}/sim
defGlobalVar SIM_PE_DIR ${PRJ_DIR}/sim_post_elaborate
defGlobalVar SIM_PPR_DIR ${PRJ_DIR}/sim_post_pr
defGlobalVar SIM_PSYN_DIR ${PRJ_DIR}/sim_post_syn
defGlobalVar AMS_SIM_PSYN_DIR ${PRJ_DIR}/ams_sim_post_syn
defGlobalVar AMS_SIM_PPR_DIR ${PRJ_DIR}/ams_sim_post_pr
defGlobalVar AMS_SIM_PBACKEND_DIR ${PRJ_DIR}/ams_sim_post_backend
defGlobalVar SRC_DIR ${PRJ_DIR}/design/rtl
defGlobalVar TB_DIR ${PRJ_DIR}/design/tb_src
defGlobalVar TECHNO_DIR ${PRJ_DIR}/../techno
defGlobalVar TOOLS_DIR ${PRJ_DIR}/../tools

####################################################################
# DESIGN SOURCES
####################################################################
#  Name of the top Module
defGlobalVar TOP_MODULE  present_v0

#  RTL packages sources (give an empty list if not needed}
defGlobalVar SV_PKGS     {present_pkg.sv}

#  RTL file sources
defGlobalVar V_FILES     {}
defGlobalVar SV_FILES    {present_dp.sv  present_ctrl.sv  present.sv}

#  Name of the testbench top module
defGlobalVar TB_MODULE  present_tb

#  TestBench source files
defGlobalVar TB_FILES   {present_tb.sv}

# unroll factor
defGlobalVar  UNROLL_FCTR 2

# AMS TestBench source files
defGlobalVar AMS_TB_FILES {breadboard.vams}

####################################################################
# TIMING CONSTRAINTS
####################################################################
# clock constraints 
# Those are used in both synthesis (sdc), PR (sdc and clock tree synthesis) 
# and for power estimation after P&R
# UNITS are ps
defGlobalVar CLK_PERIOD 10000
defGlobalVar CLK_SKEW   100
defGlobalVar CLK_MAX_TRANS 100
defGlobalVar HOLD_SLACK 0

# For power estimation after P&R if no simulation waveform.
# TODO : is it realy used by the script ?
defGlobalVar ACTIVITY     0.3

####################################################################
# TECHNOLOGICAL CHOICES
####################################################################
# Kind of VT flavor: choose between (LVT8, LVT or RVT) for the standard 
# cells libs
#defGlobalVar TECHNO_VT LVT
# Should welltaps allow split supply beetween bulk and cells
#defGlobalVar SPLIT_WELLTAP 0

####################################################################
# GDSII postprocessing
####################################################################
# Power / Ground pin names legalization. Power/Ground Pins names generated by encounter
# for GDSII export have a "colon" as last char (VDD -> VDD:). 
# We may want to remove these colons.
defGlobalVar LEGALIZE_PG_PINS 0


####################################################################
# Start of techno configuration : should be launched at the
# end of the design configuration as it may be modified by the
# design choices
####################################################################
source ${TECHNO_DIR}/techno_def.tcl


####################################################################
# Echo GlobalVarlist if wanted. (Used by the Makfiles)
if {$argc == 1} {
  puts ${GlobalVarList}
}
