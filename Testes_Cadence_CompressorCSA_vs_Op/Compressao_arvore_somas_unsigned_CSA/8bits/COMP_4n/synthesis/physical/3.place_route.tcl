#############################################################
##Place pins in left and right margins
editPin -side Top -pinWidth 0.1 -pinDepth 0.52 -layer 3 -spreadType center -spacing 1  -pin { {clk} {bias[15]} {bias[14]} {bias[13]} {bias[12]} {bias[11]} {bias[10]} {bias[9]} {bias[8]} {bias[7]} {bias[6]} {bias[5]} {bias[4]} {bias[3]} {bias[2]} {bias[1]} {bias[0]}  }
 
editPin -side Left -pinWidth 0.1 -pinDepth 0.52 -layer 3 -spreadType center -spacing 1  -pin { {s_mult[47]} {s_mult[46]} {s_mult[45]} {s_mult[44]} {s_mult[43]} {s_mult[42]} {s_mult[41]} {s_mult[40]} {s_mult[39]} {s_mult[38]} {s_mult[37]} {s_mult[36]} {s_mult[35]} {s_mult[34]} {s_mult[33]} {s_mult[32]} {s_mult[31]} {s_mult[30]} {s_mult[29]} {s_mult[28]} {s_mult[27]} {s_mult[26]} {s_mult[25]} {s_mult[24]} {s_mult[23]} {s_mult[22]} {s_mult[21]} {s_mult[20]} {s_mult[19]} {s_mult[18]} {s_mult[17]} {s_mult[16]} {s_mult[15]} {s_mult[14]} {s_mult[13]} {s_mult[12]} {s_mult[11]} {s_mult[10]} {s_mult[9]} {s_mult[8]} {s_mult[7]} {s_mult[6]} {s_mult[5]} {s_mult[4]} {s_mult[3]} {s_mult[2]} {s_mult[1]} {s_mult[0]}  }
editPin -side Right -pinWidth 0.1 -pinDepth 0.52 -layer 3 -spreadType center -spacing 1  -pin { {y[17]} {y[16]} {y[15]} {y[14]} {y[13]} {y[12]} {y[11]} {y[10]} {y[9]} {y[8]} {y[7]} {y[6]} {y[5]} {y[4]} {y[3]} {y[2]} {y[1]} {y[0]}  }

## Add Substrate and NWELL contacts
addWellTap -cell NWSX -prefix XTAP -cellInterval 30 -checkerBoard

##Place the design
setPlaceMode -fp false
placeDesign -prePlaceOpt
setDrawView place

##Initial route of the design
trialRoute -maxRouteLayer 6
