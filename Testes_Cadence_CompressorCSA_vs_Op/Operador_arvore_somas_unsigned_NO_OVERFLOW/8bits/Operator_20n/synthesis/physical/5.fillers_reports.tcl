
##############################################################
##Add filler cells
getFillerMode -quiet
addFiller -cell NWSX -prefix XTAP
addFiller -cell FILL2 -prefix FILLER
addFiller -cell FILL1 -prefix FILLER
##Generate reports
summaryReport -outdir summaryReport
