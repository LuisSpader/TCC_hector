# set rtl_files [glob -nocomplain $env(RTL_DIR)/.*.v]
# set folders [glob -nocomplain -directory $MY_SCRIPT_PATH -type d MAC_synth* ]
# set folders [glob -nocomplain -directory $MY_SCRIPT_PATH -type d MAC_synth* ]
# set folders [exec find "$MY_SCRIPT_PATH" -type d -name 'MAC_synth_Spiral_Comp_4' -print | grep -v '/\.']
# exec find "$MY_SCRIPT_PATH" -type d -name '*MAC_synth*' -print | grep -v '/\.'
# exec find "$MY_SCRIPT_PATH/" -name "*.cmd*"
# puts $folders


set MY_SCRIPT_PATH ./
set pattern "MAC_synth*"
set folders [list]

foreach file [glob -directory $MY_SCRIPT_PATH -tails $pattern] {
    set full_path [file join $MY_SCRIPT_PATH $file]
    if {[file isdirectory $full_path]} {
        lappend folders $full_path
    }
}
