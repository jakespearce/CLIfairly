#!/bin/bash

owned_pokemon_path="${HOME}/pokemon/gui/character_files/owned_pokemon"
battle_filetmp_path="${HOME}/pokemon/gui/battles/tmp_files"
PCPokemonFile="${battle_filetmp_path}/PCPokemon.pokemon"
NPCPokemonFile="${battle_filetmp_path}/NPCPokemon.pokemon"
moves_file="${HOME}/pokemon/gui/pokemon_database/common/moves/moves.tab"
moves_script_path="${HOME}/pokemon/gui/pokemon_database/common/moves/move_scripts"
type_value_key="${HOME}/pokemon/gui/tools/type_value_key_lookup.tab"
type_matchups_array="${HOME}/pokemon/gui/battles/arrays/type_matchups.cfg"
base_stats_path="${HOME}/pokemon/gui/pokemon_database/base_stats/"
actionStackFile="${HOME}/pokemon/gui/battles/tmp_files/actionStack.tab"
actionStackFile_tmp="${HOME}/pokemon/gui/battles/tmp_files/actionStack.tmp"
moveTicksFile="${HOME}/pokemon/gui/battles/tmp_files/moveTicks.tab"
moveTicksFile_tmp="${HOME}/pokemon/gui/battles/tmp_files/moveTicks.tmp"



source "$type_matchups_array"
source "${HOME}/pokemon/gui/tools/tools.sh"
source "${HOME}/pokemon/gui/battles/arrays/stat_stages.cfg"
source "${HOME}/pokemon/gui/battles/battle_gui.sh"

# This function generates the "battleFile" for a pokemon (a .tab file which stores its in-battle stats)
# First argument is the full path and name of the file to generate, second argument is the pokemonUniqueID of the pokemon we want to generate the battleFile for.
# eg. generate_attribute_battleFile "$PCPokemonFile" 1093.001
generate_attribute_battleFile(){

	fileToGenerate="$1"
	targetPokemon="${owned_pokemon_path}/${2}"

	read_pokemon_file "$targetPokemon"
	[[ ! -e "$fileToGenerate" ]] && touch "$fileToGenerate"
	# Note: We may use the code below elsewhere so this may become its own function one day.
	echo -e "${pokemonID}\t${pokemonUniqueID}\t${pokemonName}\t${level}\t${HP}\t${currentHP}\t${attack}\t${defense}\t${special}\t${speed}\t6\t6\t6\t6\t${attack}\t${defense}\t${special}\t${speed}\t6\t6\t1\t${typeOne}\t${typeTwo}\t${moveOne}\t${moveTwo}\t${moveThree}\t${moveFour}\t${moveOnePP}\t${moveTwoPP}\t${moveThreePP}\t${moveFourPP}\t${moveOnePPMax}\t${moveTwoPPMax}\t${moveThreePPMax}\t${moveFourPPMax}\t${majorAilment}\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0" >> "$fileToGenerate"
}


# Extracts values from a give pokemon's battleFile
# Argument must be full path + name of battleFile
read_attribute_battleFile(){

	fileToRead="$1"
	IFS_OLD=$IFS
	IFS='	' #tab

	while read pokemonID_ pokemonUniqueID_ pokemonName_ level_ HP_ currentHP_ attack_base_ defense_base_ special_base_ speed_base_ attack_stage_ defense_stage_ special_stage_ speed_stage_ attack_ defense_ special_ speed_ accuracy_ evasion_ crit_multiplier_ typeOne_ typeTwo_ moveOne_ moveTwo_ moveThree_ moveFour_ moveOnePP_ moveTwoPP_ moveThreePP_ moveFourPP_ moveOnePPMax_ moveTwoPPMax_ moveThreePPMax_ moveFourPPMax_ majorAilment_ confusion_ trapped_ seeded_ substituted_ flinch_ semiInvulnerable_ mist_ lightScreen_ reflect_ sleepCounter_; do
		pokemonID="$pokemonID_"
		pokemonUniqueID=$pokemonUniqueID_
		pokemonName=$pokemonName_
		level=$level_
		HP=$HP_
		currentHP=$currentHP_
		attack_base=$attack_base_
		defense_base=$defense_base_
		special_base=$special_base_
		speed_base=$speed_base_
		attack_stage=$attack_stage_
		defense_stage=$defense_stage_
		special_stage=$special_stage_
		speed_stage=$speed_stage_
		attack=$attack_
		defense=$defense_
		special=$special_
		speed=$speed_
		accuracy=$accuracy_
		evasion=$evasion_
		crit_multiplier=$crit_multiplier_
		typeOne=$typeOne_
		typeTwo=$typeTwo_
		moveOne=$moveOne_
		moveTwo=$moveTwo_
		moveThree=$moveThree_
		moveFour=$moveFour_
		moveOnePP=$moveOnePP_
		moveTwoPP=$moveTwoPP_
		moveThreePP=$moveThreePP_
		moveFourPP=$moveFourPP_
		moveOnePPMax=$moveOnePPMax_
		moveTwoPPMax=$moveTwoPPMax_
		moveThreePPMax=$moveThreePPMax_
		moveFourPPMax=$moveFourPPMax_
		majorAilment=$majorAilment_
		confusion=$confusion_
		trapped=$trapped_
		seeded=$seeded_
		substituted=$substituted_
		flinch=$flinch_
		semiInvulnerable=$semiInvulnerable_
		mist=$mist_
		lightScreen=$lightScreen_
		reflect=$reflect_
		sleepCounter=$sleepCounter_

	done < "$fileToRead"

	IFS=$IFS_OLD
}


# Extracts values from the moves.tab file
# Only argument is the ID of the move we want to extract data for.
read_moves_file(){

	moveToRead="$1"
	IFS_OLD=$IFS
	IFS='	' # TAB
	while read moveID_ moveName_ moveMachineType_ moveppMax_ moveType_ moveAccuracy_ movePower_ moveCategory_; do

		if [ "$moveID_" = "$moveToRead" ]; then
			moveID="$moveID_"
			moveName="$moveName_"
			moveMachineType="$moveMachineType_"
			moveppMax="$moveppMax_"
			moveType="$moveType_"
			moveAccuracy="$moveAccuracy_"
			movePower="$movePower_"
			moveCategory="$moveCategory_"

		fi

	done < "$moves_file"
	IFS=$IFS_OLD	
}


