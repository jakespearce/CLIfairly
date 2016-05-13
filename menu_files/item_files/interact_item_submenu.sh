#!/bin/bash

item_tools="${HOME}/pokemon/gui/menu_files/item_files/item_tools.sh"
source "$item_tools"
menu_tools="${HOME}/pokemon/gui/menu_files/menu_tools.sh"
source "$menu_tools"
item_submenu_file="${HOME}/pokemon/gui/menu_files/item_files/item_submenu"
menu_height=$( wc -l < "$item_submenu_file"  )
selection_adjuster=1 # used for keeping selection in range
where_selection_is=1 # used exclusively for deciding where we are on the item submenu
B=$1 # B and F are used in item_tools.sh, specifically display_inventory_items when it calls
F=$2

#get_where_selection_is_item_menu # we want to display the item menu with the correct selection highlighted
#display_inventory_items

while :
do
	clear
	get_where_selection_is_item_menu
	# to prevent conflicts with multiple scripts using the $where_selection_is variable, we provide display_inventory_items with an argument of what the last selection for the parent item menu when we called this script.
	display_inventory_items "$where_selection_is_item_menu"
	keep_selection_in_range "$where_selection_is" "$selection_adjuster"
	display_submenu
	read -n1 input < /dev/tty
	case $input in
	w) where_selection_is=$(( $where_selection_is - 1 )) ;;
	s) where_selection_is=$(( $where_selection_is + 1)) ;;
	d) echo "yo" ; sleep 2 ;; #TODO usage and toss scripts
	a) clear ; exit ;;
	esac
done


