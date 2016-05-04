#!/bin/bash

where_selection_is=2
hiOn=$( tput smso )
hiOff=$( tput rmso )
pokemon_menu_file="/dev/shm/pokemon_menu"
menu_height=$( wc -l < "$pokemon_menu_file" )
generate_pokemon_menu_script="${HOME}/pokemon/gui/menu_files/pokemon_files/pokemon_menu.sh"
moves_file="${HOME}/pokemon/gui/pokemon_database/common/moves/moves.csv" # this should be a .tab file tbh

# prep
[[ -e "$pokemon_menu_file" ]] && rm "$pokemon_menu_file"
bash "$generate_pokemon_menu_script"

display_menu() {

	IFS_OLD=$IFS
	IFS=""
	count=0;
	while read -r line; do
		((count++))
		divisible_four=$(( $count % 4 ))
		if [ "$divisible_four" -eq 0 ]; then
			: # no-op command
		else
			upper_limit_selection=$(( $where_selection_is + 1 ))
			if [ "$count" -ge "$where_selection_is" -a "$count" -le "$upper_limit_selection" ]; then
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
        where_selection_is=$(( $where_selection_is + 4 ))
    elif [ "$where_selection_is" -gt "$menu_height" ]; then
        where_selection_is=$(( $where_selection_is - 4 ))
    fi  

}

text_prompt(){

	echo "o----------------------------------o"
	echo "|        Choose a pokemon          |"
	echo "o----------------------------------o"
}

generate_submenu(){

	submenu="/dev/shm/submenu_pokemon_menu"
	count=0
	moves_line=$(( $where_selection_is + 2 ))
	while read moveOne moveTwo moveThree moveFour; do
		((count++))
		if [ "$count" -eq "$moves_line" ]; then
			# find the line in moves.csv that

			IFS_OLD=$IFS
			# IFS = tab
			IFS="	"
			for move in $moveOne $moveTwo $moveThree $moveFour; do
				while read move_id move_name TM_HM PP; do
					if [ "$move" -eq "$move_id" -a "$TM_HM" == "HM"  ]; then
						echo "$move_name" > "$submenu"
					fi
				done < "$moves_file"
			done
			IFS=$IFS_OLD
		fi

	done < "$pokemon_menu_file"

	echo "STATS" >> "$submenu"
	echo "SWITCH" >> "$submenu"
	echo "CANCEL" >> "$submenu"

	cat "$submenu"
	sleep 5
	rm "$submenu"

}

# should bring up a sub-menu
#select_menu_item(){

#}

while :
do

	clear
	keep_selection_in_range
	#refresh_menu
	display_menu
	text_prompt
	read -n1 input < /dev/tty
	case $input in
	w) where_selection_is=$(( $where_selection_is -4 )) ;;
	s) where_selection_is=$(( $where_selection_is +4 )) ;;
	d) generate_submenu ;;
	a) clear ; exit ;;
	esac
done


# todo: we need to write the 'actual' menu to a file at some point. We need to cat it every now and again when we need to clear the screen (eg. annoying input characters appearing)
# moves.csv needs to be refactored: moves.tab
# this sub menu is essentially ANOTHER menu script entirely. The trick is to just keep 'cat'ing the 'pokemon menu' on top of it as we interact with the submenu.

