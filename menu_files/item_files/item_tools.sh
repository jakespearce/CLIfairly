#!/bin/bash

inventory_items_path="${HOME}/pokemon/gui/menu_files/item_files/inventory_items.tab"
item_submenu_file="${HOME}/pokemon/gui/menu_files/item_files/item_submenu"
hiOn=$( tput smso )
hiOff=$( tput rmso )
where_selection_is_file_item_menu="${HOME}/pokemon/gui/menu_files/item_files/where_selection_is_items"


get_where_selection_is_item_menu(){

	while read value; do
		where_selection_is_item_menu="$value"
	done < "$where_selection_is_file_item_menu"
}

reposition_item_menu_window(){


    if [ "$inventory_item_selection" -lt "$B" -a "$B" -ne 1 ]; then
        B=$(( $B - 1 ))
        F=$(( $F - 1 ))
    
	# menu height needs to be sourced from the correct place.
    elif [ "$inventory_item_selection" -gt "$F" -a "$F" -ne "$menu_height" ]; then 
        B=$(( $B + 1  ))
        F=$(( $F + 1 ))
    fi 
}


display_inventory_items(){

	inventory_item_selection=$1
	reposition_item_menu_window
	local count=0
	OLD_IFS=$IFS
	IFS="	" # tab
	while read itemID_ itemName_ itemContext_ itemQuantity_ subMenu_; do
		((count++))
		itemName="$itemName_"
		itemID="$itemID_"
		itemQuantity="$itemQuantity_"
		itemContext="$itemContext_"
		subMenu="$subMenu_"

		if [ "$count" -ge "$B" -a "$count" -le "$F" ]; then
			if [ "$count" -eq "$inventory_item_selection" ]; then
				echo $hiOn "$itemName" $hiOff
			else
				echo "$itemName"
			fi
		fi

	done < "$inventory_items_path"
	IFS=$IFS_OLD
	unset count
}

# where_selection_is COULD cause conflicts if we're using this in conjunction with another menu such as the pokemon menu.
# when we use an item on a pokemon, we're taken back to the main pokemon menu and we find ourselves at the top of the menu. worth bearing in mind.
display_submenu(){

	local count=0
	while read subMenuOption_; do
		((count++))
		subMenuOption="$subMenuOption_"

		# $where_selection_is_submenu is set in the interact_item_submenu.sh script
		if [ "$where_selection_is" -eq "$count" ]; then
			echo $hiOn "$subMenuOption" $hiOff
		else
			echo "$subMenuOption"
		fi

	done < "$item_submenu_file"
}

# what's count doing in this function?
get_item_data(){

	local count=0
	OLD_IFS=$IFS
	IFS="	" # tab
	while read itemID_ itemName_ itemContext_ itemQuantity_ subMenu_; do		
		((count++))
		itemName="$itemName_"
		itemID="$itemID_"
		itemQuantity="$itemQuantity_"
		itemContext="$itemContext_"
		subMenu="$subMenu_"

	done < "$inventory_items_path"

}


