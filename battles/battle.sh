#!/bin/bash

# This script is run when we begin a battle

battle_menu="${HOME}/pokemon/gui/battles/battle_menu/menu"

source "${HOME}/pokemon/gui/battles/battle_tools.sh"
source "${HOME}/pokemon/gui/battles/battle_gui.sh"


# Below is the beginning of the battle menu. Still plenty to do.
while :
do

	clear
	generate_move_info_box "NORMAL" 28 40
	generate_move_menu
	refresh_menu
	paste "$generated_move_menu_marked" "$battle_menu_move_info"

	read -n1 input
	case $input in
		w) where_selection_is=$(( $where_selection_is - 1 )) ;;
		s) where_selection_is=$(( $where_selection_is + 1 )) ;;
	esac
done
