#############################################################
##Place pins in left and right margins
editPin -side Top -pinWidth 0.1 -pinDepth 0.52 -layer 3 -spreadType center -spacing 1  -pin { {clk} {bias[7]} {bias[6]} {bias[5]} {bias[4]} {bias[3]} {bias[2]} {bias[1]} {bias[0]}  }
 
editPin -side Left -pinWidth 0.1 -pinDepth 0.52 -layer 3 -spreadType center -spacing 1  -pin { {s_mult[23]} {s_mult[22]} {s_mult[21]} {s_mult[20]} {s_mult[19]} {s_mult[18]} {s_mult[17]} {s_mult[16]} {s_mult[15]} {s_mult[14]} {s_mult[13]} {s_mult[12]} {s_mult[11]} {s_mult[10]} {s_mult[9]} {s_mult[8]} {s_mult[7]} {s_mult[6]} {s_mult[5]} {s_mult[4]} {s_mult[3]} {s_mult[2]} {s_mult[1]} {s_mult[0]}  }
editPin -side Right -pinWidth 0.1 -pinDepth 0.52 -layer 3 -spreadType center -spacing 1  -pin { {y[10]} {y[9]} {y[8]} {y[7]} {y[6]} {y[5]} {y[4]} {y[3]} {y[2]} {y[1]} {y[0]}  }

## Add Substrate and NWELL contacts
addWellTap -cell NWSX -prefix XTAP -cellInterval 30 -checkerBoard

##Place the design
setPlaceMode -fp false
placeDesign -prePlaceOpt
setDrawView place

##Initial route of the design
trialRoute -maxRouteLayer 6
