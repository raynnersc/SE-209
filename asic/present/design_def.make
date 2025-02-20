#  Design configuration
#  Should be sourced at the beginning of each Makefile in the several directories
#  Get  the variables defined in the tcl file "design/design_conf/design_def.tcl"
#  and creates identical shell variables. The "echo" argument to the tcl script
#  is used to get an echo of all variables definitions
GlobalVarList=$(shell tclsh ../design/design_conf/design_def.tcl echo)
$(foreach vardef,${GlobalVarList},$(eval export $(firstword $(subst :, , ${vardef})) = $(subst ;, ,$(word 2,$(subst :, , ${vardef})))))

