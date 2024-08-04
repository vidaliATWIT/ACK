local Entity = require("Entity")
local monster = {}
local monster_dmg = {4, 6, 8, 10, 12, 12, 16, 18, 10, 22}
local config = require("conf")
local scale = config.scale_factor

function monster:new(o)
    o = Entity:new(o)
    setmetatable(o,self)
    self.__index=self

    o.x = o.x*scale*16
    o.y = o.y*scale*16
    o.armor = o.armor or 4
    return o
end

function monster:update(dt)
    -- monster update
end

function monster:draw()
    love.graphics.draw(self.sprite,self.x, self.y, 0, scale, scale)
end

function monster:takeDamage(amount)
    if isAlive() then
        self.hp = math.min(self.hp, self.hp-amount+self.armor)
        if amount>self.armor then
            self.armor=self.armor-1
        end

    end
end

function monster:getDamage()
    return monster_dmg[self.hd]
end

function monster:attack()
    print("Monster collided with player.")
end

function monster:interact()
    print("Player collided with ", self.name)
end

return monster
