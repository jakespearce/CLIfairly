#!/bin/bash

# this script contains functions common to different menu files.

# make sure we don't fly off the menu
keep_selection_in_range(){

	where_selection_is=$1
	selection_adjuster=$2

    if [ "$where_selection_is" -lt 1 ]; then
        where_selection_is=$(( $where_selection_is + $selection_adjuster ))
    elif [ "$where_selection_is" -gt "$menu_height" ]; then
        where_selection_is=$(( $where_selection_is - $selection_adjuster ))
    fi  

}


