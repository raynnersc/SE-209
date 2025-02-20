.PHONY: build sim clean

build: | work
	vlog +acc -f filelist

sim:
	vsim testbench -do wave.do

work:
	vlib $@

clean:
	rm -fr work
	rm -f transcript
	rm -f *.wlf
