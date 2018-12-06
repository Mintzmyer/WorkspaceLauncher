#!/bin/bash

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


# Gets location of source files
SOURCE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source "$SOURCE/UI.sh"
source "$SOURCE/OpenWorkspace.sh"
source "$SOURCE/SaveWorkspace.sh"


# Verifies a list of tools needed to run this program
#     If missing, reports the tool(s) to the user, then exits this program
#     Add tools as needed to for loop list following wmctrl
preFlight(){
    toolsNeeded=0
    for tool in wmctrl; do
        command -v $tool >/dev/null 2>&1 || \
                { echo >&2 "I require $tool but it's not installed."; toolsNeeded=$((toolsNeeded+1)); }
    done
    if [ $toolsNeeded -ne 0 ]; then
        { echo >&2 "Please install the necessary tools"; exit 1;}
    fi
}

main(){
    preFlight
    # Read all saved workspaces into an array
    workspaceFiles=()
    unset workspaceFiles
    i=0
    while read file; do
        i=$((i+1))
        workspaceFiles+=( "$i" );
        workspaceFiles+=( "$file" );
    done < <(ls $SAVES)
    # Add the option to save a new workspace
    i=$((i+1))
    workspaceFiles+=( "$i" );
    workspaceFiles+=( "Save your current configuration as a workspace" );

    echo "Workspace Launcher Menu: "
    for (( j=1; j<=i; j++ )); do
	    echo "    ${workspaceFiles[$((2*(j-1)))]}. ${workspaceFiles[$(((2*j)-1))]}"
    done
    REPLY=$(getBtnPress "Select an option to begin: ")
    # Check if the user is saving a new workspace
    if [ $REPLY -eq $i ]; then
        saveNewWorkspace
    else
        file="${workspaceFiles[$(((2*REPLY)-1))]}"
	savefile=$SAVES$file
        launchWorkspaceFromSavefile "$savefile"
    fi
}

main

