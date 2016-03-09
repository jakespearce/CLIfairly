#!bin/bash
map_function_conditions(){

  	# map swaps - always have to come before stops
  	# enter leftmost house
  	if [ "$newy" -eq 9 ]; then

    	if [ "$newx" -eq 7 -o "$newx" -eq 8 ]; then
      	change_conf_value "character_files/character.cfg" "current_map_char_is_on" 2
      	get_new_map_info_set_starting_pos 6 4
    	fi

    # go to route blahblah
  	elif [ "$newy" -eq 1 -a "$newx" -ge 21 -a "$newx" -le 24 ]; then
    	change_conf_value "character_files/character.cfg" "current_map_char_is_on" 3
    	get_new_map_info_set_starting_pos 16 12
  	fi

  	# stop being able to walk through the rightmost house
  	if [ "$newy" -eq 6 -a "$newx" -ge 8 -a "$newx" -le 13 ]; then
    	stop
  	elif [ "$newy" -eq 7 -a "$newx" -ge 7 -a "$newx" -le 14 ]; then
    	stop
  	elif [ "$newy" -ge 8 -a "$newy" -le 9 -a "$newx" -ge 6 -a "$newx" -le 15 ]; then
    	stop
  	fi
}


interaction(){

  # signpost thing
  	if [ "$y" -eq 9 -a "$x" -eq 31 ]; then
    	echo "Sign post: \"Welcome to pallet town!\""
  	fi
}
