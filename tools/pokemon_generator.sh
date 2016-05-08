#!/bin/bash

# this file literally just generates pokemon for when they're seen for the first time.

base_stat_file=$1 # /pokemon/gui/pokemon_database/base_stats/somethingsomething.bulbasaur
move_file=$2 # /pokemon/gui/pokemon_database/move_list/001.movesBULBASAUR
# still undecided on where level value will come from.
level=$3
move_script_path="${HOME}/pokemon/gui/pokemon_database/common/moves/move_scripts/"
move_data_path="${HOME}/pokemon/gui/pokemon_database/common/moves/moves.tab"
ID_counter_path="${HOME}/pokemon/gui/pokemon_database/common/ID_counter"
battle_path="${HOME}/pokemon/gui/battles/enemy/"

# Give the pokemon a unique id
while read id_value; do
	pokemonUniqueID=$((id_value + 1))
done < $ID_counter_path

# clear the ID_counter file - repopulate it with previous value + 1
> $ID_counter_path
echo "pokemon id for this guy is $pokemonUniqueID"
echo "$pokemonUniqueID" >> "$ID_counter_path"

# first generate IVs
# sauce: http://www.dragonflycave.com/stats.aspx
attack_IV=$( shuf -i 1-15 -n 1 )
defense_IV=$( shuf -i 1-15 -n 1 )
special_IV=$( shuf -i 1-15 -n 1 )
speed_IV=$( shuf -i 1-15 -n 1 )
HP_IV=0
add_HP=8
# generate the HP_IV
for i in $attack_IV $defense_IV $special_IV $speed_IV; do

	odd_test=$( expr "$i" % 2 )
	if [ "$odd_test" -ne 0 ]; then
		HP_IV=$( expr $HP_IV + $add_HP )
	fi
	add_HP=$( expr $add_HP / 2 )

done

# now obtain the base stats, typeOne, typeTwo, pokemonID, and pokemonName
while read HP_base_ attack_base_ defense_base_ special_base_ speed_base_ typeOne_ typeTwo_ pokemonID_ pokemonName_; do
	HP_base=$HP_base_
	attack_base=$attack_base_
	defense_base=$defense_base_
	special_base=$special_base_
	speed_base=$speed_base_
	typeOne=$typeOne_
	typeTwo=$typeTwo_
	pokemonID=$pokemonID_
	pokemonName=$pokemonName_
done < $base_stat_file

calculate_HP(){

	HP=$( echo "( ( ( ( $HP_base + $HP_IV ) * 2 ) * $level ) / 100 ) + $level + 10" | bc )

}
calculate_HP
echo "${HP} - HP"


calculate_stat(){

	stat_base=$1
	IV=$2
	level_=$3
	stat=$( echo "( ( ( ( $stat_base + $IV ) * 2 ) * $level_ ) / 100 ) + 5" | bc )
	echo $stat
}

attack=$( calculate_stat "$attack_base" "$attack_IV" "$level" )
defense=$( calculate_stat "$defense_base" "$defense_IV" "$level" )
special=$( calculate_stat "$special_base" "$special_IV" "$level" )
speed=$( calculate_stat "$speed_base" "$speed_IV" "$level" )

echo "${attack} - attack"
echo "${defense} - defense"
echo "${special} - special"
echo "${speed} - speed"

# extracting the correct moves given the pokemon and its level
line_count=;
while read move_level move_id; do

    ((line_count++))
    if [ "$move_level" -gt "$level"  ]; then
        highestMove_line=$(($line_count - 1))
        break    
    fi  
done < $move_file
unset line_count

# next we start at $highestMove_line and then work backwards to find the last 4 moves the pokemon would know given its level.
last_four_moves=$( tac $move_file | tail -n $highestMove_line | head -n 4 | awk '{print $NF}' )
IFS_old=$IFS
IFS=' '
move_count=;
declare -a move_index
while read -r move_id; do

	# construct filepaths to scripts for each attack
	((move_count++))
	# commented out because setting the move as the full path to the script is kinda dumb
	#move_index[$move_count]="${move_script_path}${move_id}"
	move_index[$move_count]="${move_id}"
	# while we're here we may as well grab the base PP values for each attack while we're here
	IFS='	'
	while read move_id_ move_name_ move_type_ PP_; do
		
		if [ "$move_id" -eq "$move_id_"  ]; then
			echo "${move_name_} - move name. ${PP_} - PP."	
			echo "$PP_" >> tempPP
		fi
	done < $move_data_path	
done <<< "$(echo -en "$last_four_moves")"
IFS=$IFS_old

# get pp out of tempPP file (exporting variables from nested while loops is long)
PP_count=;
tempPP="${HOME}/pokemon/gui/tools/tempPP"
while read PP; do
	((PP_count++))

	if [ "$PP_count" -le "$move_count" ]; then
		declare "PP_${PP_count}"="$PP"
	elif [ "$PP_count" -gt 4 ]; then
		break
	else
		declare "PP_${PP_count}"=0
	fi
done < $tempPP
rm $tempPP

[[ -z "$PP_1" ]] && PP_1=0
[[ -z "$PP_2" ]] && PP_2=0
[[ -z "$PP_3" ]] && PP_3=0
[[ -z "$PP_4" ]] && PP_4=0

echo "PP one - ${PP_1}"
echo "PP two - ${PP_2}"
echo "PP three - "${PP_3}""
echo "PP four - "${PP_4}""

# we want to write the values in these indexes to the battle file
# $move_count specifies how many attacks the pokemon has
count=1
while [ $count -le $move_count ]; do
	echo "${move_index[$count]} - move ${count}"
	((count++))
done
unset count

# now write to the file
battle_file="${battle_path}${pokemonUniqueID}.${pokemonID}"
touch "$battle_file"
zeroValue=0;
for value in $pokemonID $pokemonUniqueID $pokemonName $pokemonName $zeroValue $HP $level $typeOne $typeTwo ${move_index[1]} ${move_index[2]} ${move_index[3]} ${move_index[4]} $PP_1 $PP_2 $PP_3 $PP_4 $HP $attack $defense $special $speed $zeroValue $zeroValue $zeroValue $zeroValue $zeroValue $zeroValue $zeroValue $zeroValue; do
# the space after $value is a tab.
echo -n "$value	" >> $battle_file
done
echo "" >> $battle_file

# $battle file key:
#0pokemonID
#1pokemonUniqueID
#2pokemonName
#3pokemonGivenName (same as 2. for a wild or trainer owned pokemon.)
#4inventoryStatus (possibly not relevant if we store the active pokemon as a variable)
#5currentHP
#6level
#8typeOne
#9typeTwo
#10moveOne
#11moveTwo
#12moveThree
#13moveFour
#14moveOnePP
#15moveTwoPP
#16moveThreePP
#17moveFourPP
#18HP
#19attack
#20defense
#21special
#22speed
#23majorAilment - 0 = none, 1=BRN,2=FRZ,4=PAR,5=POISONED,6=BADLYPOISONED,7=SLEEP
#24confusion
#25trapped
#26charging up (can be used for flying, dig, hyper beam, flinching (maybe))
#27seeded
#28substituted
#29flinched(?)
#----below: possibly not needed here (they're not included here as of NOW). we can append these when a pokemon is captured. -----#
#35HPEV
#36attackEV
#37defenseEV
#38specialEV
#39speedEV
