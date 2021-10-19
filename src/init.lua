local Lexer = require(script.Lexer)
local parse = require(script.parse)
local solve = require(script.solve)

local function evaluate(input, variables)
	local lexer = Lexer.new(input)
	local ast = parse(lexer)

	return solve(ast, variables or {})
end

return evaluate
