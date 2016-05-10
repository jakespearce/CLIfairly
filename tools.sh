#!bin/bash

# changes a key value in a config file to a value we specify.
# usage: change_conf_value $config_file_path $key_to_change $new_value
# eg. change_conf_value /.../gui/character.cfg "level" 99
change_conf_value(){

	config_file_path=$1
  	key_to_change=$2
  	new_value=$3

  	sed -i "s/\($key_to_change *= *\).*/\1$new_value/" $config_file_path
}

# reads a pokemon file and extracts values to variables.

read_pokemon_file(){

	fileToRead=$1

        while read -r pokemonID_ pokemonUniqueID_ pokemonName_ pokemonGivenName_ inventoryStatus_ currentHP_ level_ typeOne_ typeTwo_ moveOne_ moveTwo_ moveThree_ moveFour_ moveOnePP_ moveTwoPP_ moveThreePP_ moveFourPP_ moveOnePPMAX_ moveTwoPPMax_ moveThreePPMax_ moveFourPPMax_ HP_ attack_ defence_ special_ speed_ majorAilment_ confusion_ trapped_ chargingUp_ substituted_ flinched_ levellingRate_ catchRate_ baseEXPYield_; do
            pokemonID="$pokemonID_"
            pokemonUniqueID="$pokemonUniqueID_"
            pokemonName="$pokemonName_"
            pokemonGivenName="$pokemonGivenName_"
            inventoryStatus="$inventoryStatus_"
            currentHP="$currentHP_"
            level="$level_"
            typeOne="$typeOne_"
            typeTwo="$typeTwo_"
            moveOne="$moveOne_"
            moveTwo="$moveTwo_"
            moveThree="$moveThree_"
            moveFour="$moveFour_"
            moveOnePP="$moveOnePP_"
            moveTwoPP="$moveTwoPP_"
            moveThreePP="$moveThreePP_"
            moveFourPP="$moveFourPP_"
            moveOnePPMax="$moveOnePPMax_"
            moveTwoPPMax="$moveTwoPPMax_"
            moveThreePPMax="$moveThreePPMax_"
            moveFourPPMax="$moveFourPPMax_"
            HP="$HP_"
            attack="$attack_"
            defence="$defence_"
            special="$special_"
            speed="$speed_"
            majorAilment="$majorAilment_"
            confusion="$confusion_"
            trapped="$trapped_"
            chargingUp="$chargingUp_"
            seeded="$seeded_"
            substituted="$substituted_"
            flinched="$flinched_"
            levellingRate="$levellingRate_"
            catchRate="$catchRate_"
            baseEXPYield="$baseEXPYield"
        done < "${pokemon_file_location[$]}"
    IFS=$OLD_IFS


}


