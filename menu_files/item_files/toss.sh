#!/bin/bash

item_tools="${HOME}/pokemon/gui/menu_files/item_files/item_tools.sh"
source "$item_tools"
menu_tools="${HOME}/pokemon/gui/menu_files/menu_tools.sh"
source "$menu_tools"
B=$1 #TODO so far B and F are created and changed via item_menu. They are passed on to item_submenu. They are then passed here. They are passed as script arguments. This is very unsexy and upsetting, it should be fixed.
F=$2
menu_height=1 #TODO this is just a placeholder so that reposition_item_menu_window in item_tools.sh doesn't break. It doesn't matter what value it is, as long as it's an integer. This is saddening and needs fixing.
tossQuantity=1

get_item_data # we pull itemQuantity from here.

# this function ensures that we 'loop' through the quantity to toss
adjust_toss_quantity(){

	[[ $tossQuantity -gt $itemQuantity ]] && tossQuantity=1
	[[ $tossQuantity -le 0 ]] && tossQuantity="$itemQuantity"
}

display_toss_quantity(){

	# test below adds whitespace to tossQuantity if the value is less than 10 ie. string length is 1.
	[[ ${#tossQuantity} == 1  ]] && tossQuantityforDisplay="${tossQuantity} " || tossQuantityforDisplay="$tossQuantity"

	echo "O---------------------O"
	echo "| Toss how many?" $hiOn  $tossQuantityforDisplay $hiOff "|"
	echo "O---------------------O"
}

# toss_items(){} TODO

while :
do
	clear
	get_where_selection_is_item_menu
	get_where_selection_is_item_submenu
	display_inventory_items "$where_selection_is_item_menu"
	display_submenu "$where_selection_is_item_submenu"
	display_toss_quantity
	get_item_data "$where_selection_is_item_menu" # get data about the item we have selected.
	read -n1 input < /dev/tty
	case $input in
	w) tossQuantity=$(( $tossQuantity + 1 )) ; adjust_toss_quantity ;;
	s) tossQuantity=$(( $tossQuantity - 1  )) ; adjust_toss_quantity ;;
	a) exit ;;
	esac
done