# Argument will be all caps string representing an element eg. ELECTRIC
# Function translates ELECTRIC into its corresponding integer value (see arrays/type_value_key)
# The integer value we get from this can be plugged into arrays to get attributes of that element.
translate_type_string_to_key(){

	typeString="$1"
	while read typeString_ typeValueKey_; do
		if [ "$typeString_" = "$typeString" ]; then
			typeValueKey="$typeValueKey_"
		fi
	done < "$type_value_key"
}


# Reads the base stats file for a given pokemon.
# A given pokemon is expressed in the form of the pokemon species ID. eg. Bulbasaur = 001 ($targetPokemonSpeciesID)
read_base_stats(){

	targetPokemonSpeciesID="$1"
	IFS_OLD=$IFS
	IFS='	' # tab
	while read HP_base_ attack_base_ defense_base_ special_base_ speed_base_ typeOne_ typeTwo_ pokemonID_ pokemonName_ levellingRate_ catchRate_ baseExpYield_; do
	    HP_base=$HP_base_
	    attack_base=$attack_base_
	    defense_base=$defense_base_
	    special_base=$special_base_
	    speed_base=$speed_base_
	    typeOne=$typeOne_
	    typeTwo=$typeTwo_
	    pokemonID=$pokemonID_
	    pokemonName=$pokemonName_
	    levellingRate=$levellingRate_
	    catchRate=$catchRate_
	    baseExpYield=$baseExpYield_
	done < "${base_stats_path}${targetPokemonSpeciesID}.stats"
	IFS=$IFS_OLD
}


# Determines whether the move hits or not.
# attacking and defending Pokemon parameters aare "PCPokemon.pokemon" or "NPCPokemon.pokemon"
# attackBeingUsed is a number representing the moveID of the move being used.
accuracy_check(){

	local attackingPokemon="$1"
	local defendingPokemon="$2"
	local attackBeingUsed="$3"

	read_attribute_battleFile "${battle_filetmp_path}/${defendingPokemon}.pokemon"
	# If the pokemon is semi-invulnerable then the move just doesn't hit
	if [ $semiInvulnerable -eq 1 ]; then
		doesTheMoveHit="no"
		return 0
	fi

	local defenderEvasion="$evasion"
	local evasionValue="EVASIONSTAGE[${evasion}]"
	local evasionValue=${!evasionValue}

	read_attribute_battleFile "${battle_filetmp_path}/${attackingPokemon}.pokemon"
	local attackerAccuracy="$accuracy"
	local accuracyValue="ACCURACYSTAGE[${attackerAccuracy}]"
	local accuracyValue=${!accuracyValue}

	read_moves_file "$attackBeingUsed"
	local accuracyMove="$moveAccuracy"

	local probabilityToHit=$( echo "scale=3;${accuracyMove}*(${accuracyValue}/${evasionValue})" | bc )
	local probabilityToHit=$(echo "${probabilityToHit}/1" | bc)
	local randomValue=$( shuf -i 1-100 | head -1 )

	if [ $probabilityToHit -gt $randomValue ]; then
		# The move hits
		doesTheMoveHit="yes"
	else
		doesTheMoveHit="no"
	fi

	# Uncomment for testing

	echo -e "\n\n==ACCURACY CHECK==\n\nThe evasionValue for the defending pokemon is ${evasionValue}.\nThe accuracy value for the defending pokemon is ${accuracyValue}.\nThe accuracy of the move being used is ${accuracyMove}.\nThe probability for the move to hit is ${probabilityToHit} (\$probabilityToHit).\n\nIf the randomValue, which is a value between 1-100, falls within the range of the probabilityToHit, then the move is a hit.\nThe randomValue is: ${randomValue}.\nDoes the move hit? ${doesTheMoveHit}.\n"
	
}


# Checks to see if modifying a stat stage by a given amount raises the stage > 12 or < 0. 
# If either of these is true then we need to inform the parent script by setting the fail variable. 
# Eg. if $fail == "true" then display the text "But it failed!"
statStageModCheck(){

	targetPokemon="$1"
	attributeToModify="$2"
	modifierValue="$3"
	# Set $fail up here otherwise it won't be set if it's false
	fail="false"

	read_attribute_battleFile "${battle_filetmp_path}/${targetPokemon}.pokemon"

	case $attributeToModify in
		attack) attack_stage=$(( $attack_stage + $modifierValue )) ; if [ $attack_stage -gt 12 -o $attack_stage -lt 0 ]; then fail="true"; fi ;;
		defense) defense_stage=$(( $defense_stage + $modifierValue )) ; if [ $defense_stage -gt 12 -o $defense_stage -lt 0 ]; then fail="true"; fi ;;
		special) special_stage=$(( $special_stage + $modifierValue ))  ; if [ $special_stage -gt 12 -o $special_stage -lt 0 ]; then fail="true"; fi ;;
		speed) speed_stage=$(( $speed_stage + $modifierValue ))  ; if [ $speed_stage -gt 12 -o $speed_stage -lt 0 ]; then fail="true"; fi ;;
		accuracy) accuracy=$(( $accuracy + $modifierValue ))  ; if [ $accuracy -gt 12 -o $accuracy -lt 0 ]; then fail="true"; fi ;;
		evasion) evasion=$(( $evasion + $modifierValue)) ; if [ $evasion -gt 12 -o $evasion -lt 0 ]; then fail="true"; fi  ;;
	esac

	# Uncomment for testing
	echo "fail is ${fail}."

}


# Takes an attribute parameter (eg. attack, evasion) and a value parameter (+/- 1 to 9)
# Modifies specified attribute by value for target pokemon
# All this function does is modify an attribute, no checks to see if that attribute is lt 0 or gt 12 take place here.
modifyAttributeByStage(){

	targetPokemon="$1"
	attributeToModify="$2"
	modifierValue="$3"


	read_attribute_battleFile "${battle_filetmp_path}/${targetPokemon}.pokemon"

	# The following block is for testing purposes
	attack_stageOLD="$attack_stage"
	defense_stageOLD="$defense_stage"
	special_stageOLD="$special_stage"
	speed_stageOLD="$speed_stage"
	accuracyOLD="$accuracy"
	evasionOLD="$evasion"
	# /testing purposes block

	case $attributeToModify in
		attack) attack_stage=$(( $attack_stage + $modifierValue )) ;;
		defense) defense_stage=$(( $defense_stage + $modifierValue )) ;;
		special) special_stage=$(( $special_stage + $modifierValue )) ;;
		speed) speed_stage=$(( $speed_stage + $modifierValue )) ;;
		accuracy) accuracy=$(( $accuracy + $modifierValue )) ;;
		evasion) evasion=$(( $evasion + $modifierValue)) ;;
	esac

