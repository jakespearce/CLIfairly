#!/bin/bash
# Attack ID 101 is fly. This is here for testing out the functionality of the moveTicks system. 

source "${HOME}/pokemon/gui/battles/battle_tools.sh"

attackingPokemon="$1"
defendingPokemon="$2"
counterVariableArgument="$3"
attackBeingUsed=101
nameOfAttack="Fly"

# If $counterVariable is empty
if [ -z $counterVariableArgument ]; then
	echo "The counter variable is unset. This means the Pokemon is flying up high. This is when we write a line to the moveTicks file."
elif [ $counterVariableArgument -eq 1 ]; then
	echo "This is when the Pokemon comes down for an attack"
fi


# Calling growl, an example:
# $ bash 45.sh $AttackingPokemon $DefendingPokemon
# $ bash 45.sh PCPokemon NPCPokemon 
