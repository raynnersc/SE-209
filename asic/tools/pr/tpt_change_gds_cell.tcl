################################################################################################ #
# calibredrv script for layout postProcessing:
#
# Args:
#  filein : the input gds file
#  fileout : the output gds file (maybe equal to filein)
#  cellin  : the name of a cell to replace
#  cellout : the name of a replacement cell
#################################################################################################

# Get the arguments
set filein [lindex $argv 0]
set fileout [lindex $argv 1]
set cellin [lindex $argv 2]
set cellout [lindex $argv 3]

# Read the input gds
set L [layout create $filein -dt_expand -preservePaths -preserveTextAttributes -preserveProperties -noReport]

# Get the topcell name
set topcell [$L topcell]
# Read the design kit map file in order to get the code associated to the purpose "label"
set reflist [$L iterator ref ${topcell}  range 0 end ]
foreach ref $reflist {
              set ref_name [lindex $ref 0] 
              set ref_x [lindex $ref 1] 
              set ref_y [lindex $ref 2] 
              set mirror [lindex $ref 3]
              set angle [lindex  $ref 4]
              set mag   [lindex  $ref 5]
              if {$ref_name == $cellin} {
                puts "\$L delete ref $topcell $cellin $ref_x $ref_y $mirror $angle $mag"
                $L delete ref ${topcell} $cellin $ref_x $ref_y $mirror $angle $mag
                puts "\$L create ref $topcell $cellout $ref_x $ref_y $mirror $angle $mag -force"
                $L create ref ${topcell} $cellout $ref_x $ref_y $mirror $angle $mag -force
              }
              #  $L modify text ${topcell} ${tlayer} $pinx $piny $pinname ${attributes} ${tlayer} $pinx $piny $new_pinname $attributes
}

$L gdsout $fileout -noEmptyCells
exit 0
