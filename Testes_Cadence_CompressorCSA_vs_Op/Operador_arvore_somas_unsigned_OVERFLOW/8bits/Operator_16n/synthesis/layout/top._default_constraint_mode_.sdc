# ####################################################################

#  Created by Genus(TM) Synthesis Solution 16.24-s065_1 on Mon Jun 12 19:48:15 -0300 2023

# ####################################################################

set sdc_version 1.7

set_units -capacitance 1000.0fF
set_units -time 1000.0ps

# Set the current design
current_design top

set_clock_gating_check -setup 0.0 
