MY_SCRIPT_PATH=$(pwd)

folders=$(find "$MY_SCRIPT_PATH" -type d -name 'MAC_synth*' -print | grep -v '/\.' )

echo " ================= Clean Synthesis files ================= "

for dir in $folders
do
    cd $dir/cadence_synthesis/
    echo "Folder: $dir"
    
    echo "Removing folder: ./cadence_synthesis/synthesis/fv"
    rm -rf ./synthesis/fv
    
    echo "Removing folder: ./cadence_synthesis/synthesis/layout"
    rm -rf ./synthesis/layout

    echo "Removing *.cmd* files"
    find "./" -name "*.cmd*" -type f -delete
    
    echo "Removing *.log* files"
    find "./" -name "*.log*" -type f -delete

    echo "Removing *.tstamp* files"
    find "./" -name "*tstamp*" -type f -delete

done