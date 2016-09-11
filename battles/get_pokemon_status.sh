#!/bin/bash

# This file is simply for testing purposes since there's no gui yet

source battle_tools.sh

tmp_file_path="${HOME}/pokemon/gui/battles/"
pokemonToLookAt="${tmp_file_path}${1}"

read_attribute_battleFile "$pokemonToLookAt"

echo -e "The Pokemon with unique ID ${pokemonUniqueID} has ${currentHP}/${HP} HP."