#	echo -e "${pokemonID}\t${pokemonUniqueID}\t${pokemonName}\t${level}\t${HP}\t${currentHP}\t${attack}\t${defense}\t${special}\t${speed}\t${attack_stage}\t${defense_stage}\t${special_stage}\t${speed_stage}\t${attack}\t${defense}\t${special}\t${speed}\t${accuracy}\t${evasion}\t${crit_multiplier}\t${typeOne}\t${typeTwo}\t${moveOne}\t${moveTwo}\t${moveThree}\t${moveFour}\t${moveOnePP}\t${moveTwoPP}\t${moveThreePP}\t${moveFourPP}\t${moveOnePPMax}\t${moveTwoPPMax}\t${moveThreePPMax}\t${moveFourPPMax}\t${majorAilment}\t${confusion}\t${trapped}\t${seeded}\t${substituted}\t${flinch}" >> "${battle_filetmp_path}/${1}.pokemon"


	# Uncomment for testing
	echo -e "The attributeToModify is ${attributeToModify}.\nThe modifierValue is ${modifierValue}.\nThe old values are: attack=${attack_stageOLD}  defense=${defense_stageOLD}  special=${special_stageOLD}  speed=${speed_stageOLD} accuracy=${accuracyOLD}  evasion=${evasionOLD}.\nThe new values are: attack=${attack_stage}  defense=${defense_stage}  special=${special_stage}  speed=${speed_stage} accuracy=${accuracy}  evasion=${evasion}.\n"
}



#---- FUNCTIONS THAT CALCULATE MODIFIER VALUES ----#

# Modifier values are: STAB, Type multiplier, Crit bonus, and finally a random number from 0.85-1.


# This function could also be called "Does the move crit?" Crit bonus is a value from 1-2.
# A value of 2 is a critical hit.
# Parameteres:
# PokemonSpeciesID
# attackingPokemon (This is either NPCPokemon.pokemon or PCPokemon.pokemon)
# critRateMultiplier (This always comes from the move script. This is how we're going to handle moves with high crit rates.)
calculate_crit_bonus(){

	local pokemonSpeciesID="$1"
	# This will either be NPCPokemon.pokemon or PCPokemon.pokemon
	local attackingPokemon="$2"
	local critRateMultiplier="$3"
	# There are only 8 moves in the game that have a non-base (1) crit bonus. These moves will supply that bonus as an argument to this function in their move scripts.
	if [ -z $critRateMultiplier ]; then
		critRateMultiplier=1
	fi
	# Read the battle attribute file for the attacking pokemon in order to get the battle crit_multiplier
	read_attribute_battleFile "${battle_filetmp_path}/${attackingPokemon}.pokemon"
	local critMultiplierAttribute=$crit_multiplier

	read_base_stats "$pokemonSpeciesID"
	local baseSpeed="$speed_base"

	# Calculate critRate, generate random number between 1 and 255, if critRate > random then it's a crit.
	local critRate=$( echo "( ${baseSpeed} * ${critRateMultiplier} * ${critMultiplierAttribute} ) / 2" | bc )
	if [ $critRate -ge 256 ]; then
		local critRate=255
	fi
	local randomValue=$( shuf -i 1-255 | head -1 )

	if [ $critRate -gt $randomValue ]; then
		criticalModifier=2
	else
		criticalModifier=1
	fi

	# Uncomment for testing

	echo -e "\n\n==CALCULATE CRIT BONUS==\n\nThe critRateMultiplier (supplied by the move script) is ${critRateMultiplier}.\nThe critMultiplierAttribute, the crit value from the pokemon's attribute file, is ${critMultiplierAttribute}.\nThe base speed of the attacking pokemon is ${baseSpeed}.\nThe critRate, ${critRate}, needs to exceed ${randomValue} in order to be a crit.\nThe criticalModifier (1 = no crit, 2 = crit) is ${criticalModifier}.\n"

#	echo $pokemonSpeciesID
#	echo $critRateMultiplier
#	echo $critMultiplierAttribute
#	echo $attackingPokemon
#	echo $baseSpeed
#	echo $critRate
#	echo $randomValue
}


# STAB - Same type attack bonus (if the pokemon shares at least one type with the move its using then apply 1.5x)
# This function takes 3 arguments: 
# $1 - ID of the attack being used (integer)
# $2 - typOne of the attacker (all-caps string ;))
# $3 - typeTwo of the attacker (")
calculate_STAB(){

	# attackBeingUsed will be the ID of the attack eg. 44
	local attackBeingUsed="$1"
	local typeOne="$2"
	local typeTwo="$3"

	read_moves_file "$attackBeingUsed"

	if [ "$typeOne" = "$moveType" -o "$typeTwo" = "$moveType" ]; then
		STAB=1.5
	else
		STAB=1
	fi
}


