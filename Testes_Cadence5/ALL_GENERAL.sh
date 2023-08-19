script_name=logic_script.sh
echo "Running script $script_name"
# cd ../Operador_arvore_somas_unsigned_NO_OVERFLOW
./$script_name
wait

script_name=get_logic_result_folders.sh
echo "Running script $script_name"
# cd ../Operador_arvore_somas_unsigned_OVERFLOW
./$script_name
wait

echo "cleaning synthesis files"
# tclsh ./clean_synthesis.tcl
tclsh clean_all_synthesis_except_log.tcl
# # cd ..

git add *.txt
git add *.sh
git add *.tcl
#git add --all
script_date=$(date +%d-%m-%Y_%Hh%M)
git commit -m "get MACs CSA Logic Synthesis with results - $script_date"
git push


# cd Compressao_arvore_somas_unsigned; ./GENERAL_script_logic.sh; wait; cd ..;cd Operador_arvore_somas_unsigned_NO_OVERFLOW;./GENERAL_script_logic.sh;wait;cd ..;cd Operador_arvore_somas_unsigned_OVERFLOW;./GENERAL_script_logic.sh;wait;cd ..;
