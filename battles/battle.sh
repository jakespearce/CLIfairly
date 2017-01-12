#!/bin/bash

# This script is run when we begin a battle

battle_menu="${HOME}/pokemon/gui/battles/battle_menu/menu"

source "${HOME}/pokemon/gui/battles/battle_tools.sh"
source "${HOME}/pokemon/gui/battles/battle_gui.sh"


move_battle_menu(){

	# The menu will not display if the PC has an action in the actionStack
	# check_actionStack for actions populates the PCactionStack variable.
#	unset PCaction
#	check_actionStack_for_actions
#	if [ "$PCactionStack" == "populated" ]; then
#		full_battle_sequence
#		# Exit move_battle_menu function after a full battle sequence
#		return 0
#	fi

	decide_if_PC_selects_move
	if [ $exitMoveBattleMenu -eq 1 ]; then return 0; fi

	# The move battle menu
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
			e) PC_select_move ; break ;;
			q) return 0 ;;
		esac
	done
}



main_battle_menu(){

	main_battle_menu_selection="FIGHT"

	while :
	do

		clear
		display_art
		display_main_battle_menu

		read -n1 input
		case $input in
			w|d|s|a) set_main_battle_menu_selection "$input" "$main_battle_menu_selection" ;;
			e) [[ "$main_battle_menu_selection" == "FIGHT" ]] && move_battle_menu ;;
		esac

	done
}

main_battle_menu
