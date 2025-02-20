# Use bash shell for system commands
SHELL=/bin/bash

# Ou est le simulateur
XRUN = /comelec/softs/bin/xrun

# General defs for the design
include ../design_def.make



# Defines simulator options
SIM_OPTS =  -timescale "1ps/100fs"
SIM_OPTS += +define+PERIOD=${CLK_PERIOD}ps

# Defines DESIGN options
SIM_OPTS += +define+UNROLL_FCTR=$(UNROLL_FCTR)

# Defines TOP_MODULE for log purposes
SIM_OPTS += +define+TOP_MODULE=$(TOP_MODULE)

# Choose where are the reference gate libraries
SIM_OPTS  += $(REF_IRUN_LIBS)

# Suppress systematic warning on the SystemVerilog version used...
SIM_OPTS += -disable_sem2009

# Prepare full access to the waveforms for simVision tools
SIM_OPTS += -access +rw

# Defines the top level module of the simulation
SIM_OPTS += -top present_tb

# Define probes
SIM_OPTS += -input ../probe.tcl


# Sources for the testbench
TB_SRC   = $(patsubst %,${SRC_DIR}/%, ${SV_PKGS}) $(patsubst %,${TB_DIR}/%, ${TB_FILES})

# Sources for the module
RTL_SRC   = $(patsubst %,${SRC_DIR}/%, ${SV_FILES})

SIM_SRC = $(TB_SRC) $(RTL_SRC)

sim: .sim

sim: SIM_OPTS += -input ../run.tcl

.sim: $(SIM_SRC) |work results
	cd work && $(XRUN) $(SIM_OPTS) $(SIM_SRC)
	touch .sim

sim_gui: |work results
	cd work && $(XRUN) -gui $(SIM_OPTS) $(SIM_SRC)

results:
	mkdir $@

work:
	mkdir -p $@

clean:
	@rm -rf work
	@rm -f .sim

uclean: clean
	@rm -rf results

