local UNARY_BINDING_POWER = 5

local function getInfixBindingPower(operator)
	if operator == "+" or operator == "-" then
		return 1, 2
	elseif operator == "*" or operator == "/" or operator == "%" then
		return 3, 4
	elseif operator == "^" then
		return 8, 7
	end
end

local function parseFunction(identifier, lexer, expression)
	local arguments = {}

	lexer:expect("Open Parenthesis")

	while lexer:peek() ~= nil and lexer:peek().kind ~= "Close Parenthesis" do
		table.insert(arguments, expression(lexer, 1))
	end

	lexer:expect("Close Parenthesis")

	return { kind = "Function Call", identifier = identifier, arguments = arguments }
end

local function parseUnaryOperation(operator, lexer, parseExpression)
	local value = parseExpression(lexer, UNARY_BINDING_POWER)

	if value == nil then
		error("Expected value after unary")
	end

	return {
		kind = "Unary Operation",
		operator = operator,
		value = value,
	}
end

local function parseOpenParenthesis(lexer, parseExpression)
	local expression = parseExpression(lexer, 0)

	if expression == nil then
		error("Expected value within parentheses")
	end

	lexer:expect("Close Parenthesis")

	return expression
end

local function parseLeft(lexer, parseExpression)
	local token = lexer:next()

	if token == nil then
		return nil
	elseif token.kind == "Number" or token.kind == "Variable" then
		return token
	elseif token.kind == "Function" then
		return parseFunction(token.identifier, lexer, parseExpression)
	elseif token.kind == "Operator" then
		return parseUnaryOperation(token.operator, lexer, parseExpression)
	elseif token.kind == "Open Parenthesis" then
		return parseOpenParenthesis(lexer, parseExpression)
	end
end

local function parseExpression(lexer, minimumBindingPower)
	local left = parseLeft(lexer, parseExpression)

	while lexer:peek() ~= nil do
		local nextToken = lexer:peek()
		local leftBindingPower, rightBindingPower = getInfixBindingPower(nextToken.operator)

		if leftBindingPower == nil or leftBindingPower < minimumBindingPower then
			break
		end

		lexer:expect("Operator")

		local right = parseExpression(lexer, rightBindingPower)

		if right == nil then
			error(string.format("Expected value after %s", nextToken.operator))
		end

		left = { kind = "Binary Operation", operator = nextToken.operator, left = left, right = right }
	end

	return left
end

local function parse(lexer)
	if lexer:peek() == nil then
		error("Input empty")
	end

	return parseExpression(lexer, 1)
end

return parse
