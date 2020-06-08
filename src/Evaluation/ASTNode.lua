--< Module >--
local ASTNode = {}

function ASTNode.new(token, leftChildeNode, rightChildNode)
    local self = {}
    
    self.Token = token
    self.LeftChildNode = leftChildeNode
    self.RightChildNode = rightChildNode
    
    return self
end

return ASTNode