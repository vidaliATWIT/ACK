local Entity = require("entity.Entity")
local monster = setmetatable({}, {__index = Entity})
local monster_dmg = {4, 6, 8, 10, 12, 12, 16, 18, 10, 22}
local Dice = require("util.Dice")
local Enums = require("util.Enums")

local MonsterTemplates = {
    GOBLIN = {
        name = "Goblin",
        image = "/res/darkelf1.png",
        hd = 1,
        monsterType="goblin",
        awarenessCooldown=3
    },
    DARKELF = {
        name = "Dark Elf",
        image = "/res/elf1.png",
        hd = 2,
        monsterType="elf",
        awarenessCooldown=4,
    },
}

monster.__index = Monster

function monster:new(templateName, x, y)
    local template=MonsterTemplates[templateName]
    if not template then
        error("Unknown monster template: " .. templateName)
    end
    local o = Entity:new({
        x=x,
        y=y,
        type=Enums.EntityType.MONSTER,
        name=template.name,
        sprite_path=template.image,
        hd=template.hd,
        monsterType=template.monsterType,
        maxAwarenessCooldown=template.awarenessCooldown
    })
    setmetatable(o,self)
    self.__index=self
    print(o.type)

    o.max_hp=Dice.rollMultiple(o.hd, 8) -- Random roll to determine hp
    o.hp=o.max_hp
    o.armor = o.hd
    o.awareCooldown=o.maxAwarenessCooldown

    return o
end

function monster:update(dt)
    -- monster update
end

function monster:draw()
    love.graphics.draw(self.sprite,self.x, self.y, 0, scale, scale)
end

-- Checks if you're within attack range
function monster:scan(distance)
    if distance<=self.attack_range then
        return true
    else
        self.state=Enums.EntityState.IDLE
        return false
    end
end

-- Use Bresenham line to look for player
function monster:search(visible)
    if visible then 
        self.state=Enums.EntityState.ATTACK 
        self.awareCooldown=self.maxAwarenessCooldown
        return true 
    else 
        self.state=Enums.EntityState.AWARE  
        return false 
    end
end
-- Handles setting state depending on distance
function monster:setState(distance, playerPos) 
    -- If close enough they'll start checking if they can see you
    if distance<=self.attack_range then
        self.state=Enums.EntityState.AWARE
    else
        self.state=Enums.EntityState.IDLE
    end
end

-- Return a random direction to move in
function monster:getIdleDirection()
    local directions = {{x=0,y=1},{x=0,y=-1}, {x=1,y=0},{x=-1,y=0}}
    local random_dir = directions[math.random(#directions)]
    return random_dir
end

function monster:takeDamage(amount)
    self.hp=self.hp-amount
end

function monster:getDamage()
    return monster_dmg[self.hd]
end

function monster:attack(player)
    if Dice.rollUnder(player.finesse) then
        local baseDmg = monster_dmg[self.hd]
        local rawDamage = Dice.roll(baseDmg)
        local finalDamage = math.max(0, rawDamage-player.armor)
        player:takeDamage(finalDamage)
        return true, finalDamage
    end
    return false, 0
end

function monster:decrementCooldown()
    self.awareCooldown=self.awareCooldown-1
end

function monster:interact(agent)
    local hit, damage = agent:attack(self)
    return {
        type="combat",
        result = {hit=hit, damage=damage}
    }
end

return monster
