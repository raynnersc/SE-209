# YM/TPT
# Add metal type under IO pins in order to respect
# DRC checks of GDSII (all pin shall be entirely
# covered by metal layer.

proc tpt_extend_IOpins_for_gds {} {
  # Get all the terminals of the top cell
  set designTermList [get_db ports]

  # Loop on the terminals
  puts "--> Extend IO signal IO pins for GDS"
  foreach term $designTermList {
      set location [split [lindex [get_db $term .location] 0]]
      set x [lindex $location 0]
      set y [lindex $location 1]
      set layerName [get_db $term .layer.name]
      set width [get_db $term .width]
      set depth [get_db $term .depth]
      set name [get_db $term .name]
      set side [get_db $term .side]
      switch ${side}  {
              west  { create_shape -layer ${layerName} -net ${name} -rect  $x                   [expr $y -$width/2.0] [expr $x+$depth]   [expr $y+$width/2.0]  }
              east  { create_shape -layer ${layerName} -net ${name} -rect  [expr $x-$depth]     [expr $y -$width/2.0] $x                 [expr $y+$width/2.0]  }
              north { create_shape -layer ${layerName} -net ${name} -rect  [expr $x-$width/2.0] [expr $y -$depth]     [expr $x+$width/2] [expr $y]             }
              south { create_shape -layer ${layerName} -net ${name} -rect  [expr $x-$width/2.0] $y                    [expr $x+$width/2] [expr $y+$depth]      }
      }
  }
  # Loop on the Power/Ground terminals
  puts "--> Extend Power/Ground I/O pins for GDS"
  set designPGTermList [get_db designs .pg_ports]
  if {$designPGTermList != 0x0} {
    foreach term $designPGTermList {
        set name [get_db $term .name]
        foreach pin [get_db $term .physical_pins] {
            set layer_shape [get_db $pin .layer_shapes]
            set layer_name [get_db $layer_shape .layer.name]
            set shape [get_db $layer_shape .shapes]
            set rect  [get_db $shape .rect]
            create_shape -layer ${layer_name} -net ${name} -rect ${rect}
        }
    }
  }
}





