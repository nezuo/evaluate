--< Modules >--
local Token = require(script.Parent.Token)

--< Functions >--
local function IsDigit(character)
    return tonumber(character) ~= nil
end

local function IsLetter(character)
    return string.match(character, "%a") ~= nil
end

local function IsOperator(character)
    local Operators = {"^", "*", "/", "%", "+", "-"}

    return table.find(Operators, character) ~= nil
end

--< Module >--
local function Tokenize(str)
    local Result = {}

    str = string.gsub(str, "%s+", "") -- Remove whitespace
    str = string.split(str, "")

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
        -- Clear buffers
        if IsLetter(character) == false then
            ClearLetterBuffer()
        elseif #NumberBuffer > 0 then
            ClearNumberBuffer()
            table.insert(Result, Token("Operator", "*"))
        end

        if IsDigit(character) == false and character ~= "." then
            ClearNumberBuffer()
        end

        -- Tokenize
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