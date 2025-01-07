# Scripts

## clean_ros_workspace.sh

Clean ros workspace files, including **build**, **devel** and **CMakeLists.txt** for symbolic link.

### How to use

Clean current path
```bash
./clean_ros_workspace.sh
```

Clean path which you want
```bash
./clean_ros_workspace.sh path/you/want/clean
```

# install_ros_noetic.sh

Install **Ros Noetic** with version: ros-noetic-desktop-full

### How to use

```bash
./install_ros_noetic.sh
```

## pip_upgrade.sh

Use `pip` search packages which are outdated and upgrade them.

### How to use

```bash
./pip_upgrade.sh
```

## purge_dpkg_rc.sh

`apt purge` package which has been removed but with config files left.

### How to use

```bash
./purge_dpkg_rc.sh
```

## remove_folders.sh

Remove folders in **folder A** and **subfolders**

### How to use

The first parameter is **the folder you want to organize**, and the subsequent parameters are the folders you want to organize and **the folders you want to delete from the folder**.

For example, if you want to delete folder_a and folder_b in folder_c, you just run sh file like below

```bash
./remove_folders.sh folder_c folder_a folder_b
```

If you want delete more folders, just list them behind the folder_b.

## remove_symlink_cmakelists.sh

Remove the CMakeLists.txt file whose attribute is a symbolic link.

### How to use

```bash
./remove_symlink_cmakelists.sh root/folder/you/want/clean
```

## merge_compile_commdans.py

merge every compile_commands.json in each package into a single compile_commands.json file.

### How to use

`git clone` the repository into your **ros_ws** root folder and then

```bash
python3 merge_compile_commands.py
```
