#!/bin/bash

map_function_conditions(){
	canWeMove="yes"

	# Exit Oak's mansion and return to pallet town
	if [ "$y_element" -eq 9 -a "$x_element" -ge 12 -a "$x_element" -le 15 ]; then
		change_conf_value "${HOME}/pokemon/gui/character_files/character.cfg" "current_map_char_is_on" 1
		get_new_map_info_set_start_pos 27 16
		display_map
		canWeMove="yes" 
	fi
}