# This function takes three arguments, defending pokemon's types and attack's ID.
# Defending pokemon's types are text in all caps eg. ICE. Attack's ID is eg. 44
# Spits out $typeDamageBonus, which is calculated by multiplying together the two damage multipliers we get from
# examining the attack type vs defender types. If the defending pokemon only has one type, then the non-existent second type's multiplier resolves to 1. Because we're lazy.
# Eg. A Pokemon has two types, one of which the attack is super effective against (2x bonus) and one of which the attack is weak against (1/2x bonus.)
# $typeDamageBonus = 1/2 * 2 = 1x damage multiplier overall
calculate_type_damage_bonus(){

	local attackBeingUsed="$1"
	local defenderTypeOne="$2"

	# If the pokmon doesn't have a secondary type set the key to 0.
	# In our array table a value of 0 always resolves to 1 regardless of type of attack.
	if [ "$3" = "NULL" ]; then
		local typeValueKeyTwo=0
	else
		# Note: here, defenderTypeTwo is a string of text.
		local defenderTypeTwo="$3"
	fi

	# Here we need to read type_value_key_lookup.tab and get the number values for each of the defending pokemon's types.
	# defenderTypeOne first:
	translate_type_string_to_key "$defenderTypeOne"
	# typeValueKey is obtained in the translate_type_string_to_key function.
	typeValueKeyOne="$typeValueKey"

	if [ "$typeValueKeyTwo" == 0 ]; then
		:
	else
		translate_type_string_to_key "$defenderTypeTwo"
		typeValueKeyTwo="$typeValueKey"
	fi

	# Now get the TYPE of the attack being used.
	# To get typeDamageBonus: TYPE[defenderTypeOne] * TYPE[defenderTypeTwo] 
	# Eg. BUG[10] * BUG[14] = 1 * 1 = 1 (A BUG attack against an Ice and Water type pokemon)
	read_moves_file "$attackBeingUsed"
	local moveTypeofAttack="$moveType"

	# Now to construct an array from moveTypeofAttack
	# This could resolve to: ICE[1] which represents an ICE attacking dealing damage to a NORMAL typed pokemon.
	# See the battles/arrays/type_matchups.cfg along with battles/arrays/type_value_key for the values.
	damageMultiplierOne="${moveTypeofAttack}[${typeValueKeyOne}]"
	damageMultiplierTwo="${moveTypeofAttack}[${typeValueKeyTwo}]"
	# The grand finale
	typeDamageBonus=$( echo "scale=2;${!damageMultiplierOne} * ${!damageMultiplierTwo}" | bc )


	# Uncomment for testing
#	echo -e "The type of the attack is ${moveTypeofAttack}.\nThe defending pokemon has typeOne=${defenderTypeOne} and typeTwo=${defenderTypeTwo}. \nThe damage multiplier of a ${moveTypeofAttack} move vs ${defenderTypeOne} is ${!damageMultiplierOne}. The damage multiplier of a ${moveTypeofAttack} vs ${defenderTypeTwo} is ${!damageMultiplierTwo}.\nThe overall damage multiplier is ${typeDamageBonus}"
}


# This function modifies the HP in a given pokemon attribute file.
# Note: Dealing damage means we have to supply this function with a negative HPMod integer.
modify_HP_value(){


	targetPokemon="$1"
	# Can be +ve or -ve
	HPMod="$2"

	read_attribute_battleFile "${battle_filetmp_path}/${targetPokemon}.pokemon"
	currentHP_forTesting=$currentHP
	currentHP=$( expr $currentHP + $HPMod )

	# Don't let currentHP drop under 0 or go over the maximum (maximum HP is $HP)
	if [ $currentHP -lt 0 ]; then
		currentHP=0
	elif [ $currentHP -gt $HP ]; then
		currentHP=$HP
	fi

	# Empty the target attribute battle file
#	> "${battle_filetmp_path}/${targetPokemon}.pokemon"

#	echo -e "${pokemonID}\t${pokemonUniqueID}\t${pokemonName}\t${level}\t${HP}\t${currentHP}\t${attack}\t${defense}\t${special}\t${speed}\t${attack_stage}\t${defense_stage}\t${special_stage}\t${speed_stage}\t${attack}\t${defense}\t${special}\t${speed}\t${accuracy}\t${evasion}\t${crit_multiplier}\t${typeOne}\t${typeTwo}\t${moveOne}\t${moveTwo}\t${moveThree}\t${moveFour}\t${moveOnePP}\t${moveTwoPP}\t${moveThreePP}\t${moveFourPP}\t${moveOnePPMax}\t${moveTwoPPMax}\t${moveThreePPMax}\t${moveFourPPMax}\t${majorAilment}\t${confusion}\t${trapped}\t${seeded}\t${substituted}\t${flinch}" >> "${battle_filetmp_path}/${1}.pokemon"



	echo -e "The Pokemon's HP was modified by ${HPMod}. The original HP value was ${currentHP_forTesting}. The current HP is now ${currentHP}.\n\n"
}



#TODO
# We should have a seperate function that actually changes the HP value in the defending pokemon's attribute file.
# That function can be called by deal_damage. 

deal_damage(){

	attackingPokemon="$1"
	defendingPokemon="$2"
	attackBeingUsed="$3"
	# This value comes from calculate_crit_bonus
	critRateMultiplier="$4"

	read_moves_file "$attackBeingUsed"
	# Gives us 1) Type of move = $moveType
	# Gives us 2) Power of move = $movePower
	# Gives us 3) Category of mvoe = $moveCategory
	# Warning: This function is invoked in calculate_STAB, calculate_type_damage_bonus too.
	# We're reading the line for the same move each time (and hence $moveType and $movePower will be 'updated', but just be aware of this. As long as we don't read the line for another move from here until the damage calculation we should be okay.

	# Get values from attacking pokemon
	read_attribute_battleFile "${battle_filetmp_path}/${attackingPokemon}.pokemon"
	levelAttacker=$level
	# Categories are: PHYSICAL, SPECIAL, STATUS. Note that STATUS moves don't use the damage formula.
	if [ "$moveCategory" = "PHYSICAL" ]; then
		attackAttacker=$attack

		if [ "$majorAilment" == "BRN" ]; then
			attackAttacker=$(( $attackAttacker / 2 ))
		fi

	else
		attackAttacker=$special
	fi
	# Used for STAB calculation.
	attackerTypeOne=$typeOne
	attackerTypeTwo=$typeTwo

	#--- Calculate Modifiers ---#

	# Gives us $STAB
	calculate_STAB "$attackBeingUsed" "$attackerTypeOne" "$attackerTypeTwo"
	# Next, invoke calculate_type_damage_bonus
	# It gives us $typeDamageBonus
	#TODO We need to read the defending pokemon's Attribute file to extract their typeOne and typeTwo for arguments
	read_attribute_battleFile "${battle_filetmp_path}/${defendingPokemon}.pokemon"
	defenderTypeOne="$typeOne"
	defenderTypeTwo="$typeTwo"
	if [ "$moveCategory" = "PHYSICAL" ]; then
		defenderDefense=$defense

		if [ $reflect -eq 1 ]; then
			defenderDefense=$(( $defenderDefense * 2 ))
		fi

	else
		defenderDefense=$special

		if [ $lightScreen -eq 1 ]; then
			defenderDefense=$(( $defenderDefense * 2 ))
		fi

	fi

	# Hard-coding Self-Destruct and Explosion here. They're the only moves in the game that have this effect.
	if [ "$attackBeingUsed" -eq 120 -o "$attackBeingUsed" -eq 153 ]; then
		defenderDefense=$(( $defenderDefense / 2 ))
	fi

	calculate_type_damage_bonus "$attackBeingUsed" "$defenderTypeOne" "$defenderTypeTwo"
	
	# Generate a random number between 0.85 and 1
	randomDamageMultiplier=$( shuf -i 85-100 | head -1 )
	randomDamageMultiplier=$( echo "scale=2;${randomDamageMultiplier}/100" | bc )

	#--- The damage calculation ---#
	damageToDeal=$( echo "scale=4;( ( ( ( ( 2*${levelAttacker}+10 )/250 )*( ${attackAttacker}/${defenderDefense} )*( ${movePower} ) + 2 ) + 2 )*( ${STAB}*${typeDamageBonus}*${critRateMultiplier}*${randomDamageMultiplier} ) )" | bc )
	# Divide it by -1 to get negative value (for use in the HP modification function)
	# Since there's no 'scale=X' it rounds the number down to the nearest integer
	damageToDeal=$( echo "${damageToDeal}/-1" | bc )

	# Uncomment for testing
	echo -e "\n==DAMAGE CALCULATION==\n\nLevel of attacker: ${levelAttacker}\nAttack of attacker: ${attackAttacker} (${moveCategory} - Category)\nDefense of defender: ${defenderDefense}\nAttack being used: ${moveName} (ID = ${moveID})\nBase power of move: ${movePower}\n\nMODIFIERS\n\nSTAB: ${STAB}\nType damage bonus: ${typeDamageBonus}\nThe random value: ${randomDamageMultiplier}\nThe total damage dealt by the ${moveName} attack: ${damageToDeal}\n\n"

	modify_HP_value "$defendingPokemon" "$damageToDeal"

}



