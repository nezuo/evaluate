# Evaluate

Basic Example:
```lua
local Evaluate = require(...)
local Result = Evaluate("4 + 4")

print(Result) -- 8
```
Variable Example:
```lua
local Evaluate = require(...)
local Result = Evaluate("var * 2", {var = 6})

print(Result) -- 12
```
Function Example:
```lua
local Evaluate = require(...)
local Result = Evaluate("sqrt(4) + 2")

print(Result) -- 4
```
