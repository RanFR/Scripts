# tar_with_progress.bash

## Dependencies

Need to install `pv`.

```bash
apt update && apt install pv
```

## Usage

Compile

```bash
./tar_with_progress.bash -c file.tar.{xz|gz|bz2} file1 file2 folder1 folder2
```

Decompress

```bash
./tar_with_progress.bash -x file.tar.{xz|gz|bz2} {destination}
```

Or you can use `./tar_with_progress.bash` without any parameters to show the usage.
