#!/bin/bash

mkdir -p /Users/$USER/WorkspaceLauncher/SaveData

OpenWorkspace(){
    echo "This function will open a new workspace
"
}

SaveWorkspace(){
    echo "This function will allow users to create a workspace by entering programs, for later use
"
#This command locates executable, for example Google Chrome
#find / -name "Google Chrome" -type f -perm +111 -print -quit 2> >(grep -v 'Permission denied' >&2)
}

SaveWorkspace(){
    echo "This function will accept a file of programs and save it as a workspace for later use
"
}

# Possibly come back to this, for setting different save directories
#    echo $2
#    mkdir -p $2
#    echo $2 >> /Users/ifreyja/WorkspaceLauncher/SaveData

# Open workspace (2 params: open command and workspace name)
if [ "$#" -eq 2 ] && [ $1 == "open" ] then
    OpenWorkSpace()


# Set savefile location (2 params: set command and dir location)
elif [ "$#" -eq 2 ] && [ $1 == "new" ]; then
    SaveWorkspace

# Save to file functions (Overloaded)
    # (1 param: write command launches list)
elif [ "$#" -eq 1 ] && [ $1 == "save" ]; then
    SaveWorkspace

    # (2 param: write command and launch file)
elif [ "$#" -eq 2 ] && [ $1 == "save" ]; then
    SaveWorkspace

# Usage helper mesage
else
    echo "Usage: ./Launcher.sh has a number of commands
Unfortunately, none of them are implemented yet :)

Set a savefile location to store preset workspaces

Set a new workspace preset

Open a new workspace preset
"
fi
