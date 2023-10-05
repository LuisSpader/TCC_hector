################################################################################
#
# Innovus setup file
# Created by Genus(TM) Synthesis Solution 21.17-s066_1
#   on 10/05/2023 16:40:30
#
################################################################################
#
# Genus(TM) Synthesis Solution setup file
# This file can only be run in Innovus Legacy UI mode.
#
################################################################################


# Version Check
###########################################################

      namespace eval ::genus_innovus_version_check { 
        set minimum_version 21
        set maximum_version 22
        regexp {\d\d} [get_db program_version] this_version
        Puts "Checking Innovus major version against Genus expectations ..."
        if { $this_version < $minimum_version || $this_version > $maximum_version } {
          error "**ERROR: this operation requires Innovus major version to be between '$minimum_version' and '$maximum_version'."
        }
      }
    
set _t0 [clock seconds]
Puts [format  {%%%s Begin Genus to Innovus Setup (%s)} \# [clock format $_t0 -format {%m/%d %H:%M:%S}]]
set allowMultiplePortPinWithoutMustjoin 1
set mustjoinallports_is_one_pin true
setLibraryUnit -cap 1pf -time 1ns


# Design Import
################################################################################
source -quiet /usr/eda/cadence/genus2117/tools.lnx86/lib/cdn/rc/edi/innovus_procs.tcl
## Reading FlowKit settings file
source layout/top.flowkit_settings.tcl

source layout/top.globals
init_design

# Reading metrics file
################################################################################
read_metric -id current layout/top.metrics.json
## Reading Innovus Mode attributes file
pqos_eval {rcp::read_taf layout/top.mode_attributes.taf.gz}


# Mode Setup
################################################################################
source layout/top.mode


# MSV Setup
################################################################################

# Reading write_name_mapping file
################################################################################

      if { [is_attribute -obj_type port original_name] &&
           [is_attribute -obj_type pin original_name] &&
           [is_attribute -obj_type pin is_phase_inverted]} {
        source layout/top.wnm_attrs.tcl
      }
    

# Reading NDR file
source layout/top.ndr.tcl

# Reading Instance Attributes file
pqos_eval { rcp::read_taf layout/top.inst_attributes.taf.gz}

# Reading minimum routing layer data file
################################################################################
pqos_eval {rcp::load_min_layer_file layout/top.min_layer {M1 M2 M3 M4 MT ML} {1 2 3 4 5 6}}
eval {set edi_pe::pegConsiderMacroLayersUnblocked 1}
eval {set edi_pe::pegPreRouteWireWidthBasedDensityCalModel 1}

      set _t1 [clock seconds]
      Puts [format  {%%%s End Genus to Innovus Setup (%s, real=%s)} \# [clock format $_t1 -format {%m/%d %H:%M:%S}] [clock format [expr {28800 + $_t1 - $_t0}] -format {%H:%M:%S}]]
    


# The following is partial list of suggested prototyping commands.
# These commands are provided for reference only.
# Please consult the Innovus documentation for more information.
#   Placement...
#     ecoPlace                     ;# legalizes placement including placing any cells that may not be placed
#     - or -
#     placeDesign -incremental     ;# adjusts existing placement
#     - or -
#     placeDesign                  ;# performs detailed placement discarding any existing placement
#   Optimization & Timing...
#     optDesign -preCTS            ;# performs trial route and optimization
#     timeDesign -preCTS           ;# performs timing analysis

