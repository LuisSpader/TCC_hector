#!/bin/bash

# Get the directory of the script
MY_SCRIPT_PATH=$(dirname "$0")
#folder_abrv="cadence_sequence0_"
#folders_abrv=$(echo "cadence_sequence0_*")
#folders=$(ls -d $folder_abrv* | sort -t_ -k3 -n)
pwd
folders=$(ls -d $MY_SCRIPT_PATH/COMP_* | sort -t_ -k3 -V)
echo "folders: $folders"


# Output file paths
csv_file="results.csv"
txt_file="results.txt"

# Remove existing result files
rm -f "$csv_file" "$txt_file"

# Create headers in the CSV file
echo "Folder, Number of Cells, Cell Area, Net Area, Total Area, Highest Timing Value, Start-point, End-point, Leakage Power, Dynamic Power, Total Power" >> "$csv_file"

# Get a sorted list of subdirectories
#sorted_dirs=$(find "$MY_SCRIPT_PATH" -maxdepth 1 -type d -name "$folder_name*" | sort)
#echo "--------------------------->>>>>> sorted_dirs: $sorted_dirs"


# -------------------------------- FUNCTIONS -------------------------------- #
create_pattern(){
	local words=("$@") # store the input words in an array
	# Construct the grep pattern to match lines containing all the words
	#pattern = "word1.*word2.* ..."
	local pattern=""

	# [@]: The [@] notation is used to reference all elements in the array. It ensures that each element is treated as a separate entity.
	for word in "${words[@]}"; do
	  # -z: test if pattern is empty 
	  if [ -z "$pattern" ]; then
	    pattern="\\b$word\\b"
	  else
	    pattern="$pattern.*\\b$word\\b"
	  fi
	done
	echo "$pattern"
}

# Function to extract area results from the provided text
get_area_results() {
	local text="$1"
	local folder_name="$2"
	#local txt_file="$3"

	# Search string to identify the section of interest
	local words=("Instance" "Module" "Cells" "Area")
	local pattern=$(create_pattern "${words[@]}")

	# Extract the relevant section
	local relevant_section=$(grep -A2 -E "$pattern" <<< "$text")

	# Extract the values for number of cells, cell area, net area, and total area using awk
	local number_of_cells=$(awk '/^top/ {print $2}' <<< "$relevant_section")
	local cell_area=$(awk '/^top/ {print $3}' <<< "$relevant_section")
	local net_area=$(awk '/^top/ {print $4}' <<< "$relevant_section")
	local total_area=$(awk '/^top/ {print $5}' <<< "$relevant_section")

	# Print the values
	#echo "Number of Cells: $number_of_cells" 
	#echo "Cell Area: $cell_area" 
	#echo "Net Area: $net_area"
	#echo "Total Area: $total_area"
	#echo -e "$folder_name\t\t$number_of_cells\t\t$cell_area\t\t$net_area\t\t$total_area" >> "$txt_file"
	echo "$number_of_cells:$cell_area:$net_area:$total_area"

}

