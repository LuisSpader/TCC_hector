
#===============================================================================
## load synthesis configuration
#===============================================================================

set_attribute script_search_path ./ /
set_attribute init_lib_search_path {. /usr/eda/dk/ibm/cmrf7sf/digital_20111130/lef/ /usr/eda/dk/ibm/cmrf7sf/digital_20111130/synopsys/nom/} /
set_attribute init_hdl_search_path ../rtl /
set_attribute information_level 5 /
set_attribute max_cpus_per_server 4 /
set_attribute use_scan_seqs_for_non_dft false /

#===============================================================================
#  Load libraries
#===============================================================================
set_attribute library {PnomV180T025_STD_CELL_7RF.lib} /

set_attribute lef_library {cmos7rf_6ML_tech.lef ibm_cmos7rf_sc_12Track.lef } /

#===============================================================================
#  Elaborate -> declaramos os arquivos '.vhd' abaixo (arquivo principal no final)
#todo:  **ALTERAR ABAIXO**
#===============================================================================

read_hdl -vhdl top.vhd
elaborate top

#===============================================================================
#todo:  Read constraints **ALTERAR ABAIXO**
#===============================================================================
read_sdc ../constraint/top.sdc

#===============================================================================
#  Synthesize
#===============================================================================
syn_generic
puts "Runtime & Memory after 'syn_generic'"
time_info GENERIC
syn_map
puts "Runtime & Memory after 'syn_map'"
time_info MAPPED
syn_opt
puts "Runtime & Memory after syn_opt"
time_info INCREMENTAL

#===============================================================================
#todo:  Build physical synthesis environment **ALTERAR ABAIXO: layout/top**
#===============================================================================
write_design -innovus -basename layout/top



puts "# ---------------------- report area ----------------------------- "
report area
# puts [exec report area]

puts "# ---------------------- report power ---------------------------- "
report power
# # puts [exec report power]

puts "# ----------------------- report timing -------------------------- "
report timing
# puts [exec report timing]

exit

# # ---
# set outputFile [open "synthesis_log.txt" a]

# puts $outputFile "# ------- report area ------- "
# report area
# puts $outputFile [exec report area]

# puts $outputFile "# ------- report power ------- "
# report power
# puts $outputFile [exec report power]

# puts $outputFile "# ------- report timing ------- "
# report timing
# puts $outputFile [exec report timing]

# close $outputFile


# # ---
# set outputFile [open "synthesis_log.txt" a]

# # printing on terminal
# puts "# ------- report area ------- "
# puts [exec report area]
# puts $outputFile "# ------- report area ------- "
# puts $outputFile [exec report area]

# puts "# ------- report power ------- "
# puts [exec report power]
# puts $outputFile "# ------- report power ------- "
# puts $outputFile [exec report power]

# puts "# ------- report timing ------- "
# puts [exec report timing]
# puts $outputFile "# ------- report timing ------- "
# puts $outputFile [exec report timing]

# close $outputFile
#   (verificar no reporte anterior se o circuito consegue operar na frequência de relógio especificada, ou seja, se o “slack time” é um número positivo)