#---- "CHECK" FUNCTIONS ----#
# Eg. Check if the Pokemon has died

#- Functions that run checks before the attack phase-#

# Checks for ailments and decides whether a pokemon can attack this turn
# Eg. Pokemon is Frozen, therefore it can't attack
# Parameters: pokemonToCheck, attackUsed
#pre_attack_status_checks NPCPokemon 44

pre_attack_status_checks(){

	pokemonToCheck="$1"
	# Used for the disable check. If attack used = D then that move is disabled
	attackUsed="$2"

	read_attribute_battleFile "${battle_filetmp_path}/${pokemonToCheck}.pokemon"
	# variables extracted via this function that we care about:
	# flinch, majorAilment, trapped, move{One,Two,Three,Four}PPMax (to check for the D which stands for disabled)
	# confusion, TODO obedience

	# The order in which we check for attributes is important
	# Eg. Sleep needs to be checked first as this overrides everything else

	#TODO Sleep could also be handled in the ClockFile, but we'll have it here for testing
	#TODO It's possible for a pokemon to be confused AND paralysed. So far we ignore paralysis if the pokemon is confused.
	if [ "$majorAilment" == "SLP" ]; then
		set_skip_attack_and_cause "SLP"
		return 0
	elif [ "$majorAilment" == "FRZ"  ]; then
		set_skip_attack_and_cause "FRZ"
		return 0
	# Maybe trapped should be a counter like confusion is?
	elif [ "$trapped" == 1 ]; then
		set_skip_attack_and_cause "trapped"
		return 0
	elif [ "$attackUsed" == "D" ]; then
		set_skip_attack_and_cause "disabled"
		return 0
	elif [ $confusion -ne 0 ]; then
		set_skip_attack_and_cause "confused"
		return 0
	elif [ "$majorAilment" == "PAR" ]; then
		set_skip_attack_and_cause "PAR"
		return 0
	fi

	# Uncomment for testing - Note: Include this OUTSIDE of the function.
	# echo "The value for skip_attack = ${skip_attack}. The reason for this is: ${skip_attack_cause}."
}
# Used by pre_attack_status_checks function
set_skip_attack_and_cause(){

	skip_attack=1
	skip_attack_cause="$1"
}


#- Functions that 'check' after the attack phase -#


# Checks if the active pokemon (the pokemon whos turn it is) is poisoned, and if they are, damages them
# Parameters: pokemonToCheck (eg. NPCPokemon)
poison_check(){

	pokemonToCheck="$1"
	read_attribute_battleFile "${battle_filetmp_path}/${pokemonToCheck}.pokemon"

	if [ "$majorAilment" == "PSN" ]; then
		poisonDamage=$( echo "scale=0;(${HP}/16)*(-1)" | bc )
		modify_HP_value "$pokemonToCheck" "$poisonDamage"
	fi
}


# Checks if the active pokemon (the pokemon whos turn it is) is burned, and if they are, damages them
# Parameters: pokemonToCheck (eg. NPCPokemon)
burn_check(){

	pokemonToCheck="$1"
	read_attribute_battleFile "${battle_filetmp_path}/${pokemonToCheck}.pokemon"

	if [ "$majorAilment" == "BRN" ]; then
		burnDamage=$( echo "scale=0;(${HP}/16)*(-1)" | bc )
		modify_HP_value "$pokemonToCheck" "$burnDamage"
	fi
}


# Checks if the active pokemon (the pokemon whos turn it is) is seeded, and if they are, damages them
# and restores the damage to the opposing pokemon
# Parameters: pokemonToCheck opposingPokemon
leech_seed_check(){

	pokemonToCheck="$1"
	opposingPokemon="$2"
	read_attribute_battleFile "${battle_filetmp_path}/${pokemonToCheck}.pokemon"

	if [ "$seeded" == "1" ]; then
		leechDamage=$( echo "scale=0;(${HP}/16)*(-1)" | bc )
		# damage the pokemon who is seeded
		modify_HP_value "$pokemonToCheck" "$leechDamage"
		# heal the opposing pokemon
		leechHeal=$( echo "scale=0;(${leechDamage})*(-1)" | bc )
		modify_HP_value "$opposingPokemon" "$leechHeal"
	fi

	# Uncomment for testing
	# echo "leechDamage = ${leechDamage}. leechHeal = ${leechHeal}." 
}


# End of turn status checks: poison, burn and leech seed for each pokemon.
EOT_status_checks(){

	poison_check 'NPCPokemon'
	burn_check  'NPCPokemon'
	leech_seed_check  'NPCPokemon' 'PCPokemon'

	poison_check 'PCPokemon'
	burn_check 'PCPokemon'
	leech_seed_check 'PCPokemon' 'NPCPokemon'

}


#---- DECISIONS FOR THE PC ---#

