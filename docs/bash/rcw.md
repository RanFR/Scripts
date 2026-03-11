# rcw.md

Clean workspace files, including **build**, **devel**, **logs** and **CMakeLists.txt** for symbolic link.

## Help

Use `--help` to display help information.

## Clean current path

```bash
./rcw.bash
```

## Clean path which you want

```bash
./rcw.bash path/you/want/clean
```

## Display the files that will be deleted

Using the `-n` parameter, you can use dry on mode and display the content to be cleaned without performing the actual cleaning operation.

```bash
./rcw.bash -n
./rcw.bash -n path/you/want/clean
```
