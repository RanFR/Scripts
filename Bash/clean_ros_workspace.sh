#!/bin/bash

# If no root directory is provided, the current directory is used by default
root_dir="${1:-.}"

# delete build and devel folders
find "$root_dir" -type d \( -name "build" -o -name "devel" -o -name "logs" \) -exec rm -rf {} +

# delete .catkin_workspace
find "$root_dir" -type f -name ".catkin_workspace" -exec rm -f {} +

# delete symbol link CMakeLists.txt
find "$root_dir" -type l -name "CMakeLists.txt" -exec rm -f {} +

echo "Delete successfully!"
