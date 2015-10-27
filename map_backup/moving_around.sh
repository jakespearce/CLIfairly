#!bin/bash

# x and y must be set initially for our starting position on the map. simply doing move 2 2 then running input_prompt will mean that either one of y or x at the prompt will = ''
x=2;
y=2;

# temporarily outside map info for testing. map should be a variable based on where the character is in the world.
map_height=$( cat map | wc -l )
chars_on_map=$( cat map | wc -c )
# -1 so we ignore the newline character
map_width=$(( $(( $chars_on_map / $map_height )) - 1 ))

get_map_info(){
  # eventually we want to read a config file that tells us what map we're on, then set that map name as the $map variable
  # maybe have a map config file that tells us where we start on that map
  map_height=$( cat map | wc -l )
  chars_on_map=$( cat map | wc -c )
  # -1 so we ignore the newline character
  map_width=$(( $(( $chars_on_map / $map_height )) - 1 ))
}

move(){
  newx=$1
  newy=$2
  rock_flag=;
  grass_flag=;
  local ycount=1;
  local xcount=1;
  while read row; do
    if [ "$ycount" -eq "$newy" ]; then
      # find y plane we want to be on, then read across until we get to the x value we want to be at, then write the character to that place.
      ( echo $row > yline_that_x_is_on )
      xchar_newline_count=;
      while read -n1 xcharacter; do
        ((xchar_newline_count++))
        if [ "$xcount" -eq "$newx" ]; then
          # here we test for different floor blocks if the char is standing on them
          if [ "$xcharacter" == "O" ]; then
            rock_flag=1
          elif [ "$xcharacter" == "w" ]; then
            grass_flag=1
          fi
          echo -n "C"
        else
          # we can colour things in here
          echo -n $xcharacter
        fi
        ((xcount++))
        if [ "$xchar_newline_count" -eq "$map_width" ]; then
          echo "" # get this shit on a new line, hardcoding 7 at the moment but 7 has to be the maximum value of x
        fi
      done < yline_that_x_is_on
    else
      echo $row
    fi
    ((ycount++))
  done < map > tmp/marked_map
  echo ""
  [[ $rock_flag ]] && rock
  clear
  [[ $grass_flag ]] && grass
  cat house_art # drop dope ascii art into the background
  cat tmp/marked_map
}

input_prompt(){
  read -n1 input
  case $input in
    w) up ;;
    s) down ;;
    a) left ;;
    d) right ;;
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
rock(){ # reverse last $input so it appears the char can't move through rock
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

move $x $y # starting pos on map

while true; do
  input_prompt
done
