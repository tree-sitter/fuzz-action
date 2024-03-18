# Tree-sitter parser fuzzing

> [!IMPORTANT]
> This only works on Linux.

## Options

```yaml
directory:
  description: The directory of the grammar
corpus:
  description: The directory of the seed corpus
timeout:
  description: The time to wait if the fuzzer hangs
  default: 10
max-time:
  description: The maximum total fuzzing time
  default: 60
max-length:
  description: The maximum fuzz input length
  default: 4096
tree-sitter-version:
  description: The tree-sitter version to install
  default: latest
```

## Example configuration

```yaml
name: Fuzz parser

on:
  push:
    branches: [master]
    paths:
      - src/scanner.c
  pull_request:
    paths:
      - src/scanner.c

jobs:
  test:
    name: Parser fuzzing
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: tree-sitter/fuzz-action@v4
```

## Using locally

### Requirements

- `pkg-config`
- `make`
- `jq`
- `llvm`
- `tree-sitter` library

### Usage

```bash
make LANG_NAME=parser LANG_DIR=/path/to/tree-sitter-parser
```

> [!TIP]
> Check the [Makefile](./Makefile) for more options.

## Credits

Based on [vigoux/tree-sitter-fuzz-action](https://github.com/vigoux/tree-sitter-fuzz-action)
