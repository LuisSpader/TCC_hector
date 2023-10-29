#!/bin/bash
# This script is a general version of the script 'my_script.sh'. It loops over each subdirectory in the a_mult_cte directory and runs the same commands in each one.
# You can save this script as my_general_script in the a_mult_cte directory, then make it executable with 
#     chmod +x my_general_script 
# and run it with 
#     ./my_general_script.

# tee: The tee command reads standard input, then writes it to standard output and also to any files given as arguments. This is useful when you want not only to send some data down a pipe, but also to save a copy.
# tee -a: append to the file rather than overwriting it
#!/bin/bash
# --------
# Source setup
# source /usr/eda/scripts/setup.digital 
source /usr/eda/scripts/setup.digital 

# Get the directory of the script
MY_SCRIPT_PATH=$(dirname "$0")

# Loop over each subdirectory
for dir in $MY_SCRIPT_PATH/Operator_*
do
    # Go into the directory
    cd $dir
    LOG_FILE_PATH=./synthesis/synthesis_log.txt
    
    echo "MY SCRIPT PATH: $MY_SCRIPT_PATH"
    echo "dir: $dir"
    echo "log file path: $LOG_FILE_PATH"
    # echo "" > synthesis_log.txt
    # The > operator is used to overwrite the file if it exists or create a new one if it doesn't. The >> operator is used to append to the file. The 2>&1 part redirects both the stdout and stderr to the specified file. The stderr is redirected to stdout, and then the stdout is redirected to the file.
    
    # Clear the log file
    pwd
    echo "" | tee $LOG_FILE_PATH
    # The command echo "" > synthesis_log.txt is used to clear the log file each time the script is run. If you want to append the logs for each run, you can remove this line.
    
    cd synthesis
    LOG_FILE_PATH=./synthesis_log.txt
    #pwd
    echo "########################################################################################"
    echo "# -------------- Run Logical synthesis --------------" 2>&1 | tee -a $LOG_FILE_PATH
    # genus -gui -legacy_ui -f sintese.tcl >> synthesis_log.txt 2>&1
    # report area >> area_log.txt 2>&1
    # report power >> synthesis_log.txt 2>&1
    # report timing >> synthesis_log.txt 2>&1
    # genus -gui -legacy_ui -f sintese.tcl 2>&1 | tee -a $LOG_FILE_PATH
    #pwd
    echo "# Openning genus ..." 2>&1 | tee -a $LOG_FILE_PATH
    genus -legacy_ui -f sintese.tcl 2>&1 | tee -a $LOG_FILE_PATH

    # The -a option is used with the tee command to append to the file rather than overwriting it. The 2>&1 redirects both standard output and error to the tee command.

    # exit

    # echo "# -------------- Run physical synthesis --------------"  2>&1 | tee -a $LOG_FILE_PATH
    # innovus >> synthesis_log.txt 2>&1
    # source physical/1.init.tcl >> synthesis_log.txt 2>&1
    # source physical/2.power_plan.tcl >> synthesis_log.txt 2>&1
    # source physical/3.place_route.tcl >> synthesis_log.txt 2>&1
    # source physical/4.nano_route.tcl >> synthesis_log.txt 2>&1
    # source physical/5.fillers_reports.tcl >> synthesis_log.txt 2>&1
    # source physical/6.netlist_sdf.tcl >> synthesis_log.txt 2>&1
  
    # innovus 2>&1 | tee -a $LOG_FILE_PATH
    # source physical/1.init.tcl 2>&1 | tee -a $LOG_FILE_PATH
    # source physical/2.power_plan.tcl 2>&1 | tee -a $LOG_FILE_PATH
    # source physical/3.place_route.tcl 2>&1 | tee -a $LOG_FILE_PATH
    # source physical/4.nano_route.tcl 2>&1 | tee -a $LOG_FILE_PATH
    # source physical/5.fillers_reports.tcl 2>&1 | tee -a $LOG_FILE_PATH
    # source physical/6.netlist_sdf.tcl 2>&1 | tee -a $LOG_FILE_PATH

    # # 9. Verificar se há erros, isto pode ser feito nos menus:
    # # Verify > Verify Geometry
    # # Verify > Verify DRC
    # # Verify > Verify Connectivity
    # # Verify > Verify Process Antenna

    # ncsdfc top.sdf

    # cd ../sim/sdf
    # irun -f file_list.f
    
    # exit

    # Go back to the original directory
    cd ../../
    #echo "######################################################################################"
    #echo " ------------------------ NORMAL DIRECTORY -------------------------------------------"
    #pwd
    #echo "######################################################################################"
    #cd $MY_SCRIPT_PATH
done

# # Get the directory of the script
# MY_SCRIPT_PATH=$(dirname "$0")

# # Loop over each subdirectory
# for dir in $MY_SCRIPT_PATH/cadence_sequence0_*
# do
#   # Check if my_script.sh exists in the directory
#   if [ -f "$dir/my_script.sh" ]; then
#     echo "Running my_script.sh in $dir"
#     # Go into the directory
#     cd $dir
#     # Run the script
#     ./my_script.sh
#     # Go back to the original directory
#     cd $MY_SCRIPT_PATH
#   fi
# done
