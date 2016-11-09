#!/bin/bash

# This script is run when we begin a battle

battle_menu="${HOME}/pokemon/gui/battles/battle_menu/menu"

source "${HOME}/pokemon/gui/battles/battle_tools.sh"
source "${HOME}/pokemon/gui/battles/battle_gui.sh"


# Below is the beginning of the battle move menu. Still plenty to do.
while :
do

	clear
	keep_move_menu_selection_in_range
	generate_move_info_box
	generate_move_menu # We only really need to do this once, consider moving this outside of the loop.
	refresh_menu
	display_art
	paste "$generated_move_menu_marked" "$battle_menu_move_info"

	read -n1 input
	case $input in
		w) where_selection_is=$(( $where_selection_is - 1 )) ;;
		s) where_selection_is=$(( $where_selection_is + 1 )) ;;
	esac
done
