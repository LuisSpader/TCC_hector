
# * Synthesis Script, to run it:
# source /usr/eda/scripts/setup.digital
# with GUI
#$ genus -gui -legacy_ui -f sintese.tcl -log {genus.syn.log genus.basic.cmd}
#$ genus -gui -legacy_ui -f sintese.tcl

# without GUI
#$ genus -f sintese.tcl -log {genus.syn.log genus.basic.cmd}
#$ genus -f sintese.tcl

#===============================================================================
## load synthesis configuration
#===============================================================================
source ./utils.tcl
set init_hdl_search_path "../rtl"

# set_db init_hdl_search_path <path> /
#* ================= Setting paths =================='
set_attribute script_search_path ./ /
set_attribute init_lib_search_path {. /usr/eda/dk/ibm/cmrf7sf/digital_20111130/lef/ /usr/eda/dk/ibm/cmrf7sf/digital_20111130/synopsys/nom/} /
set_attribute init_hdl_search_path ../rtl /

#* ================= Setting configurations ==================
set_attribute information_level 5 /
set_attribute max_cpus_per_server 4 /
set_attribute use_scan_seqs_for_non_dft false /

#* ================= Setting effort levels ==================
# set_db syn_generic_effort <low|medium|high|express> /
# set_db syn_map_effort <low|medium|high|express> /
# set_db syn_opt_effort <none|low|medium|high|express> /
# set_db syn_global_effort <none|low|medium|high|express> /

#' default effort level
# syn_generic_effort: medium
# syn_map_effort: high
# syn_opt_effort: high
# syn_global_effort: none
# express: enables early feasibility analysis with much faster runtimes and reasonable quality of results (QoR)

#* ================= Setting other parameters ==================
#$ set_db auto_ungroup <both|none>
# set_db auto_ungroup none

# To prevent ungrouping of all instances of a module, set the ungroup_ok attribute for the module to false:
#$ set_db [get_db design:design .modules *name] .ungroup_ok false

# To prevent ungrouping of a specific instance, set the ungroup_ok attribute for the instance to false:
#$ set_db [get_db design:design .insts *name] .ungroup_ok false

# Partitioning is the process of disassembling (partitioning) designs into more manageable block sizes. This enables faster run-times and an improved memory footprint without sacrificing the accuracy of synthesis results. To enable partitioning, set the auto_partition attribute to true before synthesis:
#$ set_db auto_partition true

# By default, Genus optimizes Worst Negative Slack (WNS) to achieve the timing requirements. During this process, it tries to fix the timing on the most critical path. It also checks the timing on all the other paths. However, Genus will not work on the other paths if it cannot improve
# timing on the WNS.
# ➤ To make Genus work on all the paths to reduce the total negative slack (TNS), instead of just WNS, type the following command:
#$ set_db tns_opto true


# set_db design:top .retime true

#* ================= Setting DFT ==================
# Set the DFT scan flip-flop style for scan replacement using the following command:
# set_db dft_scan_style muxed_scan

# Adding a prefix to the name of he DFT logic that is inserted into the design:
#$ set_db dft_prefix <prefix>
# set_db dft_prefix dft_

# Define the test signals that are used to control the DFT logic:
#$ define_shift_enable -name {scan_en} -active {high} -create_port {scan_en}
# define_shift_enable -name SE -active high -create_port SE

# check_dft_rules

#===============================================================================
#  Load libraries
#===============================================================================
set_attribute library {PnomV180T025_STD_CELL_7RF.lib} /
# read_libs {PnomV180T025_STD_CELL_7RF.lib}

set_attribute lef_library {cmos7rf_6ML_tech.lef ibm_cmos7rf_sc_12Track.lef } /

#===============================================================================
#  Elaborate -> declaramos os arquivos '.vhd' abaixo (arquivo principal no final)
#  **ALTERAR ABAIXO**
#===============================================================================
read_hdl -vhdl top.vhd
# read_hdl -verilog top.vhd
# read_HDL_files "../" "RTL_list.txt"
elaborate top

# check unresolved references and empty modules
check_design -unresolved

#===============================================================================
#  Read constraints **ALTERAR ABAIXO**
#===============================================================================
read_sdc ../constraint/top.sdc
puts "$::dc::sdc_failed_commands > failed.sdc"
# [-stop_on_errors]
# [-view <analysis_view>]
# [-no_compress]

# check constraints consistency
check_timing_intent -verbose

#===============================================================================
#  Synthesize: normal flow
#===============================================================================
# Generic gate optimization
# syn_generic <-physical>
syn_generic
puts "Runtime & Memory after 'syn_generic'"
time_info GENERIC

# Technology Transformation (Mapping): maps the specified design(s) to the cells described in the supplied technology library and performs logic optimization.
# syn_map <-physical>
syn_map
puts "Runtime & Memory after 'syn_map'"
time_info MAPPED

