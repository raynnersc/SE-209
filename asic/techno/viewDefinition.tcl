# Worst case conditions for setup
create_library_set -name SS_library_set -timing {\
                          /comelec/softs/opt/opus_kits/CADENCE_PDKS/tpt_gsclib045/timing/basicCells_ss_0.90V_125C_ecsm.lib \
   }

# Best case conditions for hold
create_library_set -name FF_library_set -timing {\
                          /comelec/softs/opt/opus_kits/CADENCE_PDKS/tpt_gsclib045/timing/basicCells_ff_1.30V_M40C_ecsm.lib \
   }

# Typical  conditions for mean perf estimations
create_library_set -name TT_library_set -timing {\
                          /comelec/softs/opt/opus_kits/CADENCE_PDKS/tpt_gsclib045/timing/basicCells_tt_1.10V_25C_ecsm.lib \
   }

# Pas de différence entre les rc_corner pour cette techno de démonstration...
# On garde tout de même des noms différents pour une migration des scripts
# vers une techno plus réaliste
# Technological conditions
create_rc_corner -name SS_corner_set -temperature 125 \
      -qrc_tech  /comelec/softs/opt/opus_kits/CADENCE_PDKS/gsclib045_all_v4.4/gsclib045/qrc/qx/gpdk045.tch

# Best case technological conditions
create_rc_corner -name FF_corner_set -temperature -40 \
      -qrc_tech  /comelec/softs/opt/opus_kits/CADENCE_PDKS/gsclib045_all_v4.4/gsclib045/qrc/qx/gpdk045.tch

# Typical technological cond
create_rc_corner -name TT_corner_set -temperature 25 \
      -qrc_tech  /comelec/softs/opt/opus_kits/CADENCE_PDKS/gsclib045_all_v4.4/gsclib045/qrc/qx/gpdk045.tch

# Les "operating conditions"
# Worst operating conditions
create_opcond -name SS_PVT_0P9V_125C \
            -process 1.0 \
            -voltage .90 \
            -temperature 125 

# Best case operating conditions
create_opcond -name FF_PVT_1P3V_M40C \
            -process 1.0 \
            -voltage 1.3 \
            -temperature -40

# Best case operating conditions
create_opcond -name TT_PVT_1P1V_25C \
            -process 1.0 \
            -voltage 1.1 \
            -temperature -40

# Les "Timing conditions"
create_timing_condition -name SS_timing_condition \
            -library_set SS_library_set   \
            -opcond SS_PVT_0P9V_125C

create_timing_condition -name FF_timing_condition \
            -library_set FF_library_set   \
            -opcond FF_PVT_1P3V_M40C

create_timing_condition -name TT_timing_condition \
            -library_set TT_library_set   \
            -opcond TT_PVT_1P1V_25C

# On associe des conditions de timing avec des 
create_delay_corner -name SS_delay_corner \
            -timing_condition SS_timing_condition  \
            -rc_corner SS_corner_set

create_delay_corner -name FF_delay_corner \
            -timing_condition FF_timing_condition  \
            -rc_corner FF_corner_set

create_delay_corner -name TT_delay_corner \
            -timing_condition TT_timing_condition  \
            -rc_corner TT_corner_set

create_analysis_view -name SS_view \
            -constraint_mode default_constraint_mode \
            -delay_corner SS_delay_corner

create_analysis_view -name FF_view \
            -constraint_mode default_constraint_mode \
            -delay_corner FF_delay_corner

create_analysis_view -name TT_view \
            -constraint_mode default_constraint_mode \
            -delay_corner TT_delay_corner


# Unique analysis view
set_analysis_view  -setup [list SS_view]  -hold  [list FF_view]
