#!/bin/bash

map_function_conditions(){
	canWeMove="yes"

	# Exit my house and return to pallet town
	if [ "$y_element" -eq 9 -a "$x_element" -ge 8 -a "$x_element" -le 9 ]; then
		change_conf_value "${HOME}/pokemon/gui/character_files/character.cfg" "current_map_char_is_on" 1
		get_new_map_info_set_start_pos 9 10
		canWeMove="yes"

	# Go to the second floor of my house
	elif [ "$y_element" -eq 2 -a "$x_element" -eq 22 ]; then
		change_conf_value "${HOME}/pokemon/gui/character_files/character.cfg" "current_map_char_is_on" 4
		get_new_map_info_set_start_pos 21 2
		canWeMove="yes"
	fi

	# Stop walking through walls: From top row to bottom: N, E, S, W
	if [ \
		\( "$y_element" -eq 1 -a "$x_element" -ge 1 \) -o \
		\( "$y_element" -ge 1 -a "$x_element" -eq 23 \) -o \
		\( "$y_element" -ge 9 -a "$x_element" -ge 10 \) -o \
		\( "$y_element" -ge 9 -a "$x_element" -le 7 \) -o \
		\( "$y_element" -ge 1 -a "$x_element" -eq 1 \) \
		 ]; then
		canWeMove="no"
	fi
}
