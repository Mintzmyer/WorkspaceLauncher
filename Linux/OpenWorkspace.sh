#!/bin/bash

#---------------------------------------------------------------------
# This script handles the functionality for opening a preset workspace
#     layout; starts programs, resizes and relocates windows, etc
#---------------------------------------------------------------------

# Launches a program or application and returns the process id
startProgram(){
    cmd=$1
    $cmd &
    PID=$!
    echo "$PID"
}

# This is a test function exercising some commands, disregard this
move(){
    sleep 0.5
    wmctrl -l -p
    WID=$(wmctrl -l -p | grep "$PID" | cut "-d " -f1)
    echo "$WID"
    wmctrl -i -r $WID -b remove,maximized_horz,maximized_vert
    wmctrl -i -r $WID -e 0,50,50,500,500
    wmctrl -i -r $WID -b add,maximized_horz,maximized_vert
}

#Test
startProgram firefox

