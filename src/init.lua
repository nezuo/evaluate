--< Modules >--
local Functions = require(script.Functions)
local Queue = require(script.Queue)
local Stack = require(script.Stack)
local Token = require(script.Token)
local Tokenize = require(script.Tokenize)

--< Constants >--
local CONSTANTS = {
    pi = math.pi;
    huge = math.huge;
}

--< Functions >--
local function ShuntOperators(output, stack, token)
    local Operator = stack:Peek()

    while Operator ~= nil and (Operator.Type == "Operator" or Operator.Type == "Unary Operator") and ((token.Associativity == "Left" and token.Precedence <= Operator.Precedence) or (token.Precedence < Operator.Precedence)) do
        output:Enqueue(stack:Pop())
        Operator = stack:Peek()
    end
end

local function ShuntingYard(expression)
    local Operators = Stack.new()
    local Output = Queue.new()

    local Tokens = Tokenize(expression)

    local LastFunction = nil
    local PreviousToken = nil

    for _,token in ipairs(Tokens) do
        if token.Type == "Literal" then
           Output:Enqueue(token)
        end

        if token.Type == "Variable" then
            Output:Enqueue(token)
        end

        if token.Type == "Function" then
            Operators:Push(token)

            LastFunction = token
        end

        if token.Type == "Function Argument Separator" then
            while not Operators:IsEmpty() and Operators:Peek().Type ~= "Left Parenthesis" do
                Output:Enqueue(Operators:Pop())
            end

            if Operators:IsEmpty() and LastFunction == nil then
                error("Unexpected comma.")
            end
        end

        if token.Type == "Operator" then
            ShuntOperators(Output, Operators, token)

            Operators:Push(token)
        end

        if token.Type == "Unary Operator" then
            ShuntOperators(Output, Operators, token)

            Operators:Push(token)
        end

        if token.Type == "Left Parenthesis" then
            if PreviousToken ~= nil then
                local Type = PreviousToken.Type

                if Type == "Literal" or Type == "Right Parenthesis" or Type == "Variable" then
                    -- Add multiplication operator for implicit multiplication.
                    Operators:Push(Token("Operator", "*"))
                end

                if Type == "Function" then
                    Output:Enqueue(token)
                end
            end

            Operators:Push(token)
        end

        if token.Type == "Right Parenthesis" then
            while not Operators:IsEmpty() and Operators:Peek().Type ~= "Left Parenthesis" do
                Output:Enqueue(Operators:Pop())
            end

            Operators:Pop()

            if not Operators:IsEmpty() and Operators:Peek().Type == "Function" then
                Output:Enqueue(Operators:Pop())
            end
        end

        PreviousToken = token
    end

    while not Operators:IsEmpty() do
        Output:Enqueue(Operators:Pop())
    end

    return Output.Elements
end

--< Module >--
local function EvaluateOperation(operator, first, second)
    if operator == "^" then
        return first ^ second
    elseif operator == "*" then
        return first * second
    elseif operator == "/" then
        return first / second
    elseif operator == "%" then
        return first % second
    elseif operator == "+" then
        return first + second
    elseif operator == "-" then
        return first - second
    end
end

local function SolveRPN(rpn, variables)
    local Output = Stack.new()

    for _,token in ipairs(rpn) do
        if token.Type == "Unary Operator" then
            local Value = Output:Pop()

            if token.Value == "-" then
                Output:Push(-tonumber(Value))
            else
                Output:Push(tonumber(Value))
            end
        end

        if token.Type == "Operator" then
            local Second = Output:Pop()
            local First = Output:Pop()

            Output:Push(EvaluateOperation(token.Value, First, Second))
        end

        if token.Type == "Function" then
            local Arguments = {}

            while not Output:IsEmpty() and Output:Peek() ~= "Left Parenthesis" do
                table.insert(Arguments, 1, Output:Pop())
            end

            if Output:Peek() == "Left Parenthesis" then
                Output:Pop()
            end

            Output:Push(Functions[token.Value].Fn(unpack(Arguments)))
        end

        if token.Type == "Left Parenthesis" then
            Output:Push("Left Parenthesis")
        end
        
        if token.Type == "Variable" then
            if variables[token.Value] == nil then
                error("Unknown variable `" .. token.Value .. "`.")
            end

            Output:Push(variables[token.Value])
        end

        if token.Type == "Literal" then
            Output:Push(tonumber(token.Value))
        end
    end

    return Output:Pop()
end

local function Validate(rpn)
    local Scope = Stack.new()

    Scope:Push(0)

    for _,token in ipairs(rpn) do
        if token.Type == "Unary Operator" then
            if Scope:Peek() < 1 then
                error("Missing paramater(s) for operator " .. token.Value .. ".")
            end
        elseif token.Type == "Operator" then
            if Scope:Peek() < 2 then
                error("Missing paramater(s) for operator " .. token.Value .. ".")
            end

            Scope:Set(Scope:Size(), Scope:Peek() - 2 + 1)
        elseif token.Type == "Function" then
            local NumberOfArguments = Scope:Pop()

            local Function = Functions[token.Value]

            if NumberOfArguments == 0 or (Function.NumberOfParameters ~= nil and NumberOfArguments ~= Function.NumberOfParameters) then
                error("Function `" .. token.Value .. "` expected " .. (Function.NumberOfParameters == nil and "" or Function.NumberOfParameters) .. " argument(s), got " .. NumberOfArguments .. ".")
            end

            if Scope:IsEmpty() then
                error("Too many function calls, maximum scope exceeded.")
            end

            Scope:Set(Scope:Size(), Scope:Peek() + 1)
        elseif token.Type == "Left Parenthesis" then
            Scope:Push(0)
        else
            Scope:Set(Scope:Size(), Scope:Peek() + 1)
        end
    end

    if Scope:Size() > 1 then
        error("Too many unhandled function paramater lists.")
    elseif Scope:Peek() > 1 then
        error("Too many numbers or variables.")
    elseif Scope:Peek() < 1 then
        error("Empty expression.")
    end
end

local function Evaluate(str, variables)
    local RPN = ShuntingYard(str)

    Validate(RPN)

    variables = variables or {}

    for constant,value in pairs(CONSTANTS) do
        if variables[constant] == nil then
            variables[constant] = value
        end
    end

    return SolveRPN(RPN, variables)
end

return Evaluate