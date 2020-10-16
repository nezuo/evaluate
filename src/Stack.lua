--< Module >--
local Stack = {}
Stack.__index = Stack

function Stack.new()
    return setmetatable({}, Stack)
end

function Stack:Peek()
    return #self > 0 and self[#self] or nil
end

function Stack:Push(element)
    table.insert(self, element)
end

function Stack:Pop()
    return table.remove(self)
end

return Stack