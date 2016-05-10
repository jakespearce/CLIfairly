#!/bin/bash

source "${HOME}/pokemon/gui/tools/tools.sh" # calculate_whitespace is sourced from here
pokemon_art_path="${HOME}/pokemon/gui/pokemon_database/art"
where_selection_is_pokemon_menu_file="${HOME}/pokemon/gui/menu_files/pokemon_files/where_selection_is_pokemon_menu"
owned_pokemon="${HOME}/pokemon/gui/character_files/owned_pokemon"
while read value; do
	pokemon_menu_hidden_values_line="$(( $value + 2 ))"
done < "$where_selection_is_pokemon_menu_file"
pokemon_menu_file="/dev/shm/pokemon_menu"
blockOne="/dev/shm/blockOne"
blockTwo="/dev/shm/blockTwo"
blockThree="/dev/shm/blockThree"
blockFour="/dev/shm/blockFour"
blockFive="/dev/shm/blockFive"
whitespace_character=" "

# get the ID of the pokemon that is currently selected in the pokemon menu:
count=0
while read moveOne moveTwo moveThree moveFour pokemonUniqueID; do
	((count++))
	if [ "$count" -eq "$pokemon_menu_hidden_values_line" ]; then
		selectedPokemon="$pokemonUniqueID"
	fi
done < "$pokemon_menu_file"
unset count

pokemonFileToRead="${owned_pokemon}/${selectedPokemon}.*"
read_pokemon_file $pokemonFileToRead
pokemon_Art="${pokemon_art_path}/${pokemonName}.art"
artLength="$( wc -L < "$pokemon_Art" )"

# calculates the number of empty lines that should be on top of a given block so that the block sits level with the pokemon art. Only used for blockOne and blockSomethingIForgot
calculate_topSpace(){

block=$1
artHeight=$( wc -l < "$pokemon_Art" )
blockHeight=$( wc -l < "$block" )
topSpace=$(( $artHeight - $blockHeight ))
local count=0
while [ "$count" -le "$topSpace" ]; do
	((count++))
	echo -e "\n$(cat "$block")" > "$block"
done
}

# creates 5 separate blocks of gui that we combine with an .art file to create each of the two stats screens
# Without correct whitespace.. 

#blockOne (stat screen one): 
#
# $POKEMONNAME
# L $pokemon_level
# HP: #########--------
#    $currentHP / $maxHP
# STATUS / $mainAilment
touch "$blockOne"
calculate_whitespace 16 ${#pokemonName} $whitespace_character
echo "     ${pokemonName}${whitespace}|" >> "$blockOne"
calculate_whitespace 12 ${#level} $whitespace_character
echo "       L:${level}${whitespace}|" >> "$blockOne"
draw_HPbar $currentHP $HP 10
echo "    hp:${populated_HPbar}${unpopulate_HPbar}    |" >> "$blockOne"
HP_value_display="${currentHP} / ${HP}"
calculate_whitespace 15 ${#HP_value_display} $whitespace_character
echo "      ${HP_value_display}${whitespace}|" >> "$blockOne"
[[ $majorAilment = 0 ]] && majorAilment="OK"
calculate_whitespace 10 ${#majorAilment} $whitespace_character
echo "   STATUS/ ${majorAilment}${whitespace}|" >> "$blockOne"
echo " <-------------------0" >> "$blockOne"
echo " " >> "$blockOne"
calculate_topSpace "$blockOne"


#blockTwo (stat screen one)
touch "$blockTwo"
half_artLength="$( echo "scale=1;${artLength} / 2" | bc  )"
half_artLength="$( echo "${half_artLength} / 1" | bc )"
calculate_whitespace $(( $half_artLength - 2 )) 6 $whitespace_character
echo "${whitespace}No.${pokemonID}${whitespace}" >> "$blockTwo"
calculate_whitespace $(( $artLength - 1 )) 0 "-"
echo "O${whitespace}O" >> "$blockTwo"
attackDisplay="ATTACK  ${attack}"
calculate_whitespace $(( $artLength - 10 )) ${#attackDisplay} " "
echo "|         $attackDisplay${whitespace}|" >> "$blockTwo"
defenseDisplay="DEFENSE ${defense}"
calculate_whitespace $(( $artLength - 10 )) ${#defenseDisplay} " "
echo "|         $defenseDisplay${whitespace}|" >> "$blockTwo"
speedDisplay="SPEED   ${speed}"
calculate_whitespace $(( $artLength - 10 )) ${#speedDisplay} " "
echo "|         $speedDisplay${whitespace}|" >> "$blockTwo"
specialDisplay="SPECIAL ${special}"
calculate_whitespace $(( $artLength - 10 )) ${#specialDisplay} " "
echo "|         $specialDisplay${whitespace}|" >> "$blockTwo"
calculate_whitespace $(( $artLength - 1 )) 0 "-"
echo "O${whitespace}O" >> "$blockTwo"

#TODO See how badly everything will break if the typeOne typeTwo etc. in the base stats file are changed to strings:
# eg. POISON, GRASS, GHOST etc.
# might b worth doing this in moves.tab too

#blockThree (stat screen one)
#
# TYPE1/
# 	$typeOne
# TYPE 2/ (if applicable. otherwise this is empty)
# 	$typeTwo
# IDNo/
# 	$pokemonUniqueID
# OT/
# 	$originalTrainer (?)
#
#blockFour (stat screen two)
#
# $POKEMONNAME
#
# EXP POINTS
# 	$exPoints
# LEVEL UP
# 	210 to :L $(( $pokemon_level + 1 ))
#
#blockFive (stat screen two)
#
#
#(slightly to the left so it lands under the .art image, we have "No.$pokemonID"
#(sick box graphics)
# $moveOneName
# 	pp $moveOnePP / $moveOneMaxPP
# $moveTwoName
# 	pp $moveTwoPP / $moveTwoMaxPP
# $moveThreeName
# 	pp $moveThreePP / $moveThreeMaxPP
# $moveFourName
# 	pp $moveFourPP / $moveFourMaxPP
#
