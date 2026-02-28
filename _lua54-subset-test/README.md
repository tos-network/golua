# Lua 5.4 Subset Tests

This directory starts from Lua `v5.4.8` official `testes/` and is adapted for
this deterministic contract VM fork.

VM constraints:
- uint256 integer-only number model
- deterministic built-in library surface (`io`, `os`, `debug`, `coroutine` removed)

Use `manifest.tsv` with `_tools/run-lua54-subset-tests.sh`:

```bash
make lua54-subset-test
```
