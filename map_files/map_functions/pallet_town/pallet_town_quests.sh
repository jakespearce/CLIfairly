#!/bin/bash

# this should be sourced from somewhere else
character_progress="${HOME}/pokemon/gui/character_files/character_progress.tab"

# So far this function is essentially a rough demo of how to 'move' multiple elements across the map
first_oak_quest(){

	# in future, put the quest reader function in map_tools so we've got the function to hand whenever we need it
	get_quest_progress_value 2
	[[ "$quest_status" == 0 ]] && echo "this quest has not been started yet" || echo "this quest is either in progress or complete."

	# The quest triggers at (21,2) The X appears just above us and we're redrawn on the map to mark 
	change_map_element 21 1 X "$map" $map_width
	mark_source_map "$map"
	change_map_element 21 2 C "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5

	change_map_element 21 2 X "$map" $map_width
	mark_source_map "$map"
	change_map_element 21 3 C "$map" $map_width
	mark_source_map "$map"
	#---now we change the previous set of coordinates (21,1) back to what it was, as it no longer has special characters in that position---#
	change_map_element 21 1 w "$map" $map_width
	mark_source_map "$map"
	display_map
	sleep 0.5

	change_map_element 21 3 X "$map" $map_width
	mark_source_map "$map"
	#---Now we only change the element for where X was previously, as we use the down function below to account for C---#
	change_map_element 21 2 w "$map" $map_width

	mark_source_map "$map"


	# finally we change y to the value that the player should be on had they'd moved to the new pos themselves
	# the formula is y or x = distance travelled - 1. Then make up the -1 by calling a move function in that direction.
	y=3
	down

}
