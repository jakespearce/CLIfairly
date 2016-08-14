#!/bin/bash

# this should be sourced from somewhere else
character_progress="${HOME}/pokemon/gui/character_files/character_progress.tab"

# So far this function is essentially a rough demo of how to 'move' multiple elements across the map
first_oak_quest(){

	# return 0: successful exit status that exits the function, not excecuting any further code.
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


	# Change of direction as we go past the top of Oak's mansion. X goes west, player character goes south
	change_map_element 21 11 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 20 11 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 21 10 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	change_map_element 20 11 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 19 11 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 21 11 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	change_map_element 19 11 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 19 12 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 20 11 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	change_map_element 19 12 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 18 12 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 19 11 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	change_map_element 18 12 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 18 13 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 19 12 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	change_map_element 18 13 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 18 14 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 18 12 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	change_map_element 18 14 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 18 15 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 18 13 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	change_map_element 18 15 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 18 16 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 18 14 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5



	# At this point, we've turned the bottom left hand corner on Oak's mansion.
	change_map_element 18 16 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 19 16 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 18 15 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	change_map_element 19 16 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 20 16 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 18 16 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	change_map_element 20 16 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 21 16 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 19 16 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	change_map_element 21 16 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 22 16 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 20 16 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	change_map_element 22 16 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 23 16 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 21 16 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	change_map_element 23 16 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 24 16 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 22 16 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	change_map_element 24 16 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 25 16 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 23 16 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	change_map_element 25 16 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 26 16 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 24 16 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	change_map_element 26 16 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 27 16 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 25 16 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	# At this point, X is walking up into Oak's mansion.
	change_map_element 27 16 C "$map" $map_width
	mark_source_map "$map"
	change_map_element 27 15 X "$map" $map_width
	mark_source_map "$map"

	change_map_element 26 16 "." "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5


	# At this point, we need X to disappear. X is walking into the house so we replace it with the floor tile of the door. This is also where we set line 2 of character_files/character_progress.tab to complete (so we can have access to the mansion)
	change_map_element 27 15 '[' "$map" $map_width
	mark_source_map "$map"
	# Now we change the quest progress value in line 2 of character_files/character_progress.tab. 
	# change_quest_progress $target_quest $progress_value
	change_quest_progress_value 2 1
	display_map
	mark_source_map "$map"


 	#TODO Monday: Figure out why oak_mansion doesn't display immediately when player enters map. This is strange because this works fine with the inside_house map

	#TODO 0) Build the Oak mansion map
	#1) We need to built a portal to Oak's mansion from the actual Pallet town map.
	# This portal needs to be one map element 'higher' (one Y less in our map's language) than we think it should be (as it would be nice to have the effect of the player walking onto Oak's door and THEN appearing on the new map.
	# The following constraints apply to entering Oak's mansion: 1. You can't enter unless quest 1 (line2) in character_files/character_progress.tab reads 1.
	#TODO The above is done (kind of)
	# You can't leave Oak's mansion unless quest2 (line4) reads 1


	# finally we change y to the value that the player should be on had they'd moved to the new pos themselves
	# the formula is y or x = distance travelled - 1. Then make up the -1 by calling a move function in that direction.
	# This part is now deprecated. We'll be in Oak's mansion by the time we give control back to the player.
	#y=11
	#down

}

