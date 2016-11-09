#!/bin/bash

# A test script to see to what extent gui components can be used in battle_tools.sh and the move scripts that battle_tools.sh calls
#NOTE: functions in this script are being called from move.sh scripts and battle.sh

#---- Path variables ----#

art_path="${HOME}/pokemon/gui/pokemon_database/art"
battle_menu_move_info="/dev/shm/battle_menu_move_info"
generated_move_menu="/dev/shm/generated_move_menu"
generated_move_menu_marked="/dev/shm/generated_move_menu_marked"

#---- Sources ----#
# We source calculate_whitespace from here
source "${HOME}/pokemon/gui/tools/tools.sh"


#---- Variables for the move list part of the menu ----#

selection_adjuster=1
where_selection_is=1
hiOn=$( tput smso )
hiOff=$( tput rmso )


#---- Functions that deal with generating parts of the battle menu ----#

# This function generates and displays a menu of the player's pokemon's moves
# Two components: The backend component consisting of a tab file with the following fields:
# moveID | pp
# ...And the front end component consisting of a basic menu gui 
generate_move_menu(){

	# First generate the basic menu display
	#NOTE 14 characters is the longest of any move name.
	# Give every move a max of 20 characters of space
	# Each line is a total of 48 characters long
	# calculate whitespace for move 1
	#TODO check whether each of moveOne moveTwo moveThree moveFour are set or unset before calling read_moves_file
	# if we pass the check then call read_moves_file and save each move name to a variable. We also need to save PP to a variable
	# once we have each move name, work out the length and then calculate_whitespace appropriately
	# if the variable is empty then just use the maximum of 20 whitespace and don't display the 1) or 2) or 3) or 4)
#	calculate_whitespace 20 
	read_attribute_battleFile "${battle_filetmp_path}/PCPokemon.pokemon"

	# First get PP fields as these are stored in the attribute file
	moveOnePP_display=$moveOnePP
	moveOnePPMax_display=$moveOnePPMax
	moveTwoPP_display=$moveTwoPP
	moveTwoPPMax_display=$moveTwoPPMax
	moveThreePP_display=$moveThreePP
	moveThreePPMax_display=$moveThreePPMax
	moveFourPP_display=$moveFourPP
	moveFourPPMax_display=$moveFourPPMax

	# For each of the pokemon's move slots, check to see whether it's empty.
	# If the move slot has a move then read_moves_file for that move and capture the move's name 
	
	[[ $moveOne -ne 0 ]] &&  read_moves_file $moveOne && moveOneName_display="$moveName" && moveOneType_display=$moveType || moveOneName_display="empty"

	[[ $moveTwo -ne 0 ]] &&  read_moves_file $moveTwo && moveTwoName_display=$moveName && moveTwoType_display=$moveType || moveTwoName_display="empty"

	[[ $moveThree -ne 0 ]] && read_moves_file $moveThree && moveThreeName_display=$moveName && moveThreeType_display=$moveType || moveThreeName_display="empty"

	[[ $moveFour -ne 0 ]] && read_moves_file $moveFour && moveFourName_display=$moveName && moveFourType_display=$moveType || moveFourName_display="empty"

	# Uncomment for testing
#	echo -e "moveOneName_display = $moveOneName_display moveOneType_display = $moveOneType_display \n moveTwoName_display = $moveTwoName_display \n moveThreeName_display = $moveThreeName_display \n moveFourName_display = $moveFourName_display"

	# usage: calculate_whitespace $whitespaceMax $string_length $whitespace_character
	if [ "$moveOneName_display" != "empty" ]; then
		calculate_whitespace 20 ${#moveOneName_display} ' '
		moveOneName_display="${moveOneName_display}${whitespace}"
		echo "$moveOneName_display	$moveOneType_display	$moveOnePP_display	$moveOnePPMax	$moveOne" > "$generated_move_menu"
	else
		calculate_whitespace 20 1 ' '
		echo "-${whitespace}	null	null	null	null" > "$generated_move_menu"

	fi

	if [ "$moveTwoName_display" != "empty" ]; then
		calculate_whitespace 20 ${#moveTwoName_display} ' '
		moveTwoName_display="${moveTwoName_display}${whitespace}"
		echo "$moveTwoName_display	$moveTwoType_display	$moveTwoPP_display	$moveTwoPPMax	$moveTwo" >> "$generated_move_menu"
	else
		calculate_whitespace 20 1 ' '
		echo "-${whitespace}	null	null	null	null" >> "$generated_move_menu"

	fi

	if [ "$moveThreeName_display" != "empty" ]; then
		calculate_whitespace 20 ${#moveThreeName_display} ' '
		moveThreeName_display="${moveThreeName_display}${whitespace}"
		echo "$moveThreeName_display	$moveThreeType_display	$moveThreePP_display	$moveThreePPMax	$moveThree" >> "$generated_move_menu"
	else
		calculate_whitespace 20 1 ' '
		echo "-${whitespace}	null	null	null	null" >> "$generated_move_menu"


	fi

	if [ "$moveFourName_display" != "empty" ]; then
		calculate_whitespace 20 ${#moveFourName_display} ' '
		moveFourName_display="${moveThreeName_display}${whitespace}"
		echo "$moveFourName_display	$moveFourType_display	$moveFourPP_display	$moveFourPPMax	$moveFour" >> "$generated_move_menu"
	else
		calculate_whitespace 20 1 ' '
		echo "-${whitespace}	null	null	null	null" >> "$generated_move_menu"


	fi

	# Uncomment for testing
#	echo "this is the name of move one with whitespace: ${moveOneName_display}. "
#	echo "this is the name of move two with whitespace: ${moveTwoName_display}. "
#	echo "this is the name of move three with whitespace: ${moveThreeName_display}. "
#	echo "this is the name of move four with whitespace: ${moveFourName_display}. "

}


# Displays information about the move to the right of the move list
# Usage: generate_move_info_box $moveType $PP $PPMax
# generate_move_info_box "Rock" 12 64
generate_move_info_box(){

	read_generated_move_menu
	moveType_info="$moveType_menu"
	PP_info="$PP_menu"
	PPMax_info="$PPMax_menu"

	# usage: calculate_whitespace $whitespaceMax $string_length $whitespace_character
	calculate_whitespace 10 ${#moveType_info} ' '
	moveType_displayString="${moveType_info}${whitespace}"

	PP_info_displayString="${PP_info}/${PPMax_info}"
	calculate_whitespace 10 ${#PP_info_displayString} ' '
	PP_info_displayString="${PP_info_displayString}${whitespace}"

	echo "0-------------0" > "$battle_menu_move_info"
	echo "|   Type/     |" >> "$battle_menu_move_info"
	echo "|   ${moveType_displayString}|" >> "$battle_menu_move_info"
	echo "|   ${PP_info_displayString}|" >> "$battle_menu_move_info"
	# This needs 16 whitespace characters as when we paste it to $generated_move_menu_marked this line falls off the end
	echo "                0-------------0" >> "$battle_menu_move_info"

}


# Doesn't show the menu for the user, it just marks the selected line as selected and writes it to generated_move_menu_marked
refresh_menu(){

	local count=0
	OLD_IFS=$IFS
	IFS='	' #tab

	while read moveName_menu moveType_menu PP_menu PPMax_menu moveID_menu; do
		((count++))
		if [ $count -eq $where_selection_is ]; then
			echo "> ${moveName_menu::-2}"
		else
			echo "${moveName_menu}"
		fi
	done < "$generated_move_menu" > "$generated_move_menu_marked"

	IFS=$IFS_OLD
}


# Stops the selection from hitting null moves or going out of range
keep_move_menu_selection_in_range(){

	calculate_upper_limit_move_menu

	if [ $where_selection_is -le 0 ]; then
		where_selection_is=$(( $where_selection_is + 1 ))

	elif [ $where_selection_is -ge 5 ]; then
		where_selection_is=$(( $where_selection_is - 1 ))

	elif [ $where_selection_is -ge $menu_upper_limit ]; then
		where_selection_is=$(( $where_selection_is - 1 ))

	fi

}


calculate_upper_limit_move_menu(){

	local count=0
	OLD_IFS=$IFS
	IFS='	' #tab

	while read moveName_menu moveType_menu PP_menu PPMax_menu moveID_menu; do
		((count++))
		if [ "$moveType_menu" == "null" ]; then
			menu_upper_limit=$count
			IFS=$IFS_OLD
			break
		fi
	done < "$generated_move_menu"

	IFS=$IFS_OLD
}


read_generated_move_menu(){

	OLD_IFS=$IFS
	IFS='	' # tab
	local count=0

	while read moveName_menu_ moveType_menu_ PP_menu_ PPMax_menu_ moveID_menu_; do

		((count++))
		moveName_menu="$moveName_menu_"
		moveType_menu="$moveType_menu_"
		PP_menu="$PP_menu_"
		PPMax_menu="$PPMax_menu_"
		moveID_menu="$moveID_menu_"

		if [ $count -eq $where_selection_is ]; then
			break
		fi

	done < "$generated_move_menu"

	IFS=$IFS_OLD
	
}


display_art(){

	read_attribute_battleFile "${battle_filetmp_path}/PCPokemon.pokemon"
	cat "${art_path}/${pokemonID}.art"
	echo ""
}
