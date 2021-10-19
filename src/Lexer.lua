local Functions = require(script.Parent.Functions)

local NUMBER_PATTERN = "%d+%.?%d*"
local IDENTIFIER_PATTERN = "[%a_][%w_]*"
local OPERATOR_PATTERN = "[%+%-%*/%%^]"
local OPEN_PARENTHESIS_PATTERN = "%("
local CLOSE_PARENTHESIS_PATTERN = "%)"
local ARGUMENT_SEPARATOR_PATTERN = ","

local function match(input, pattern, tokenizer)
	local matched = string.match(input, "^" .. pattern)

	if matched ~= nil then
		return tokenizer(matched), string.sub(input, #matched + 1)
	end
end

local function matchNumber(input)
	return match(input, NUMBER_PATTERN, function(matched)
		return { kind = "Number", value = tonumber(matched) }
	end)
end

local function matchIdentifier(input)
	return match(input, IDENTIFIER_PATTERN, function(matched)
		local kind = Functions[matched] ~= nil and "Function" or "Variable"

		return { kind = kind, identifier = matched }
	end)
end

local function matchOperator(input)
	return match(input, OPERATOR_PATTERN, function(matched)
		return { kind = "Operator", operator = matched }
	end)
end

local function matchOpenParenthesis(input)
	return match(input, OPEN_PARENTHESIS_PATTERN, function()
		return { kind = "Open Parenthesis" }
	end)
end

local function matchCloseParenthesis(input)
	return match(input, CLOSE_PARENTHESIS_PATTERN, function()
		return { kind = "Close Parenthesis" }
	end)
end

local function matchArgumentSeparator(input)
	return match(input, ARGUMENT_SEPARATOR_PATTERN, function()
		return { kind = "Argument Separator" }
	end)
end

local function removeWhitespace(input)
	return string.gsub(input, "%s+", "")
end

local function matchOrElse(potentialMatches)
	return function(input)
		for _, potentialMatch in ipairs(potentialMatches) do
			local token, rest = potentialMatch(input)

			if token ~= nil then
				return token, rest
			end
		end

		return nil, input
	end
end

local findNextToken = matchOrElse({
	matchNumber,
	matchIdentifier,
	matchOperator,
	matchOpenParenthesis,
	matchCloseParenthesis,
	matchArgumentSeparator,
})

local function tokenize(input)
	local nextToken, rest = findNextToken(removeWhitespace(input))
	local tokens = {}

	while nextToken ~= nil do
		table.insert(tokens, nextToken)
		nextToken, rest = findNextToken(rest)
	end

	if #rest > 0 then
		error(string.format("Unexpected sequence: %s", rest))
	end

	return tokens
end

local Lexer = {}
Lexer.__index = Lexer

function Lexer.new(input)
	return setmetatable({
		tokens = tokenize(input),
		index = 1,
	}, Lexer)
end

function Lexer:peek()
	return self.tokens[self.index]
end

function Lexer:next()
	local token = self.tokens[self.index]

	self.index += 1

	return token
end

function Lexer:expect(kind)
	local token = self:next()

	assert(token ~= nil and token.kind == kind, string.format("Expected %s", kind))
end

return Lexer
