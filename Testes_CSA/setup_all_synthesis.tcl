
set MY_SCRIPT_PATH [pwd]
puts "MY_SCRIPT_PATH $MY_SCRIPT_PATH"

# Find directories matching the pattern 'MAC_synth*'
# set folders exec $(find "$MY_SCRIPT_PATH" -type d -name 'MAC_synth*' -print | grep -v '/\.' )
# set folders [glob -directory "./" -type d  *]
# set folders [glob -type d -directory $MY_SCRIPT_PATH *MAC_synth*]

set folders [glob -directory $MY_SCRIPT_PATH -type d -nocomplain {*}[glob -nocomplain -directory $MY_SCRIPT_PATH MAC_synth*]]
puts "folders $folders"
set filtered_folders {}

foreach folder $folders {
    if {![string match {*/.*} $folder] && [file isdirectory $folder]} {
        lappend filtered_folders $folder
    }
}

# Now the list "filtered_folders" contains the directories that match 'MAC_synth*' pattern and do not start with a dot.


# # Filter out directories containing "/."
# set filtered_folders [lsearch -all -inline $folders -not -regexp {/\.}]

foreach folder $filtered_folders {
    puts "folder $folder"
}
# puts "folders $folders"
# Now the 'filtered_folders' variable contains the list of directories without '/.'

puts " ================= Copying 'cadence_synthesis' folder to all folders starting with NN ================= "
foreach folder $filtered_folders {

    # check if first and second letters are HIGHER case
    # if {[regexp {^[./A-Z_]+$} $folder]} {
    puts "--------------"
    set path [pwd]
    puts "path $path"
    cd $folder
    # puts "folder $folder"
    # set normal_pipe [glob -directory "./" -type d  *]
    # puts "normal_pipe $normal_pipe"

    # foreach dir $normal_pipe {

    # cd $dir
    # puts "dir $dir"

    # gets all folders starting with NN
    # set FOLDERS [glob -directory "./" MAC_synth*]
    # puts $FOLDERS
    # foreach folder $FOLDERS {

    set folder_path "$folder/cadence_synthesis"

    # Folder exists
    if {[file exists $folder_path] && [file isdirectory $folder_path]} {
        set path [pwd]
        puts "path $path"

        puts "Warning: Folder exists at $folder_path . Copying 'cadence_synthesis' folder to $folder overwriting it."
        exec cp -r ../../../cadence_synthesis $folder
        puts ""
        # exec cp -r ../cadence_synthesis $folder
    } else {
        # Folder does not exist
        # puts "Folder does not exist at $folder_path"
        puts "Copying 'cadence_synthesis' folder to $folder"
        exec cp -r ../../../cadence_synthesis $folder
        puts ""
        # exec cp -r ../cadence_synthesis $folder

    }

    # }
    # cd ../
    # }
    # cd ../
    # }
}


puts " ================= Synthesis setup scripts ================= "
foreach folder $folders {

    # check if first and second letters are HIGHER case
    if {[regexp {^[./A-Z_]+$} $folder]} {
        set path [pwd]
        puts "folder $path"
        cd $folder
        set normal_pipe [glob -directory "./" -type d  *]

        foreach dir $normal_pipe {
            cd $dir
            set FOLDERS [glob -directory "./" MAC_synth*]

            foreach folder $FOLDERS {
                # run script inside folder
                cd $folder/cadence_synthesis

                # source clean.tcl
                source setup_synthesis.tcl
                puts "\n\n\n\n\n\n\n\n\n\n\n\n"
                cd ../../
            }
            cd ../
        }
        cd ../
    }
}