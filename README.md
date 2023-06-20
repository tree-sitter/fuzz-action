# Tree-sitter fuzzing action

Options:

```yaml
language:
  description: "Name of the language (in your grammar.js)"
  required: true
external-scanner:
  description: "Path to your external scanner"
timeout:
  description: "Time to wait if the fuzzer hangs"
  default: 10
time:
  description: "Fuzzing time"
  default: 120
```

Example configuration (for the `vim` parser):

```yaml
name: Fuzz parser

# Run this workflow on changes to the external scanner
on:
  push:
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
      - uses: actions/checkout@v2
      - uses: vigoux/tree-sitter-fuzz-action@v1
        with:
          language: vim
          external-scanner: src/scanner.c
          time: 60
          timeout: 5
```
