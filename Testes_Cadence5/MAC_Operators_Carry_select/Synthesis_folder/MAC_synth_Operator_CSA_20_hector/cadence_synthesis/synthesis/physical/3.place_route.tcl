#############################################################
##Place pins in left and right margins
# -----------------------------------------------------------
set top_ports [get_ports "clk*" -filter {port_direction == in}]
append top_ports [get_ports "rst*" -filter {port_direction == in}]
append top_ports [get_ports -filter {port_direction == in && ![regexp {in}]}]

set left_ports [get_ports -filter {port_direction == in && [regexp {in}] }]

set right_ports [get_ports "*out*" -filter {port_direction == out}]

# set bottom_ports [get_ports "*out*" -filter {port_direction == out}]
# -----------------------------------------------------------
editPin -side Top -pinWidth 0.1 -pinDepth 0.52 -layer 3 -spreadType center -spacing 1  -pin { $top_ports }
editPin -side Left -pinWidth 0.1 -pinDepth 0.52 -layer 3 -spreadType center -spacing 1 -pin { $left_ports }
editPin -side Right -pinWidth 0.1 -pinDepth 0.52 -layer 3 -spreadType center -spacing 1  -pin { $right_ports }

# editPin -side Bottom -pinWidth 0.1 -pinDepth 0.52 -layer 3 -spreadType center -spacing 1  -pin {Bottom}


## Add Substrate and NWELL contacts
addWellTap -cell NWSX -prefix XTAP -cellInterval 30 -checkerBoard

##Place the design
setPlaceMode -fp false
placeDesign -prePlaceOpt
setDrawView place

##Initial route of the design
trialRoute -maxRouteLayer 6
