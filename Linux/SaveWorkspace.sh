#!/bin/bash

#---------------------------------------------------------------------
# This script handles the functionality for saving the current desktop
#     layout; programs, window sizes and locations, etc
#---------------------------------------------------------------------

# Gets location of source files
SOURCE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source "$SOURCE/UI.sh"

# Handles logic for getting user savefile name
# Returns: filename - A name for the new workspace's savefile
getSaveFileName(){
    filename=$(getUserInputLine "Save this workspace as: ")
    if [ -f "$SAVES$filename" ]; then
        prompt="The workspace $filename already exists! Overwrite it? Y/n: "
    else
        prompt="Save workspace as $filename? Y/n: "
    fi
    REPLY=$(getBtnPress "$prompt")
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "$filename"
    else
        REPLY=$(getBtnPress "Try a different name? Y/n: ")
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            getSaveFileName
	fi
    fi
}

# Parses the PID from a line of wmctrl -lp
# Arguments: Line - a line of the wmctrl -lp output
# Returns: PID - The process ID
getPidFromWmctrlLine(){
    line=$1
    line=${line/  / }
    pid=$(echo $line | cut "-d " -f3)
    echo $pid
}

# Parses the WID from a line of wmctrl -lp
# Arguments: Line - a line of the wmctrl -lp output
# Returns: WID - The window ID
getWidFromWmctrlLine(){
    line=$1
    line=${line/  / }
    wid=$(echo $line | cut "-d " -f1)
    echo $wid
}

# Fetches the command name associated with a PID
# Arguments: PID - The process ID
# Returns: String of the process command name
getCommandNameByPid(){
    PID=$1
    # Gets the process name from the PID
    name=$(ps -p $PID -o comm= 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo $name
    fi
}

# Gathers window position/dimensions of a WID
# Arguments: WID - The window ID to gather
# Returns: String x-offset y-offset width height separated by spaces
getDimensionsByWid(){
    WID=$1
    line=$(wmctrl -lG | grep $WID | head -1 )
    # Only single spaces, remove extra whitespace from line #
    dims=${line/  / }
    echo $(echo $dims | cut "-d " -f3-6)
}

# Writes info (programs, parameters, positioning etc) to a savefile
# Arguments: Filename - the file to write to
#            Value - the content to write
#            [Overwrite] - boolean: 0 to append, 1 to clear/overwrite
writeLineToSavefile(){
    FILE=$1
    line=$2
    mkdir -p "$SAVES"
    # Default behavior is append, unless Overwrite is specified
    if [ $# -ge 3 ] && [ $3 -eq 1 ]; then
        echo "$line" > "$SAVES$FILE"
    else
        echo "$line" >> "$SAVES$FILE"
    fi
}

# Iterates through windows, saving programs on user approval
saveNewWorkspace(){
    # Get save file name. If none selected, return
    savefile=$(getSaveFileName)
    if [[ "$savefile" == "" ]]; then
        return;
    fi
    # Empty any existing contents of file
    > "$savefile"

    #for line in $(wmctrl -lp); do
    while read -r line; do
        PID=$(getPidFromWmctrlLine "$line")
	CMD=$(getCommandNameByPid "$PID")
	REPLY=""
	if [[ "$CMD" != "" ]]; then
            REPLY=$(getBtnPress "Save location of $CMD? Y/n: ")
        fi
	if [[ $REPLY =~ ^[Yy]$ ]]; then
            WID="$(getWidFromWmctrlLine "$line")"
	    DIM="$(getDimensionsByWid "$WID")"
            writeLineToSavefile "$savefile" "$CMD $DIM"
        fi
    done <<< $(wmctrl -lp)
}

