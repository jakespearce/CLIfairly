#!/bin/bash

# this file literally just generates pokemon for when they're seen for the first time.

base_stat_file=$1 # /pokemon/gui/pokemon_database/base_stats/somethingsomething.bulbasaur
move_file=$2 # /pokemon/gui/pokemon_database/move_list/001.movesBULBASAUR
level=$3
move_script_path="${HOME}/pokemon/gui/pokemon_database/common/moves/move_scripts/"
move_data_path="${HOME}/pokemon/gui/pokemon_database/common/moves/moves.csv"
ID_counter_path="${HOME}/pokemon/gui/pokemon_database/common/ID_counter"
battle_path="${HOME}/pokemon/gui/battles/enemy/"

# super first: give the pokemon a unique id
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

# hp calculation
level=5
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

#----------find move scripts----------
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

	((move_count++))
	move_index[$move_count]="${move_script_path}${move_id}"

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

# this is bad, improve this
[[ -z "$PP_1" ]] && PP_1=0
[[ -z "$PP_2" ]] && PP_2=0
[[ -z "$PP_3" ]] && PP_3=0
[[ -z "$PP_4" ]] && PP_4=0

echo "PP one - ${PP_1}"
echo "PP two - ${PP_2}"
echo "PP three - "${PP_3}""
echo "PP four - "${PP_4}""

# we want to write the values in these indexes to the battle file
# $move_count specifies how many attacks the pokemon has - we may need to use this later
count=1
while [ $count -le $move_count ]; do
	echo "${move_index[$count]} - move ${count}"
	((count++))
done
unset count

#---------- now write to file ---------#
battle_file="${battle_path}${pokemonUniqueID}.${pokemonID}"
touch "$battle_file"
zeroValue=0;
#echo -n "${pokemonID}	" >> "$battle_file"
#echo -n "${pokemonName}	" >> 

for value in $pokemonID $pokemonName $pokemonName $zeroValue $HP $level $typeOne $typeTwo "${move_index[1]}.sh" "${move_index[2]}.sh" "${move_index[3]}.sh" "${move_index[4]}.sh" $PP_1 $PP_2 $PP_3 $PP_4 $HP $attack $defense $special $speed $zeroValue $zeroValue $zeroValue $zeroValue $zeroValue $zeroValue $zeroValue $zeroValue $zeroValue $zeroValue $zeroValue $zeroValue; do
echo -n "$value " >> $battle_file
done
echo "" >> $battle_file


# what's the battle file looking like then?
# pokemonUniqueID
# pokemon common ID
# all base stats
# script paths that lead to move.sh files
# PP for each move (how to ID the move the PP belongs to, though?)
# an inventory status that is always written as 0
# an entry for each status ailment that is initially populated with 0
# current hp ( which is = to hp stat)

# todo as of 420:
# Xgrab the PP for each move the pokemon knows
# Xgrab the pokemon's typeOne and typeTwo from somewhere (base stats file)
# grab the pokemon ID (base stats file)
# grab the pokemon's name (base stats file)
# grab the pokemon unique ID (generated on the fly, but should increment)
# grab inventory status - we don't actually need this, just write a 0 directly to the battle file.


# todo: moves, pp, currentHP (we'll need this in battle), name, whether we can catch it or not.
# how do we generate moves?
# 1 - get the level of the enemy pokemon. find the most recent 4 moves it knows from /pokemon_database/move_list/xxx.movesPOKEMONNAME
# 2 - get data on the moves the pokemon knows from /pokemon_database/common/moves/moves.csv
#???
# write all of this data to a pokemon battle file. this file is only used/read when the pokemon is in battle.
#TODO write something that writes moves to the pokemon battle file
# moves: 
# a move in the file is represented by an index in an array that points to a directory full of scripts that are just named with numbers. The index corresponds to script we run for each move.
# Say 'poison sting' is used. the poison sting script calls the damage script, passing it a damage parameter. Poison sting also calls the poison script, passing it a parameter for the % of the opponent getting poisoned.
# Therefore, for the sake of this pokemon generation script, we just need to write the correct numbers to the right place in /pokemon/gui/battles/enemy directory
# This nearly renders the /pokemon/gui/pokemon_database/common/moves/moves.csv file useless, aside from:
# PP, which is definitely an attribute of the pokemon rather than the move.
# I think we still need moves.csv, but only keep PP, name, type (HM or TM)  and id of the move (which corresponds to the name of the move's script file.) Name will come in handy for the pokemon menu item, as well as when we need to use HM's, PP up and other similar items outside of battlle.
