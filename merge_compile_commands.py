"""
dump all compile_commands.json files in the build folder and its child folders to a single file
"""

import os
import json

# get the root directory of the project
file_dir = os.getcwd()
root_dir = file_dir
build_dir = os.path.join(root_dir, 'build')

# save the compile_commands.json file
compile_commands = []

# loop build folder and child folders to find compile_commands.json file
for root, _, files in os.walk(build_dir):
    # skip the root folder if it is the build folder
    if root == build_dir and 'compile_commands.json' in files:
        continue
    if 'compile_commands.json' in files:
        file_path = os.path.join(root, 'compile_commands.json')
        if os.path.getsize(file_path) > 0:  # check whether the file is empty
            try:
                with open(file_path, 'r', encoding="UTF-8") as f:
                    compile_commands.extend(json.load(f))
            except json.JSONDecodeError as e:
                print(f"Error decoding JSON from {file_path}: {e}")
        else:
            print(f"Skipping empty file: {file_path}")

# define path of compile_commands.json file
output_file_path = os.path.join(build_dir, 'compile_commands.json')

# check whether the build folder exists, if not, create it
if not os.path.exists(build_dir):
    os.makedirs(build_dir)

# dump the compile_commands to the output file
with open(output_file_path, 'w', encoding="UTF-8") as f:
    json.dump(compile_commands, f, indent=2)

print(f"Compile commands have been written to {output_file_path}")
