set path [pwd]
puts $path

# file delete -force {*}[glob /path/to/folder/*.log*]

# exec rm -rf $path/rtl/*
# exec rm -rf $path/sim/tb/*
proc delete_files {path} {
    set files [glob -nocomplain -directory $path -types f *]
    if {[llength $files] > 0} {
        file delete -force {*}$files
    } else {
        puts "No files found in the 'rtl' folder."
    }
}


# file delete -force {*}[glob -nocomplain -directory $path/rtl/ -types f *]
# file delete -force {*}[glob -nocomplain -directory $path/sim/tb/ -types f *]

# delete_files $path/rtl/
# delete_files $path/sim/tb/

# exec rm -rf $path/RTL_list.txt
# file delete $path/RTL_list.txt
# file delete $path/synthesis/synthesis_log.txt

# exec rm -rf $path/synthesis/fv
# exec rm -rf $path/synthesis/layout
file delete -force $path/synthesis/fv
file delete -force $path/synthesis/layout


exec find "$path/" -name "*.cmd*" -type f -delete
exec find "$path/" -name "*.log*" -type f -delete
exec find "$path/" -name "*tstamp*" -type f -delete
# exec find "$path/" -name "*synthesis_log.txt" -type f -delete
# exec find "$path/" -name "clean_synthesis.tcl" -type f -delete

# file delete -force {*}[glob -nocomplain -types f -tails -path $path *.log*]
# file delete -force {*}[glob -nocomplain -types f -tails -path $path *.cmd*]
# file delete -force {*}[glob -nocomplain -types f -tails -path $path *.tstamp*]
