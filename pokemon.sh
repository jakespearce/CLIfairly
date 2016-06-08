#!/bin/bash

# Everything aside from moving around the map is a script that runs over the top of this one.

pokemon_path="${HOME}/pokemon/gui"
source "${pokemon_path}/character_files/character.cfg"
source "${pokemon_path}/map_files/maps.cfg"
source "${pokemon_path}/map_files/map_tools.sh"
source "${pokemon_path}/tools/tools.sh"


input_prompt(){

	read -n1 input
	case $input in
		w) up ;;
		s) down ;;
		a) left ;;
		d) right ;;
		# interaction is a function found whatever the current_map_functions file is set to
		# map_rw_path needs to be located in /dev/shm in the future
		e) clear ; cat "${map_rw_path}/marked_map_output" ; echo "" ; echo -n " " ; interaction ;;
		m) bash ${HOME}/pokemon/gui/menu_files/menu.sh ; cat "${map_rw_path}/marked_map_output" ;;
		*) echo "WASD to move, e to interact with things, m for menu." ;;
	esac
}


get_map_info

while true; do
	stty_OLD=$( stty -g )
	stty -echo 		# so the user can't see their own input
	input_prompt
	stty $stty_OLD
done
