# if matchs it means that the folder should be excluded
proc shouldIncludeFolder {actual_folder excludeList} {
    foreach excludeDir $excludeList {
        if {[string match $excludeDir $actual_folder]} {
            return 0
        }
    }
    return 1
}

proc copy_files {SOURCE_DIR DEST_DIR TB_DIR} {
    # set rtl_files [glob -nocomplain $SOURCE_DIR/.*.v]
    # set rtl_files [glob -nocomplain -dir $SOURCE_DIR -type *.v]
    # set rtl_files [glob -nocomplain $SOURCE_DIR -type *.v]
    set rtl_files [glob -nocomplain -dir $SOURCE_DIR *.v]


    set fileList [glob -nocomplain -directory $SOURCE_DIR *]
    if {[llength $fileList] > 0} {
        # foreach file $fileList {
        #     file copy -force $file $destinationDir
        # }
        # puts "Files copied successfully."

        # puts "rtl_files: $rtl_files"
        if { [llength $rtl_files] == 0 } {
            # set rtl_files [glob -nocomplain $SOURCE_DIR/.*.vhd]
            set rtl_files [glob -nocomplain -dir $SOURCE_DIR *.vhd]
            # set rtl_files [glob -nocomplain $SOURCE_DIR -type *.vhd]

        }
        if { [llength $rtl_files] == 0 } {
            # if there is no vhdl files as well, exit with error
            puts "ERROR: No RTL files found in $SOURCE_DIR"
            # exit 1
            exit 0
        }


        foreach file $rtl_files {
            if { [string match "*_tb*" $file] } {
                # lappend file_list_f [file join $tb_path $file]
                puts "Copying $file to $TB_DIR"
                file copy -force $file $TB_DIR

            } else {
                # lappend file_list_f [file join $rtl_path $file]
                puts "Copying $file to $DEST_DIR"
                file copy -force $file $DEST_DIR
            }


        }

    } else {
        puts "No files found in the source directory."
    }
}

proc copy_RTL_Files_Recursive { SOURCE_DIR DEST_DIR TB_DIR excludedFolders } {
    # global DEST_DIR

    puts "-------------- copy_RTL_Files_Recursive --------------"
    puts "Source directory: $SOURCE_DIR"
    puts "Destination directory: $DEST_DIR"
    # Print the modified excludedFolders list
    # puts "Excluded folders:"
    foreach folder $excludedFolders {
        puts "Excluded folder: $folder"
    }
    puts ""

    # files
    copy_files $SOURCE_DIR $DEST_DIR $TB_DIR

    # folders
    # set folders [glob -directory $SOURCE_DIR/.*]
    set folders [glob -nocomplain -directory $SOURCE_DIR -type d *]
    foreach folder $folders {
        if {[shouldIncludeFolder $folder $excludedFolders]} {
            copy_RTL_Files_Recursive $folder $DEST_DIR $TB_DIR $excludedFolders
        }

    }
    # puts "###############################################"

}

# ---------------------------------------------------

proc set_DIRs {source_dir dest_dir tb_dir excludedFolders} {
    puts "------------------ set_DIRs ------------------"
    global script_dir SOURCE_DIR DEST_DIR TB_DIR modifiedExcludedFolders

    # set script_dir [pwd]
    set script_path [info script]
    set script_dir [file dirname $script_path]
    puts "Script directory: $script_dir"
    # set excludedFolders [linsert $excludedFolders 0 $script_dir]
    # Iterate over the excludedFolders list and prepend script_dir to each element
    set modifiedExcludedFolders {}
    foreach folder $excludedFolders {
        lappend modifiedExcludedFolders [file join $script_dir $folder]
    }


    if {$source_dir == ""} {
        set SOURCE_DIR "$script_dir/../"
        puts "Warning: SOURCE_DIR parameter is empty, setting default source dir: $SOURCE_DIR"
        # exit 1
    } else {
        puts "Changing path: $source_dir --> to --> $script_dir/$source_dir"
        set SOURCE_DIR "$script_dir/$source_dir"
    }

    if {$dest_dir == ""} {
        set DEST_DIR "$script_dir/rtl"
        puts "Warning: DEST_DIR parameter is empty, setting default destiny dir: $DEST_DIR"
        # exit 1
    } else {
        set DEST_DIR "$script_dir/$dest_dir"
        puts "Changing path: $dest_dir --> to --> $DEST_DIR"
    }

    if {$tb_dir == ""} {
        set TB_DIR "$script_dir/sim/tb"
        puts "Warning: DEST_DIR parameter is empty, setting default testbench dir: $TB_DIR"
        # exit 1
    } else {
        set TB_DIR "$script_dir/$tb_dir"
        puts "Changing path: $tb_dir --> to --> $TB_DIR"
    }

    if { ![file exists $DEST_DIR] } {
        puts "Warning: $DEST_DIR (DEST_DIR) does not exist, creating it"
        file mkdir $DEST_DIR
    }

    # lassign $SOURCE_DIR $DEST_DIR $modifiedExcludedFolders
    puts "Source directory: $SOURCE_DIR"
    puts "Destination directory: $DEST_DIR"
    puts "\n ------------------------------------------- \n"

}

