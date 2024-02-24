# Tree-sitter parser fuzzing

## Options

```yaml
directory:
  description: The directory of the grammar
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
  default: v0.21.0
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

## Credits

Based on [vigoux/tree-sitter-fuzz-action](https://github.com/vigoux/tree-sitter-fuzz-action)
