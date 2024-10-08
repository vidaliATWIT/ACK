local Entity = require("entity.entity")
local monster = setmetatable({}, {__index = Entity})
local monster_dmg = {4, 6, 8, 10, 12, 12, 16, 18, 10, 22}
local Dice = require("util.dice")
local Enums = require("util.enums")
local SoundManager = require("managers.soundManager")
local UI = require("ui")

local MonsterTemplates = {
    GOBLIN = {
        name="Goblin",
        image="/res/goblin1.png",
        hd=1,
        monsterType="goblin",
        awarenessCooldown=3,
        ability={multiAttackChance=20,duration=2}
    },
    SKELETON = {
        name = "Skeleton",
        image = "/res/skeleton1.png",
        hd = 1,
        monsterType="skeleton",
        awarenessCooldown=3,
        ability={poisonChance=5,duration=3}
    },
    DARKELF = {
        name = "Dark Elf",
        image = "/res/darkelf1.png",
        hd = 2,
        monsterType="elf",
        awarenessCooldown=4,
    },
    KNIGHT = {
        name="Knight",
        image="res/knight1.png",
        hd=2,
        monsterType="knight",
        awarenessCooldown=10,
    },
    MARAUDER = {
        name="Marauder",
        image="res/marauder1.png",
        hd=2,
        monsterType="knight",
        awarenessCooldown=8,
        ability={poisonChance=10,duration=3}
    },
    KNIGHTCHAMP = {
        name="Knight Champion",
        image="res/knightChampion1.png",
        hd=3,
        monsterType="knight",
        awarenessCooldown=10,
    },
    OGRE = {
        name="Ogre",
        image="res/ogre1.png",
        hd=3,
        monsterType="ogre",
        awarenessCooldown=3,
    },
    OGREKNIGHT = {
        name="Ogre",
        image="res/ogre1.png",
        hd=3,
        monsterType="ogre",
        awarenessCooldown=3,
        ability={multiAttackChance=10,duration=2}
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
        maxAwarenessCooldown=template.awarenessCooldown,
        ability=template.ability
    })
    setmetatable(o,self)
    self.__index=self

    o.max_hp=Dice.rollMultiple(o.hd, 8) -- Random roll to determine hp
    o.hp=o.max_hp
    o.defense = o.hd
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
    if not Dice.rollUnder(player.finesse) then
        SoundManager:playHit()
        local baseDmg = monster_dmg[self.hd]
        local rawDamage = Dice.roll(baseDmg)
        local finalDamage = math.max(0, rawDamage-player.defense)
        if self.ability and self.ability.poisonChance and Dice.rollUnder(self.ability.poisonChance) then -- Wrap this in a helper function
            player:addStatus("poisoned", self.ability.duration)
        elseif self.ability and self.ability.multiAttackChance and Dice.rollUnder(self.ability.multiAttackChance) then -- MULTIATTACK BITCH
            UI:addCombatMessage(self.name .. " hit again!")
            finalDamage = self.ability.duration*rawDamage
        end
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

function monster:applyState(state)
    self.hp=state.hp
    self.max_hp = state.max_hp
    self.state="IDLE"
    self.awareCooldown=state.maxAwarenessCooldown
end

function monster:getState()
    return {hp=self.hp,max_hp=self.max_hp,state=self.state,cooldown=self.awareCooldown}
end

return monster