# Triggered in battle.sh when the PC selects a move.
# Writes a line to the actionStack
PC_select_move(){

	# NOTE: Uncommented as it destroys things written to the actionStack by moveTicks.
#	clear_actionStack

	read_attribute_battleFile "${battle_filetmp_path}/PCPokemon.pokemon"
	declare -a moveArrayPC=( $moveOne $moveTwo $moveThree $moveFour )
	echo $where_selection_is
	echo ${moveArrayPC[$where_selection_is - 1]}

	write_to_actionStack 1 1 ${moveArrayPC[$where_selection_is - 1]} "PCPokemon" 0 "$actionStackFile"

	# Function below checks the actionStack for NPC actions and makes a decision if it doesn't have a move in the stack yet.
	full_battle_sequence
}



#---- FUNCTIONS FOR SEQUENCING EVENTS (FUNCTIONS THAT CALL OTHER FUNCTIONS IN THE RIGHT ORDER ----#

# Called when a PC selects a move
full_battle_sequence(){

	# checks the stack for actions and then makes a decision and writes that decision to the stack.
	NPC_decide_actions_and_write_to_stack_if_possible
	rewrite_actionStack_with_corrected_priorities

	# Uncomment for testing
	cat "$actionStackFile"

	execute_action
	#TODO check_for_pokemon_death
	clear_top_line_of_actionStack

	# Uncomment for testing
	cat "$actionStackFile"

	execute_action 
	#TODO check_for_pokemon_death

	EOT_status_checks
	#TODO check_for_pokemon_death

	clear_top_line_of_actionStack
	moveTicks_attempt_write_to_actionStack
	tick_down_moveTicks_counters
	#TODO moveTicks_write_to_actionStack - WHY IS THIS HERE? BATTLE SEQUENCE SEEMS TO BE FINISHED
	cat "$actionStackFile"
}



#---- DECISIONS FOR THE NPC ----#
# randomlySelectedMove is a move that has PP and isn't disabled.
# WARNING: If the pokemon has no available moves left this will loop forever
select_random_move(){

	read_attribute_battleFile "${battle_filetmp_path}/NPCPokemon.pokemon"

	declare -a moveArray=( $moveOne $moveTwo $moveThree $moveFour )
	declare -a ppArray=( $moveOnePP $moveTwoPP $moveThreePP $moveFourPP )

	randomIndex=$( shuf -i 0-3 | head -1 )
	randomlySelectedMove=${ppArray[$randomIndex]}

	if [ "$randomlySelectedMove" -eq "$randomlySelectedMove" ] 2>/dev/null; then
		if [ $randomlySelectedMove -gt 0 ]; then
			: # Or do we have to set it to a different variable here?
		else
			select_random_move
		fi
	else
		select_random_move
	fi

	# At this point we have the correct $randomIndex which we just apply to moveArray to get the right move index
	# Re-use randomlySelectedMove cos why not
	randomlySelectedMove=${moveArray[$randomIndex]}
}



# Selects a move and writes the move to the actionStack
#TODO This function will need logic for wild pokemon, trainer pokemon etc.
#TODO For now this function will just select a random move because our aspirations thus far are low.
NPC_select_move(){

	select_random_move
	write_to_actionStack 1 1 "$randomlySelectedMove" "NPCPokemon" 0 "$actionStackFile"
}


#TODO Will handle decision making. This ties in closely with who the fight is with, eg. A wild pokemon can only
# decide to run or fight whereas a juggle might switch out pokemon more often.
# For now this just selects a move.
NPC_make_decision(){

	NPC_select_move	
}


# Called twice per battle loop: Once after the moveTick is complete and once after the player selects an action.
NPC_decide_actions_and_write_to_stack_if_possible(){

	unset NPCaction
	check_actionStack_for_actions
	# $NPCactionStack is obtained from check_actionStack_for_actions
	if [ "$NPCactionStack" == "unpopulated" ]; then
		NPC_make_decision
	fi
}


#---- FUNCTIONS THAT DEAL WITH TIMING/THE STACK----#
# the stack is a cool term that i appropriated from magic the gathering

# Empties the actionStack file
clear_actionStack(){

	> "$actionStackFile"
}

# Writes to the actionStack. Creates an actionStack file if it doesn't exist.
write_to_actionStack(){

	actionID="$1"
	priority="$2"
	scriptVariable="$3"
	playerID="$4"
	counterVariable="$5"
	actionStackFile_toWrite="$6"

	if [ -e "$actionStackFile_toWrite" ]; then
		echo "${actionID}	${priority}	${scriptVariable}	${playerID}	${counterVariable}" >> "$actionStackFile_toWrite"
	else
		echo "${actionID}	${priority}	${scriptVariable}	${playerID}	${counterVariable}" > "$actionStackFile_toWrite"
	fi
}

read_moveTicks(){

	unset PCtickmoveID
	unset PCtickCounter
	unset NPCtickmoveID
	unset NPCtickCounter

	IFS_OLD=$IFS
	IFS='	' #tab
	while read tickmoveID tickCounter tickPlayerID; do
		if [ "$tickPlayerID" == "PCPokemon" ]; then
			PCtickmoveID="$tickmoveID"
			PCtickCounter="$tickCounter"
		elif [ "$tickPlayerID" == "NPCPokemon" ]; then
			NPCtickmoveID="$tickmoveID"
			NPCtickCounter="$tickCounter"
		fi
	done < "$moveTicksFile"
	IFS=$IFS_OLD

}


# reads the moveTicks file and if there's something to write to the actionStack for a given player it does so.
moveTicks_attempt_write_to_actionStack(){

	read_moveTicks

	if [ ! -z "$PCtickmoveID" ]; then
		echo "1	1	${PCtickmoveID}	PCPokemon	${PCtickCounter}" >> "$actionStackFile"
	fi

	if [ ! -z "$NPCtickmoveID" ]; then
		echo "1	1	${NPCtickmoveID}	NPCPokemon	${NPCtickCounter}" >> "$actionStackFile"
	fi
}


# For each line in moveTick file, tick down the counterVariable by 1
# If the counterVariable reaches 0 then don't write the line back to the file
tick_down_moveTicks_counters(){


	# If file has any contents
	if [ -s "$moveTicksFile" ]; then
		IFS_OLD=$IFS
		IFS='	' # tab

		while read tickmoveID tickCounter tickPlayerID; do
	
			[[ $tickCounter -ge 1 ]] && ((tickCounter--))
			if [ $tickCounter -gt 0 ]; then
				echo "${tickmoveID}	${tickCounter}	${tickPlayerID}" >> "$moveTicksFile_tmp"
			fi
	
		done < "$moveTicksFile"

		[[ ! -e "$moveTicksFile_tmp" ]] && touch "$moveTicksFile_tmp"

		mv "$moveTicksFile_tmp" "$moveTicksFile"
	fi
}


