# Evaluate

**Evaluate** is mathematical evaluator for Lua.

Features:
- Supports variables
- Support constants like pi
- Supports standard mathematical operators
- Functions with a variable number of arguments like min
- Supports implicit multiplication, e.g. 2(x - y) which is the same as 2*(x - y)
- Supports unary operators, e.g. -2

## Usage Examples:
```lua
local Evaluate = require(...)

-- Simple expression without variables.
Evaluate("1 + 1 / 3") -- 1.3333333333333

-- A more complex expression showing support for unary operators.
Evaluate("(3.4 + -4.1)/2") -- -0.35

-- Expression using functions and variables.
Evaluate("sqrt(a^2 + b^2)", {
    a = 2.4;
    b = 9.253;
}) -- 9.5591845363504

-- Expression with constant.
Evaluate("pi * 2") -- 6.2831853071796

-- Expression using implicit multiplication.
Evaluate("(2 - 1)(4+2)") -- 6

-- Expression using composite function calls and constant.
Evaluate("sin(cos(pi)))") -- -0.8414709848079

-- Expression using function with variable paramaters.
Evaluate("max(2, 4, 7, 1)") -- 7
```

## Supported Operators

| Operator | Description |
| ----------- | ----------- |
| + | Addition operator / Unary plus
| - | Subtraction operator / Unary minus
| * | Multiplication operator
| / | Division operator
| % | Modulo operator
| ^ | Power operator

## Supported Functions

| Function |
| ----------- |
| abs |
| acos |
| asin |
| atan |
| atan2 |
| ceil |
| clamp |
| cos |
| cosh |
| deg |
| exp |
| floor |
| fmod |
| ldexp |
| log |
| max |
| min |
| noise |
| pow |
| rad |
| random |
| sign |
| sin |
| sinh |
| sqrt |
| tan |
| tanh |

## Supported Constants

| Constant |
| ----------- |
| pi |
| huge |