local Constants = require(script.Parent.Constants)
local Functions = require(script.Parent.Functions)

local function solveFunctionCall(name, arguments)
	return Functions[name](table.unpack(arguments))
end

local function solveVariable(name, variables)
	return variables[name] or Constants[name] or error(string.format("'%s' is not defined", name))
end

local function solveBinaryOperation(operator, left, right)
	if operator == "+" then
		return left + right
	elseif operator == "-" then
		return left - right
	elseif operator == "*" then
		return left * right
	elseif operator == "/" then
		return left / right
	elseif operator == "%" then
		return left % right
	elseif operator == "^" then
		return left ^ right
	end
end

local function solveUnaryOperation(operator, value)
	if operator == "-" then
		return -value
	end

	return value
end

local function solveArguments(arguments, solve, variables)
	local solvedArguments = {}

	for _, argument in ipairs(arguments) do
		table.insert(solvedArguments, solve(argument, variables))
	end

	return solvedArguments
end

local function solve(node, variables)
	if node.kind == "Number" then
		return node.value
	elseif node.kind == "Variable" then
		return solveVariable(node.identifier, variables)
	elseif node.kind == "Function Call" then
		return solveFunctionCall(node.identifier, solveArguments(node.arguments, solve, variables))
	elseif node.kind == "Binary Operation" then
		return solveBinaryOperation(node.operator, solve(node.left, variables), solve(node.right, variables))
	elseif node.kind == "Unary Operation" then
		return solveUnaryOperation(node.operator, solve(node.value, variables))
	end
end

return solve