get_timing_results() {
	local text="$1"
	local folder_name="$2"
	#local txt_file="$3"

	# Extract the timing values, start-point, and end-point
	#highest_timing=$(grep -oP "\d+\s+[F|R]\b"  <<< "$text" | sort -n | tail -n 1)
	local highest_timing=$(grep -oP "\d+(?=\s+[F|R]\b)" <<< "$text" | sort -n | tail -n 1)

	# -o : Only output the matched part of the line
	# -P : Use Perl-compatible regular expressions
	# '\d+' : Match one or more digits (timing values)
	#    \d+: This part matches one or more digits. \d is a shorthand character class that represents any digit (0-9), and + is a quantifier that matches one or more occurrences of the preceding pattern.
	# (?= ... ): This is the syntax for a lookahead assertion. It specifies a condition that should match immediately after the current position, without consuming any characters.
	#	The parentheses ( and ) are used to define the boundary of the lookahead expression.
	#    \s+: This matches one or more whitespace characters. \s is a shorthand character class that represents any whitespace character (space, tab, etc.), and + is a quantifier that matches one or more occurrences of the preceding pattern.
	#    [F|R]: This character class matches either 'F' or 'R'. The square brackets [] denote a character class, and F|R within it specifies the characters to match.
	#    \b: This matches a word boundary. It ensures that the match occurs at the end of a word, meaning there should be no additional alphanumeric characters immediately after the match.
	# <<< "$text" : Redirect the text as input to grep
	# sort -n : Sort the timing values numerically
	# tail -n 1 : Output the last line (highest timing value)


	local start_point=$(grep -oP '(?<=Start-point  : )[^\n]+' <<< "$text")
	# '(?<=Start-point  : )' : Positive lookbehind assertion for 'Start-point  : ' (to exclude it from the match)
	# [^\n]+ : Match one or more characters that are not a newline character
	# <<< "$text" : Redirect the text as input to grep

	local end_point=$(grep -oP '(?<=End-point    : )[^\n]+' <<< "$text")
	# '(?<=End-point    : )' : Positive lookbehind assertion for 'End-point    : ' (to exclude it from the match)
	# [^\n]+ : Match one or more characters that are not a newline character
	# <<< "$text" : Redirect the text as input to grep

	# Print the results
	#echo "Highest Timing Value: $highest_timing" 
	#echo "Start-point: $start_point"
	#echo "End-point: $end_point"
	#echo -e "$folder_name\t\t$highest_timing\t\t$start_point\t\t$end_point" >> "$txt_file"
	echo "$highest_timing:$start_point:$end_point"
}

get_power_results() {
	local text="$1"
	local folder_name="$2"
	local txt_file="$3"

	# Search string to identify the section of interest
	local words=("Instance" "Cells" "Power")
	local pattern=$(create_pattern "${words[@]}")
	# Extract the relevant section
	#relevant_section=$(grep -A2 "$search_string" <<< "$text")
	local relevant_section=$(grep -A2 -E $pattern <<< "$text" )
	#echo "POWER relevant_section: $relevant_section"

	# Extract the values for number of cells, leakage power, dynamic power, and total power using awk
	local number_of_cells=$(awk '/^top/ {print $2}' <<< "$relevant_section")
	local leakage_power=$(awk '/^top/ {print $3}' <<< "$relevant_section")
	local dynamic_power=$(awk '/^top/ {print $4}' <<< "$relevant_section")
	local total_power=$(awk '/^top/ {print $5}' <<< "$relevant_section")

	# Print the values
	#echo "Number of Cells: $number_of_cells"
	#echo "Leakage Power: $leakage_power nW"
	#echo "Dynamic Power: $dynamic_power nW"
	#echo "Total Power: $total_power nW"

	#echo -e "$folder_name\t\t$leakage_power\t\t$dynamic_power\t\t$total_power" >> "$txt_file"
	echo "$leakage_power:$dynamic_power:$total_power"
}

################################################################ SCRIPT ################################################################
# # Loop over each subdirectory
#for dir in $MY_SCRIPT_PATH/cadence_sequence0_*
# Loop over each subdirectory


echo "# ------------------------------------------------ CSV LOOP ------------------------------------------------ #"
# Loop over the sorted folders
echo "$folders"
for dir in $folders
do
	# Print the current directory
	#echo "Current directory: $dir"

	# Go into the directory
	cd $dir
	csv_file="../results.csv"
	#txt_file="../results.txt"
	#echo ">>>>>>>>>>>>>>>>>>>> !!! dir: $dir"
	# Read the text from a file
	text=$(cat ./synthesis/synthesis_log.txt)

	# Get the folder name
	folder_name=$(basename "$dir")
	#---------------------------------------------

	#get_area_results "$text" "$folder_name"
	result=$(get_area_results "$text" "$folder_name")
	IFS=':' read -r number_of_cells cell_area net_area total_area <<< "$result"
	#echo -e "$folder_name\t\t$number_of_cells\t\t$cell_area\t\t$net_area\t\t$total_area" >> "$txt_file"

	#get_timing_results "$text" "$folder_name"
	result=$(get_timing_results "$text" "$folder_name")
	IFS=':' read -r highest_timing start_point end_point <<< "$result"
	#echo -e "$folder_name\t\t$highest_timing\t\t$start_point\t\t$end_point" >> "$txt_file"

	#get_power_results  "$text" "$folder_name"
	result=$(get_power_results "$text" "$folder_name" )
	IFS=':' read -r leakage_power dynamic_power total_power <<< "$result"
	#echo -e "$folder_name\t\t$leakage_power\t\t$dynamic_power\t\t$total_power" >> "$txt_file"


	# Append the results to the CSV file
	echo "$folder_name, $number_of_cells, $cell_area, $net_area, $total_area, $highest_timing, $start_point, $end_point, $leakage_power, $dynamic_power, $total_power" >> "$csv_file"


	# Return to the main directory
	pwd
	cd ..
	pwd

