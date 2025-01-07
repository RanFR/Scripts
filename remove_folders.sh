#!/bin/bash

# Check if at least two arguments are provided
if [ $# -lt 2 ]; then
  echo "Usage: $0 <Root folder> <folder 1> <folder 2> ..."
  exit 1
fi

# The first parameter is the root directory
root_dir="$1"
# Remove the first parameter, and the remaining parameters are the names of the folders to be deleted
shift

# Loop through all the folder names to be deleted
for folder in "$@"; do
  # Recursively find and delete folders with the specified name
  find "$root_dir" -type d -name "$folder" -exec rm -rf {} +
  echo "Deleted folder: $folder"
done

echo "Deletion completed!"
