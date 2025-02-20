## General defs for the design
include ../design_def.make

export PATH := $(PATH):/comelec/softs/bin

# Uses stylus mode for commands
INNOVUS_OPTIONS  = -stylus -overwrite -no_logv

.PHONY: all step1_init step2_floorplan step3_place step4_cts step5_route step6_timing step7_power step8_export gui clean uclean

all: help
step8_export: work/.step8_export.ok
step7_power: work/.step7_power.ok
step6_timing: work/.step6_timing.ok
step5_route: work/.step5_route.ok
step4_cts: work/.step4_cts.ok
step3_place: work/.step3_place.ok
step2_floorplan: work/.step2_floorplan.ok
step1_init: work/.step1_init.ok


help:
	@echo "Place & Route command, can be launch step by step or in one command"
	@echo "  make step1_init      : 1/ initialization of libs, design and  tools"
	@echo "  make step2_floorplan : 2/ floorplan (defines geometry, power routing, bloackages, body ties)"
	@echo "  make step3_place     : 3/ Placement of standard cells"
	@echo "  make step4_cts       : 4/ Clock trees synthesis (buffers + rounting)"
	@echo "  make step5_route     : 5/ GLobal/detail route of signals"
	@echo "  make step6_timing    : 6/ Timing analysis + verilog and sdf extraction for postroute simulation"
	@echo "  make step7_power     : 7/ Power analysis based on postroute simulation"
	@echo "  make step8_export    : 8/ Several exports (GDSII, def,lef) for postprocessing or hieararchical placement"

work/.step8_export.ok: work/.step7_power.ok step8_export.tcl
	cd work &&\
	innovus $(INNOVUS_OPTIONS) -init ${PR_DIR}/step8_export.tcl -log step8_export

work/.step7_power.ok: work/.step6_timing.ok step7_power.tcl
	make -C ${SIM_PPR_DIR} sim
	cd work &&\
	innovus $(INNOVUS_OPTIONS) -init ${PR_DIR}/step7_power.tcl -log step7_power

work/.step6_timing.ok: work/.step5_route.ok step6_timing.tcl
	cd work &&\
    innovus $(INNOVUS_OPTIONS) -init ${PR_DIR}/step6_timing.tcl -log step6_timing

work/.step5_route.ok: work/.step4_cts.ok step5_route.tcl
	cd work &&\
    innovus $(INNOVUS_OPTIONS) -init ${PR_DIR}/step5_route.tcl -log step5_route

work/.step4_cts.ok: work/.step3_place.ok step4_cts.tcl
	cd work &&\
	innovus $(INNOVUS_OPTIONS) -init ${PR_DIR}/step4_cts.tcl -log step4_cts

work/.step3_place.ok: work/.step2_floorplan.ok step3_place.tcl
	cd work &&\
    innovus $(INNOVUS_OPTIONS) -init ${PR_DIR}/step3_place.tcl -log step3_place

work/.step2_floorplan.ok: work/.step1_init.ok step2_floorplan.tcl 
	cd work &&\
    innovus $(INNOVUS_OPTIONS) -init ${PR_DIR}/step2_floorplan.tcl -log step2_floorplan

work/.step1_init.ok: ${PRJ_DIR}/syn/work/.eval_power step1_init.tcl |work results
	cd work &&\
	innovus $(INNOVUS_OPTIONS) -init ${PR_DIR}/step1_init.tcl -log step1_init

${PRJ_DIR}/syn/work/.eval_power:
	make -C ${SYN_DIR} eval_power

gui_explore: INNOVUS_OPTIONS+=-win
gui_explore:
	cd work &&\
	innovus  $(INNOVUS_OPTIONS) -init ${PR_DIR}/step_gui.tcl


work:
	mkdir -p work

results:
	mkdir -p results

clean:
	rm -rf work

uclean: clean
	rm -rf results
