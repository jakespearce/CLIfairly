hiOn=$( tput smso )
hiOff=$( tput rmso )

where_selection_is=1
current_menu="menuOne"
menu_height=$( cat main_menu | wc -l )
cat main_menu > marked_main_menu

show_menu(){
  while read menu_item selected; do
    if [[ "$selected" == "selected" ]]; then
      echo "$hiOn $menu_item $hiOff"
    else
      echo "$menu_item"
    fi
  done < marked_main_menu # will have to be some sort of marked menu
}

refresh_menu(){
  local count=;
  while read menu_line; do
    ((count++))
    if [ "$count" -eq "$where_selection_is" ]; then
      echo $menu_line "selected"
    else
      echo $menu_line
    fi
  done < main_menu > marked_main_menu
}

keep_selection_in_range(){
  # replace these with builtin tests
  if [ "$where_selection_is" -lt 1 ]; then
    where_selection_is=$(( $where_selection_is + 1 ))
  elif [ "$where_selection_is" -gt "$menu_height" ]; then
    where_selection_is=$(( $where_selection_is - 1 ))
  fi
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
    # clear
    # refresh_menu ;;
    s|S) where_selection_is=$(( $where_selection_is + 1 )) ;;
    # clear
    # refresh_menu ;;
  esac
done
