# proc read_HDL_files {init_hdl_search_path} {
#     puts " --------------- read_HDL_files --------------- "
#     set script_path [info script]
#     set script_dir [file dirname $script_path]
#     puts "script_dir: $script_dir"
#     set rtl_names ""

#     set rtl_files [glob -nocomplain -dir $init_hdl_search_path *.v]
#     foreach file_path $rtl_files {
#         lappend rtl_names [file tail $file_path]
#     }
#     puts "rtl_names: $rtl_names"
#     puts ""
#     set result [sort_by_level $rtl_names]
#     set sorted_rtl_list [lindex $result 0]
#     set rtl_names [lindex $result 1]

#     puts "\nSorted list:"
#     foreach item $sorted_rtl_list {
#         puts "item: $item"
#     }

#     # -----------------
#     if { [llength $sorted_rtl_list] == 0 } {
#         set sorted_rtl_list [glob -nocomplain -dir $init_hdl_search_path *.vhd]
#     } else {
#         read_hdl -verilog $sorted_rtl_list
#     }

#     if { [llength $sorted_rtl_list] == 0 } {
#         # if there is no vhdl files as well, exit with error
#         puts "ERROR: No RTL files found in $init_hdl_search_path"
#         exit 1
#         # exit 0
#     } else {
#         read_hdl -vhdl $sorted_rtl_list
#     }
# }

proc read_RTL_list {file_path filename} {
    puts " --------------- read_RTL_list --------------- "
    # -----------------
    set directoryPath "$file_path"

    set fileList [glob -nocomplain -directory $directoryPath *]

    if {[llength $fileList] > 0} {
        puts "List of files in $directoryPath:"
        foreach file $fileList {
            puts "- $file"
        }
    } else {
        puts "No files found in $directoryPath."
    }
    # -----------------
    # Read the sorted_rtl_list from the file
    # set filename "$file_path/$filename"
    set filename "$file_path$filename"
    set file_handle [open $filename "r"]
    set sorted_rtl_list [gets $file_handle]
    close $file_handle

    return $sorted_rtl_list
}

proc read_HDL_files {{file_path "../"} {filename "RTL_list.txt"}} {



    # Read the sorted_rtl_list from the file
    set rtl_list [read_RTL_list $file_path $filename]

    puts " --------------- read_HDL_files --------------- "
    puts "\n RTL list:"
    foreach item $rtl_list {
        puts "item: $item"
    }

    set filtered_rtl_list [lsearch -all -inline -regexp $rtl_list {\.v$}]
    # set filtered_rtl_list [glob -nocomplain $sorted_rtl_list *.v]
    # -----------------
    if { [llength $filtered_rtl_list] != 0 } {
        puts "Verilog filtered_rtl_list: $filtered_rtl_list"
        read_hdl -verilog $filtered_rtl_list
    } else {
        set filtered_rtl_list [lsearch -all -inline -regexp $rtl_list {\.vhd$}]
        # set filtered_rtl_list [glob -nocomplain $sorted_rtl_list *.vhd]

    }

    if { [llength $filtered_rtl_list] != 0 } {
        puts "VHDL filtered_rtl_list: $filtered_rtl_list"
        read_hdl -vhdl $filtered_rtl_list
    } else {
        # if there is no vhdl files as well, exit with error
        puts "ERROR: No RTL files found in '$file_path/$filename' "
        exit 1
        # exit 0
    }
}






# --------------------------------------------------------
# set init_hdl_search_path "../rtl"
# set rtl_files [glob -nocomplain -dir $init_hdl_search_path *.vhd]
# foreach file_path $rtl_files {
#     lappend rtl_names [file tail $file_path]
# }
# # Sort the list using the custom sorting command
# # set sorted_list [lsort -command sort_by_level $rtl_files]

# set result [sort_by_level $rtl_names]
# # parse result values
# set sorted_rtl_list [lindex $result 0]
# set rtl_names [lindex $result 1]

# puts "\nSorted list:"
# foreach item $sorted_rtl_list {
#     puts "item: $item"
# }

# puts $sorted_rtl_list

# # set sorted_rtl_list {file1.v file2.v file3.v}


# # set filename "rtl_list.txt"
# # set file_handle [open $filename "w"]
# # puts $file_handle $sorted_rtl_list
# # close $file_handle

# save_list_to_file $sorted_rtl_list "rtl_list.txt" "./"