done
# ------------------------------------------------ TXT LOOP ------------------------------------------------ #

echo "# -------------------------------- GET AREA ---------------------------------- #"
# Create header in txt file as a table
txt_file="./results.txt"
echo -e "Folder\t\t\tNumber of Cells\t\tCell Area\t\tNet Area\t\tTotal Area" >> "$txt_file"

# Loop over the sorted folders
for dir in $folders
do
	# Print the current directory
	#echo "Current directory: $dir"

	# Go into the directory
	cd $dir

	txt_file="../results.txt"
	#echo ">>>>>>>>>>>>>>>>>>>> !!! dir: $dir"
	# Read the text from a file
	text=$(cat ./synthesis/synthesis_log.txt)

	# Get the folder name
	folder_name=$(basename "$dir")
	#---------------------------------------------

	#get_area_results "$text" "$folder_name"
	result=$(get_area_results "$text" "$folder_name")
	IFS=':' read -r number_of_cells cell_area net_area total_area <<< "$result"
	echo -e "$folder_name\t\t$number_of_cells\t\t$cell_area\t\t\t$net_area\t\t\t$total_area" >> "$txt_file"

	# Return to the main directory
	pwd
	cd ..
	pwd

done



echo "# ------------------------------- GET TIMING ------------------------------- #"
# Create header in txt file as a table
txt_file="./results.txt"
echo -e "\nFolder\t\t\tHighest Timing Value\tStart-point\t\tEnd-point" >> "$txt_file"

# Loop over the sorted folders
for dir in $folders
do
	# Print the current directory
	#echo "Current directory: $dir"

	# Go into the directory
	cd $dir

	txt_file="../results.txt"
	#echo ">>>>>>>>>>>>>>>>>>>> !!! dir: $dir"
	# Read the text from a file
	text=$(cat ./synthesis/synthesis_log.txt)

	# Get the folder name
	folder_name=$(basename "$dir")
	#---------------------------------------------

	#get_timing_results "$text" "$folder_name"
	result=$(get_timing_results "$text" "$folder_name")
	IFS=':' read -r highest_timing start_point end_point <<< "$result"
	echo -e "$folder_name\t\t$highest_timing\t\t$start_point\t\t\t$end_point" >> "$txt_file"

	# Return to the main directory
	pwd
	cd ..
	pwd

done

echo "# ------------------------------- GET POWER ------------------------------- #"
# Create header in txt file as a table
txt_file="./results.txt"
echo -e "\nFolder\t\t\tLeakage Power\t\tDynamic Power\t\tTotal Power" >> "$txt_file"

# Loop over the sorted folders
for dir in $folders
do
	# Print the current directory
	#echo "Current directory: $dir"

	# Go into the directory
	cd $dir

	txt_file="../results.txt"
	#echo ">>>>>>>>>>>>>>>>>>>> !!! dir: $dir"
	# Read the text from a file
	text=$(cat ./synthesis/synthesis_log.txt)

	# Get the folder name
	folder_name=$(basename "$dir")
	#---------------------------------------------

	#get_power_results  "$text" "$folder_name"
	result=$(get_power_results "$text" "$folder_name" )
	IFS=':' read -r leakage_power dynamic_power total_power <<< "$result"
	echo -e "$folder_name\t\t$leakage_power\t\t$dynamic_power\t\t$total_power" >> "$txt_file"

	# Return to the main directory
	pwd
	cd ..
	pwd

done




