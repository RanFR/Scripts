#!/bin/bash

# If no root directory is provided, the current directory is used by default
root_dir="${1:-.}"
dry_run=false

# Check if -n option is provided
if [[ "$1" == "-n" ]]; then
    dry_run=true
    root_dir="${2:-.}"  # The second parameter is the directory
fi

echo "Starting cleanup under: $root_dir"
if $dry_run; then
    echo "[Dry Run Mode] No files will actually be deleted."
fi

# Function to safely find, excluding .git directories
safe_find() {
    find "$root_dir" -path "$root_dir/.git" -prune -o "$@"
}

# Delete build, devel, and logs directories
echo "Searching for directories named build, devel, or logs..."
safe_find -type d \( -name "build" -o -name "devel" -o -name "logs" \) -print | while read -r dir; do
    echo "Found directory: $dir"
    if ! $dry_run; then
        rm -rf "$dir"
        echo "Deleted: $dir"
    fi
done

# Delete .catkin_workspace files
echo "Searching for .catkin_workspace files..."
safe_find -type f -name ".catkin_workspace" -print | while read -r file; do
    echo "Found file: $file"
    if ! $dry_run; then
        rm -f "$file"
        echo "Deleted: $file"
    fi
done

# Delete symbolic link CMakeLists.txt
echo "Searching for symbolic links named CMakeLists.txt..."
safe_find -type l -name "CMakeLists.txt" -print | while read -r link; do
    echo "Found symbolic link: $link"
    if ! $dry_run; then
        rm -f "$link"
        echo "Deleted: $link"
    fi
done

echo "Cleanup completed!"
