#!/bin/bash

echo "Type root path for the rust-bspwm-docker followed by [ENTER]:"
read root_path

echo "Type the project path followed by [ENTER]:"
read -e project

if [ "$root_path" == "" ]; then
    echo "Bad root path: " $root_path
    exit 1
else
    if [ "$project" == "" ]; then
        echo "Bad project path: " $project
        exit 1
    else
        docker run --rm -it -e DISPLAY=$DISPLAY \
            -p 8083:8083 \
            -v ~/$root_path/rust-bspwm-docker/.vscode/:/home/andrei/.vscode/ \
            -v $project:/home/andrei/project/ \
            rust-bspwm-docker:latest \
            supervisord
        exit 0
    fi
fi
