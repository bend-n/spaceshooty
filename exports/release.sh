#!/bin/bash

release_path=~/spaceshooty/exports

if [ "$1" == "-y" ]; then
    yes | release -e spaceshooty "$release_path/linux" "$release_path/windows" "$release_path/mac" "$release_path/html" $1
else
    release -e spaceshooty "$release_path/linux" "$release_path/windows" "$release_path/mac" "$release_path/html" $1
fi
