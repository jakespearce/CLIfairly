#!/bin/bash

map_function_conditions(){

	canWeMove="yes"

	# Exit Gary's house and return to Pallet Town
	if [ \
		\( "$y_element" -eq 9 -a "$x_element" -ge 8 -a "$x_element" -le 9 \) \
		]; then
            change_conf_value "character_files/character.cfg" "current_map_char_is_on" 1
            get_new_map_info_set_start_pos 28 10
	fi

	# Stop walking through walls: From top row to bottom: N, E, S, W
	if [ \
		\( "$y_element" -eq 1 -a "$x_element" -ge 1 \) -o \
		\( "$y_element" -ge 1 -a "$x_element" -eq 23 \) -o \
		\( "$y_element" -ge 10 -a "$x_element" -ge 10 \) -o \
		\( "$y_element" -ge 10 -a "$x_element" -le 7 \) -o \
		\( "$y_element" -ge 1 -a "$x_element" -eq 1 \) \
		 ]; then
		canWeMove="no"

	# Bookshelf top left hand corner
	elif [ \
		\( "$y_element" -eq 2 -a "$x_element" -ge 2 -a "$x_element" -le 5 \) \
		]; then
		canWeMove="no"

	# Bookshelf top right hand corner
	elif [ \
		\( "$y_element" -eq 2 -a "$x_element" -ge 20 \) \
		]; then
		canWeMove="no"

	# Table in room's center
	elif [ \
		\( "$y_element" -eq 4 -a "$x_element" -ge 10 -a "$x_element" -le 14 \) -o \
		\( "$y_element" -ge 5 -a "$y_element" -le 6 -a "$x_element" -ge 9 -a "$x_element" -le 15 \) \
		]; then
		canWeMove="no"

	# Plant in bottom right hand corner
	elif [ \
		\( "$y_element" -eq 9 -a "$x_element" -eq 22 \) \
		]; then
		canWeMove="no"

	# Plant in bottom left hand corner
	elif [ \
		\( "$y_element" -eq 9 -a "$x_element" -eq 2 \) \
		]; then
		canWeMove="no"

	# Gary's sister (The X)
	elif [ \
		\( "$y_element" -eq 7 -a "$x_element" -eq 17 \) \
		]; then
		canWeMove="no"
	fi
}


interaction(){

	# Bookshelf top left
	if [ \
		\( "$y_element" -eq 3 -a "$x_element" -le 6 \) \
		]; then
		rolling_dialogue 1 1 "$current_map_text_prompts"

	elif [ \
		\( "$y_element" -eq 2 -a "$x_element" -ge 10 -a "$x_element" -le 14 \) \
		]; then
		rolling_dialogue 2 2 "$current_map_text_prompts"

	# Bookshelf top right
	elif [ \
		\( "$y_element" -eq 3 -a "$x_element" -ge 18 \) \
		]; then
		rolling_dialogue 1 1 "$current_map_text_prompts"

	# Gary's sister
	elif [ \
		\( "$y_element" -ge 6 -a "$y_element" -le 8 -a "$x_element" -ge 16 -a "$x_element" -le 18 \) \
		]; then
		rolling_dialogue 6 7 "$current_map_text_prompts"

	# Plant bottom right
	elif [ \
		\( "$y_element" -ge 8 -a "$x_element" -ge 21 \) \
		]; then
		rolling_dialogue 3 3 "$current_map_text_prompts"

	# Plant bottom left
	elif [ \
		\( "$y_element" -ge 8 -a "$x_element" -le 3 \) \
		]; then
		rolling_dialogue 3 3 "$current_map_text_prompts"
	fi
}