# Incremental Optimization: synthesizes to potimized gates
# syn_optyn_map <-spatial> <-incr> :
#
syn_opt
puts "Runtime & Memory after syn_opt"
time_info INCREMENTAL

# <-physical> <-spatial> : it takes physical domain into consideration, runs placement and performs physical optimization (requires Genus-Physical License option).


#===============================================================================
#  Reporting
#===============================================================================

puts "# ---------------------- report area ----------------------------- "
report area

puts "# ---------------------- report power ---------------------------- "
report power

puts "# ----------------------- report timing -------------------------- "
report timing


# report_area: prints an exhaustive hierarchical area report
# ? report_dp: prints a datapath resources report (to be done bbefore syn_map)
# report_design_rules: print design rule violations

# puts "# ---------------------- report gates ----------------------------- "
# report_gates:report libcells used, total area, and instance count summary
# report_gates

# puts "# -------------------- report_hierarchy --------------------------- "
# report_hierarchy: prints a hierarchy report
# report_hierarchy

# report_instance: generates a report on the specified instance
# report_memory: prints memory usage report
#' report_messages: prints a summary of the error messages that have been issued
# report_power: prints a power report
# report_qor: prints a QoR report
# report_timing: prints a timing report
# report_summary: prints an area, timing, and design rules report
# report_summary

# puts "######################################################## "
# puts " ################ Hierarquical Reports ################# "
# puts "# -------------------- report_area -physical
# --------------------------- "
# report_area -physical

# puts "# -------------------- report_timing -physical
# --------------------------- "
# report_timing -physical

# puts "# -------------------- report_power -physical
# --------------------------- "
# report_power -physical

# puts "######################################################## "

#===============================================================================
#  Build physical synthesis environment **ALTERAR ABAIXO: layout/top**
#===============================================================================
write_design -innovus -basename layout/top

# ? write_hdl > basic.syn.v
# write_hdl > basic.syn.v

# write_db [-design <design>] <db_file>: Write the design to a database file
# write_db <db_file> -all_root_attributes -no_root_attrinutes -script_file -design <design> -quiet -verbose
#' Why and when is used: to reload the design into the Genus tool
#$ write_db -design top design.db

# write_netlist > <filename>: generate a Gate-level netlist to a file
# write_netlist > <filename>: prints the Gate-level netlist on Genus console
#* Why and when is used: used in Innovus tool (physical synthesis)
# $ write_netlist > netlist.v
#write_netlist > netlist.v

# write_script: generates a Genus constraints file
#' Why and when is used: use it when reloading the constraints back into Genus for further optimization (optimize the Genus results)
#$ write_script > constraints.g

# write_sdc [design] > [filename]: generates SDC constraints file
#* Why and when is used: used in Innovus tool (physical synthesis)
#$ write_sdc top > test.sdc

#? write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > outputs/delays.sdf
# -timescale : mentions the time unit
# -nonegchecks: ignores negative timing checks
# -recrem: splits out the recovery-removal timing check to separate checks for recovery and removal
# -edges: specifies the edge values
# -setuphold: keeps edge specifiers on timing check arcs but does not add edge specifiers on combinational arcs

#===============================================================================
#  Incremental Synthesis: DFT flow
#===============================================================================
#* ================= Setting DFT ==================
# check_dft_rules

#? Specify the number of scan chains required to connect all FFs in the design
# set_db design:top .dft_min_number_of_scan_chains 1

#? Specify the scan-in and scan-out ports of the scan chain
# define_scan_chain -name top_chain -sdi scan_in -sdo scan_out -create_ports

#? Connect the scan chains using the connect_scan_chains command. This will include all original FFs that were mapped to scan flops.
# connect_scan_chains -auto_create_chains

#? Run incremental synthesis
# syn_opt -incr

#? View the DFT chains
# report_scan_chains

#? Write out the final netlist
# write_hdl > outputs/top_netlist_dft.v

#? Write out the final SDF
# write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > outputs/dft_delays.sdf

# Write out the final constraints (.sdc)
# write_sdc > outputs/top_dft.sdc

# # Write out the final ScanDEF
# write_scandef > outputs/top_scanDEF.scandef

# Run the final ATPG analysis and vector generation. This step will take the final scan chains and run through the basic ATPG flow (it will generate a directoru named 'test_scripts' in the current working location).
# write_dft_atpg -library ../lib/slow_vdd1v0_basiccells.v

# on 'test_scripts' directory, will be the following files generated by Genus:
# top.test_netlist.v (completed Verilog netlist used for ATPG tool)
# runmodus.atpg.tcl (ATPG script)
# top.FULLSCAN.pinassign (file specifying I/O test behavior)
# run_fullscan_sim_sdf (file for running 'Back Annotated Simulations' or 'Non zero delay simulations')
# run_fullscan_sim (file for running 'Zero delay simulations')

exit
