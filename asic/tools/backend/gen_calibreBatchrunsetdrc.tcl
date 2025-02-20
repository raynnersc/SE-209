#!/usr/bin/tclsh
#####################################################################################
# Generate a runset for drc with calibre gui.
# For a  different configuration, use calibre in interactive mode, modify some flags
# and configuration, save the runset and then modify the runset genrerator according
# to the new example
# The DRC rules are choosen to avoid errors with standard-cells skeletons. Unwanted 
# rules are deselected:
# - no density check
# - no check of mandatory transistors under polybias
# - the check may be limited to a predifined area in order to avoid errors with the
# IO blocks from ST. The flag CALIBRE_DRC_WITHOUT_IO may be set to in order to
# define the area
#
#####################################################################################
set PRJ_DIR $env(PRJ_DIR)
source ${PRJ_DIR}/design/design_conf/design_def.tcl

set fp [open "calibreBatchrunsetdrc" w]

# Design dependant customisation
puts $fp "*drcLayoutPaths: ${BACKEND_DIR}/results/${TOP_MODULE}_full.gds"
puts $fp "*drcLayoutPrimary: ${TOP_MODULE}"
puts $fp "*drcLayoutLibrary: ${TOP_MODULE}_lib"
puts $fp "*drcResultsFile: ${TOP_MODULE}.drc.results"
puts $fp "*drcSummaryFile: ${TOP_MODULE}.drc.summary"
puts $fp "*cmnTranscriptFile: ${TOP_MODULE}.calibre.log"
puts $fp "*cmnFDILayoutLibrary: ${TOP_MODULE}_lib"
puts $fp "*cmnFDIDEFLayoutPath: ${TOP_MODULE}.def"
if {${CALIBRE_DRC_WITHOUT_IO} == 1} {
  source ${PR_DIR}/results/${TOP_MODULE}_areas.tcl
  puts $fp "*drcDRCCheckArea: 1"
  puts $fp "*drcDRCAreaCoords: ${fplan_box_without_io}"
}



# Put here the interactive flags sets. (related to the customisation menu def : CALIBRE_DRC_CUSTOMIZATION_FILE
puts $fp "*cmnCustomFileOverrideValues: {DEFINE DRC name DESIGN_TYPE 1 CELL_NOESD} {DEFINE DRC name CHECK_PAD_ASSEMBLY 0 {}} {DEFINE DRC name METRO_TILE 0 {}}"

# Put here the unwanted rules for simple block drc
puts $fp "*drcUserRecipes: {{Checks selected in the rules file (Modified)} {{group_unselect\[1\]} all {group_select\[1\]} rule_file {check_unselect\[1\]} B1.DEN.1 {check_unselect\[2\]} B2.DEN.1 {check_unselect\[3\]} IA.DEN.1 {check_unselect\[4\]} IB.DEN.1 {check_unselect\[5\]} M1.DEN.1 {check_unselect\[6\]} M2.DEN.1 {check_unselect\[7\]} M3.DEN.1 {check_unselect\[8\]} M4.DEN.1 {check_unselect\[9\]} M5.DEN.1 {check_unselect\[10\]} M6.DEN.1 {check_unselect\[11\]} PC.DEN.1 {check_unselect\[12\]} RX.DEN.1 {check_unselect\[13\]} POB.R.4}}"

# All other variables are not design dependant
puts $fp "*drcRulesFile: ${CALIBRE_DRC_DECK}"
puts $fp "*drcRunDir: ./batchDrcRunDir"
puts $fp "*drcExtraLayoutPaths: $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_10_20130429_memcell_cam0711_LVT_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_10_20130619_memcell_dp0316_SW_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_10_20130718_memcell_sp0152_LVT_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_10_20131122_memcell_sp0152_SW_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_10_memcell_otp2P4_28SOI_EG_FW_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_10_memcell_otp2P4_28SOI_EG_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_10_memcell_sp0120_SW_LL_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_10_memcell_sp0197_LL_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_11_20131122_memcell_rf0251_SW_LL_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_12_20131121_memcell_cam0793_SW_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_12_memcell_rom0136_RVT_32_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_13_memcell_sp0120_LL_28_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_14beta1_memcell_sp0120_LL_28_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_10_20120620_memcell_rf0298_LL_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_11_20140123_memcell_rf0298_LL_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_10_20140918_memcell_rf0251_BB_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_12_20140930_memcell_rom0110_LVT_28SOI_nolayer.*"
puts $fp "*drcGoldenLayoutPaths: $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_10_20130429_memcell_cam0711_LVT_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_10_20130619_memcell_dp0316_SW_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_10_20130718_memcell_sp0152_LVT_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_10_20131122_memcell_sp0152_SW_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_10_memcell_otp2P4_28SOI_EG_FW_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_10_memcell_otp2P4_28SOI_EG_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_10_memcell_sp0120_SW_LL_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_10_memcell_sp0197_LL_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_11_20131122_memcell_rf0251_SW_LL_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_12_20131121_memcell_cam0793_SW_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_12_memcell_rom0136_RVT_32_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_13_memcell_sp0120_LL_28_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_14beta1_memcell_sp0120_LL_28_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_10_20120620_memcell_rf0298_LL_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_11_20140123_memcell_rf0298_LL_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_10_20140918_memcell_rf0251_BB_28SOI_nolayer.* $PDKITROOT/DATA/DRC/CALIBRE/BRL_reference/BRL_12_20140930_memcell_rom0110_LVT_28SOI_nolayer.*"
puts $fp "*drcLayoutView: layout"
puts $fp "*drcLayoutGetFromViewer: 0"
puts $fp "*drcDRCMaxVertexCount: 199"
puts $fp "*drcActiveRecipe: Checks selected in the rules file (Modified)"
puts $fp "*drcIncrDRCSlaveHosts: {use {}} {hostName {}} {cpuCount {}} {a32a64 {}} {rsh {}} {maxMem {}} {workingDir {}} {layerDir {}} {mgcLibPath {}} {launchName {}}"
puts $fp "*drcIncrDRCLSFSlaveTbl: {use 1} {totalCpus 1} {minCpus 1} {architecture {{}}} {minMemory {{}}} {resourceOptions {{}}} {submitOptions {{}}}"
puts $fp "*drcIncrDRCGridSlaveTbl: {use 1} {totalCpus 1} {minCpus 1} {architecture {{}}} {minMemory {{}}} {resourceOptions {{}}} {submitOptions {{}}}"
puts $fp "*cmnTranscriptEchoToFile: 1"
puts $fp "*cmnRunHier: 0"
puts $fp "*cmnSaveTVFRulesToSVRF: 1"
puts $fp "*cmnTemplate_TF: %l.calibre.log"
puts $fp "*cmnUseCustomFile: 1"
puts $fp "*cmnCustomFileName: ${CALIBRE_DRC_CUSTOMIZATION_FILE}"
puts $fp "*cmnSlaveHosts: {use {}} {hostName {}} {cpuCount {}} {a32a64 {}} {rsh {}} {maxMem {}} {workingDir {}} {layerDir {}} {mgcLibPath {}} {launchName {}}"
puts $fp "*cmnLSFSlaveTbl: {use 1} {totalCpus 1} {minCpus 1} {architecture {{}}} {minMemory {{}}} {resourceOptions {{}}} {submitOptions {{}}}"
puts $fp "*cmnGridSlaveTbl: {use 1} {totalCpus 1} {minCpus 1} {architecture {{}}} {minMemory {{}}} {resourceOptions {{}}} {submitOptions {{}}}"
puts $fp "*cmnFDILayoutView: layout"
close $fp
