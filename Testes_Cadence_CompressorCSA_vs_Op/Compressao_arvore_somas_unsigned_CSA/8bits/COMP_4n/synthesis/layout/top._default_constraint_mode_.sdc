# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.17-s066_1 on Sun Oct 29 21:37:06 -03 2023

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design top

set_clock_gating_check -setup 0.0 
