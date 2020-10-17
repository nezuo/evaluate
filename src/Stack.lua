--< Module >--
local Stack = {}
Stack.__index = Stack

function Stack.new()
    local self = setmetatable({}, Stack)

    self.Elements = {}

    return self
end

function Stack:IsEmpty()
    return #self.Elements == 0
end

function Stack:Set(index, element)
    self.Elements[index] = element
end

function Stack:Size()
    return #self.Elements
end

function Stack:Peek()
    return self.Elements[#self.Elements]
end

function Stack:Push(element)
    table.insert(self.Elements, element)
end

function Stack:Pop()
    return table.remove(self.Elements)
end

return Stack