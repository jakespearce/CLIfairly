#!bin/bash

map_function_conditions(){

	canWeMove="yes" # this will be one of a few similar variables, eg. canWeCut would be present here, defaulting as "no", if there were a tree to cut down on the map.

  	# map swaps - always have to come before stops
  	# enter leftmost house
	if [ "$y_element" -eq 9 ]; then

		if [ "$x_element" -eq 7 -o "$x_element" -eq 8 ]; then
			change_conf_value "character_files/character.cfg" "current_map_char_is_on" 2
			get_new_map_info_set_start_pos 6 4 
		fi

    # go to route blahblah
	elif [ "$y_element" -eq 1 -a "$x_element" -ge 21 -a "$x_element" -le 24 ]; then
			change_conf_value "character_files/character.cfg" "current_map_char_is_on" 3
			get_new_map_info_set_start_pos 16 12
	fi


  	# stop being able to walk through the rightmost house
	if [ \
		\( "$y_element" -eq 6 -a "$x_element" -ge 8 -a "$x_element" -le 13 \) -o \
		\( "$y_element" -eq 7 -a "$x_element" -ge 7 -a "$x_element" -le 14 \) -o \
		\( "$y_element" -ge 8 -a "$y_element" -le 9 -a "$x_element" -eq 6 \) -o \
		\( "$y_element" -ge 8 -a "$y_element" -le 9 -a "$x_element" -ge 9 -a "$x_element" -le 15 \) \
		]; then
		canWeMove="no"
	fi

	# map edges starting from west and going clockwise.
	if [ \
		\( "$y_element" -ge 1 -a "$y_element" -le 18 -a "$x_element" -eq 1 \) -o \
		\( "$y_element" -eq 18 -a "$x_element" -ge 1 -a "$x_element" -le 8 \) -o \
		\( "$y_element" -eq 18 -a "$x_element" -ge 15 -a "$x_element" -le 41 \) -o \
		\( "$y_element" -ge 1 -a "$y_element" -le 17 -a "$x_element" -eq 41 \) -o \
		\( "$y_element" -eq 2 -a "$x_element" -ge 1 -a "$x_element" -le 20 \) -o \
		\( "$y_element" -eq 2 -a "$x_element" -ge 25 -a "$x_element" -le 41 \) \
		]; then
		canWeMove="no"
	fi

	
}


interaction(){

	# signpost thing
	if [ "$y_element" -eq 9 -a "$x_element" -eq 31 ]; then
		echo "Sign post: \"Welcome to pallet town!\""
	fi
}

