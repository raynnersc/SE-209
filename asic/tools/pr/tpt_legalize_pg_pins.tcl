################################################################################################ #
# calibredrv script for layout postProcessing:
# Remove ":" colon character at the end of label names. Ie : "VDD:" -> "VDD"
#
# Call:
#  calibredrv legalize_pg_pins.tcl filein fileout mapfile
#
# Args:
#  filein : the input gds file
#  fileout : the output gds file (maybe equal to filein)
#  mapfile : the mapfile for Virtuoso/gds
#################################################################################################

# Get the arguments
set filein [lindex $argv 0]
set fileout [lindex $argv 1]
set mapfile [lindex $argv 2]

# Read the input gds
set L [layout create $filein -dt_expand -preservePaths -preserveTextAttributes -preserveProperties -noReport]

# Get the topcell name
set topcell [$L topcell]
# Read the design kit map file in order to get the code associated to the purpose "label"
set f [open $mapfile "r"]
while {[gets $f line]>=0} {
   set fields [regexp -all -inline {\S+} $line ]
   set cpurpose [lindex $fields 1]
   if {$cpurpose == "label"} { 
       # Forge the layer number (n.m)
       set tlayer  [lindex $fields 2].[lindex $fields 3]
       # Test if an object of this layer exists in the design
       if {[$L exists layer ${tlayer}]} {
          set pinlist [$L iterator text ${topcell} ${tlayer} range 0 end]
          foreach pin $pinlist {
              set pinname [lindex $pin 0] 
              set pinx [lindex $pin 1] 
              set piny [lindex $pin 2] 
              set attributes [lrange $pin 3 end]
              if { [string index $pinname [expr [string length $pinname] -1]] == ":" } {  
                set new_pinname  [string range $pinname 0 [expr [string length $pinname] -2]]
                puts $topcell
                puts $tlayer
                puts $pinx
                puts $piny
                puts $pinname
                puts $attributes
                puts $tlayer
                puts $pinx
                puts $piny
                puts $new_pinname
                puts $attributes
                puts "Legalization : $pinname --> $new_pinname"
                $L modify text ${topcell} ${tlayer} $pinx $piny $pinname ${attributes} ${tlayer} $pinx $piny $new_pinname $attributes
              }
          }
       }
   }
}

$L gdsout $fileout -noEmptyCells
exit 0
