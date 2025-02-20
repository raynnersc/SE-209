# Simple translation script from Verilog netlist to Verilog-AMS Netlist
# Input netlist is supposed to be generated by Synopsys Netlister after place&route
# Connections to VDD, VSS, VDDs and VSSs are added.
# Main level module name is renamed in order to avoid confusion with
# original module
# usage : awk -f vlog2vams.awk -v <top_level_module_name> <verilog_file>

BEGIN { 
      print "//"
      print "// Translated from Verilog by vlog2vams.awk"
      print "//"
      print ""
      print "// Mandatory for Cadence IRUN/AMS in order to avoid confusion between"
      print "// the  access function Q (charge evaluation) and a port named Q"
      print "// should be defined berfore the standard VAMS include files."
      print "`define VAMS_ELEC_DIS_ONLY"
      print ""
      print "// Mandatory for  AMS"
      print "`include \"constants.vams\""
      print "`include \"disciplines.vams\""
      print ""
      print "// All modules should have a timescale directive"
      print "`timescale 1ns/100fs"
      print ""
      }

# General substitutions: constants should be replaced by connections to VSS or VDD
{ $0 = gensub(/1'b0/,"VSS","g") }
{ $0 = gensub(/1'b1/,"VDD","g") }
{ $0 = gensub(/\(/," ( ","g") }
{ $0 = gensub(/\)/," ) ","g") }
# If wires are declared
{ $0 = gensub(/wire/,"electrical","g") }

# Patch the top module name
#/^module/ {
#          if($2 == top_module_name) { $2 = top_module_name"_phy" }
#          }

/electrical/ { print; next }

/module/ { in_module_def = 1 }

# Submodule definitions end by ");"
/)\s*;/ { 
       for(i=1;i<NF-1;i++) { 
         printf("%s ",$i) 
       } 
       if( in_module_def == 1) {
         printf(", VDD, VSS );\n") ;
         # add supplies definition
         printf("inout VDD ;\n") ;
         printf("inout VSS ;\n") ;
       } else {
       printf(", .VDD(VDD), .VSS(VSS) );\n") ;
      }
      in_module_def = 0 ;
       next
     }

{print}

END {}
