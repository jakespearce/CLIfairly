#!bin/bash
map_function_conditions(){

  	if [ "$newy" -eq 3 -a "$newx" -eq 2 ]; then
    	stop
  	fi

  	# map changes
	# couldn't this shit somehow be more elegant? have some decorum you swine
  	if [ "$current_map_char_is_on" -eq 2 -a "$y" -eq 5 ]; then
    	if [ "$x" -eq 6 -o "$x" -eq 7 ]; then
      		change_conf_value "character_files/character.cfg" "current_map_char_is_on" 1
      		get_new_map_info_set_starting_pos 7 10
    	fi
  	fi
}
