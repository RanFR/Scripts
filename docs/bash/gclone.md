# gclone

## 用法

可以直接输入`gclone`查看用法。

```bash
gclone
```

指定`-h`为使用 HTTPS 协议克隆仓库（默认，参数可忽略），指定`-s`为使用 SSH 协议克隆仓库（参数不可忽略）。可以在仓库名后追加一个可选的目标目录 `dest`，等同于 `git clone <url> dest`。

### HTTPS（默认）

举例说明，如果需要克隆用户**A**的**a**仓库，并使用 HTTPS 协议克隆。一般写法为：

```bash
git clone https://github.com/A/a.git
```

使用`gclone`工具，输入以下命令即可：

```bash
gclone -h A/a
```

以 HTTPS 协议克隆仓库为默认用法，`-h`参数可以忽略。

### SSH

举例说明，如果需要克隆用户**A**的**a**仓库，并使用 SSH 协议克隆。一般写法为：

```bash
git clone git@github.com:A/a
```

使用`gclone`工具，输入以下命令即可：

### 指定目标目录

例如使用 SSH 克隆到自定义目录：

```bash
gclone -s A/a TempDir
```

等同：

```bash
git clone git@github.com:A/a TempDir
```

使用默认 HTTPS 协议克隆到自定义目录：

```bash
gclone A/a mydir
```

等同：

```bash
git clone https://github.com/A/a.git mydir
```

```bash
gclone -s A/a
```
