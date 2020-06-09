--< Modules >--
local Functions = require(script.Functions)
local Tokenize = require(script.Tokenize)
local Stack = require(script.Stack)
local ASTNode = require(script.ASTNode)

--< Functions >--
local function Parse(str, variables)
    local Operators = Stack.new()
    local Output = Stack.new()

    local Tokens = Tokenize(str)

    local function AddNode(stack, operator)
        local RightNode = stack:Pop()

        local LeftNode = nil
        if operator.Type ~= "Function" then
            LeftNode = stack:Pop()
        end

        stack:Push(ASTNode.new(operator, LeftNode, RightNode))
    end

    for _,token in ipairs(Tokens) do
        if token.Type == "Literal" or token.Type == "Variable" then
            Output:Push(ASTNode.new(token))
        end

        if token.Type == "Left Parenthesis" then
            Operators:Push(token)
        end

        if token.Type == "Right Parenthesis" then
            while Operators:Peek() and Operators:Peek().Type ~= "Left Parenthesis" do
                AddNode(Output, Operators:Pop())
            end

            Operators:Pop()
        end

        if token.Type == "Operator" or token.Type == "Function" then
            local Operator = Operators:Peek()

            while Operator and Operator.Type ~= "Left Parenthesis" and (Operator.Precedence > token.Precedence or (token.Associativity == "Left" and Operator.Precedence == token.Precedence)) do
                AddNode(Output, Operators:Pop())
                Operator = Operators:Peek()
            end

            Operators:Push(token)
        end
    end

    while Operators:Peek() do
        AddNode(Output, Operators:Pop())
    end

    return Output:Pop()
end

--< Module >--
local function SolveAST(tree)
    if tree.Token.Value == "^" then
        return math.pow(SolveAST(tree.LeftChildNode), SolveAST(tree.RightChildNode))
    elseif tree.Token.Value == "*" then
        return SolveAST(tree.LeftChildNode) * SolveAST(tree.RightChildNode)
    elseif tree.Token.Value == "/" then
        return SolveAST(tree.LeftChildNode) / SolveAST(tree.RightChildNode)
    elseif tree.Token.Value == "%" then
        return SolveAST(tree.LeftChildNode) % SolveAST(tree.RightChildNode)
    elseif tree.Token.Value == "+" then
        return SolveAST(tree.LeftChildNode) + SolveAST(tree.RightChildNode)
    elseif tree.Token.Value == "-" then
        return SolveAST(tree.LeftChildNode) - SolveAST(tree.RightChildNode)
    elseif tree.Token.Type == "Function" then
        return Functions[tree.Token.Value](SolveAST(tree.RightChildNode))
    elseif tree.Token.Type == "Function Argument Separator" then
        return table.pack(SolveAST(tree.LeftChildNode), SolveAST(tree.RightChildNode))
    else
        return tonumber(tree.Token.Value)
    end
end

local function Evaluate(str, variables)
    local Tree = Parse(str, variables)

    return SolveAST(Tree)
end

return Evaluate