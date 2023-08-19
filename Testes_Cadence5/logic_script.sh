!/bin/bash
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
MY_SCRIPT_PATH=$(dirname "$0")

# synthesis_path=""
synthesis_path="cadence_synthesis"

intermediate_folders=$(find . -type d -maxdepth 1)
echo "intermediate_folders: $intermediate_folders"

# Get the directory of the script
# MY_SCRIPT_PATH=$(dirname "$0")
MY_SCRIPT_PATH=$(pwd)

folders=$(find "$MY_SCRIPT_PATH" -type d -name 'MAC_synth*' -print | grep -v '/\.' )
# folders=$(ls -d $MY_SCRIPT_PATH/NN_* | sort -t_ -k3 -V)
echo "folders: $folders"


# Loop over each subdirectory
# for dir in $MY_SCRIPT_PATH/NN_*
for dir in $folders
do
    # for folder in $intermediate_folders
    # do
    #     for synth in ./NN_*
    #     do

    # Go into the directory
    # cd $dir/$folder/$synth/$synthesis_path
    cd $dir/$synthesis_path

    LOG_FILE_PATH=./synthesis/synthesis_log.txt
    
    echo "MY SCRIPT PATH: $MY_SCRIPT_PATH"
    echo "dir: $dir/$synthesis_path"
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

    # # Go back to the original directory
    # # -z: test if pattern is empty 
    # if [ -z "$synthesis_path" ]; then
    #     cd ../../../
    # else
    #     cd ../../../../
    # fi
    
    #echo "######################################################################################"
    cd $MY_SCRIPT_PATH
    #echo " ------------------------ NORMAL DIRECTORY -------------------------------------------"
    #pwd
    #echo "######################################################################################"
    #cd $MY_SCRIPT_PATH
    #     done
    # done
done