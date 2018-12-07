#!/bin/bash

#---------------------------------------------------------------------
# This script handles the functionality for opening a preset workspace
#     layout; starts programs, resizes and relocates windows, etc
#---------------------------------------------------------------------

# Gets location of source files
SOURCE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source "$SOURCE/UI.sh"


# Returns the location of a savefile given a workspace name
# Arguments: Workspace name - The name of a workspace
# Returns: Location of the savefile
getSavefileFromWorkspace(){
    workspace=$1
    location=$SAVES$workspace
    echo "$location"
}

# Launches a program or application and returns the process id
# Arguments: Command - The command to launch
# Returns: PID - The process ID of the command
startProgram(){
    cmd=$1
    # Need to redirect output or command substitution blocks return
    $cmd >/dev/null & PID=$!

    # This doesn't quite work. It returns the PID of the
    # process launching the command, but if the program is
    # already running it *may* be absorbed under the original
    # processes's PID. Hence the need for getWidFromLine()
    echo "$PID"
}

# Parses out and starts the program contained in a line of a savefile
# Arguments: Line - A line of the savefile: <Program> <x> <y> <width> <height>
# Returns: PID - The process ID of the command that started
startProgramFromSavefileLine(){
    line=$1
    CMD=$(echo $line | cut "-d " -f1)
    PID=$(startProgram "$CMD")
    echo "$PID"
}

# Fetches the most recently launched WID given the PID
# Arguments: PID - The Process ID of a program
# Returns: WID - The Window ID of a program's window, or ""
getWidFromPid(){
    PID=$1
    # Make sure we have a PID to search for
    if [ "$PID" == "" ]; then
        return;
    fi
    WID=$(wmctrl -lp | grep "$PID" | tail -1 | cut "-d " -f1)
    echo $WID
}

# Tries to find a WID by the process name given a savefile line, returns WID
#     Chooses the most recently launched process of that name
# Arguments: Line - A line of the savefile: <Program> <x> <y> <width> <height>
# Returns: WID - A Windows ID, or ""
getWidFromLine(){
    line=$1
    cmd=$( echo "$line" | cut "-d " -f1)
    WID=$(wmctrl -l | grep "$cmd" | tail -1 | cut "-d " -f1)
    # If WID wasn't found using wmctrl, try using pgrep
    if [ "$WID" == "" ]; then
        PID=$(pgrep "$cmd")
	    WID=$(getWidFromPid "$PID")
    fi

    echo "$WID"
}

# Relocates and resizes window by WID
# Arguments: WID - Window ID
#            Line - A line of the savefile: <Program> <x> <y> <width> <height>
resizeWindowByWid(){
    WID=$1
    line=$2
    if [ $DEBUG -eq 1 ]; then echo "$WID $line"; fi
    xywh=( $(echo "$line" | cut "-d " -f2-5) )
    # For some reason, wmctrl reports the x and y position as double
    # Dig in here to find a true x/y location, but for now just halve it
    wmctrl -i -r $WID -e 0,$((${xywh[0]}/2)),$((${xywh[1]}/2)),${xywh[2]},${xywh[3]}
}

# Uses a line of the savefile to position a program window
# Arguments: line - A line of the savefile: <Program> <x> <y> <width> <height>
#            PID - The Process ID of a program
positionWindowFromSavefileLine(){
    line=$1
    PID=$2
    WID=$(getWidFromPid "$PID")
    # If WID wasn't found using PID, try using the command name
    if [ "$WID" == "" ]; then
        WID=$(getWidFromLine "$line")
    fi

    if [ $DEBUG -eq 1 ]; then echo "pIdNum=$pIdNum PID=${workspacePids[$pIdNum]} WID=$WID"; fi
    resizeWindowByWid "$WID" "$line"
}

# Opens a savefile and launches each element in workspace
# Arguments: pathToSavefile - The savefile representation of the workspace to launch
launchWorkspaceFromSavefile(){
    pathToSavefile=$1

    # Read the workspace savefile line by line and launch the program
    while read line; do
        PID=$(startProgramFromSavefileLine "$line")
        sleep .5
        positionWindowFromSavefileLine "$line" "$PID"
    done <"$pathToSavefile"
}
