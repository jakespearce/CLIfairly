#!/bin/bash

# This script is useful for testing out the actionStack. 
# If the actionStack function calls a move, then we get a loop when we run the function from the battle_tools file
# This is because the move script sources battle_tools, which runs the action stack, which calls the move script...


source "${HOME}/pokemon/gui/battles/battle_tools.sh"

read_actionStack
execute_action "PC" "$PCaction" "$PCscriptVariable"
execute_action "NPC" "$NPCaction" "$NPCscriptVariable"
