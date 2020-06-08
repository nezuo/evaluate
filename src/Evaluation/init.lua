--< Modules >--
local Tokenize = require(script.Tokenize)
local Queue = require(script.Queue)
local Stack = require(script.Stack)
local ASTNode = require(script.ASTNode)

--< Functions >--
--[[
formASTNode.prototype.toString = function(count) {
    if (!this.leftChildNode && !this.rightChildNode)
        return this.token + "\t=>null\n" + Array(count+1).join("\t") + "=>null";
        
    var count = count || 1;
    count++;
    
    return this.token + "\t=>" + this.leftChildNode.toString(count) + "\n" + Array(count).join("\t") + "=>" + this.rightChildNode.toString(count);
};
]]

--[[
RPN Method

local function Parse(str)
    local OutputQueue = Queue.new()
    local OperatorStack = Stack.new()

    local Tokens = Tokenize(str)

    for _,token in ipairs(Tokens) do
        if token.Type == "Literal" or token.Type == "Variable" then
            OutputQueue:Push(token)
        elseif token.Type == "Function" or token.Type == "Left Parenthesis" then
            OperatorStack:Push(token)
        elseif token.Type == "Function Argument Separator" then
            while OperatorStack:Peek().Type ~= "Left Parenthesis" do
                OutputQueue:Push(OperatorStack:Pop())
            end
        elseif token.Type == "Operator" then
            local TopOperator = OperatorStack:Peek()

            while TopOperator and TopOperator.Type == "Operator" and ((token.Associativity == "Left" and token.Precedence <= TopOperator.Precedence) or (token.Associativity == "Right" and token.Precedence < TopOperator.Precedence)) do
                OutputQueue:Push(OperatorStack:Pop())
                TopOperator = OperatorStack:Peek()
            end

            OperatorStack:Push(token)
        elseif token.Type == "Right Parenthesis" then
            while OperatorStack:Peek().Type ~= "Left Parenthesis" do
                OutputQueue:Push(OperatorStack:Pop())
            end

            OperatorStack:Pop()
        end

        if OperatorStack:Peek() and OperatorStack:Peek().Type == "Function" then
            OutputQueue:Push(OperatorStack:Pop())
        end
    end

    while OperatorStack:Peek() do
        OutputQueue:Push(OperatorStack:Pop())
    end

    return OutputQueue
end
--]]

--[[
    OLD AST

    local function Parse(str)
    local OutputStack = Stack.new()
    local OperatorStack = Stack.new()

    local Tokens = Tokenize(str)

    local function AddNode(stack, operator)
        local RightNode = stack:Pop()
        local LeftNode = stack:Pop()

        stack:Push(ASTNode.new(operator, LeftNode, RightNode))
    end

    for _,token in ipairs(Tokens) do
        if token.Type == "Literal" or token.Type == "Variable" then
            OutputStack:Push(ASTNode.new(token, nil, nil))
        elseif token.Type == "Function" or token.Type == "Left Parenthesis" then
            OperatorStack:Push(token)
        elseif token.Type == "Function Argument Separator" then
            while OperatorStack:Peek().Type ~= "Left Parenthesis" do
                OutputStack:Push(OperatorStack:Pop())
            end
        elseif token.Type == "Operator" then
            local TopOperator = OperatorStack:Peek()

            while TopOperator and TopOperator.Type == "Operator" and ((token.Associativity == "Left" and token.Precedence <= TopOperator.Precedence) or (token.Associativity == "Right" and token.Precedence < TopOperator.Precedence)) do
                AddNode(OutputStack, OperatorStack:Pop())
                TopOperator = OperatorStack:Peek()
            end

            OperatorStack:Push(token)
        elseif token.Type == "Right Parenthesis" then
            while OperatorStack:Peek() and OperatorStack:Peek().Type ~= "Left Parenthesis" do
                AddNode(OutputStack, OperatorStack:Pop())
            end

            --OperatorStack:Pop()
        end

        if OperatorStack:Peek() and OperatorStack:Peek().Type == "Function" then
            local RightBranch = OutputStack:Pop()
            local LeftBranch = OutputStack:Pop()

            OutputStack:Push(ASTNode.new(token, LeftBranch, RightBranch))

            AddNode(Ou)
        end
    end

    while OperatorStack:Peek() do
        AddNode(OutputStack, OperatorStack:Pop())
    end

    return OutputStack:Pop()
end
--]]

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
    --[[
        RPN
    local RPN = Parse(str)

    local Values = {}

    for _,token in ipairs(RPN) do
        table.insert(Values, token.Value)
    end

    print(table.concat(Values, " "))
    ]]
    
    print(SolveAST(Parse(str)))

    return SolveAST(Parse(str))
end

-- "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3"

return Evaluate