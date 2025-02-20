#################################################################################################
#
# calibredrv script for layout postProcessing:
# Add a  rectangle of an arbitrary layer/purpose in the top module of a GDS tree
# lengths are in GDSII units
#
# Call:
#  calibredrv tpt_add_rectangle_to_gds.tcl filein fileout llx lly urx ury layer mapfile layer purpose
#
# Args:
#  filein : the input gds file
#  fileout : the output gds file (may be equal to filein)
#  llx lly urx ury : the rectangle to add
#  mapfile : the layer map file to use
#  layer : the layer name (M1, M2, ...)
#  purpose : the layer type
#################################################################################################

# Get the arguments
set filein [lindex $argv 0]
set fileout [lindex $argv 1]
set llx [lindex $argv 2]
set lly [lindex $argv 3]
set urx [lindex $argv 4]
set ury [lindex $argv 5]
set mapfile [lindex $argv 6]
set layer [lindex $argv 7]
set purpose [lindex $argv 8]


# Read the input gds
set L [layout create $filein -dt_expand -preservePaths -preserveTextAttributes -preserveProperties -noReport]
# Get the topcell name
set topcell [$L topcell]

# Read the design kit map file in order to get the layer indexes for the metal markers.
set f [open $mapfile "r"]
while {[gets $f line]>=0} {
   set fields [regexp -all -inline {\S+} $line ]
   set clayer [lindex $fields 0]
   set cpurpose [lindex $fields 1]
   if {$cpurpose == $purpose && $clayer == $layer } {
       set lnum  [lindex $fields 2].[lindex $fields 3]
       $L create layer $lnum
       $L create polygon $topcell $lnum $llx $lly $urx $ury
       break
   }
}
$L gdsout $fileout -noEmptyCells
exit 0
