#!bin/bash

map_function_conditions(){

	canWeMove="yes" # this will be one of a few similar variables, eg. canWeCut would be present here, defaulting as "no", if there were a tree to cut down on the map.

  	# map swaps - always have to come before stops
  	# enter leftmost house
	if [ "$y_element" -eq 9 ]; then

		if [ "$x_element" -eq 9 -o "$x_element" -eq 10 ]; then
			change_conf_value "character_files/character.cfg" "current_map_char_is_on" 2
			get_new_map_info_set_start_pos 6 4 
		fi

    # go to route blahblah
	elif [ "$y_element" -eq 1 -a "$x_element" -ge 21 -a "$x_element" -le 24 ]; then
			change_conf_value "character_files/character.cfg" "current_map_char_is_on" 3
			get_new_map_info_set_start_pos 16 12
	fi

  	# stop being able to walk through the leftmost house
	if [ \
		\( "$y_element" -eq 6 -a "$x_element" -ge 10 -a "$x_element" -le 15 \) -o \
		\( "$y_element" -eq 7 -a "$x_element" -ge 9 -a "$x_element" -le 16 \) -o \
		\( "$y_element" -ge 8 -a "$y_element" -le 9 -a "$x_element" -eq 8 \) -o \
		\( "$y_element" -ge 8 -a "$y_element" -le 9 -a "$x_element" -ge 11 -a "$x_element" -le 17 \) \
		]; then
		canWeMove="no"
	fi

	# stop being able to walk through the rightmost house
	if [ \
		\( "$y_element" -eq 6 -a "$x_element" -ge 29 -a "$x_element" -le 34 \) -o \
		\( "$y_element" -eq 7 -a "$x_element" -ge 9 -a "$x_element" -le 16 \) -o \
		\( "$y_element" -ge 8 -a "$y_element" -le 9 -a "$x_element" -eq 8 \) -o \
		\( "$y_element" -ge 8 -a "$y_element" -le 9 -a "$x_element" -ge 11 -a "$x_element" -le 17 \) \
		]; then
		canWeMove="no"
	fi

	# Stop being able to walk through Oak's mansion
	if [ \
		\( "$y_element" -eq 12 -a "$x_element" -ge 20 -a "$x_element" -le 35 \) -o \
		\( "$y_element" -ge 13 -a "$y_element" -le 14 -a "$x_element" -ge 19 -a "$x_element" -le 36 \) -o \
		\( "$y_element" -eq 15 -a "$x_element" -ge 19 -a "$x_element" -le 26 \) -o \
		\( "$y_element" -eq 15 -a "$x_element" -ge 29 -a "$x_element" -le 36 \) \
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

#------- Quests ---------#


	# first_oak_quest
	if [ "$y_element" -eq 2 -a "$x_element" -ge 21 -a "$x_element" -le 24 ]; then
		# function is from pallet_town_quests.sh, which is sourced 
		first_oak_quest
	fi

#------- /Quests ---------#

	
}


interaction(){

	# signpost thing
	if [ "$y_element" -eq 10 -a "$x_element" -ge 4 -a "$x_element" -le 6 ]; then
#		echo "Sign post: \"Gary's house\"" TEMPORARILY CHANGED FOR TESTING
		move_map_element 24 10 21 10 L T "$map"
	fi

	if [ "$y_element" -eq 10 -a "$x_element" -ge 23 -a "$x_element" -le 25 ]; then
		echo "Sign post: \"My house\""
	fi


}


