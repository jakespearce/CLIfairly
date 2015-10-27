#!bin/bash

# character conf file has a value representing what map he's on
source character_files/character.cfg
# map conf file has an array of maps
source map_files/maps.cfg
# tools file, containing useful functions that may be useful all over the place
source tools.sh
# get correct map and starting coords based on $current_map_char_is_on in character.cfg
# the value of $current_map_char_is_on points to arrays in maps.cfg to get the right map data
get_map_info(){
map="${maps[$current_map_char_is_on]}"
# if we want custom x and y values, depending on where we entered the map: could come up with a function that briefly changes the config file for when we load the map, run get_map_info with these modified starting coordinates, then after it's run we change them back.
x="${starting_x_coords[$current_map_char_is_on]}"
y="${starting_y_coords[$current_map_char_is_on]}"
background_art="${background_art_selection[$current_map_char_is_on]}"
# get max_width, useful for things
map_height=$( cat $map | wc -l )
chars_on_map=$( cat $map | wc -c )
# -1 so we ignore the newline character
map_width=$(( $(( $chars_on_map / $map_height )) - 1 ))
# depending on what map the character is on, we load a different set of map functions. see map_function_conditions function
current_map_functions="${map_functions[$current_map_char_is_on]}"
source "$current_map_functions"
}

move(){
  IFS=;
  # where we'll be if it all goes to plan
  newx=$1
  newy=$2
  stop_flag=;
  grass_flag=;
  door_flag=;
  local ycount=1;
  local xcount=1;
  yline_that_x_is_on=;
  # stop the character escaping the map
  if [ "$newx" -gt "$map_width" ]; then
    newx=$(( $x - 1 ))
    x=$(( $x - 1 ))
  elif [ "$newx" -lt 1 ]; then
    newx=$(( $x + 1 ))
    x=$(( $x + 1 ))
  elif [ "$newy" -gt "$map_height" ]; then
    newy=$(( $y - 1 ))
    y=$(( $y - 1 ))
  elif [ "$newy" -lt 1 ]; then
    newy=$(( $y + 1 ))
    y=$(( $y + 1 ))
  fi
  # this function gets called from eg. pallet_town_functions.sh, when the map the char is on is 0. This function is named the same thing for every map, so going to a new map will give us new function conditions
  map_function_conditions
  while read -r row; do
    if [ "$ycount" -eq "$newy" ]; then
      # find y plane we want to be on, then read across until we get to the x value we want to be at, then write the character to that place.
      yline_that_x_is_on=$( echo -n $row )
      xchar_newline_count=;
      while read -rn1 xcharacter; do
        ((xchar_newline_count++))
        if [ "$xcount" -eq "$newx" ]; then
          # here we test for different floor blocks if the char is standing on them
          if [ "$xcharacter" == "O" -o "$xcharacter" == "~" -o "$xcharacter" == " " ]; then
            stop_flag=1
          elif [ "$xcharacter" == "w" ]; then
            grass_flag=1

          # possibly no longer needed as we're controlling doors via the map_function_conditions function now

          # elif [ "$xcharacter" == "[" -o "$xcharacter" == "]" ]; then
          #   door_flag=1
          fi
          echo -n "C"
        else
          # we can colour things in here
          echo -n $xcharacter
        fi
        ((xcount++))
        if [ "$xchar_newline_count" -eq "$map_width" ]; then
          # so the map doesn't render in one massive line
          echo ""
        fi
      done <<< $yline_that_x_is_on
    else
      echo $row
    fi
    ((ycount++))
  done < $map > /dev/shm/marked_map
  echo ""
  [[ $stop_flag ]] && stop
  clear
  [[ $grass_flag ]] && grass
  [[ $door_flag ]] && load_new_map || cat /dev/shm/marked_map
}

input_prompt(){
  read -n1 input
  case $input in
    w) up ;;
    s) down ;;
    a) left ;;
    d) right ;;
    # interaction is a function found whatever the current_map_functions file is set to
    e) clear ; cat /dev/shm/marked_map ; echo "" ; echo -n " " ; interaction ;;
    *) echo "fuck off" ;;
   esac
}

# we can abuse these for teleports and shit
up(){
  y=$(( $y - 1 ))
  move $x $y
}

down(){
  y=$(( $y + 1 ))
  move $x $y
}

left(){
  x=$(( x - 1 ))
  move $x $y
}

right(){
  x=$(( $x + 1 ))
  move $x $y
}

# terrain types
# w
grass(){
  pokemon_appearing_chance=$(( ( RANDOM % 30 ) + 1 ))
  [ $pokemon_appearing_chance -gt 28 ] && echo "pokemon"
}
# O
stop(){ # reverse last $input so it appears the char can't move through stop
  if [ "$input" == "w" ]; then
    down
  elif [ "$input" == "s" ]; then
    up
  elif [ "$input" == "a" ]; then
    right
  else
    left
  fi
}
# ] or [
# load_new_map(){
#   background_art=;
#   # ---all doors for home_map
#   # go to inside_house_from_home_map
#   # if [ "$current_map_char_is_on" -eq 1 -a "$y" -eq 9 ]; then
#   #   if [ "$x" -eq 7 -o "$x" -eq 8 ]; then
#   #     change_conf_value "character_files/character.cfg" "current_map_char_is_on" 2
#   #     get_new_map_info_set_starting_pos 6 4
#   #   fi
#   # ---all doors for inside_house_from_home_map
#   # go to pallet_town
#   #below should just be changed to elif once the other if statemnet is back
#   # if [ "$current_map_char_is_on" -eq 2 -a "$y" -eq 5 ]; then
#   #   if [ "$x" -eq 6 -o "$x" -eq 7 ]; then
#   #     change_conf_value "character_files/character.cfg" "current_map_char_is_on" 1
#   #     get_new_map_info_set_starting_pos 7 10
#   #   fi
#   # fi
# }

get_new_map_info_set_starting_pos(){
  source character_files/character.cfg
  # get_map_info sets the default x and y for the map, however if we're coming into the map through one of the map's multiple entrance points, then the default values for the map may not make sense
  get_map_info
  x=$1
  y=$2
  move $x $y
}

echo "Press w a s or d to continue......."

# for when we load up the game
get_map_info

while true; do
  input_prompt
done
