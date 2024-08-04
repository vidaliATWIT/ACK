Entity = {}

-- setmetatable(a,{__index = b}) makes 'a' a prototype of 'b'

function Entity:new(o)
    o=o or {} -- create object if user does not provide one
    setmetatable(o,self) --o is the new object, self is the Prototype(Entity)
    self.__index = self

    -- basic variables
    o.x = o.x or 2
    o.y = o.y or 5
    o.width = 16
    o.height = 16
    o.name = o.name or "Unnamed Entity"
    o.sprite = o.sprite or love.graphics.newImage("nopingu.png")
        
    -- stats
    o.max_hp=o.max_hp or 666
    o.hp=o.max_hp
        
    return o
end

function Entity:getName()
    return self.name
end

function Entity:update(dt)
    error("Subclass must implement update method")
end

function Entity:draw()
    error("Subclass must implement draw method")
end

function Entity:interact()
    error("Subclass must implement interact method")
end


Monster = {}

function Monster:new(o)
    o = Entity.new(o)
    setmetatable(o,self) --o is the new object, self is the Prototype(Entity)
    self.__index = self

    -- new attributes
    o.hd = o.hd or 5
    o.dmg = o.dmg or 6
    return o
end

function Monster:getHd()
    return self.hd
end

function Monster:interact()
    print("INTERACTED WITH: ", self.name)
end

a = Entity:new{name="Glorff", x=3}
print("Entity: ", a:getName())
print("XPOS: ", a.x)

m = Monster:new{name="Goblin",x=6,y=6,hd=6}
print("Monster: ", m:getHd())
m:interact()
