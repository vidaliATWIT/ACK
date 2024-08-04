Node = {}

-- Basic node class for our A* algorithm

function Node:new(o)
    o=o or {} -- create object if user does not provide one
    setmetatable(o,self) --o is the new object, self is the Prototype(Entity)
    self.__index = self
    self.parent = o.parent
    self.position = o.position
    self.g=0
    self.h=0
    self.f=0

    return o
end

function Node:eq(other)
    return self.position[1]==other.position[1] and self.position[2]==other.position[2]
end

-- So what are you waiting for? You got what you asked for. 
-- Did it fix what was wrong with you? Are you less than?
function Node:lessThan(other)
    return self.f < other.f
end

function Node:greaterThan(other)
    return self.f > other.f
end

return Node