
##############################################################
##Loading std cell libs / netlist / constraints / setting vdd/gnd
#loadConfig layout/gcd.conf 0
#setUIVar rda_Input ui_gndnet gnd
#setUIVar rda_Input ui_pwrnet vdd
#commitConfig

set init_pwr_net {vdd}
set init_gnd_net {gnd}

## ** ALTERAR ABAIXO **
source layout/top.invs_setup.tcl

##Generating floorplan (Height is 0.5 times the width) with 70% of density (0.8) with 6um margins
floorPlan -r 0.5 0.7 6 6 6 6
##fit screen
fit
