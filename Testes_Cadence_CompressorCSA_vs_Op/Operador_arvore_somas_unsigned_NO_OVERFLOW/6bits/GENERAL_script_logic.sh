
dir=$(pwd)

# Run logical synthesis
script_name=my_general_script_logic.sh
echo "Running script $script_name"


$dir/$script_name
wait
# $dir/a_mult_cte/a_mult_cte_SEQ/$script_name
# wait
# $dir/SPIRAL_a_mult_cte/sequence_0_addsub17_depth3_neg10_COMB/$script_name
# wait
# $dir/SPIRAL_a_mult_cte/sequence_0_addsub18_depth2_neg10_COMB/$script_name
# wait
# $dir/SPIRAL_a_mult_cte/sequence_0_addsub18_depth2_neg10_SEQ/$script_name
# wait
#$dir/SPIRAL_a_mult_cte_CSA/sequence_0_addsub17_depth3_neg10_COMB/$script_name
#wait
#$dir/SPIRAL_a_mult_cte_CSA/sequence_0_addsub18_depth2_neg10_SEQ/$script_name
#wait

# Run logical synthesis
script_name=get_logic_results_folders.sh
echo "Running script $script_name"
$dir/$script_name
wait
#$dir/a_mult_cte/a_mult_cte_SEQ/$script_name
#wait
#$dir/SPIRAL_a_mult_cte/sequence_0_addsub17_depth3_neg10_COMB/$script_name
#wait
#$dir/SPIRAL_a_mult_cte/sequence_0_addsub18_depth2_neg10_COMB/$script_name
#wait
#$dir/SPIRAL_a_mult_cte/sequence_0_addsub18_depth2_neg10_SEQ/$script_name
#wait
#$dir/SPIRAL_a_mult_cte_CSA/sequence_0_addsub17_depth3_neg10_COMB/$script_name
#wait
#$dir/SPIRAL_a_mult_cte_CSA/sequence_0_addsub18_depth2_neg10_SEQ/$script_name
#wait

git add .
script_date=$(date +%d-%m-%Y_%Hh%M)
git commit -m "Logic Synthesis sum tree COMPressors - $script_date"
git push
