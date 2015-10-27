#!bin/bash

source character_files/character.cfg
source map_files/maps.cfg
source tools.sh

get_map_info(){
map="${maps[$current_map_char_is_on]}"
x="${starting_x_coords[$current_map_char_is_on]}"
y="${starting_y_coords[$current_map_char_is_on]}"
}

get_map_info
echo "before load_new_map"
echo $map
echo "$x, $y"

# set new x and y values, these would normally be set by the player

x=14
y=3

load_new_map(){
  # this only works for going from map 0 to map x
  if [ "$current_map_char_is_on" -eq 0 -a "$y" -eq 3 ]; then
    if [ "$x" -eq 13 -o "$x" -eq 14 ]; then
      change_conf_value "character_files/character.cfg" "current_map_char_is_on" 1
      source character_files/character.cfg
    fi
  fi
}
load_new_map
get_map_info
echo "after load_new_map"
echo $map
echo "$x, $y"
