#!/usr/bin/python
# Compute initial values for electrical simulation from initial values from a digital simulation VCD dump file.
# Net names me be patched using argument 3 and 4
# argument 1 : the name of the vcd dump file
# argument 2 : the value of the VDD power supply
# argument 3 : part of the signal names to be replaced
# argument 4 : replacement string for the signal names
# Example:
#   vcd2ic waves.vcd 1.1 .dut. .dut.dut_phys.

from Verilog_VCD import *
import sys

vcdfile = str(sys.argv[1]) 
valim = str(sys.argv[2])
oldstr = str(sys.argv[3])
newstr = str(sys.argv[4])

vcd = parse_vcd(vcdfile)
sigs = []
for k in vcd.keys():
    v = vcd[k]
    nets = v['nets']
    tv = v['tv']
    net = nets[0]['hier']+'.'+nets[0]['name']
    net = net.replace(oldstr,newstr,1)
    (time,value) = tv[0]
    if value == '0':
        print net + " " + "0.0"
    else:
        if value == '1':
          print net + " " + valim



