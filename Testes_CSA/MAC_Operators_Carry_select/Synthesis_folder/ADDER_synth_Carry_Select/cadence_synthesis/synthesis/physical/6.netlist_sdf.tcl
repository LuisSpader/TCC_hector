##############################################################
##Export design netlist
## ** ALTERAR ABAIXO **
saveNetlist top.v
##Annotate design delay
extractRC -outfile top.cap
setAnalysisMode -analysisType onChipVariation
clearClockDomains
setClockDomains -all
timeDesign -postRoute -pathReports -drvReports -slackReports -numPaths 50 -prefix contador_postRoute -outDir timingReports
## ** ALTERAR ABAIXO **
write_sdf -ideal_clock_network top.sdf