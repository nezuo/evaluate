--< Module >--
local Queue = {}
Queue.__index = Queue

function Queue.new()
    return setmetatable({}, Queue)
end

function Queue:Push(element)
    table.insert(self, element)
end

return Queue