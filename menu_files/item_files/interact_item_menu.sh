#!/bin/bash


where_selection_is=1 # we can set this value to whatever's in where_selection_is_item if landing on 1 whenever this script is called is for some reason bad.
item_tools="${HOME}/pokemon/gui/menu_files/item_files/item_tools.sh"
source "$item_tools"
menu_tools="${HOME}/pokemon/gui/menu_files/menu_tools.sh"
source "$menu_tools"
item_submenu_script="${HOME}/pokemon/gui/menu_files/item_files/interact_item_submenu.sh"
where_selection_is_file_item_menu="${HOME}/pokemon/gui/menu_files/item_files/where_selection_is_items"
item_menu_file="${HOME}/pokemon/gui/menu_files/item_files/inventory_items.tab"
menu_height=$( wc -l < "$item_menu_file"  )
selection_adjuster=1 # used for keeping selection in range
B=1 # B = Before, F = in front. We see 7 menu items at a time. When we open the menu we see all items between 1 and 7.
F=7

while :
do
	clear
	keep_selection_in_range "$where_selection_is" "$selection_adjuster"
	display_inventory_items "$where_selection_is"
	read -n1 input < /dev/tty
	case $input in
	w) where_selection_is=$(( $where_selection_is - 1)) ;;
	s) where_selection_is=$(( $where_selection_is + 1)) ;;
	d) echo "$where_selection_is" > "$where_selection_is_file_item_menu" ; bash "$item_submenu_script" "$B" "$F" ;;
	a) clear ; exit ;;
	esac
done

