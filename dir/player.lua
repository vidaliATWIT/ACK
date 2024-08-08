-- Define player table
local player = {}
local config = require("conf")
local GM = require("GameMaster")
local scale = config.scale_factor
local Dice = require("Dice")
local Bonuses = {}


function player:load()
    player.image = love.graphics.newImage("res/pc.png")
    player.x=1
    player.y=1
    player.targetX=player.x
    player.targetY=player.y
    player.moving=false
    -- Stats
    player.speed=1
    player.torch_light=50
end

-- Init player stats
function player:init(o)
    if o==nil then
        o = {}
    end
    -- Character Stats
    player.name=o.name or "Manco"
    player.level = o.level or 1
    player.x = o.x or player.x
    player.y = o.y or player.y
    -- Base Stats
    player.speed=o.speed or 1
    player.max_hp=o.max_hp or 8
    player.hp=player.max_hp
    player.force=o.force or 14
    player.finesse=o.finesse or 14
    player.contemplation=o.contemplation or 14
    player.hardiness=o.hardiness or 14
    -- "Equipment" Stats
    player.armor=o.armor or 2
    player.damage=o.damage or 6
end

function player:keypressed(key)
    player.targetX=player.x
    player.targetY=player.y
    if key == "up" then
		player.targetY = player.y - player.speed
        player.moving=true
	elseif key == "down" then
		player.targetY = player.y + player.speed
        player.moving=true
	elseif key == "left" then
		player.targetX = player.x - player.speed
        player.moving=true
	elseif key == "right" then
		player.targetX = player.x + player.speed
        player.moving=true
    elseif key == "t" then
        if self.torch_light==50 then
            self.torch_light=100
        else
            self.torch_light=50
        end
    end
    return player.targetX,player.targetY
end

function player:move()
    -- called by gamemanager
    player.y=player.targetY
    player.x=player.targetX
end

function player:draw()
    love.graphics.draw(player.image,player.x, player.y, 0, scale, scale)
end

function player:heal(amount)
    player.hp = math.min(player.max_hp, player.hp+amount)
end

-- Handles attacking, is called by entites during some interacts
function player:attack(entity)
    if Dice.rollUnder(player.finesse) then
        local baseDmg = player.damage + player.getBonus(player.force)
        local rawDamage = Dice.roll(baseDmg)
        local finalDamage = math.max(0, rawDamage-entity.armor)
        entity:takeDamage(finalDamage)
        return true, finalDamage
    end
    return false, 0
end

-- Get Stat Bonus
function player.getBonus(stat)
    if stat % 2 == 0 then stat=stat-1 end
    print("STAT: ", stat)
    local bonus_table={[3]=-3,[5]=-2,[7]=-1,[9]=0,[11]=1,[13]=2,[15]=3,}
    return bonus_table[stat]
end

function player:getPosition()
    return {x=player.x, y=player.y}
end

function player:takeDamage(amount)
    player.hp = player.hp-amount
end

function player:isAlive()
    return player.hp>0
end

function player:setName(name)
    player.name=name
end

function player:setLevel(level)
    player.level=level
end

function player:setSpeed(speed)
    player.speed=speed
end

function player:setMaxHp(maxHp)
    player.max_hp=maxHp
end

function player:setHp(hp)
    player.hp=hp
end

function player:setForce(force)
    player.force=force
end

function player:setForce(finesse)
    player.finesse=finesse
end

function player:setContemplation(contemplation)
    player.contemplation=contemplation
end

function player:setHardiness(hardiness)
    player.hardiness=hardiness
end

function player:setArmor(armor)
    player.armor=armor
end

function player:setDamage(damage)
    player.damage=damage
end

return player