#!/bin/bash
# Make the script executable by running the command chmod +x my_script.sh.
# Run the script using the command ./my_script.sh.

# Source setup
source /usr/eda/scripts/setup.digital

# Get the directory of the script
MY_SCRIPT_PATH=$(dirname "$0")

# Clear the log file
echo "" | tee synthesis_log.txt

# Change directory and run simulation
# cd $MY_SCRIPT_PATH/sim/rtl
# irun -f file_list.f >> $MY_SCRIPT_PATH/synthesis_log.txt 2>&1

# -------------- Run Logical synthesis --------------
cd $MY_SCRIPT_PATH/synthesis
echo "# Openning genus ..." 2>&1 | tee -a synthesis_log.txt
# genus -gui -legacy_ui -f sintese.tcl >> $MY_SCRIPT_PATH/synthesis_log.txt 2>&1
# report area >> $MY_SCRIPT_PATH/synthesis_log.txt 2>&1
# report power >> $MY_SCRIPT_PATH/synthesis_log.txt 2>&1
# report timing >> $MY_SCRIPT_PATH/synthesis_log.txt 2>&1
genus -gui -legacy_ui -f sintese.tcl 2>&1 | tee -a synthesis_log.txt

# echo "# ----------- report area ----------- " 2>&1 | tee -a synthesis_log.txt
# report area 2>&1 | tee -a synthesis_log.txt
# echo "# ----------- report power ----------- " 2>&1 | tee -a synthesis_log.txt
# report power 2>&1 | tee -a synthesis_log.txt
# echo "# ----------- report timing ----------- " 2>&1 | tee -a synthesis_log.txt
# report timing 2>&1 | tee -a synthesis_log.txt
#   (verificar no reporte anterior se o circuito consegue operar na frequência de relógio especificada, ou seja, se o “slack time” é um número positivo)

# exit

# # -------------- Run physical synthesis --------------
# cd $MY_SCRIPT_PATH/synthesis
# innovus >> $MY_SCRIPT_PATH/synthesis_log.txt 2>&1
# source physical/1.init.tcl >> $MY_SCRIPT_PATH/synthesis_log.txt 2>&1
# source physical/2.power_plan.tcl >> $MY_SCRIPT_PATH/synthesis_log.txt 2>&1
# source physical/3.place_route.tcl >> $MY_SCRIPT_PATH/synthesis_log.txt 2>&1
# source physical/4.nano_route.tcl >> $MY_SCRIPT_PATH/synthesis_log.txt 2>&1
# source physical/5.fillers_reports.tcl >> $MY_SCRIPT_PATH/synthesis_log.txt 2>&1
# source physical/6.netlist_sdf.tcl >> $MY_SCRIPT_PATH/synthesis_log.txt 2>&1

# 9. Verificar se há erros, isto pode ser feito nos menus:
# Verify > Verify Geometry
# Verify > Verify DRC
# Verify > Verify Connectivity
# Verify > Verify Process Antenna

# ncsdfc top.sdf
# cd ../sim/sdf
# irun -f file_list.f

# exit
    

# The > operator is used to overwrite the file if it exists or create a new one if it doesn't. The >> operator is used to append to the file. The 2>&1 part redirects both the stdout and stderr to the specified file. The stderr is redirected to stdout, and then the stdout is redirected to the file.

# Note: The command echo "" > synthesis_log.txt is used to clear the log file each time the script is run. If you want to append the logs for each run, you can remove this line.

# The file paths for redirection (../../../../synthesis_log.txt) are assuming that synthesis_log.txt is located in the Testes_Cadence2 directory. If the file is located elsewhere, you'll need to adjust the paths accordingly.





