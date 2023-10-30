# script_name=GENERAL_script_logic.sh
# script_name=GENERAL_get_results.sh
script_name=GENERAL_results.sh
echo "Running script $script_name"

cd Compressao_arvore_somas_unsigned_CSA
./$script_name
wait

cd ../Operador_arvore_somas_unsigned_NO_OVERFLOW
./$script_name
wait

cd ../Operador_arvore_somas_unsigned_OVERFLOW
./$script_name
wait

cd ..

# cd Compressao_arvore_somas_unsigned; ./GENERAL_script_logic.sh; wait; cd ..;cd Operador_arvore_somas_unsigned_NO_OVERFLOW;./GENERAL_script_logic.sh;wait;cd ..;cd Operador_arvore_somas_unsigned_OVERFLOW;./GENERAL_script_logic.sh;wait;cd ..;