proc print_list {print_list_var {str ""}} {
    foreach item $print_list_var {
        puts "$str $item"
    }
}

# proc set_RTL_Files {DEST_DIR} {
#     puts "DEST_DIR: $DEST_DIR"
#     # global rtl_files
#     set rtl_files [glob -nocomplain -dir $DEST_DIR *.v]

#     if { [llength $rtl_files] == 0 } {
#         set rtl_files [glob -nocomplain -dir $DEST_DIR *.vhd]

#     }
#     if { [llength $rtl_files] == 0 } {
#         # if there is no vhdl files as well, exit with error
#         puts "ERROR: No RTL files found in $DEST_DIR"
#         # exit 1
#         # exit 0
#     }
#     # puts "rtl_files: $rtl_files"

#     return $rtl_files
# }

# proc get_file_names {rtl_files} {
#     # set rtl_names ""
#     foreach file_path $rtl_files {
#         lappend rtl_names [file tail $file_path]
#     }
#     # set file_name [file tail $file_path]
#     # set file_name [file rootname $file_name]
#     return $rtl_names

# }

# proc text_to_file {text filePath} {
#     # Open the file for writing
#     set file [open $filePath "w"]

#     # Write the variable content to the file
#     puts $file $text

#     # Close the file
#     close $file
# }

# proc set_file_list_f {rtl_names DEST_DIR} {
#     set rtl_path "../../rtl/"
#     set tb_path "../tb/"
#     set filePath "$DEST_DIR/../sim/rtl/file_list.f"

#     foreach file $rtl_names {
#         if { [string match "*_tb*" $file] } {
#             lappend file_list_f [file join $tb_path $file]
#         } else {
#             lappend file_list_f [file join $rtl_path $file]
#         }
#     }

#     set file_list_f [join $file_list_f "\n"]
#     # print_list $file_list_f

#     set rtl_file_list_f "-smartorder -work work -V93 -top tb_top -notimingchecks -gui -access +rw \n"

#     append rtl_file_list_f $file_list_f
#     # puts $rtl_file_list_f
#     puts "Writing file: $filePath"
#     text_to_file $rtl_file_list_f $filePath
# }

# {0 {adder} {generic}}
# {1 {generic} {jjj}}
# {2 {seq} {jjj}}
# {3 {compressor} {jjj}}
# {4 {top} {jjj}}

# {0 {parameters} {jjj}}
# {1 {Leaky Reg ReLU mult add ROM} {MAC neuron}}
# {2 {activation shift} {jjj}}
# {3 {MAC} {jjj}}
# {4 {neuron} {camada ReLU Leaky Linear Sigmoid}}
# {5 {camada layer} {comb Barriers}}
# {6 {top} {jjj}}

