# clean_workspace.md

Clean workspace files, including **build**, **devel**, **logs** and **CMakeLists.txt** for symbolic link.

## Clean current path

```bash
./clean_ros_workspace.bash
```

## Clean path which you want
```bash
./clean_ros_workspace.bash path/you/want/clean
```

## Display the files that will be deleted

Using the `-n` parameter, you can display the content to be cleaned without performing the actual cleaning operation.

```bash
./clean_ros_workspace.bash -n
./clean_ros_workspace.bash -n path/you/want/clean
```
