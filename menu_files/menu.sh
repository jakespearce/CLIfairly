#!/bin/bash

source menus.cfg
source ${HOME}/pokemon/gui/tools.sh

# echo "$hiOn $menu_item $hiOff" will result in $menu_item appearing highlighted.
hiOn=$( tput smso )
hiOff=$( tput rmso )

# always start with where_selection_is at 1, so we're at the top of any menu we land on
where_selection_is=1

# $current_menu will be a path to a menu file, determined by menus.cfg
current_menu=${menu[${current_menu_in_view_x},${current_menu_in_view_y}]}
menu_height=$( wc -l < $current_menu )
cat $current_menu > /dev/shm/marked_menu
# problem - it's not registering our 2d array COS YOU DIDN'T DECLARE IT IDIO

echo $current_menu

sleep 2

show_menu(){
  # we're expecting to see possibly 2 columns in our marked_menu. the first one is the menu item eg. ITEM, the second is a marker that determines whether that menu item appears highlighted, eg. a line in /dev/shm/marked_menu that appeared as "ITEM selected" would appear to the player as ITEM, but highlighted
  while read menu_item selected; do
    if [[ "$selected" == "selected" ]]; then
      echo "$hiOn $menu_item $hiOff"
    else
      echo "$menu_item"
    fi
  done < /dev/shm/marked_menu
}

refresh_menu(){
  # this is where we 'mark' the menu so that the show_menu function actually works
  local count=;
  while read menu_line; do
    ((count++))
    if [ "$count" -eq "$where_selection_is" ]; then
      echo $menu_line "selected"
    else
      echo $menu_line
    fi
  done < $current_menu > /dev/shm/marked_menu
}

keep_selection_in_range(){
  # replace these with builtin tests
  if [ "$where_selection_is" -lt 1 ]; then
    where_selection_is=$(( $where_selection_is + 1 ))
  elif [ "$where_selection_is" -gt "$menu_height" ]; then
    where_selection_is=$(( $where_selection_is - 1 ))
  fi
}

# interesting thing: whenever we load a menu for the first time, immediately add 1 to the $current_menu_in_view_x
# this could resolve as menu[1,2]; this would refer to the second menu down (2) that was located on the first menu tier (1)
# if we were viewing the contents of menu 2 and we selected the 4th menu down on there, then the menu we'd see would be menu[2,4]
# a plan: change the value of $current_menu to, say, ${pokedex[${current_menu_in_view_x},${current_menu_in_view_y}]}

select_menu_item(){
  local count=;
  while read menu_line selected; do
    ((count++))
    if [ "$selected" == "selected" ]; then
      echo "you tried to open the sub menu that was on line ${count}"
      sleep 2
      change_conf_value "menus.cfg" "current_menu_in_view_y" $count
      change_conf_value "menus.cfg" "current_menu_in_view_x" $(( $current_menu_in_view_x + 1 ))
      sleep 2
      source menus.cfg
      current_menu=${menu[${current_menu_in_view_x},${current_menu_in_view_y}]}
      echo $current_menu
      sleep 2
      # reset selection so we start at the top again, possibly do this somewhere else tho
      where_selection_is=1
	# reset menu height
	menu_height=$( wc -l < $current_menu )
      refresh_menu
    fi
  done < /dev/shm/marked_menu
}

while :
do
  clear
  keep_selection_in_range
  refresh_menu
  show_menu
  read -n1 input
  case $input in
    w|W) where_selection_is=$(( $where_selection_is - 1 )) ;;
    s|S) where_selection_is=$(( $where_selection_is + 1 )) ;;
    # empty string is enter key
    "") select_menu_item ;;
  esac
done
