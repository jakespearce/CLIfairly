#!/bin/bash

map_function_conditions(){
	canWeMove="yes"

	# Go to First floor of My House
	if [ "$y_element" -eq 2 -a "$x_element" -eq 21 ]; then
		change_conf_value "${HOME}/pokemon/gui/character_files/character.cfg" "current_map_char_is_on" 2
		get_new_map_info_set_start_pos 22 2
		canWeMove="yes"
	fi
}

