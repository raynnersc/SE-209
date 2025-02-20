onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/reset_n
add wave -noupdate -divider avalon
add wave -noupdate /testbench/avs_*
add wave -noupdate -divider ios
add wave -noupdate /testbench/pio_i
add wave -noupdate /testbench/pio_o
add wave -noupdate -divider irq
add wave -noupdate /testbench/irq
add wave -noupdate -divider __DUT__
add wave -noupdate /testbench/dut/*
add wave -noupdate /testbench/dut/irq_reg
