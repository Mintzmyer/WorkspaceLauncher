#!/bin/bash

source ./OpenWorkspace.sh
source ./SaveWorkspace.sh

#---------------------------------------------------------------------
# This script saves and launches preset desktop/program configurations
#     referred to as 'Workspaces'. Often, different tasks will require
#     different sets of applications and a developer may have specific
#     layouts they prefer.
#
# The goal is to save time and tedium by allowing developers to launch
#     a series of programs/files automatically, positioned and set up.
#
# This file predominantly contains interface and control logic, saving
#     and opening workspace functionality is implemented separately
#---------------------------------------------------------------------


# Verifies a list of tools needed to run this program
#     If missing, reports the tool(s) to the user, then exits this program
preFlight(){
    toolsNeeded=0
    for tool in xdotool wmctrl; do
        command -v $tool >/dev/null 2>&1 || { echo >&2 "I require $tool but it's not installed."; }
        toolsNeeded=$((toolsNeeded||1))
    done
    if [ $toolsNeeded -eq 1 ]; then
        { echo >&2 "Aborting"; exit 1;}
    fi
}

OpenWorkspace(){
    echo "This function will open a new workspace
"
}

WriteWorkspace(){
    echo "This function will allow users to create a workspace by entering programs, for later use
"
}

SaveWorkspace(){
    echo "This function will accrue info of current setup and save it as a workspace for later use
"
}


main(){
    echo "Main Loop"
    preFlight
}

# Set savefile location (2 params: set command and dir location)
if [ "$#" -eq 2 ] && [ $1 == "new" ]; then
    SaveWorkspace

# Write to file functions (Overloaded)
    # (1 param: write command launches list)
elif [ "$#" -eq 1 ] && [ $1 == "save" ]; then
    WriteWorkspace

    # (2 param: write command and launch file)
elif [ "$#" -eq 2 ] && [ $1 == "save" ]; then
    SaveWorkspace

# Usage helper message
else
    echo "Usage: ./Launcher.sh has a number of commands
Unfortunately, none of them are implemented yet :)

Set a savefile location to store preset workspaces

Set a new workspace preset

Open a new workspace preset
"
fi


main

