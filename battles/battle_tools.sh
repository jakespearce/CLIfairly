#!/bin/bash

owned_pokemon_path="${HOME}/pokemon/gui/character_files/owned_pokemon"
battle_filetmp_path="${HOME}/pokemon/gui/battles/tmp_files"
PCPokemonFile="${battle_filetmp_path}/PCPokemon.pokemon"

zeroValue=0

source "${HOME}/pokemon/gui/tools/tools.sh"

# This function generates 
generate_attribute_battleFile(){

	#TODO In future this will be an argument specifying name and location.
	fileToGenerate="$PCPokemonFile"
	#TODO in future this will be an argument specifying the Pokemon file we want to generate
	# an attribute battleFile for.
	targetPokemon="${owned_pokemon_path}/1092.001"

	#TODO this function will be supplied with an argument which will be the pokemon we want to generate battle
	# files for.
	# Random Pokemon is hardcoded for now
	read_pokemon_file "$targetPokemon"
	[[ ! -e "$fileToGenerate" ]] && touch "$fileToGenerate"
	# Note: We may use the code below elsewhere so this may become its own function one day.
	echo -e "${pokemonID}\t${pokemonUniqueID}\t${pokemonName}\t${level}\t${HP}\t${currentHP}\t${attack}\t${defense}\t${special}\t${speed}\t6\t6\t${typeOne}\t${typeTwo}\t${moveOne}\t${moveTwo}\t${moveThree}\t${moveFour}\t${moveOnePP}\t${moveTwoPP}\t${moveThreePP}\t${moveFourPP}\t${moveOnePPMax}\t${moveTwoPPMax}\t${moveThreePPMax}\t${moveFourPPMax}\t${majorAilment}\t0\t0\t0\t0\t0\t0" >> "$fileToGenerate"


}


read_attribute_battleFile(){

	fileToRead="$1"
	IFS_OLD=$IFS
	IFS='	' #tab

	while read pokemonID_ pokemonUniqueID_ pokemonName_ level_ HP_ currentHP_ attack_ defense_ special_ speed_ accuracy_ evasion_ typeOne_ typeTwo_ moveOne_ moveTwo_ moveThree_ moveFour_ moveOnePP_ moveTwoPP_ moveThreePP_ moveFourPP_ moveOnePPMax_ moveTwoPPMax_ moveThreePPMax_ moveFourPPMax_ majorAilment_ confusion_ trapped_ seeded_ substituted_ flinch_; do
		pokemonID="$pokemonID_"
		pokemonUniqueID=$pokemonUniqueID_
		pokemonName=$pokemonName_
		level=$level_
		HP=$HP_
		currentHP=$currentHP_
		attack=$attack_
		defense=$defense_
		special=$special_
		speed=$speed_
		accuracy=$accuracy_
		evasion=$evasion_
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

	done < "$fileToRead"

	IFS=$IFS_OLD
}


#generate_attribute_battleFile
