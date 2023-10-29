#############################################################
##Place pins in left and right margins
editPin -side Top -pinWidth 0.1 -pinDepth 0.52 -layer 3 -spreadType center -spacing 1  -pin { {clk} {bias[19]} {bias[18]} {bias[17]} {bias[16]} {bias[15]} {bias[14]} {bias[13]} {bias[12]} {bias[11]} {bias[10]} {bias[9]} {bias[8]} {bias[7]} {bias[6]} {bias[5]} {bias[4]} {bias[3]} {bias[2]} {bias[1]} {bias[0]}  }
 
editPin -side Left -pinWidth 0.1 -pinDepth 0.52 -layer 3 -spreadType center -spacing 1  -pin { {s_mult[139]} {s_mult[138]} {s_mult[137]} {s_mult[136]} {s_mult[135]} {s_mult[134]} {s_mult[133]} {s_mult[132]} {s_mult[131]} {s_mult[130]} {s_mult[129]} {s_mult[128]} {s_mult[127]} {s_mult[126]} {s_mult[125]} {s_mult[124]} {s_mult[123]} {s_mult[122]} {s_mult[121]} {s_mult[120]} {s_mult[119]} {s_mult[118]} {s_mult[117]} {s_mult[116]} {s_mult[115]} {s_mult[114]} {s_mult[113]} {s_mult[112]} {s_mult[111]} {s_mult[110]} {s_mult[109]} {s_mult[108]} {s_mult[107]} {s_mult[106]} {s_mult[105]} {s_mult[104]} {s_mult[103]} {s_mult[102]} {s_mult[101]} {s_mult[100]} {s_mult[99]} {s_mult[98]} {s_mult[97]} {s_mult[96]} {s_mult[95]} {s_mult[94]} {s_mult[93]} {s_mult[92]} {s_mult[91]} {s_mult[90]} {s_mult[89]} {s_mult[88]} {s_mult[87]} {s_mult[86]} {s_mult[85]} {s_mult[84]} {s_mult[83]} {s_mult[82]} {s_mult[81]} {s_mult[80]} {s_mult[79]} {s_mult[78]} {s_mult[77]} {s_mult[76]} {s_mult[75]} {s_mult[74]} {s_mult[73]} {s_mult[72]} {s_mult[71]} {s_mult[70]} {s_mult[69]} {s_mult[68]} {s_mult[67]} {s_mult[66]} {s_mult[65]} {s_mult[64]} {s_mult[63]} {s_mult[62]} {s_mult[61]} {s_mult[60]} {s_mult[59]} {s_mult[58]} {s_mult[57]} {s_mult[56]} {s_mult[55]} {s_mult[54]} {s_mult[53]} {s_mult[52]} {s_mult[51]} {s_mult[50]} {s_mult[49]} {s_mult[48]} {s_mult[47]} {s_mult[46]} {s_mult[45]} {s_mult[44]} {s_mult[43]} {s_mult[42]} {s_mult[41]} {s_mult[40]} {s_mult[39]} {s_mult[38]} {s_mult[37]} {s_mult[36]} {s_mult[35]} {s_mult[34]} {s_mult[33]} {s_mult[32]} {s_mult[31]} {s_mult[30]} {s_mult[29]} {s_mult[28]} {s_mult[27]} {s_mult[26]} {s_mult[25]} {s_mult[24]} {s_mult[23]} {s_mult[22]} {s_mult[21]} {s_mult[20]} {s_mult[19]} {s_mult[18]} {s_mult[17]} {s_mult[16]} {s_mult[15]} {s_mult[14]} {s_mult[13]} {s_mult[12]} {s_mult[11]} {s_mult[10]} {s_mult[9]} {s_mult[8]} {s_mult[7]} {s_mult[6]} {s_mult[5]} {s_mult[4]} {s_mult[3]} {s_mult[2]} {s_mult[1]} {s_mult[0]}  }
editPin -side Right -pinWidth 0.1 -pinDepth 0.52 -layer 3 -spreadType center -spacing 1  -pin { {y[22]} {y[21]} {y[20]} {y[19]} {y[18]} {y[17]} {y[16]} {y[15]} {y[14]} {y[13]} {y[12]} {y[11]} {y[10]} {y[9]} {y[8]} {y[7]} {y[6]} {y[5]} {y[4]} {y[3]} {y[2]} {y[1]} {y[0]}  }

## Add Substrate and NWELL contacts
addWellTap -cell NWSX -prefix XTAP -cellInterval 30 -checkerBoard

##Place the design
setPlaceMode -fp false
placeDesign -prePlaceOpt
setDrawView place

##Initial route of the design
trialRoute -maxRouteLayer 6
