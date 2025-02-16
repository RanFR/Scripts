#!/bin/bash

# For PX4-Autopilot v1.12.3

# Function
add_to_env() {
    local var_name=$1
    shift
    local paths=("$@")

    # Get current value
    local current_value=$(eval echo \$$var_name)

    # Loop
    for new_path in "${paths[@]}"; do
        if [[ ":$current_value:" != *":$new_path:"* ]]; then
            current_value="$current_value:$new_path"
            echo "$new_path has been added to $var_name."
        else
            echo "$new_path is already in $var_name."
        fi
    done

    export $var_name="$current_value"
}

ROOT_DIR="/home/ranfr/Softwares/PX4-Autopilot"
BUILD_DIR="${ROOT_DIR}/build/px4_sitl_default"

new_path_for_package=(
    "${ROOT_DIR}"
    "${ROOT_DIR}/Tools/sitl_gazebo"
)

new_path_for_plugin=("${BUILD_DIR}/build_gazebo")

new_path_for_model=("${ROOT_DIR}/Tools/sitl_gazebo/models")

new_path_for_LIBRARY=("${BUILD_DIR}/build_gazebo")

# Setup Gazebo env and update package path
add_to_env "ROS_PACKAGE_PATH" "${new_path_for_package[@]}"
add_to_env "GAZEBO_PLUGIN_PATH" "${new_path_for_plugin[@]}"
add_to_env "GAZEBO_MODEL_PATH" "${new_path_for_model[@]}"
add_to_env "LD_LIBRARY_PATH" "${new_path_for_library[@]}"
