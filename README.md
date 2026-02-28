# gopher-lua — Blockchain-Safe Lua for TOS

A fork of [gopher-lua](https://github.com/yuin/gopher-lua) hardened for execution
inside a Byzantine-fault-tolerant blockchain (TOS). Every validator must produce
**identical results** from identical inputs; the original library's I/O, randomness,
and channel primitives make that impossible — they are removed here.

Redis has run a sandboxed Lua engine in production for over a decade under exactly
these constraints. This fork applies the same discipline to a Go blockchain node.

---

## What was removed and why

| Removed | Reason |
|---------|--------|
| `io` library | File open/read/write — non-deterministic across nodes |
| `os` library | `os.time`, `os.clock`, `os.execute`, `os.exit` — wall-clock and syscalls |
| `loadlib` / `require` / `module` | Filesystem module loading — arbitrary code injection |
| `channel` library | `reflect.Select` on goroutines — non-deterministic scheduling |
| `math.random` / `math.randomseed` | PRNG seeded from runtime entropy — non-deterministic |
| `dofile` / `loadfile` | Filesystem execution from Lua scripts |
| `LState.DoFile` / `LState.LoadFile` | Go-level file loader methods |

## What was kept

| Library | Status | Notes |
|---------|--------|-------|
| `base` | Modified | Removed `dofile`, `loadfile`, `require`, `module`. Kept `collectgarbage` (calls `runtime.GC()` — pure Go, consensus-safe) |
| `table` | Unchanged | Deterministic |
| `string` | Unchanged | Deterministic |
| `math` | Modified | Removed `random`/`randomseed`; all other functions are deterministic |
| `debug` | Unchanged | Stack introspection only, no I/O |
| `coroutine` | Unchanged | Cooperative scheduling — fully deterministic |

---

## New: Gas Metering

Every blockchain transaction has a gas budget. Scripts that loop forever must be
killed before they stall a validator. Gas metering counts VM instructions and
aborts execution when the budget is exhausted.

### API

```go
L := lua.NewState()
defer L.Close()

// Set the gas limit before running any script.
// Zero means unlimited (default, for trusted internal use).
L.SetGasLimit(1_000_000)

err := L.DoString(src)
if err != nil {
    // err.Error() contains "lua: gas limit exceeded" if the budget ran out
}

// How many instructions were consumed:
fmt.Println("gas used:", L.GasUsed())
```

`SetGasLimit` resets `GasUsed` to zero. Call it once per transaction, before
`DoString`.

### Error string

When the gas budget is exceeded the VM raises:

```
lua: gas limit exceeded
```

The TOS executor catches this string and maps it to `ErrIntrinsicGas`.

---

## Injecting Host Primitives

Lua scripts interact with the blockchain through Go functions registered as a
module. This is the standard gopher-lua `LGFunction` + `RegisterModule` pattern —
no changes to the VM required.

```go
L := lua.NewState()
defer L.Close()
L.SetGasLimit(gasRemaining)

L.RegisterModule("tos", map[string]lua.LGFunction{
    "get":      tosGet,      // read contract storage
    "set":      tosSet,      // write contract storage
    "transfer": tosTransfer, // transfer TOS between accounts
    "balance":  tosBalance,  // query TOS balance
    "caller":   tosCaller,   // msg.From address
    "value":    tosValue,    // msg.Value in wei
})

if err := L.DoString(string(contractSource)); err != nil {
    // handle error
}
```

A Lua contract calling these primitives looks like:

```lua
local bal = tos.balance(tos.caller())
tos.require(tonumber(bal) >= 1000, "insufficient balance")
tos.set("initialized", "1")
tos.transfer("0x...", "500000000000000000")
```

---

## Running Scripts

Scripts are always passed as strings (source code stored on-chain via `code_put_ttl`).
There is no file loading — use `DoString`:

```go
L := lua.NewState()
defer L.Close()
L.SetGasLimit(500_000)

err := L.DoString(`
    local x = 0
    for i = 1, 100 do
        x = x + i
    end
    tos.set("result", tostring(x))
`)
```

---

## Calling Go from Lua

Any Go function can be exposed to Lua as an `LGFunction`:

```go
func myFunc(L *lua.LState) int {
    arg := L.CheckString(1)   // get first argument
    L.Push(lua.LString("hello " + arg))  // push return value
    return 1                  // number of return values
}

L.SetGlobal("myFunc", L.NewFunction(myFunc))
```

---

## Context / Timeout

The upstream context cancellation mechanism is preserved and works alongside gas
metering. Use gas metering for deterministic termination (same limit on every
validator). Use context only for wall-clock timeouts in off-chain tooling.

```go
ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
defer cancel()
L.SetContext(ctx)
L.SetGasLimit(10_000_000)
err := L.DoString(src)
```

---

## Data Types

| Lua type | Go type | Notes |
|----------|---------|-------|
| `nil` | `lua.LNil` | constant |
| `bool` | `lua.LBool` | `lua.LTrue`, `lua.LFalse` |
| `number` | `lua.LNumber` | `float64` |
| `string` | `lua.LString` | `string` |
| `table` | `*lua.LTable` | |
| `function` | `*lua.LFunction` | |
| `userdata` | `*lua.LUserData` | for Go-defined types |
| `thread` | `*lua.LState` | coroutines |

---

## LState Options

```go
L := lua.NewState(lua.Options{
    RegistrySize:        1024 * 20,
    RegistryMaxSize:     1024 * 80,
    RegistryGrowStep:    32,
    CallStackSize:       256,
    SkipOpenLibs:        false,
    IncludeGoStackTrace: false,
})
```

---

## glua CLI

A minimal REPL / script runner for local testing (not for on-chain use):

```bash
go build ./cmd/glua
./glua script.lua
./glua -e 'print("hello")'
```

---

## Module

```
github.com/tos-network/gopher-lua
```

Forked from [yuin/gopher-lua](https://github.com/yuin/gopher-lua) (MIT).
Modifications © TOS Network, MIT License.
