#!/bin/bash

# visual component:
# user selects a pokemon using 'switch'. the user should be able to navigate the menu normally and select another pokemon for the switch. 
# at this point we simply swap the ordering of the values in /gui/character_files/pokemon_in_inventory.csv
# we then re-generate the gui component of the pokemon menu.
pokemon_in_inventory="${HOME}/pokemon/gui/character_files/pokemon_in_inventory.csv"
pokemon_menu_directory="${HOME}/pokemon/gui/menu_files/pokemon_files"
hiOn=$( tput smso )
hiOff=$( tput rmso )
pokemon_menu_file="/dev/shm/pokemon_menu"
menu_height=$( wc -l < "$pokemon_menu_file" )
# we'll use this postion value for the pokemon we selected for the switch
while read line; do
    pokemon_menu_position="$line"
done < where_selection_is_pokemon_menu

# our starting position for this script will be the same starting position as where the pokemon to switch is
where_selection_is=$pokemon_menu_position

# todo: get the pokemonUniqueID for the pokemon that corresponds to where_selection_is
# i don't think this needs to be a function
get_pokemon_to_swap(){

	count=0
	target_line=$(( $where_selection_is + 2 ))
	while read moveOne moveTwo moveThree moveFour pokemonUniqueID; do
		((count++))
		if [ "$count" -eq "$target_line" ]; then
			pokemonUniqueID_to_swap="$pokemonUniqueID"
		fi
	done < "$pokemon_menu_file"

}
get_pokemon_to_swap

get_the_swapee(){

    count=0
    target_line=$(( $where_selection_is + 2 ))
    while read moveOne moveTwo moveThree moveFour pokemonUniqueID; do
        ((count++))
        if [ "$count" -eq "$target_line" ]; then
            pokemonUniqueID_swapee="$pokemonUniqueID"
        fi  
    done < "$pokemon_menu_file"
}

the_swap(){

	temp_pokemon_in_inventory="${pokemon_menu_directory}/temp_pokemon_in_inventory.csv"
	touch "$temp_pokemon_in_inventory"
	IFS_OLD=$IFS
	IFS="."
	while read inventory_pokemonUniqueID pokemonID; do
		if [ "$inventory_pokemonUniqueID" -eq "$pokemonUniqueID_to_swap" ]; then
			echo "${pokemonUniqueID_swapee}.${pokemonID}" >> "$temp_pokemon_in_inventory"
		elif [ "$inventory_pokemonUniqueID" -eq "$pokemonUniqueID_swapee" ]; then
			echo "${pokemonUniqueID_to_swap}.${pokemonID}" >> "$temp_pokemon_in_inventory"
		else
			echo "${inventory_pokemonUniqueID}.${pokemonID}" >> "$temp_pokemon_in_inventory"
		fi
	done < "$pokemon_in_inventory"
	IFS=$IFS_OLD

	mv "$temp_pokemon_in_inventory" "$pokemon_in_inventory"
	clear
	bash "${pokemon_menu_directory}/pokemon_menu.sh"

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
			upper_limit_new_position=$(( $where_selection_is + 1 ))
            if [ "$count" -ge "$pokemon_menu_position" -a "$count" -le "$upper_limit_selection" ]; then
                echo $hiOn $line $hiOff
			elif [ "$count" -ge "$where_selection_is" -a "$count" -le "$upper_limit_new_position" ]; then
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
    echo "|       Move pokemon where?        |"
    echo "o----------------------------------o"
}


while :
do

    clear
    keep_selection_in_range
    display_pokemon_menu
    text_prompt
	get_the_swapee
    read -n1 input < /dev/tty
    case $input in
    w) where_selection_is=$(( $where_selection_is -4 )) ;;
    s) where_selection_is=$(( $where_selection_is +4 )) ;;
    d) the_swap ; exit ;; # this is where our function for swapping the position of the pokemon in inventory should go
    a) clear ; exit ;;
    esac
done

# todo: we need to write the swap function.

