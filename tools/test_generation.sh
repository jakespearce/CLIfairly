#!/bin/bash
base="${HOME}/pokemon/gui/pokemon_database/base_stats/001.statsBULBASAUR"
movs="${HOME}/pokemon/gui/pokemon_database/move_list/001.movesBULBASAUR"
pokemon_generation="/home/senpai/pokemon/gui/tools/pokemon_generator.sh"
level=40

bash $pokemon_generation $base $movs $level
