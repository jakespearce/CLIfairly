#!/bin/bash

# looking at what we're required to generate here it's apparent that our 'owned pokemon' files need more data.
# data we don't have but data we need for this 

# Things that our Owned pokemon file is missing: move{One,Two,Three,Four} max PP (we CAN get this from the move file... but is it better to have it all in one place? (could create a tool.sh function for reading max PP values.)
# Experience points (read up on this - may turn out to be quite involved.)
# For Experience points, see the experience points notes in the tools directory.

# creates 5 separate blocks of gui that we combine with an .art file to create each of the two stats screens
# Without correct whitespace.. 

#blockOne (stat screen one): 
#
# $POKEMONNAME
# L $pokemon_level
# HP: #########--------
#    $currentHP / $maxHP
# STATUS / $mainAilment
#
#blockTwo (stat screen one)
#
# $pokemonID
# (some nice box formatting)
# ATTACK
# 	$attack
# DEFENSE
# 	$defense
# SPEED
# 	$speed
# SPECIAL
# 	$special
#
#blockThree (stat screen one)
#
# TYPE1/
# 	$typeOne
# TYPE 2/ (if applicable. otherwise this is empty)
# 	$typeTwo
# IDNo/
# 	$pokemonUniqueID
# OT/
# 	$originalTrainer (?)
#
#blockFour (stat screen two)
#
# $POKEMONNAME
#
# EXP POINTS
# 	$exPoints
# LEVEL UP
# 	210 to :L $(( $pokemon_level + 1 ))
#
#blockFive (stat screen two)
#
#
#(slightly to the left so it lands under the .art image, we have "No.$pokemonID"
#(sick box graphics)
# $moveOneName
# 	pp $moveOnePP / $moveOneMaxPP
# $moveTwoName
# 	pp $moveTwoPP / $moveTwoMaxPP
# $moveThreeName
# 	pp $moveThreePP / $moveThreeMaxPP
# $moveFourName
# 	pp $moveFourPP / $moveFourMaxPP
#
#
echo "This is the stats script. this should be fun to code :)"

sleep 2

