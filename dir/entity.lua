local Entity = {}

function Entity:new(o)
    o=o or {} -- create object if user does not provide one
    setmetatable(o,self) -- o is the new object, self is the Prototype
    self.__index = self

    -- basic variables
    o.x = o.x or 1
    o.y = o.y or 1
    o.width = 16
    o.height = 16
    o.name = o.name or "Unnamed Entity"
    o.sprite_path=o.sprite_path or "/res/nopingu.png"
    print(o.sprite_path)
    o.sprite = love.graphics.newImage(o.sprite_path)
    
    -- stats
    o.max_hp=o.max_hp or 666
    o.hp=o.max_hp
    o.hd = o.hd or 5
    
    return o
end

-- Abstract methods

function Entity:update(dt)
    error("Subclass must implement update method")
end

function Entity:draw()
    error("Subclass must implement draw method")
end

function Entity:takeDamage(amount)
    error("Subclass must implement takeDamage method")
end

function Entity:getDamage()
    error("Subclass must implement getDamage method")
end

function Entity:interact()
    error("Subclass must implement interact method")
end

-- Common functions

function Entity.getPosition()
    return self.x, self.y
end

function Entity.getName()
    return self.name
end

function Entity.isAlive()
    return self.hp~=0
end

return Entity