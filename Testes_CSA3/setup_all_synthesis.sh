MY_SCRIPT_PATH=$(pwd)

# pwd
folders=$(find "$MY_SCRIPT_PATH" -type d -name 'MAC_synth*' -print | grep -v '/\.' )
echo "$folders"
echo ""

echo " ================= Copying 'cadence_synthesis' folder to all folders starting with NN ================= "

for folder in $folders
do
    echo "$folder"
    # cd $folder
    echo "Copying 'cadence_synthesis' folder to $folder"
    cp -r $MY_SCRIPT_PATH/../cadence_synthesis $folder
    echo "-------------------"
done
echo "





"



echo " ================================== Synthesis setup scripts ================================== "
for folder in $folders
do
    echo "$folder"
    cd $folder/cadence_synthesis
    tclsh setup_synthesis.tcl
    echo "-------------------"
    # cd $MY_SCRIPT_PATH
done