# This function reads the actionStack.tab file 
# It extracts variables from the values written to that file.
read_actionStack(){

	IFS_OLD=$IFS
	IFS='	' #tab
	while read actionID priority scriptVariable playerID counterVariable; do
		if [ "$playerID" == "PCPokemon" ]; then
			PCaction="$actionID"
			PCpriority="$priority"
			PCscriptVariable="$scriptVariable"
			PCcounterVariable="$counterVariable"
		elif [ "$playerID" == "NPCPokemon" ]; then
			NPCaction="$actionID"
			NPCpriority="$priority"
			NPCscriptVariable="$scriptVariable"
			NPCcounterVariable="$counterVariable"
		fi
	done < "$actionStackFile"
	IFS=$IFS_OLD


	# Uncomment for testing
#	echo -e "PCaction is ${PCaction}, PCpriority is ${PCpriority}.\nNPCaction is ${NPCaction}. NPC priority is ${NPCpriority}."
}


# If NPC or PC action variable is unpopulated then we know they have no action in the actionStack
check_actionStack_for_actions(){

	read_actionStack
	[[ -z "$PCaction" ]] && PCactionStack="unpopulated" || PCactionStack="populated"
	[[ -z "$NPCaction" ]] && NPCactionStack="unpopulated" || NPCactionStack="populated"

	# Uncomment for testing
#	echo $PCactionStack
#	echo $NPCactionStack
}

# Should both parties pick attack (which defaults to priority 1) then priority is adjusted based on speed stat
# The loser in this comparison gets their action priority in the actionStack (attack in this case) set to 2
# Sets a variable $priority which indicates who goes first.
determine_attack_priority(){

	read_attribute_battleFile "${battle_filetmp_path}/PCPokemon.pokemon"
	PCspeed="$speed"
	read_attribute_battleFile "${battle_filetmp_path}/NPCPokemon.pokemon"
	NPCspeed="$speed"

	if [ $PCspeed -gt $NPCspeed ]; then
		PCpriority_determined=1 && NPCpriority_determined=2

	elif [ $NPCspeed -gt $PCspeed ]; then
		NPCpriority_determined=1 && PCpriority_determined=2

	elif [ $PCspeed -eq $NPCspeed ]; then
		local randomValue=$( shuf -i 1-2 | head -1 )
		case $randomValue in
			1) PCpriority_determined=1 && NPCpriority_determined=2 ;;
			2) NPCpriority_determined=1 && PCpriority_determined=2 ;;
		esac
	fi
}


# If both players have a move on the actionStack then rewrite the actionStack with corrected priorities 
#TODO Expand this later on to consider correcting the priorities of item usage etc.
rewrite_actionStack_with_corrected_priorities(){

	read_actionStack

	if [ $PCaction -eq 1 -a $NPCaction -eq 1 ]; then

		determine_attack_priority

		order_write_to_actionStack

		mv "$actionStackFile_tmp" "$actionStackFile"

	else

		echo "One or both of them didn't choose to attack"
	fi	
}


# Since the action to be executed first is ALWAYS at the top of the stack we write it to the stack in order
order_write_to_actionStack(){

	if [ $NPCpriority_determined -le $PCpriority_determined ]; then

		write_to_actionStack 1 "$NPCpriority_determined" "$NPCscriptVariable" 'NPCPokemon' "$NPCcounterVariable" "$actionStackFile_tmp"
		write_to_actionStack 1 "$PCpriority_determined" "$PCscriptVariable" 'PCPokemon' "$PCcounterVariable" "$actionStackFile_tmp"

	else

		write_to_actionStack 1 "$PCpriority_determined" "$PCscriptVariable" 'PCPokemon' "$PCcounterVariable" "$actionStackFile_tmp"
		write_to_actionStack 1 "$NPCpriority_determined" "$NPCscriptVariable" 'NPCPokemon' "$NPCcounterVariable" "$actionStackFile_tmp"

	fi
}


# The first line of the actionStack is always the one we want to execute.
# We always want to delete a line in the actionStack after it has been executed.
#TODO consider converting the regular read_actionStack to do what this script does but with a line to read up to that
# can be passed as an argument.
read_first_line_actionStack(){

	IFS_OLD=$IFS
	IFS='	' #tab
	while read actionID priority scriptVariable playerID counterVariable; do

		actionID_toExecute=$actionID
		priority_toExecute=$priority
		scriptVariable_toExecute=$scriptVariable
		playerID_toExecute=$playerID
		counterVariable_toExecute=$counterVariable

		break

	done < "$actionStackFile"
	IFS=$IFS_OLD
}


# If there is only one line left of the actionStack then it leaves us with an empty file.
# We don't want anything left in the stack if all actions have been executed.
clear_top_line_of_actionStack(){

	tail -n +2 "$actionStackFile" > "$actionStackFile_tmp"
	mv "$actionStackFile_tmp" "$actionStackFile"
}


execute_action(){

	read_first_line_actionStack

	if [ $actionID_toExecute -eq 1 ] 2>/dev/null; then

		execute_attack "$scriptVariable_toExecute" "$playerID_toExecute" "$counterVariable_toExecute"

	elif [ $actionID_toExecute -eq 2 ] 2>/dev/null; then
		: # Item?

	fi

	unset actionID_toExecute

}


execute_attack(){

	local moveToUse="$1"
	local attackingPokemon="$2"
	local attackArgument="$3"

	if [ "$attackingPlayer" == "PCPokemon" ]; then
		defendingPokemon="NPCPokemon"
	else
		defendingPokemon="PCPokemon"
	fi

	bash "${moves_script_path}/${moveToUse}.sh" "$attackingPokemon" "$defendingPokemon" "$attackArgument"

}


