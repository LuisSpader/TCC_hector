#
##############################################################
##Generate / connect global nets (VDD/GND)
clearGlobalNets
globalNetConnect vdd -type pgpin -pin VDD! -inst *
globalNetConnect gnd -type pgpin -pin GND! -inst *
#globalNetConnect vdd -type tiehi -inst *
#globalNetConnect gnd -type tielo -inst *
##Generate power ring with 1um spacing (between metal lines), 2um width and 1um offset from the core. Use M1 for horizontal and M2 for vertical

addRing -stacked_via_top_layer M6 -nets {gnd vdd} -around each_block -stacked_via_bottom_layer M1 -layer {bottom M1 top M1 right M2 left M2} -width 2 -spacing 1 -offset 1
 

##Route power rails using M1
sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { M1 M6 } -blockPinTarget { nearestRingStripe nearestTarget } -padPinPortConnect { allPort oneGeom } -checkAlignedSecondaryPin 1 -blockPin useLef -allowJogging 1 -crossoverViaBottomLayer M1 -allowLayerChange 1 -targetViaTopLayer M6 -crossoverViaTopLayer M6 -targetViaBottomLayer M1 -nets { gnd vdd }


