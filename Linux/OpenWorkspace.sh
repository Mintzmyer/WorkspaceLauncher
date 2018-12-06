#!/bin/bash

#---------------------------------------------------------------------
# This script handles the functionality for opening a preset workspace
#     layout; starts programs, resizes and relocates windows, etc
#---------------------------------------------------------------------

# Gets location of source files
SOURCE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source "$SOURCE/UI.sh"


# Launches a program or application and returns the process id
# Arguments: Command - The command to launch
# Returns: PID - The process ID of the command
startProgram(){
    cmd=$1
    $cmd &
    # This doesn't quite work. It returns the PID of the
    # process launching the command, distinct from the
    # PID of the command itself. Need to rethink this.
    PID=$!
    echo "$PID"
}

# Returns the location of a savefile given a workspace name
# Arguments: Workspace name - The name of a workspace
# Returns: Location of the savefile
getSavefileFromWorkspace(){
    workspace=$1
    location=$SAVES$workspace
    echo "$location"
}

# Starts the program contained in a line of a savefile
# Arguments: Line - A line of the savefile: <Program> <x> <y> <width> <height>
# Returns: PID - The process ID of the command that started
startProgramFromSavefileLine(){
    line=$1
    CMD=$(echo $line | cut "-d " -f1)
    PID=$(startProgram "$CMD")
    echo "$PID"
}

# Fetches the WID given the PID
# Arguments: PID - The Process ID of a program
# Returns: WID - The Window ID of a program's window
getWidFromPid(){
    PID=$1
    WID=$(wmctrl -lp | grep "$PID" | cut "-d " -f1)
    echo $WID
}

# Relocates and resizes window by WID
# Arguments: WID - Window ID
#            Line - A line of the savefile: <Program> <x> <y> <width> <height>
resizeWindowByWid(){
    WID=$1
    line=$2
    echo "$WID $line"
    xywh=( $(echo "$line" | cut "-d " -f2-5) )
    # For some reason, wmctrl reports the x and y position as double
    # Dig in here to find a true x/y location, but for now just halve it
    wmctrl -i -r $ID -e 0,$((${xywh[0]}/2)),$((${xywh[1]}/2)),${xywh[2]},${xywh[3]}
}

# Uses a line of the savefile to launch a program and position it
# Arguments: line - A line of the savefile: <Program> <x> <y> <width> <height>
launchAndPositionFromSavefileLine(){
    line=$1
    PID=$(startProgramFromSavefileLine "$line")
    # Brief sleep to let window launch
    sleep .5
    WID=$(getWidFromPid "$PID")
    resizeWindowByWid "$WID" "$line"
}

# Opens a savefile and launches each element in workspace
# Arguments: pathToSavefile - The savefile representation of the workspace to launch
launchWorkspaceFromSavefile(){
    pathToSavefile=$1
    while read line; do
        launchAndPositionFromSavefileLine "$line" &
    done <"$pathToSavefile"
}


