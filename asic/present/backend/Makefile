# General defs for the design
include ../design_def.make


.PHONY: all defin strmout drc rve

all:
	@echo "Backend post processing"
	@echo "make defin       : Imports a DEF Innovus bloc in a Virtuoso open access database"
	@echo "make verilog2oa  : Imports a Verilog Innovus bloc in a Virtuoso open access database (netlist + schematic)"
	@echo "make drc         : Execute a batch DRC. Results are in the file work/batch_DRC/DRC.err"
	@echo "make lvs         : Execute a batch LVS. Results are in the file work/batch_LVS/LVS.csm"
	@echo "make ext         : Execute a batch EXTRACTION of the netlist with parasitics. Results are in the file work/<module>.sp"
	@echo "make strmout     : export a full GDS hierarchy (including stdcell layout skeleton) from the imported bloc"
	@echo "make gui         : open a virtuoso session within the current KIT context for imported cell exams"

defin: work/${TOP_MODULE}_lib/${TOP_MODULE}/layout
verilog2oa: work/${TOP_MODULE}_lib/${TOP_MODULE}/netlist
strmout: results/${TOP_MODULE}_full.gds
drc: work/batch_DRC/DRC.err
lvs: work/batch_LVS/LVS.csm
ext: work/${TOP_MODULE}.sp

########################################################################################################################
# Create temporary directory configured for GPDK045 techno with auxiliary files
########################################################################################################################
work: 
	@mkdir -p $@
	@echo "Creating a working directory with GPDK045 initialisation, it may take some time..."
	@cd $@ &&\
		$(PDKITROOT)/COMELEC/gpdkinit
	echo "Done"

########################################################################################################################
# Create a directory for final results such as netlists, GDSII ...
########################################################################################################################
results:
	@mkdir -p $@

########################################################################################################################
# Import DEF design into Virtuoso open access lib.
########################################################################################################################

work/${TOP_MODULE}_lib/${TOP_MODULE}/layout: ${PR_DIR}/results/${TOP_MODULE}.def | work
	@cd work &&\
	${EXEC_KIT_ENV}  defin \
		-shared \
		-pinPurp "pin" \
        -lib ${TOP_MODULE}_lib \
	    -overwrite \
		-def $< \
		-tech gsclib045_tech \
		-masterLibs "${virtuoso_ref_libs}" \
		-viewNameList "layout" \
		-createModHier

########################################################################################################################
# Import Verilog design into Virtuoso open access lib (netlist view)  then convert to schematic
# As the design may be hierarchical, convert all submodules as netlist and then convert
# all netlists as schematics. 
# TODO: 
########################################################################################################################

work/${TOP_MODULE}_lib/${TOP_MODULE}/netlist: ${PR_DIR}/results/${TOP_MODULE}.v | work
	@cd work && \
	${EXEC_KIT_ENV} verilog2oa \
    	-shared \
    	-overwrite \
		-designPerMod \
        -lib ${TOP_MODULE}_lib \
    	-verilog $< \
    	-refLibs "${virtuoso_ref_libs}"  \
    	-refViews "symbol"
	@cd work && \
		for netlist in `find  ${TOP_MODULE}_lib -maxdepth 1 -type d`; do \
		    conn2sch -lib ${TOP_MODULE}_lib -cell $$(basename $$netlist) -view netlist -destview schematic ;\
	    done




########################################################################################################################
# Execute DRC in batch mode.
########################################################################################################################
work/batch_DRC/DRC.err: work/${TOP_MODULE}_lib/${TOP_MODULE}/layout | work
	mkdir -p work/batch_DRC
	sed "s/LIBNAME/${TOP_MODULE}_lib/;s/MODULE/${TOP_MODULE}/;s|PDKITROOT|${PDKITROOT}|" ${ASSURA_DRC_TEMPLATE_FILE} > work/batch_DRC/batch_DRC.rsf
	cd work && ${EXEC_KIT_ENV} assura batch_DRC/batch_DRC.rsf 2>&1 | tee batch_DRC.log

########################################################################################################################
# Execute LVS in batch mode. 
########################################################################################################################
work/batch_LVS/LVS.csm: work/${TOP_MODULE}_lib/${TOP_MODULE}/layout work/${TOP_MODULE}_lib/${TOP_MODULE}/netlist | work
	mkdir -p work/batch_LVS
	sed "s/LIBNAME/${TOP_MODULE}_lib/;s/MODULE/${TOP_MODULE}/;s|PDKITROOT|${PDKITROOT}|" ${ASSURA_LVS_TOP_TEMPLATE_FILE} > work/batch_LVS/batch_LVS.rsf
	cat ${ASSURA_COMPARE_RULES_FILE} >> work/batch_LVS/batch_LVS.rsf
	cat ${ASSURA_LVS_BOTTOM_TEMPLATE_FILE} >> work/batch_LVS/batch_LVS.rsf
	sed "s/LIBNAME/${TOP_MODULE}_lib/;s/MODULE/${TOP_MODULE}/;s|PDKITROOT|${PDKITROOT}|" ${ASSURA_LVS_VLR} > work/batch_LVS/batch_LVS.vlr
	cd work && ${EXEC_KIT_ENV} assura batch_LVS/batch_LVS.rsf 2>&1 | tee batch_LVS.log

########################################################################################################################
# Execute EXTRACTION in batch mode. Must follow LVS
########################################################################################################################
work/${TOP_MODULE}.sp: work/batch_LVS/LVS.csm | work results
	sed "s/LIBNAME/${TOP_MODULE}_lib/;s/MODULE/${TOP_MODULE}/;s|PDKITROOT|${PDKITROOT}|" ${ASSURA_QRC_NETLIST_CCL} > work/batch_LVS/batch_QRC.ccl
	cd work && ${EXEC_KIT_ENV} qrc -cmd  batch_LVS/batch_QRC.ccl 2>&1 | tee batch_EXT.log

########################################################################################################################
# def and verilog files comes from place and route directory
########################################################################################################################
${PR_DIR}/results/${TOP_MODULE}.def:
	make -C ${PR_DIR} step8_export

########################################################################################################################
# Export design from Virtuoso for DRC or Foundery : TODO
########################################################################################################################
# Should be a full hierarchical design including leaf cells
# no cellmap file
#results/${TOP_MODULE}_full.gds:  work/${TOP_MODULE}_lib work/strmout_template | results
#	cd work &&\
#	${EXEC_KIT_ENV} strmout -templateFile strmout_template &&\
#	mv ${TOP_MODULE}_full.gds ../results
#
## Generate template file for stream out
#work/strmout_template: | work
#	@cd work &&\
#	${TOOLS_DIR}/backend/gen_strmout_template
#

########################################################################################################################
# Interactive targets
########################################################################################################################
# Open Virtuoso in gui mode
gui: work
	@cd $< ; ${EXEC_KIT_ENV} virtuoso


clean:
	@rm -rf work

uclean: clean
	@rm -rf results


