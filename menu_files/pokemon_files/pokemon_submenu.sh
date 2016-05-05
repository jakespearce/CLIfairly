#!/bin/bash

pokemon_menu_file="/dev/shm/pokemon_menu"
pokemon_submenu_file="/dev/shm/submenu_pokemon_menu"
hiOn=$( tput smso )
hiOff=$( tput rmso )
menu_height=$( wc -l < "$pokemon_submenu_file" )
where_selection_is=1
switch="${HOME}/pokemon/gui/menu_files/pokemon_files/switch.sh"
stats="${HOME}/pokemon/gui/menu_files/pokemon_files/stats.sh"


while read line; do
	pokemon_menu_position="$line"
done < where_selection_is_pokemon_menu

#make some decisions about what each item does. 
display_submenu(){

	count=0
	while read line_item HM_id; do
		((count++))
		if [ "$where_selection_is" -eq "$count"  ]; then
			echo $hiOn "$line_item" $hiOff
		else
			echo "$line_item"
		fi
	done < "$pokemon_submenu_file"

}

display_pokemon_menu() {

    IFS_OLD=$IFS
    IFS=""
    count=0;
    while read -r line; do
        ((count++))
        divisible_four=$(( $count % 4 ))
        if [ "$divisible_four" -eq 0 ]; then
            : # no-op command
        else
            upper_limit_selection=$(( $pokemon_menu_position + 1 ))
            if [ "$count" -ge "$pokemon_menu_position" -a "$count" -le "$upper_limit_selection" ]; then
                echo $hiOn $line $hiOff
            else
                echo $line
            fi  
        fi  
    done < "$pokemon_menu_file"
    IFS=$IFS_OLD
}


# make sure we don't fly off the menu
keep_selection_in_range(){

  # replace these with builtin tests
    if [ "$where_selection_is" -lt 1 ]; then
        where_selection_is=$(( $where_selection_is + 1 ))
    elif [ "$where_selection_is" -gt "$menu_height" ]; then
        where_selection_is=$(( $where_selection_is - 1 ))
    fi

}

select_menu_item(){

	count=0
	while read line_item HM_id; do
		((count++))
		if [ "$count" -eq "$where_selection_is" ]; then
			if [ "${#HM_id}" -gt 0 ]; then
				# This is where the script for a particular HM move would be called. .
				echo "temp dev - $HM_id"
				sleep 2
			else
				# todo: the stats script and the switch script. bug town right here.
				echo "temp dev - this is where the "${line_item}" script would be called"
				[[ $line_item == "STATS" ]] &&  bash "$stats" ; exit
				[[ $line_item == "SWITCH" ]] &&  bash "$switch" ; exit
				[[ $line_item == "CANCEL" ]] &&  rm "$pokemon_submenu_file" ; exit 
			fi
		fi

	done < "$pokemon_submenu_file"
}

while :
do

    clear
    keep_selection_in_range
    display_pokemon_menu
	echo " "
    display_submenu
    read -n1 input < /dev/tty
    case $input in
    w) where_selection_is=$(( $where_selection_is -1 )) ;;
    s) where_selection_is=$(( $where_selection_is +1 )) ;;
    d) select_menu_item  ;;
    a) clear ; rm "$pokemon_submenu_file" ; exit ;;
    esac
done

