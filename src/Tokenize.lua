--< Modules >--
local Functions = require(script.Parent.Functions)
local Token = require(script.Parent.Token)

--< Variables >--
local Operators = {"^", "*", "/", "%", "+", "-"}

--< Functions >--
local function IsDigit(character)
    return tonumber(character) ~= nil
end

local function IsLetter(character)
    return string.match(character, "%a") ~= nil
end

local function IsOperator(character)
    return table.find(Operators, character) ~= nil
end

--< Module >--
local function Tokenize(str)
    local Result = {}

    str = string.gsub(str, "%s+", "") -- Remove all whitespace.
    str = string.split(str, "") -- Split into individual characters.

    local NumberBuffer = {}
    local IdentifierBuffer = {}

    local function ClearNumberBuffer()
        if #NumberBuffer > 0 then
            table.insert(Result, Token("Literal", table.concat(NumberBuffer)))

            NumberBuffer = {}
        end
    end

    local function ClearIdentifierBuffer()
        if #IdentifierBuffer > 0 then
            local Identifier = table.concat(IdentifierBuffer)
            local Type = Functions[Identifier] ~= nil and "Function" or "Variable"

            table.insert(Result, Token(Type, Identifier))

            IdentifierBuffer = {}
        end
    end

    for _,character in ipairs(str) do
        if not IsLetter(character) and not (#IdentifierBuffer > 0 and IsDigit(character)) then
            ClearIdentifierBuffer()
        end
        
        if not IsDigit(character) and character ~= "." then
            ClearNumberBuffer()
        end
        
        if IsLetter(character) or (#IdentifierBuffer > 0 and IsDigit(character)) then
            table.insert(IdentifierBuffer, character)
        elseif IsDigit(character) or character == "." then
            table.insert(NumberBuffer, character)
        elseif IsOperator(character) then
            local PreviousToken = Result[#Result]
            local IsUnary = PreviousToken == nil or PreviousToken.Type == "Operator" or PreviousToken.Type == "Left Parenthesis" or PreviousToken.Type == "Function Argument Seperator" or PreviousToken.Type == "UnaryOperator"

            table.insert(Result, Token(IsUnary and "Unary Operator" or "Operator", character))
        elseif character == "(" then
            table.insert(Result, Token("Left Parenthesis", character))
        elseif character == ")" then
            table.insert(Result, Token("Right Parenthesis", character))
        elseif character == "," then
            table.insert(Result, Token("Function Argument Separator", character))
        end
    end

    ClearNumberBuffer()
    ClearIdentifierBuffer()

    return Result
end

return Tokenize