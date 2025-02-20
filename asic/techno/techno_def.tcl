# Techno definition file.
# WARNING : this configuration file cannot be used alone.
# It should only be sourced by the design configuration file of each design
# TECHNO_DIR variable is set to the directory containing this file

# PATH to the design kit installation
defGlobalVar KITDIR /comelec/softs/opt/opus_kits/CADENCE_PDKS

# PATH to the backend kit (virtuoso...)
defGlobalVar PDKITROOT ${KITDIR}/gpdk045_v_4_0/
defGlobalVar TPTPDKITROOT ${KITDIR}/tpt_gpdk045/
# PATH to the backend kit (encounter...)
#defGlobalVar EDIKITROOT  ${KITDIR}/CadenceTechnoKit_cmos028FDSOI_6U1x_2U2x_2T8x_LB_LowPower/4.2-00/EDI


# names of mapfiles for GDSII import/export
#  For exports from EDI to VIRTUOSO
defGlobalVar EDI_GDSII_mapfile ${KITDIR}/COMELEC/EDI/gpdk045.mapOut

#  For exports from and to VIRTUOSO (CALIBRE)
defGlobalVar VIRTUOSO_GDSII_mapfile  ${PDKITROOT}/gpdk045/gpdk045.layermap

# For Voltus tools
defGlobalVar VOLTUS_LEF2QRC_mapfile ${KITDIR}/gsclib045_all_v4.4/gsclib045_tech/lef2qrc.layermap

# Virtuoso OpenAccess Defs
defGlobalVar virtuoso_techno_lib gpdk045

# Virtuosos List of Reference libraries
defGlobalVar virtuoso_ref_libs [list \
                                gsclib045 \
                                gsclib045_backbias \
                                gsclib045_hvt \
                                gsclib045_lvt \
                                gsclib045_tech \
                               ]

# Assura (DRC) name of the template file for batch mode DRC
defGlobalVar ASSURA_DRC_TEMPLATE_FILE ${TECHNO_DIR}/assura_gpdk045_drc_template.rsf
# Assura (LVS) name of the template files for batch mode DRC
defGlobalVar ASSURA_LVS_TOP_TEMPLATE_FILE ${TECHNO_DIR}/assura_gpdk045_lvs_top_template.rsf
defGlobalVar ASSURA_LVS_BOTTOM_TEMPLATE_FILE ${TECHNO_DIR}/assura_gpdk045_lvs_bottom_template.rsf
defGlobalVar ASSURA_COMPARE_RULES_FILE ${PDKITROOT}/assura/compare.rul
defGlobalVar ASSURA_LVS_VLR ${TECHNO_DIR}/assura_gpdk045_lvs.vlr
defGlobalVar ASSURA_QRC_NETLIST_CCL ${TECHNO_DIR}/assura_gpdk045_qrc_extract_netlist.ccl

# Get the name of the tool in order to select tool dependant variables
defGlobalVar Prog [exec basename $argv0]

# For irun digital simulation using precompiled gate models (LVT and RVT cells...) with back annotated timings
defGlobalVar REF_IRUN_LIBS  "-reflib /${KITDIR}/tpt_gsclib045/irun_libs/func/basicCells"

# For irun  ams simulation using precompiled electrical gate models (LVT and RVT cells...)
defGlobalVar AMS_REF_IRUN_LIBS  "-reflib ${KITDIR}/tpt_gsclib045/ams_xrun_libs/lib_scs/gsclib045_basicCells "

# For irun spectre models
defGlobalVar AMS_IRUN_SPECTRE_MODELS  ${TPTPDKITROOT}/models/spectre/gpdk045.scs

########################################### FOR GENUS and INNOVUS ####################"
# What is the standard cell site
defGlobalVar TECHNO_CORE_SITE CoreSite

# where to look for technology files (libs and lefs) for "genus"
defGlobalVar LIB_SEARCH_PATH    [list  \
                           . \
                           ${KITDIR}/tpt_gsclib045/timing \
                           ]

# (Layout Extraction Format) lef files
# /!\ TECHNO. LEF MUST BE FIRST IN THE LIST !!!!
# Created innexistant gsclib045_sites.lef
# Patched gsclib045_macro.lef (inconsistant site definition for MUX2 cell)
defGlobalVar LEF_FILES       [ list \
                      ${KITDIR}/gsclib045_all_v4.4/gsclib045/lef/gsclib045_tech.lef \
                      ${KITDIR}/tpt_gsclib045/lef/gsclib045_sites.lef \
                      ${KITDIR}/tpt_gsclib045/lef/gsclib045_macro.lef \
                     ]

# Specific files only used for P&R
defGlobalVar PR_LEF_FILES    [ list \
                     ]
# (liberty) lib files (TT,0.90V, 25C)
defGlobalVar LIB_FILES    [ list \
                  basicCells_ss_0.90V_125C_ecsm.lib \
                  ]

#libs for p&r cells (clock buffers and fillers and ...)
defGlobalVar PR_LIB_FILES [ list \
                  ]

# Filler cells in decreasing size order
defGlobalVar FILLER_CELLS [list\
                   FILL1  \
                   FILL2  \
                   FILL4  \
                   FILL8  \
                   FILL16 \
                   FILL32 \
                   FILL64 \
                   ]

# Decap cells in decreasing size order
defGlobalVar DECAP_CELLS [list\
                   DECAP1 \
                   DECAP2 \
                   DECAP3 \
                   DECAP4 \
                   DECAP5 \
                   DECAP6 \
                   DECAP7 \
                   DECAP8 \
                   DECAP9 \
                   DECAP10 \
                   ]

# clk tree cells from C28SOI_SC_8_CLK_LL. We choose only version without polybiasing
defGlobalVar CLK_BUFFER_CELLS {  \
                               CLKBUFX2  CLKBUFX3  CLKBUFX4 \
                               CLKBUFX6  CLKBUFX8  CLKBUFX12 \
                               CLKBUFX16 CLKBUFX20  \
                               }
defGlobalVar CLK_INVERTER_CELLS { \
                                 CLKINVX1 CLKINVX2 CLKINVX3 \
                                 CLKINVX4 CLKINVX6 CLKINVX8 \
                                 CLKINVX12 CLKINVX16 CLKINVX20 \
                                 }
  
# For RTL compiler:  qrc file (this replaces captable files), found in the directory  defined in the lib_search_path
defGlobalVar QRC_TECH_FILE  ${KITDIR}/gsclib045_all_v4.4/gsclib045/qrc/qx/gpdk045.tch
defGlobalVar CAP_TABLE_FILE ${KITDIR}/gpdk045_v_4_0/soce/gpdk045.extended.CapTbl

########################################################################################################################
# Tool dependant parameters
########################################################################################################################

# Adapt lib and lef files list to the step (synthesis or place and root)
if {$Prog == "genus" } then {
} else {
  # Concat all libs for Innovus and tclsh for backend
  defGlobalVar LIB_FILES    [ concat $LIB_FILES $PR_LIB_FILES]
  defGlobalVar LEF_FILES    [ concat $LEF_FILES $PR_LEF_FILES ]
}

defGlobalVar VIEW_DEFINITION_FILE ${TECHNO_DIR}/viewDefinition.tcl
