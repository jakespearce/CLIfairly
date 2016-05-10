#!/bin/bash
base="${HOME}/pokemon/gui/pokemon_database/base_stats/001.statsBULBASAUR"
movs="${HOME}/pokemon/gui/pokemon_database/move_list/001.movesBULBASAUR"
pokemon_generation="${HOME}/pokemon/gui/tools/pokemon_generator.sh"
level=$1

bash $pokemon_generation $base $movs $level
