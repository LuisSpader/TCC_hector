
dir=$(pwd)

# Run logical synthesis
script_name=my_general_script_logic.sh
echo "Running script $script_name"

# $dir/6bits/$script_name
# wait
$dir/8bits/$script_name
wait
# $dir/10bits/$script_name
# wait

# Run logical synthesis
script_name=get_logic_results_folders.sh
echo "Running script $script_name"

# $dir/6bits/$script_name
# wait
$dir/8bits/$script_name
wait
# $dir/10bits/$script_name
# wait

git add .
script_date=$(date +%d-%m-%Y_%Hh%M)
git commit -m "Compressao_arvore_somas_unsigned CSA: Logic Synthesis - $script_date"
git push