# * -------------- CHANGE HERE YOUR TOP HIERARCHY NAMES (levels) --------------
proc sort_by_level {input_list} {
    puts "sort_by_level pwd: [pwd] "
    # comes first
    set levels {
        {0 {carry} {jjj}}
        {1 {top} {jjj}}
    }
    # comes after
    # global rtl_list
    set level_a ""
    set level_b ""
    set rtl_list ""
    set rtl_files $input_list

    foreach level $levels {
        puts " --------------- level: [lindex $level 0] --------------- "
        foreach rtl $input_list {
            set join_var [join [lindex $level 1] |]
            set exclude_var [join [lindex $level 2] |]

            if {[regexp $join_var $rtl ] } {
                if {[regexp $exclude_var $rtl ] } {
                    continue
                } else {
                    # puts "keywords: $keywords"
                    # puts "join_var: $join_var"

                    # set level_a $level
                    # break
                    puts "append rtl_list $rtl"
                    lappend rtl_list $rtl
                    set rtl_files [lsearch -all -inline -not $rtl_files $rtl]
                }
            }
        }

        # foreach {level keywords} $levels {
        #     if {[regexp [join $keywords |]]} {
        #         set level_b $level
        #         break
        #     }
        # }

        # return [expr {$level_a - $level_b}]
    }
    return [list $rtl_list $rtl_files]
}

# Save the sorted_rtl_list to a file
proc save_list_to_file {sorted_rtl_list filename path} {
    # set filename "rtl_list.txt"
    set file_handle [open "$path/$filename" "w"]
    puts $file_handle $sorted_rtl_list
    close $file_handle
}

proc save_RTL_sorted_list {{RTL_path "./rtl"} {save_path "./"} {RTL_list_name "RTL_list.txt"}} {

    # set RTL_path "../rtl"
    set rtl_files [glob -nocomplain -dir $RTL_path *.vhd]
    foreach file_path $rtl_files {
        lappend rtl_names [file tail $file_path]
    }

    set result [sort_by_level $rtl_names]
    # parse result values
    set sorted_rtl_list [lindex $result 0]
    # set rtl_names [lindex $result 1]

    puts "\nSorted list:"
    foreach item $sorted_rtl_list {
        puts "item: $item"
    }

    # Save the sorted_rtl_list to a file
    save_list_to_file $sorted_rtl_list $RTL_list_name $save_path
}
# ---------------------------------------------------

set sourceFolder "../"
set rtl_folder "./rtl"
set tb_folder "./sim/tb"

set excludedFolders {
    "../cadence_synthesis"
    "/path/to/source/folder/excluded_folder2"
}
# global script_dir SOURCE_DIR DEST_DIR TB_DIR modifiedExcludedFolders
# sourceFolder : SOURCE_DIR
# rtl_folder : DEST_DIR
# tb_folder : TB_DIR
# excludedFolders : modifiedExcludedFolders

puts "########################################################################################"
# puts "            >>>>>>>>>>>>>>>>>>>>>>>> set_DIRs <<<<<<<<<<<<<<<<<<<<<<<<<<< "

set_DIRs $sourceFolder $rtl_folder $tb_folder $excludedFolders
# puts "----------------------------------------------------------------------------------------"

# puts "            >>>>>>>>>>>>>>>> copy_RTL_Files_Recursive <<<<<<<<<<<<<<<< "

copy_RTL_Files_Recursive $SOURCE_DIR $DEST_DIR $TB_DIR $modifiedExcludedFolders
# puts "----------------------------------------------------------------------------------------"
# copy_RTL_Files_Recursive

# saving RTL list on 'RTL_list.txt' file
# puts "            >>>>>>>>>>>>>>>>>> save_RTL_sorted_list <<<<<<<<<<<<<<<<<< "
save_RTL_sorted_list $DEST_DIR "./" "RTL_list.txt"
# puts "----------------------------------------------------------------------------------------"

puts "########################################################################################"
puts ""

# set sourceFolder [lindex $resultList 0]
# set destinationFolder [lindex $resultList 1]
# set var3 [lindex $resultList 2]
# -------------------------------------

#! set rtl_files [set_RTL_Files $DEST_DIR]
# # print_list $rtl_files

#! set rtl_names [get_file_names $rtl_files]
# # print_list $rtl_names

# -------------------------------



# --------------------------------------

#! set_file_list_f $rtl_names $DEST_DIR
# -------------

# set joined_names [join $rtl_names ", "]
# puts $joined_names
# ==========================


