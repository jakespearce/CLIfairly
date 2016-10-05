#!/bin/bash


source "${HOME}/pokemon/gui/battles/battle_tools.sh"

attackingPokemon="$1"
defendingPokemon="$2"
attackBeingUsed=33
nameOfAttack="Tackle"

# Get attacker's species ID for the calculate_crit_bonus function
read_attribute_battleFile "${battle_filetmp_path}/${attackingPokemon}.pokemon"
attackerSpeciesID="$pokemonID"

# Determine whether the attack hits or not (returns the $doesTheMoveHit variable)
accuracy_check "$attackingPokemon" "$defendingPokemon" "$attackBeingUsed"

if [ "$doesTheMoveHit" == "yes"  ]; then
	calculate_crit_bonus "$attackerSpeciesID" "$attackingPokemon" 1
	deal_damage "$attackingPokemon" "$defendingPokemon" "$attackBeingUsed" "$criticalModifier"
elif [ "$doesTheMoveHit" == "no" ]; then
	#NOTE Here temporarily for testing
	echo "The attack missed! Write a function to call for this."
fi

#NOTE The script that lowers PP of a move should occur and before outside of the move script
#NOTE The attack missing message should be part of the battle gui. The 'attack missed' message is just here for
# testing purposes.