# This function executes things described in the actionStack for a given player
# Not sure where we'll get the $playerID argument from yet, probably somewhere else
#TODO So far we only have ways of executing attacks. We'll eventually need to add item usage and running.
#execute_action "PCPokemon" "$PCaction" "$PCscriptVariable"
_execute_action(){

	local playerID="$1"
	local actionID="$2"
	local scriptVariable="$3"

	# First, the case that the action is to attack
	if [ "$actionID" -eq 1 ]; then

		if [ "$playerID" == "PC" ]; then
			attackingPokemon="PCPokemon"
			defendingPokemon="NPCPokemon"
		else
			attackingPokemon="NPCPokemon"
			defendingPokemon="PCPokemon"
		fi	

	bash "${moves_script_path}/${scriptVariable}.sh" "$attackingPokemon" "$defendingPokemon"

	fi
}

# Occurs between move ticks and the decision phase
# Ticks down pokemon attributes: confusion, sleepCounter, reflect and lightScreen
# NOTE: NEEDS TESTING.
# TODO BREAKING CONFUSION AND SLEEP WILL REQUIRE GUI COMPONENTS MAYBE CREATE A VARIABLE OR WRITE TO SOMEWHERE
# pokemon_attribute_tick "NPCPokemon"
pokemon_attribute_tick(){

	tickingPokemon="$1"
	read_attribute_battleFile "${battle_filetmp_path}/${tickingPokemon}.pokemon"
	if [ $confusion -gt 0 ]; then
		confusionValue=$(( --confusion ))
		echo -e "${pokemonID}\t${pokemonUniqueID}\t${pokemonName}\t${level}\t${HP}\t${currentHP}\t${attack}\t${defense}\t${special}\t${speed}\t6\t6\t6\t6\t${attack}\t${defense}\t${special}\t${speed}\t6\t6\t1\t${typeOne}\t${typeTwo}\t${moveOne}\t${moveTwo}\t${moveThree}\t${moveFour}\t${moveOnePP}\t${moveTwoPP}\t${moveThreePP}\t${moveFourPP}\t${moveOnePPMax}\t${moveTwoPPMax}\t${moveThreePPMax}\t${moveFourPPMax}\t${majorAilment}\t${confusionValue}\t0\t0\t0\t0\t0\t0\t0\t0\t0" >> "${battle_filetmp_path}/${tickingPokemon}.pokemon"
	fi

	if [ $sleepCounter -gt 0 ]; then
		sleepCounterValue=$(( --sleepCounter ))
		echo -e "${pokemonID}\t${pokemonUniqueID}\t${pokemonName}\t${level}\t${HP}\t${currentHP}\t${attack}\t${defense}\t${special}\t${speed}\t6\t6\t6\t6\t${attack}\t${defense}\t${special}\t${speed}\t6\t6\t1\t${typeOne}\t${typeTwo}\t${moveOne}\t${moveTwo}\t${moveThree}\t${moveFour}\t${moveOnePP}\t${moveTwoPP}\t${moveThreePP}\t${moveFourPP}\t${moveOnePPMax}\t${moveTwoPPMax}\t${moveThreePPMax}\t${moveFourPPMax}\t${majorAilment}\t${confusionValue}\t0\t0\t0\t0\t0\t0\t0\t0\t${sleepCounterValue}" >> "${battle_filetmp_path}/${tickingPokemon}.pokemon"
	fi

	if [ $lightScreen -gt 0 ]; then
		lightScreenValue=$(( --lightScreen ))
		echo -e "${pokemonID}\t${pokemonUniqueID}\t${pokemonName}\t${level}\t${HP}\t${currentHP}\t${attack}\t${defense}\t${special}\t${speed}\t6\t6\t6\t6\t${attack}\t${defense}\t${special}\t${speed}\t6\t6\t1\t${typeOne}\t${typeTwo}\t${moveOne}\t${moveTwo}\t${moveThree}\t${moveFour}\t${moveOnePP}\t${moveTwoPP}\t${moveThreePP}\t${moveFourPP}\t${moveOnePPMax}\t${moveTwoPPMax}\t${moveThreePPMax}\t${moveFourPPMax}\t${majorAilment}\t${confusionValue}\t0\t0\t0\t0\t0\t0\t${lightScreenValue}\t0\t0" >> "${battle_filetmp_path}/${tickingPokemon}.pokemon"
	fi

	if [ $lightScreen -gt 0 ]; then
		lightScreenValue=$(( --lightScreen ))
		echo -e "${pokemonID}\t${pokemonUniqueID}\t${pokemonName}\t${level}\t${HP}\t${currentHP}\t${attack}\t${defense}\t${special}\t${speed}\t6\t6\t6\t6\t${attack}\t${defense}\t${special}\t${speed}\t6\t6\t1\t${typeOne}\t${typeTwo}\t${moveOne}\t${moveTwo}\t${moveThree}\t${moveFour}\t${moveOnePP}\t${moveTwoPP}\t${moveThreePP}\t${moveFourPP}\t${moveOnePPMax}\t${moveTwoPPMax}\t${moveThreePPMax}\t${moveFourPPMax}\t${majorAilment}\t${confusionValue}\t0\t0\t0\t0\t0\t0\t${lightScreenValue}\t0\t0" >> "${battle_filetmp_path}/${tickingPokemon}.pokemon"
	fi

}


# Example function calls for testing

#generate_attribute_battleFile "$PCPokemonFile" 1093.001
#deal_damage 'NPCPokemon.pokemon'
#read_moves_file 77
#calculate_STAB 15 "NORMAL" "POISON"
#calculate_type_damage_bonus 15 ROCK DRAGON
#read_base_stats 001
#calculate_crit_bonus 001 PCPokemon
#read_base_stats 001
#modify_HP_value PCPokemon 100
#deal_damage PCPokemon NPCPokemon 33 1
#accuracy_check "PCPokemon" "NPCPokemon" 79
#modifyAttributeByStage 'NPCPokemon' 'accuracy' 7
#statStageModCheck 'NPCPokemon' 'evasion' 4
#read_actionStack Warning - causes infinite loop
#pre_attack_status_checks NPCPokemon 44 ; echo "The value for skip_attack = ${skip_attack}. The reason for this is: ${skip_attack_cause}."
#poison_check NPCPokemon
#burn_check NPCPokemon
#leech_seed_check NPCPokemon PCPokemon
#pokemon_attribute_tick "NPCPokemon"
#check_actionStack_for_actions
#write_to_actionStack 1 2 33 NPC 1 "$actionStackFile"
#NPC_decide_actions_and_write_to_stack_if_possible
#rewrite_actionStack_with_corrected_priorities
#read_first_line_actionStack
#clear_top_line_of_actionStack
#read_moveTicks
#moveTicks_attempt_write_to_actionStack
#tick_down_moveTicks_counters
