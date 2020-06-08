--< Modules >--
local Tokenize = require(script.Tokenize)
local Stack = require(script.Stack)
local ASTNode = require(script.ASTNode)

--< Functions >--
local function Parse(str)
    local Operators = Stack.new()
    local Output = Stack.new()

    local Tokens = Tokenize(str)

    local function AddNode(stack, operator)
        local RightNode = stack:Pop()
        local LeftNode = stack:Pop()

        stack:Push(ASTNode.new(operator, LeftNode, RightNode))
    end

    for _,token in ipairs(Tokens) do
        if token.Type == "Left Parenthesis" then
            Operators:Push(token)
        elseif token.Type == "Right Parenthesis" then
            while Operators:Peek() and Operators:Peek().Type ~= "Left Parenthesis" do
                AddNode(Output, Operators:Pop())
            end

            Operators:Pop()
        elseif token.Type == "Operator" then
            while Operators:Peek() and Operators:Peek().Type ~= "Left Parenthesis" and Operators:Peek().Precedence >= token.Precedence do
                AddNode(Output, Operators:Pop())
            end

            Operators:Push(token)
        elseif token.Type == "Literal" then
            Output:Push(ASTNode.new(token, nil, nil))
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
    elseif tree.Token.Value == "+" then
        return SolveAST(tree.LeftChildNode) + SolveAST(tree.RightChildNode)
    elseif tree.Token.Value == "-" then
        return SolveAST(tree.LeftChildNode) - SolveAST(tree.RightChildNode)
    else
        return tonumber(tree.Token.Value)
    end
end

local function Evaluate(str)
    return SolveAST(Parse(str))
end

return Evaluate