#!/bin/bash

owned_pokemon_path="${HOME}/pokemon/gui/character_files/owned_pokemon"
battle_filetmp_path="${HOME}/pokemon/gui/battles/tmp_files"
PCPokemonFile="${battle_filetmp_path}/PCPokemon.pokemon"
NPCPokemonFile="${battle_filetmp_path}/NPCPokemon.pokemon"
moves_file="${HOME}/pokemon/gui/pokemon_database/common/moves/moves.tab"
type_value_key="${HOME}/pokemon/gui/tools/type_value_key_lookup.tab"
type_matchups_array="${HOME}/pokemon/gui/battles/arrays/type_matchups.cfg"
base_stats_path="${HOME}/pokemon/gui/pokemon_database/base_stats/"

source "$type_matchups_array"
source "${HOME}/pokemon/gui/tools/tools.sh"
source "${HOME}/pokemon/gui/battles/arrays/stat_stages.cfg"


# This function generates the "battleFile" for a pokemon (a .tab file which stores its in-battle stats)
# First argument is the full path and name of the file to generate, second argument is the pokemonUniqueID of the pokemon we want to generate the battleFile for.
# eg. generate_attribute_battleFile "$PCPokemonFile" 1093.001
generate_attribute_battleFile(){

	fileToGenerate="$1"
	targetPokemon="${owned_pokemon_path}/${2}"

	read_pokemon_file "$targetPokemon"
	[[ ! -e "$fileToGenerate" ]] && touch "$fileToGenerate"
	# Note: We may use the code below elsewhere so this may become its own function one day.
	echo -e "${pokemonID}\t${pokemonUniqueID}\t${pokemonName}\t${level}\t${HP}\t${currentHP}\t${attack}\t${defense}\t${special}\t${speed}\t6\t6\t6\t6\t${attack}\t${defense}\t${special}\t${speed}\t6\t6\t1\t${typeOne}\t${typeTwo}\t${moveOne}\t${moveTwo}\t${moveThree}\t${moveFour}\t${moveOnePP}\t${moveTwoPP}\t${moveThreePP}\t${moveFourPP}\t${moveOnePPMax}\t${moveTwoPPMax}\t${moveThreePPMax}\t${moveFourPPMax}\t${majorAilment}\t0\t0\t0\t0\t0\t0\t0\t0\t0" >> "$fileToGenerate"
}


# Extracts values from a give pokemon's battleFile
# Argument must be full path + name of battleFile
read_attribute_battleFile(){

	fileToRead="$1"
	IFS_OLD=$IFS
	IFS='	' #tab

	while read pokemonID_ pokemonUniqueID_ pokemonName_ level_ HP_ currentHP_ attack_base_ defense_base_ special_base_ speed_base_ attack_stage_ defense_stage_ special_stage_ speed_stage_ attack_ defense_ special_ speed_ accuracy_ evasion_ crit_multiplier_ typeOne_ typeTwo_ moveOne_ moveTwo_ moveThree_ moveFour_ moveOnePP_ moveTwoPP_ moveThreePP_ moveFourPP_ moveOnePPMax_ moveTwoPPMax_ moveThreePPMax_ moveFourPPMax_ majorAilment_ confusion_ trapped_ seeded_ substituted_ flinch_ semiInvulnerable_ mist_ lightScreen_ reflect_; do
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



	echo "The Pokemon's HP was modified by ${HPMod}. The original HP value was ${currentHP_forTesting}. The current HP is now ${currentHP}."
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


# Example function calls for testing

#generate_attribute_battleFile "$NPCPokemonFile" 1092.001
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

