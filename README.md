# Scripts

## Bash

### clean_ros_workspace.bash

Clean ros workspace files, including **build**, **devel**, **logs** and **CMakeLists.txt** for symbolic link.

#### Clean current path
```bash
./clean_ros_workspace.bash
```

#### Clean path which you want
```bash
./clean_ros_workspace.bash path/you/want/clean
```

#### Display the files that will be deleted

Using the `-n` parameter, you can display the content to be cleaned without performing the actual cleaning operation.

```bash
./clean_ros_workspace.bash -n
./clean_ros_workspace.bash -n path/you/want/clean
```

### tar_with_progress.bash

Compress and decompress to show progress by using the tar tool.

Need to install `pv`.

```bash
apt update
apt install pv
```

#### Usage

Compile

```bash
./tar_with_progress.bash c file.tar.{xz|gz|bz2} file1 file2 folder1 folder2
```

Decompress

```bash
./tar_with_progress.bash x file.tar.{xz|gz|bz2}
```

Or you can use `./tar_with_progress.bash` without any parameters to show the usage.

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
