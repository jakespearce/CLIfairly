#!/bin/bash

pokemon_in_inventory="${HOME}/pokemon/gui/character_files/pokemon_in_inventory.csv"
owned_pokemon="${HOME}/pokemon/gui/character_files/owned_pokemon"
pokemon_menu_file="/dev/shm/pokemon_menu"

generate_pokemon_menu(){

	# this loop saves the file names so we can extract data from each file later
	pokemon_count=0
	declare -a pokemon_file_location
	while read pokemon_file; do
		((pokemon_count++))
		# eg. pokemon_no3=${HOME}/pokemon/gui/character_files/owned_pokemon/1044.001
		#declare "pokemon_no${pokemon_count}"="${owned_pokemon}/${pokemon_file}"
		pokemon_file_location[$pokemon_count]="${owned_pokemon}/${pokemon_file}"

	done < "$pokemon_in_inventory"

	OLD_IFS=$IFS
	# tabs baby
	IFS="	"
	countdown=0
	declare -a pokemonIDARR
	declare -a pokemonUniqueIDARR
	declare -a pokemonNameARR
	declare -a pokemonGivenNameARR
	declare -a inventoryStatusARR
	declare -a currentHPARR
	declare -a levelARR
	declare -a typeOneARR
	declare -a typeTwoARR
	declare -a moveOneARR
	declare -a moveTwoARR
	declare -a moveThreeARR
	declare -a moveFourARR
	declare -a moveOnePPARR
	declare -a moveTwoPPARR
	declare -a moveThreePPARR
	declare -a moveFourPPARR
	declare -a HPARR
	declare -a attackARR
	declare -a defenseARR
	declare -a specialARR
	declare -a speedARR
	declare -a majorAilmentARR
#	declare -a burnARR
#	declare -a freezeARR
#	declare -a paralysisARR
#	declare -a poisonARR
#	declare -a badlyPoisonedARR
#	declare -a sleepStatusARR
	declare -a confusionARR
	declare -a trappedARR
	declare -a charingUpARR
	declare -a seededARR
	declare -a substitutedARR
	declare -a flinchedARR

	while [ "$countdown" -lt "$pokemon_count" ]; do
		((countdown++))	
	
		while read -r pokemonID_ pokemonUniqueID_ pokemonName_ pokemonGivenName_ inventoryStatus_ currentHP_ level_ typeOne_ typeTwo_ moveOne_ moveTwo_ moveThree_ moveFour_ moveOnePP_ moveTwoPP_ moveThreePP_ moveFourPP_ HP_ attack_ defence_ special_ speed_ majorAilment_ confusion_ trapped_ chargingUp_ substituted_ flinched_; do
			pokemonIDARR[$countdown]="$pokemonID_"
			pokemonUniqueIDARR[$countdown]="$pokemonUniqueID_"
			pokemonNameARR[$countdown]="$pokemonName_"
			pokemonGivenNameARR[$countdown]="$pokemonGivenName_"
			inventoryStatusARR[$countdown]="$inventoryStatus_"
			currentHPARR[$countdown]="$currentHP_"
			levelARR[$countdown]="$level_"
			typeOneARR[$countdown]="$typeOne_"
			typeTwoARR[$countdown]="$typeTwo_"
			moveOneARR[$countdown]="$moveOne_"
			moveTwoARR[$countdown]="$moveTwo_"
			moveThreeARR[$countdown]="$moveThree_"
			moveFourARR[$countdown]="$moveFour_"
			moveOnePPARR[$countdown]="$moveOnePP_"
			moveTwoPPARR[$countdown]="$moveTwoPP_"
			moveThreePPARR[$countdown]="$moveThreePP_"
			moveFourPPARR[$countdown]="$moveFourPP_"
			HPARR[$countdown]="$HP_"
			attackARR[$countdown]="$attack_"
			defenceARR[$countdown]="$defence_"
			specialARR[$countdown]="$special_"
			speedARR[$countdown]="$speed_"
			majorAilmentARR[$countdown]="$majorAilment_"
#			burnARR[$countdown]="$burn_"
#			freezeARR[$countdown]="$freeze_"
#			paralysisARR[$countdown]="$paralysis_"
#			poisonARR[$countdown]="$poison_"
#			badlyPoisonedARR[$countdown]="$badlyPoisoned_"
#			sleepStatusARR[$countdown]="$sleep_"
			confusionARR[$countdown]="$confusion_"
			trappedARR[$countdown]="$trapped_"
			chargingUpARR[$countdown]="$chargingUp_"
			seededARR[$countdown]="$seeded_"
			substitutedARR[$countdown]="$substituted_"
			flinchedARR[$countdown]="$flinched_"
		done < "${pokemon_file_location[$countdown]}"
	IFS=$OLD_IFS
	done 
	unset countdown
# todo: just generate the pokemon menu gui
	
	count=1;
	while [ "$count" -le "$pokemon_count" ]; do
		calculate_whitespace(){
			whitespace_length=$((25 - ${#pokemonGivenNameARR[$count]}))
			whitespace="$( head -c "$whitespace_length" < /dev/zero | tr '\0' ' ' )"
		}
		# this is the whitespace that appears between the pokemon name and the level display
		calculate_whitespace

		draw_HPbar(){
			filled_fraction=$(echo "${currentHPARR[$count]} / ${HPARR[$count]}" | bc -l)
			filled_length=$( echo "($filled_fraction * 20)/1" | bc)
			populated_HPbar="$( head -c "$filled_length" < /dev/zero | tr '\0' '#' )"
			unfilled_length=$(( 20 - $filled_length ))
			unpopulated_HPbar="$( head -c "$unfilled_length" < /dev/zero | tr '\0' '-' )"

		}
		# eg. hp = 2/20 then HPbar will be "##------------------"
		draw_HPbar

		get_ailment(){
			# ye ol whitespace ailment
			[[ ${majorAilmentARR[$count]} == 0 ]] && ailment="$( head -c4 < /dev/zero | tr '\0' ' ' )"
			[[ ${majorAilmentARR[$count]} == 1 ]] && ailment="BRN"
			[[ ${majorAilmentARR[$count]} == 2 ]] && ailment="FRZ"
			[[ ${majorAilmentARR[$count]} == 3 ]] && ailment="PAR"
			# 4 = poisoned, 5 = badly poisoned. same but different.
			[[ ${majorAilmentARR[$count]} == 4 ]] && ailment="PSN"
			[[ ${majorAilmentARR[$count]} == 5 ]] && ailment="PSN"
			[[ ${majorAilmentARR[$count]} == 6 ]] && ailment="SLP"
		}

		# get ailment for display
		get_ailment
		echo " " >> $pokemon_menu_file
		echo "0 ${pokemonGivenNameARR[$count]}${whitespace}L:${levelARR[$count]}${ailment}" >> $pokemon_menu_file
		echo "0 HP:${populated_HPbar}${unpopulated_HPbar}  ${currentHPARR[$count]} / ${HPARR[$count]}" >> $pokemon_menu_file
		# the moves below are space seperated.
		# we use these in interact_pokemon_menu.sh to generate a submenu that potentially contains HM moves.
		echo "${moveOneARR[$count]} ${moveTwoARR[$count]} ${moveThreeARR[$count]} ${moveFourARR[$count]}" >> $pokemon_menu_file

		unset ailment
		((count++))
	done
	
	# the format below is our basis for generating the gui part of the menu.
	# loop through this for each pokemon, the number of times of which is specified by $pokemon_count
#	echo "0 ${pokemonGivenName1}${whitespace}L:${level1}"
#	echo "0 HP:#################---  ${currentHP1} / ${HP1}"
	
}

# The gui component for the basic pokemon menu is basically done.
# todo: interactivity.
# we need to be able to scroll through this menu via this layout with highlighting etc.
# when a menu item is selected, we run ANOTHER script that brings up another menu (STATS, USE HM, USE ITEM ETC.)
# it would be smart to have a line for each pokemon that ISN'T present in the gui of this script that contains data for the smaller sub-menu, such as HM moves for example.

generate_pokemon_menu
#cat $pokemon_menu_file
#rm menu.testing
