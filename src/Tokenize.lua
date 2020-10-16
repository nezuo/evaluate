--< Modules >--
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
    local LetterBuffer = {}

    local IsVariable = false

    local function ClearNumberBuffer()
        if #NumberBuffer > 0 then
            table.insert(Result, Token("Literal", table.concat(NumberBuffer)))

            NumberBuffer = {}
        end
    end

    local function ClearLetterBuffer()
        if #LetterBuffer > 0 then
            table.insert(Result, Token(IsVariable and "Variable" or "Function", table.concat(LetterBuffer)))

            IsVariable = false

            LetterBuffer = {}
        end
    end

    for _,character in ipairs(str) do
        if not IsLetter(character) then
            ClearLetterBuffer()
        end
        
        if not IsDigit(character) and character ~= "." then
            ClearNumberBuffer()
        end

        if IsDigit(character) or character == "." then
            table.insert(NumberBuffer, character)
        elseif IsLetter(character) then
            table.insert(LetterBuffer, character)
        elseif IsOperator(character) then
            table.insert(Result, Token("Operator", character))
        elseif character == "(" then
            table.insert(Result, Token("Left Parenthesis", character))
        elseif character == ")" then
            table.insert(Result, Token("Right Parenthesis", character))
        elseif character == "," then
            table.insert(Result, Token("Function Argument Separator", character))
        elseif character == "$" then
            IsVariable = true
        end
    end

    ClearNumberBuffer()
    ClearLetterBuffer()

    return Result
end

return Tokenize