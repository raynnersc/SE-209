#################################################################################################
#
# calibredrv script for layout postProcessing:
# Add triple nwell isolation for a bloc
# length are in GDSII units
#
# Call:
#  calibredrv tpt_add_deep_nwell_to_gds.tcl filein fileout llx lly urx ury nww mapfile nwell_layer nwell_purpose deepn_layer deepn_purpose marker_layer marker_purpose
#
# Args:
#  filein : the input gds file
#  fileout : the output gds file (maybe equal to filein)
#  llx lly urx ury : the rectangle of deep_nwell to add
#  nww : the width of the nwell ring (centered on the deepn rectangle periphery
#  mapfile : the layer map file to use
#  nwell_layer : the layer name for nwell
#  nwell_purpose : the nwell layer type
#  deepn_layer : the layer name for the deep nwell
#  deepn_purpose : the deepn layer type
#  marker_layer : the layer for the marker
#  marker_purpose : the marker layer type
#################################################################################################

# Get the arguments
set filein [lindex $argv 0]
set fileout [lindex $argv 1]
set llx [lindex $argv 2]
set lly [lindex $argv 3]
set urx [lindex $argv 4]
set ury [lindex $argv 5]
set nww [lindex $argv  6]
set mapfile [lindex $argv 7]
set nwell_layer [lindex $argv 8]
set nwell_purpose [lindex $argv 9]
set deepn_layer [lindex $argv 10]
set deepn_purpose [lindex $argv 11]
set marker_layer [lindex $argv 12]
set marker_purpose [lindex $argv 13]

# Read the input gds
set L [layout create $filein -dt_expand -preservePaths -preserveTextAttributes -preserveProperties -noReport]

# Get the topcell name
set topcell [$L topcell]
# Read the design kit map file in order to create the 2 layers
set f [open $mapfile "r"]
while {[gets $f line]>=0} {
   set fields [regexp -all -inline {\S+} $line ]
   set clayer [lindex $fields 0]
   set cpurpose [lindex $fields 1]
   if {$cpurpose == $nwell_purpose && $clayer == $nwell_layer } {
       set nwell_num  [lindex $fields 2].[lindex $fields 3]
       $L create layer $nwell_num
   }
   if {$cpurpose == $deepn_purpose && $clayer == $deepn_layer } {
       set deepn_num  [lindex $fields 2].[lindex $fields 3]
       $L create layer $deepn_num
   }
   if {($marker_layer != "") && ($marker_purpose != "")} {
     if {$cpurpose == $marker_purpose && $clayer == $marker_layer } {
         puts stderr $marker_purpose
         puts stderr $marker_layer
         set marker_num  [lindex $fields 2].[lindex $fields 3]
         puts stderr $marker_num
         $L create layer $marker_num
     }
   }
}
# Create the deepn rectangle
$L create polygon $topcell $deepn_num $llx $lly $urx $ury
# Create the nwell ring bottom rectangle
$L create polygon $topcell $nwell_num [expr $llx-$nww/2] [expr $lly-$nww/2] [expr $urx+$nww/2] [expr $lly+$nww/2]
# Create the nwell ring top rectangle
$L create polygon $topcell $nwell_num [expr $llx-$nww/2] [expr $ury-$nww/2] [expr $urx+$nww/2] [expr $ury+$nww/2]
# Create the nwell ring left rectangle
$L create polygon $topcell $nwell_num [expr $llx-$nww/2] [expr $lly-$nww/2] [expr $llx+$nww/2] [expr $ury+$nww/2]
# Create the nwell ring right rectangle
$L create polygon $topcell $nwell_num [expr $urx-$nww/2] [expr $lly-$nww/2] [expr $urx+$nww/2] [expr $ury+$nww/2]
# Create the overall marker rectangle if needed
if {($marker_layer != "") && ($marker_purpose != "")} {
  $L create polygon $topcell $marker_num [expr $llx-$nww/2] [expr $lly-$nww/2] [expr $urx+$nww/2] [expr $ury+$nww/2]
}

$L gdsout $fileout -noEmptyCells
exit 0
