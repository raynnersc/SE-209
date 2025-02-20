# General defs for the design
include ../design_def.make

GENUS=/comelec/softs/bin/genus
export PATH:=$(PATH):/comelec/softs/bin

RTL_SRC  =  $(patsubst %,${SRC_DIR}/%, ${V_PKGS} ${V_FILES})
POST_ELABORATE_VCD_FILE  = ${SIM_PE_DIR}/results/${TOP_MODULE}.vcd
POST_SYN_VCD_FILE  = ${SIM_PSYN_DIR}/results/${TOP_MODULE}.vcd


.PHONY: all syn eval_power clean uclean

all: help

help:
	@echo "RTL synthesis:"
	@echo "make syn        : launch design synthesis"
	@echo "make eval_power : power consumption evaluation using activity from simulation of the synthesized design"

# Attention on crée nom pas un fichier "parasitics" (un pour les résistances, et un pour les capacités)
# Il semble que dans genus on ne puisse faire autrement (en tout cas après une synthèse en mode "spatial")
# Peut être que mode "physical" donne d'autres choses
# Il faudra fusionner les fichiers pour une simulation AMS post synthèse
syn: work/.syn | work
work/.syn:  |  results work reports
	cd work &&\
	$(GENUS) -no_gui -files $(SYN_DIR)/genus.tcl  -log "genus_syn.log genus_syn.cmd"
	touch $@

eval_power:  work/.eval_power | work
work/.eval_power:  ${POST_SYN_VCD_FILE} | results work reports
	cd work &&\
	$(GENUS) -no_gui -files $(SYN_DIR)/genus_eval_power.tcl  -log "genus_eval_power.log genus_eval_power.cmd"
	touch $@

${POST_SYN_VCD_FILE}: work/.syn
	make -C ${SIM_PSYN_DIR} sim

work:
	mkdir -p $@

results:
	mkdir -p $@

reports:
	mkdir -p $@

clean:
	rm -rf work

uclean: clean
	rm -rf results
	rm -rf reports
