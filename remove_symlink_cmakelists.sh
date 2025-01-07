#!/bin/bash

# Check if the root directory parameter is provided
if [ $# -lt 1 ]; then
  echo "Usage: $0 <root folder>"
  exit 1
fi

# Root directory path
root_dir="$1"

# Recursively find symlinked CMakeLists.txt files and delete them
find "$root_dir" -type l -name "CMakeLists.txt" -exec rm -f {} +

echo "Deletion complete!"
