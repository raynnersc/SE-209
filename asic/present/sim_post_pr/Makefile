# Use bash shell for system commands
SHELL=/bin/bash

# General defs for the design
include ../design_def.make

## Get results from the synthesis phase
NETLIST_FILE = $(PR_DIR)/results/${TOP_MODULE}.v 
SDF_FILE  =   ${PR_DIR}/results/${TOP_MODULE}.sdf

# Defines simulator options
SIM_OPTS =  -timescale "1ps/100fs"
SIM_OPTS += +define+PERIOD=${CLK_PERIOD}ps
SIM_OPTS += +define+DUMP_VCD

# Choose where are the reference gate libraries
SIM_OPTS  += $(REF_IRUN_LIBS)

# Suppress systematic warning on the SystemVerilog version used...
SIM_OPTS += -disable_sem2009

# Prepare full access to the waveforms for simVision tools
SIM_OPTS += -access +rw

# Defines the top level module of the simulation
SIM_OPTS += -top ${TB_MODULE}

# Define probes
SIM_OPTS += -input ../probe.tcl

# Add timing retroannotation for digital sim
SIM_OPTS += -sdf_cmd_file ../sdf.cmd -maxdelays


# Sources for the testbench
TB_SRC   = $(patsubst %,${SRC_DIR}/%, ${SV_PKGS}) $(patsubst %,${TB_DIR}/%, ${TB_FILES})

# Sources for the module
RTL_SRC   = $(NETLIST_FILE)

SIM_SRC = $(TB_SRC) $(RTL_SRC)



sim: .sim

sim: SIM_OPTS += -input ../run.tcl

.sim: $(SIM_SRC) work/sdf.X |work results
	cd work && irun $(SIM_OPTS) $(SIM_SRC) 
	touch .sim

sim_gui: |work results
	cd work && irun -gui $(SIM_OPTS) $(SIM_SRC)

${NETLIST_FILE}:
	make -C ${PR_DIR} step8_export

# The sdf compiled retroannotaion file
work/sdf.X: ${SDF_FILE} | work
	xmsdfc $< -output $@

results:
	mkdir $@

work:
	mkdir -p $@

clean:
	@rm -rf work
	@rm -f .sim
	@rm -f *.log

uclean: clean
	@rm -rf results

