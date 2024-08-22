local Entity = require("entity.Entity")
local npc = setmetatable({}, {__index = Entity})
local npc_dmg = {4, 6, 8, 10, 12, 12, 16, 18, 10, 22}
local Dice = require("util.Dice")
local Enums = require("util.Enums")

local NPCTemplates = {
    MOOK = { -- TALKERS & YAPPERS
        image = "/res/priest.png",
        hd = 1,
        npcType="mook",
        awarenessCooldown=3,
        offers_training=false,
        offers_quests=true,
    },
    TRAINER = { -- NPCs that can train the player
        image = "/res/trainer.png",
        hd = 5,
        npcType="trainer",
        awarenessCooldown=4,
        offers_training=true,
        offers_quests=true,
    },
}


npc.__index = npc

function npc:new(templateName, name, x, y)
    local template=NPCTemplates[templateName]
    if not template then
        error("Unknown npc template: " .. templateName)
    end
    local o = Entity:new({
        x=x,
        y=y,
        type=Enums.EntityType.NPC,
        name=name,
        sprite_path=template.image,
        hd=template.hd,
        npcType=template.npcType,
        maxAwarenessCooldown=template.awarenessCooldown
    })
    setmetatable(o,self)
    self.__index=self
    o.max_hp=o.hd*8 -- NPCs have max health for their level
    o.hp=o.max_hp
    o.armor = o.hd
    o.awareCooldown=o.maxAwarenessCooldown
    return o
end

function npc:update(dt)
    -- npc update
end

function npc:draw()
    love.graphics.draw(self.sprite,self.x, self.y, 0, scale, scale)
end

-- Checks if you're within attack range
function npc:scan(distance)
    if distance<=self.attack_range then
        return true
    else
        self.state=Enums.EntityState.IDLE
        return false
    end
end

-- Use Bresenham line to look for player
function npc:search(visible)
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
function npc:setState(distance, playerPos) 
    -- If close enough they'll start checking if they can see you
    return
end

-- Return a random direction to move in
function npc:getIdleDirection()
    local directions = {{x=0,y=1},{x=0,y=-1}, {x=1,y=0},{x=-1,y=0}}
    local random_dir = directions[math.random(#directions)]
    return random_dir
end

function npc:takeDamage(amount)
    self.hp=self.hp-amount
end

function npc:getDamage()
    return npc_dmg[self.hd]
end

function npc:attack(player)
    if Dice.rollUnder(player.finesse) then
        local baseDmg = npc_dmg[self.hd]
        local rawDamage = Dice.roll(baseDmg)
        local finalDamage = math.max(0, rawDamage-player.armor)
        player:takeDamage(finalDamage)
        return true, finalDamage
    end
    return false, 0
end

function npc:decrementCooldown()
    self.awareCooldown=self.awareCooldown-1
end

function npc:interact(agent)
    if self.state==Enums.EntityState.ATTACK then
        local hit, damage = agent:attack(self)
        return {
            type="combat",
            result = {hit=hit, damage=damage}
        }
    end
    if self.state==Enums.EntityState.IDLE then
        return {
            type="dialog",
            result="DUMMY."
        }
    end
end

-- For loading and saving state between map loads

function npc:applyState(state)
    self.hp=state.hp
    self.max_hp=state.max_hp
    self.state="IDLE"
end

function npc:getState(state)
    return {hp=self.hp, max_hp=self.max_hp, state=self.state}
end

return npc