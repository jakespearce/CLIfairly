#!/bin/bash

# this should be sourced from somewhere else
character_progress="${HOME}/pokemon/gui/character_files/character_progress.tab"

# So far this function is essentially a rough demo of how to 'move' multiple elements across the map
first_oak_quest(){

	# in future, put the quest reader function in map_tools so we've got the function to hand whenever we need it
	# ^ It's actually in tools.sh, which seems like a more sensible place?
	get_quest_progress_value 2
	[[ $quest_status -ne 0 ]] && return 0

	# Hey! Wait! Don't go out!
	rolling_dialogue 8 8 "$current_map_text_prompts"

	# This is the part where oak walks up to the player. He then proceeds to say some more shit after appearing.
	move_map_element 21 6 21 3 'X' '.' "$map"

	# He then proceeds to say some shit after appearing
	rolling_dialogue 9 13 "$current_map_text_prompts"

	# WARNING: The code below is objectively terrible. 
	# There exists a function to move an individual character across the map but not two characters.
	# Since this is a one time occurrence I'll leave this be until I figure out it happens somewhere else 
	# other than here.

	# The quest triggers at (21,2) The X appears just below us and we're redrawn on the map to mark 

	change_map_element 21 2 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 21 3 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 21 1 "w" "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5

	change_map_element 21 3 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 21 4 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 21 2 "w" "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5

	change_map_element 21 4 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 21 5 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 21 3 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5

	change_map_element 21 5 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 21 6 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 21 4 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	change_map_element 21 6 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 21 7 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 21 5 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	change_map_element 21 7 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 21 8 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 21 6 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	change_map_element 21 8 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 21 9 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 21 7 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	change_map_element 21 9 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 21 10 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 21 8 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	change_map_element 21 10 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 21 11 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 21 9 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5

	# TODO: Code the rest of us walking into Oak's mansion.

	mark_source_map "$map"


	# finally we change y to the value that the player should be on had they'd moved to the new pos themselves
	# the formula is y or x = distance travelled - 1. Then make up the -1 by calling a move function in that direction.
	# This part is now deprecated. We'll be in Oak's mansion by the time we give control back to the player.
	y=10
	down

}
