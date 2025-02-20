# Choos coherent time and load units
set_time_unit -picoseconds
set_load_unit -femtofarads

create_clock -period $CLK_PERIOD -name "main_clock" [get_ports clk]
set_clock_skew $CLK_SKEW [ get_clocks main_clock ]


# Les signaux de données arrivent au pire max_input_delay après le front d'horloge
# On suppose qu'ils arrivent aux 3/5 de la période d'horloge
# Cela oblige a limiter la logique avant les premières bascules
set max_input_delay [expr 3*$CLK_PERIOD/5.0]
set_input_delay -max $max_input_delay -clock main_clock [get_ports plaintext*]
set_input_delay -max $max_input_delay -clock main_clock [get_ports key*]
set_input_delay -max $max_input_delay -clock main_clock [get_ports nrst]
set_input_delay -max $max_input_delay -clock main_clock [get_ports start]

# Les signaux arrivent au mieux min_input_delay après le front d'horloge
# On suppose qu'ils arrivent 200ps  après le front d'horloge
# Cela facilite la gestion du thold...
set min_input_delay 200
set_input_delay -min $max_input_delay -clock main_clock [get_ports plaintext*]
set_input_delay -min $max_input_delay -clock main_clock [get_ports key*]
set_input_delay -min $max_input_delay -clock main_clock [get_ports nrst]
set_input_delay -min $max_input_delay -clock main_clock [get_ports start]

# Tsetup d'une hypothétique bascule D extérieure au circuit
# On ne permet pas au signal de sortie d'arriver tardivememnt :
# 2/5 de la période d'horloge.
set max_output_delay [expr 3*$CLK_PERIOD/5.0]
set_output_delay -max $max_output_delay -clock main_clock [get_ports ciphertext*]
set_output_delay -max $max_output_delay -clock main_clock [get_ports eoc]
# Thold d'une hypothétique bascule D connectée sur une sortie du circuit 200ps
set min_output_delay 200
set_output_delay -min $min_output_delay -clock main_clock [get_ports ciphertext*]
set_output_delay -min $min_output_delay -clock main_clock [get_ports eoc]

# Relax constraints for the key (only data should have max speed
# set_multicycle_path -setup 100 -from [get_cells Kreg*] -to [get_cells DregOut*] -comment "my multicycle path"

# ___
# \!/Check if this is coherent with your design
# for gsclib045, IVX4 input capacitance is 2fF
#                     output max load is   96fF
# Limit input capacitance to 2fF
set_max_capacitance 2 [all_inputs]

# Limit input capacitance for clock signal
# Bigger in order to avoid unwanted buffering
set_max_capacitance 4 [get_ports clk]

# Limit output capacitance 5fF (10 xivx4)
set_load            10 [all_outputs]

# Defines transition for all input signals
# Identique a celle des portes sauf pour
# l'horloge
set_input_transition  512 [all_inputs]
set_input_transition  512 [get_ports plaintext*]
set_input_transition  512 [get_ports key*]
set_input_transition  512 [get_ports nrst]
set_input_transition  512 [get_ports start]
# Cas particulier de l'horloge
set_input_transition  80 [get_ports clk]

