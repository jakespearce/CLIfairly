#!/bin/bash

# "temp" until we get writing to and from /dev/shm implemented
map_rw_path="${HOME}/pokemon/gui/map_files/saved_maps"

get_map_info(){

    map="${maps[$current_map_char_is_on]}"
    x="${starting_x_coords[$current_map_char_is_on]}"
    y="${starting_y_coords[$current_map_char_is_on]}"
    map_height=$( wc -l < $map )
    chars_on_map=$( wc -c < $map )
    # -1 so we ignore the newline character
    map_width=$(( $(( $chars_on_map / $map_height )) - 1 ))
    # depending on what map the character is on, we load a different set of map functions. see map_function_conditions function
    current_map_functions="${map_functions[$current_map_char_is_on]}"
	current_map_quests="${map_quests[$current_map_char_is_on]}"
    source "$current_map_functions"
	source "$current_map_quests"
}


display_map(){

    cat "${map_rw_path}/marked_map_output"
}


# For Pallet Town this will overwrite the map 'pallet_town' in map_files/maps/pallet_town/
mark_source_map(){

	mapToWriteOver=$1
	mapToWrite="${map_rw_path}/marked_map_output"
	cp "$mapToWrite" "$mapToWriteOver"
}


# takes in three arguments: $x $y $character $map $map_width
# the map element at x,y is written as $character
change_map_element(){

	local target_x=$1
	local target_y=$2
	local characterToWrite=$3
	local changeMap=$4
	local mapWidth=$5

	local y_count=1
	local x_count=1
	local IFS_OLD=$IFS
	local IFS=;

	while read -r row; do
	
		if [ "$y_count" -eq "$target_y" ]; then
			target_yLine=$( echo -n $row )
			x_charNewLine=0
			
			while read -rn1 xCharacter; do
				((x_charNewLine++))
				
				if [ "$x_count" -eq "$target_x" ]; then
					echo -n "$characterToWrite"
				else
					echo -n "$xCharacter"
				fi

				((x_count++))

				if [ "$x_charNewLine" -eq "$mapWidth" ]; then
					echo "" # we want a newline at the end of the line
				fi
			done <<< $target_yLine

		else
			echo $row
		fi

		((y_count++))

	done < $changeMap > "${map_rw_path}/marked_map_output"

	local IFS=$IFS_OLD
	echo ""
	clear
#	cat "${map_rw_path}/marked_map_output" NOTE: removed and added to map_tools.sh as display_map

}


get_new_map_info_set_start_pos(){

	source "${pokemon_path}/character_files/character.cfg"
	get_map_info
	x=$1
	y=$2
	change_map_element $x $y $playerCharacter $map $map_width # writes the character to the coordinates they should be at. playerCharacter is sourced from character.cfg
}


inspect_element(){ # may be called from change_map_element or perhaps using Cut or something

	x_element=$1
	y_element=$2
	map_function_conditions # x_element and y_element are used internally
}

up(){

    y=$(( $y - 1 ))
	inspect_element $x $y
 
	if [ $canWeMove == "yes" ]; then
		change_map_element $x $y $playerCharacter $map $map_width ; display_map

	else
		y=$(( $y + 1 ))
	fi
}

down(){

    y=$(( $y + 1 ))
	inspect_element $x $y
  
	if [ $canWeMove == "yes" ]; then
		change_map_element $x $y $playerCharacter $map $map_width ; display_map

	else
		y=$(( $y - 1 ))
	fi
}

left(){

    x=$(( x - 1 ))
	inspect_element $x $y
   
	if [ $canWeMove == "yes" ]; then
		change_map_element $x $y $playerCharacter $map $map_width ; display_map

	else
		 x=$(( $x + 1 ))
	fi
}

right(){

    x=$(( $x + 1 ))
	inspect_element $x $y
 
	if [ $canWeMove == "yes" ]; then
		change_map_element $x $y $playerCharacter $map $map_width ; display_map

	else
		 x=$(( $x - 1 ))
	fi
}


# TODO
# Our character disappears from the map when we're moving other characters
# Write something that identifies the previous tile that the moving character was on.
# This will be $replacementCharacter

move_map_element(){

	xInitial=$1
	yInitial=$2
	xFinal=$3
	yFinal=$4
	characterToMove=$5
	replacementCharacter=$6
	map=$7


	xDiff=$(( $xFinal - $xInitial )) 
	yDiff=$(( $yFinal - $yInitial )) 
	if [ $xDiff -ne 0 ]; then
		[[ $xDiff -lt 0 ]] && xMod=-1 || xMod=1 ; yMod=0 ; absDiff=$( echo "sqrt(${xDiff}^2)" | bc )
	else
		[[ $yDiff -lt 0 ]] && yMod=-1 || yMod=1; xMod=0 ; absDiff=$( echo "sqrt($yxDiff}^2)" | bc )
	fi

	loopsCompleted=0
	leadingXValue=$(( $xInitial + $xMod ))
	trailingXValue=$xInitial	
	leadingYValue=$(( $yInitial - $yMod ))
	trailingYValue=$yInitial

	until [ $loopsCompleted -eq $absDiff ]; do

		# this function call changes the map for the 'leading' character
		change_map_element $leadingXValue $leadingYValue $characterToMove $map $map_width
		mark_source_map	"$map"

		change_map_element $trailingXValue $trailingYValue $replacementCharacter $map $map_width
		mark_source_map	"$map"
		display_map
		sleep 2


		[[ $xMod -ne 0 ]] && leadingXValue=$(( $leadingXValue + $xMod )) ; trailingXValue=$(( $leadingXValue - $xMod ))
		[[ $yMod -ne 0 ]] && leadingYValue=$(( $leadingYValue + $yMod )) ; trailingYValue=$(( $leadingYValue - $yMod ))
		((loopsCompleted++))
	done

}







