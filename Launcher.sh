#!/bin/bash

# Usage helper mesage
if [ "$#" -ne 1 ]; then
    echo "Usage: ./Launcher.sh has a number of commands
Unfortunately, none of them are implemented yet :)

Set a savefile location to store preset workspaces

Set a new workspace preset

Start a new workspace preset
"
fi

# Set savefile location (2 params: set command and dir location)
if [ "$#" -eq 2 ] && [ $1 == "new" ]; then
    echo "This command opens a new workspace configuration
Unfortunately, this is not implemented yet
"
fi

# Read from file functions (2 params: read command and file name)


# Write to file functions (Overloaded)
    # (1 param: write command launches list)
if [ $1 == "save" ]; then
    echo "This command saves a workspace configuration for later use
Unfortunately, this is not implemented yet
"
fi

    # (2 param: write command and launch file)
if [ "$#" -eq 2 ] && [ $1 == "save" ]; then
    echo "This command takes a file as a second argument and saves it as a workspace for later use
Unfortunately, this is not implemented yet
"
fi
