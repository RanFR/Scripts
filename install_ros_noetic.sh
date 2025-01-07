#!/bin/bash

# Set ros mirror list
setup_ros_mirror() {
    local mirror_url="https://mirrors.cernet.edu.cn/ros/ubuntu/"
    local distro="focal"
    local mirror_file="/etc/apt/sources.list.d/ros.list"

    if [ ! -f "$mirror_file" ]; then
        echo "Creating $mirror_file..."
        touch "$mirror_file"
    fi

    # Write mirror url
    echo "deb $mirror_url $distro main" > "$mirror_file"
}

# Set ros key
setup_ros_key() {
    apt-get install -y curl
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
}

# Install ros
install_ros() {
    apt-get update
    apt-get install -y ros-noetic-desktop-full
}

# Set environment
setup_environment() {
    DESC="source /opt/ros/noetic/setup.bash"
    if ! grep -qF "$DESC" ~/.bashrc; then
        echo -e "\n# Ros Noetic" >> ~/.bashrc
        echo "$DESC" >> ~/.bashrc
    fi
}

# Install dependencies
install_dependencies() {
    apt-get install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential
    rosdep init
    rosdep update
}

# Main
main() {
    setup_ros_mirror
    setup_ros_key
    install_ros
    setup_environment
    install_dependencies
}

# Exec
main
