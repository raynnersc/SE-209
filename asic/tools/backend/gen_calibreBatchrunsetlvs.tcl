#!/usr/bin/tclsh
#####################################################################################
# Generate a runset for lvs with calibre gui.
# For a  different configuration, use calibre in interactive mode, modify some flags
# and configuration, save the runset and then modify the runset genrerator according
# to the new example
#####################################################################################
set PRJ_DIR $env(PRJ_DIR)
source ${PRJ_DIR}/design/design_conf/design_def.tcl

set fp [open "calibreBatchrunsetlvs" w]
# Design dependant customisation
puts $fp "*lvsLayoutPaths: ${BACKEND_DIR}/results/${TOP_MODULE}_full.gds"
puts $fp "*lvsLayoutPrimary: ${TOP_MODULE}"
puts $fp "*lvsLayoutLibrary: ${TOP_MODULE}_lib"
# In case of hierarchical LAYOUT get the list of modules from variables
if {[info exists CALIBRE_LVS_SOURCE_PATH]} {
  puts $fp "*lvsSourcePath: $CALIBRE_LVS_SOURCE_PATH"
} else {
  puts $fp "*lvsSourcePath: ${PR_DIR}/results/${TOP_MODULE}_phys.v"
}
# In case of a merge with an already netlisted blocks
if {[info exists CALIBRE_LVS_SPICE_LIB_FILES]} {
  puts $fp "*cmnV2LVS_SPICELibFiles: $CALIBRE_LVS_SPICE_LIB_FILES"
} 

puts $fp "*lvsSourcePrimary: ${TOP_MODULE}"
puts $fp "*lvsSpiceFile: ${TOP_MODULE}.sp"
puts $fp "*lvsERCDatabase: ${TOP_MODULE}.erc.results"
puts $fp "*lvsERCSummaryFile: ${TOP_MODULE}.erc.summary"
puts $fp "*lvsReportFile: ${TOP_MODULE}.lvs.report"
puts $fp "*lvsMaskDBFile: ${TOP_MODULE}.maskdb"
puts $fp "*cmnFDILayoutLibrary: ${TOP_MODULE}_lib"
puts $fp "*cmnFDIDEFLayoutPath: ${TOP_MODULE}.def"

# These variables are techno dependant
puts $fp "*lvsRulesFile: ${CALIBRE_LVS_DECK}"
puts $fp "*lvsIncludeFiles: ${CALIBRE_LVS_INCLUDE_FILES}"
# ??? pas trouvé.
puts $fp "*lvsLayersFile: \$U2DK_CAL_LVS_SIGLAYERS"
puts $fp "*cmnCustomFileName: ${CALIBRE_LVS_CUSTOMIZATION_FILE}"
# Put here the interactive flags sets. (related to the customisation menu def : CALIBRE_DRC_CUSTOMIZATION_FILE
puts $fp "*cmnCustomFileOverrideValues: {DEFINE LVS name RUN_ERC 0 {}} {DEFINE LVS name CONNECT_FILL_LAYERS 0 {}}"

# All other variables are not design dependant
puts $fp "*lvsSourceSystem: VERILOG"
puts $fp "*lvsAutoMatch: 1"
puts $fp "*lvsRunDir: ./batchLvsRunDir"
puts $fp "*lvsDeviceFilterOptionsEnabled: 0"
puts $fp "*lvsPowerNames: VDD vdd \"vdd!\" \"vdd;\" VDDS vdds \"vdds!\" \"vdds;\" \"VDD:\" VDDE VDDPrince" 
puts $fp "*lvsGroundNames: GND gnd \"gnd!\" \"gnd;\" GNDS gnds \"gnds!\" \"gnds;\" \"GND:\" GNDE"
puts $fp "*lvsRecognizeGates: NONE"
puts $fp "*lvsReduceSplitGates: 0"
puts $fp "*lvsReduceParallelMOS: 0"
puts $fp "*lvsViewExtractionReport: 1"
puts $fp "*lvsReportOptions: A B C D"
puts $fp "*lvsAbortOnSoftchk: 1"
puts $fp "*cmnShowOptions: 1"
puts $fp "*cmnSaveTVFRulesToSVRF: 1"
puts $fp "*cmnVerifySourceNetlist: 0"
if {[info exists CALIBRE_LVS_CONVERT_ARRAY]} {
  puts $fp "*cmnV2LVS_Achars: <>"
}
puts $fp "*cmnV2LVS_LastTranslation: 1447417452675015"
puts $fp "*cmnUseCustomFile: 1"
puts $fp "*cmnFDILayoutView: layout"
puts $fp "*cmnSlaveHosts: {use {}} {hostName {}} {cpuCount {}} {a32a64 {}} {rsh {}} {maxMem {}} {workingDir {}} {layerDir {}} {mgcLibPath {}} {launchName {}}"
puts $fp "*cmnLSFSlaveTbl: {use 1} {totalCpus 1} {minCpus 1} {architecture {{}}} {minMemory {{}}} {resourceOptions {{}}} {submitOptions {{}}}"
puts $fp "*cmnGridSlaveTbl: {use 1} {totalCpus 1} {minCpus 1} {architecture {{}}} {minMemory {{}}} {resourceOptions {{}}} {submitOptions {{}}}"

close $fp
