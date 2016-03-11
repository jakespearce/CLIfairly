#!/bin/bash

source ${HOME}/pokemon/gui/tools.sh

pokedex_files=${HOME}/pokemon/gui/menu_files/pokedex_files

# echo "$hiOn $menu_item $hiOff" will result in $menu_item appearing highlighted.
hiOn=$( tput smso  )

hiOff=$( tput rmso  )

where_selection_is=1

# could hard code 151 BUT WE GOTTA THINK OF THE SEQUEL BABY
pokedex_height=$( wc -l < "${pokedex_files}/pokedex"  )


keep_selection_in_range(){

  # replace these with builtin tests
    if [ "$where_selection_is" -lt 1 ]; then
        where_selection_is=$(( $where_selection_is + 1 ))
    elif [ "$where_selection_is" -gt "$pokedex_height" ]; then
        where_selection_is=$(( $where_selection_is - 1 ))
    fi
}


# for displaying the pokedex when we first run pokedex.sh
# this is pretty much the refresh_menu function from menu.sh
refresh_pokedex(){

	count=;
	while read id name seen own; do

		((count++))

		# for when that item is 'selected'
		if [ "$count" -eq "$where_selection_is" ]; then
			# if we've not seen the pokemon before and not caught it
			if [ "$seen" -eq 0 -a "$own" -eq 0 ]; then
				echo "---------" "selected"
			
			# if we've seen the pokemon before and not caught it
			elif [ "$seen" -eq 1 -a "$own" -eq 0 ]; then
				echo $name "selected"

			# if we've seen the pokemon before and caught it
			else
				echo "${name}*" "selected"
			fi

		# for when an item is not 'selected'
		else
            # if we've not seen the pokemon before and not caught it
            if [ "$seen" -eq 0 -a "$own" -eq 0 ]; then
                echo "---------"
                
            # if we've seen the pokemon before and not caught it
            elif [ "$seen" -eq 1 -a "$own" -eq 0 ]; then
                echo $name

            # if we've seen the pokemon before and caught it
            else
                echo "${name}*"
			fi
		fi
	
	done < "${pokedex_files}/pokedex" > /dev/shm/marked_pokedex
				
}


show_pokedex(){

	while read name selected; do
		
		if [ "$selected" == "selected"  ]; then
			echo "$hiOn $name $hiOff"
		else
			echo "$name"
		fi

	done < /dev/shm/marked_pokedex

}


input_prompt(){

	while :
	do 

		clear
		keep_selection_in_range
		refresh_pokedex
		show_pokedex

		# why from /dev/tty? 
		# once you get a few shells deep (like we are here) stdin fucks up
		# input < /dev/tty means we'll get input from a new tty session (i think?)
		# if a while loop is a subshell, then we're like 5 deep here or something.
		# gui_and_input while (1) + menu.sh call (2) + menu.sh while (3) + pokedex.sh (4) + pokdex.sh while (5)
		# find out more about this. idgi.
		read -n1 input < /dev/tty
		case $input in
   		    w|W) where_selection_is=$(( $where_selection_is - 1 )) ;;
        	s|S) where_selection_is=$(( $where_selection_is + 1 )) ;;
        	# empty string is enter key
#        	""|d) select_pokemon ;;
        	b) clear ; exit ;;
    	esac

	done
}

input_prompt


