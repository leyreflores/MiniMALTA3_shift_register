set sdc_version 1.3

## Define units to pico Farads and nanoseconds
set_units -capacitance pF
set_units -time 1ns

## The given constraints are the baseline clock definitions (from the sync memory design), together with some basic load/fanout constraints.

########################################
# Clock definitions
########################################


create_clock -period 100.0 -waveform {0 50} -name Clk  [get_db ports *SR_IN*Clk*]

set_clock_uncertainty -hold 0.3 [all_clocks]
set_clock_uncertainty -setup 0.3 [all_clocks]


########################################
# Output constraints
########################################

set_load 0.2 [all_outputs]

