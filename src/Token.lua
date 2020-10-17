--< Constants >--
local OPERATOR_ASSOCIATIVITY = {
    ["^"] = "Right";
    ["*"] = "Left";
    ["/"] = "Left";
    ["%"] = "Left";
    ["+"] = "Left";
    ["-"] = "Left";
}

local OPERATOR_PRECEDENCE = {
    ["^"] = 3;
    ["*"] = 2;
    ["/"] = 2;
    ["%"] = 2;
    ["+"] = 1;
    ["-"] = 1;
    ["("] = 0;
    [")"] = 0;
}

--< Module >--
local function Token(type, value)
    local Associativity = nil
    if type == "Operator" then
        Associativity = OPERATOR_ASSOCIATIVITY[value]
    elseif type == "Unary Operator" then
        Associativity = "Left"
    end

    local Precedence = nil
    if type == "Operator" then
        Precedence = OPERATOR_PRECEDENCE[value]
    elseif type == "Unary Operator" then
        Precedence = 4
    end

    return {
        Type = type;
        Value = value;
        Precedence = Precedence;
        Associativity = Associativity;
    }
end

return Token