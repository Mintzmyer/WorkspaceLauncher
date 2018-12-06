#!/bin/bash

#---------------------------------------------------------------------
# This script consolidates some of the common user interface logic
#     used throughout the program. Hopefully it can act as a template
#     for future programs as well, handling user input and so forth
#---------------------------------------------------------------------

# Global location of all saved Workspace files
SAVES="$SOURCE/../Savefiles/"

## Function to get char+enter from user and return char  ##
getBtnPress(){
    if [[ $# -lt 1 ]]; then
         prompt="Make a selection?"
    else
         prompt=$1
    fi
    read -p "$prompt" -n 2 -r REPLY </dev/tty
    echo -n $REPLY
}

## Function to get a string+enter from user and return string  ##
getUserInputLine(){
    if [[ $# -lt 1 ]]; then
         prompt="Say something: "
    else
         prompt=$1
    fi
    read -p "$prompt" REPLY </dev/tty
    echo -n $REPLY
}
