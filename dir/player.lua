-- Define player table
local player = {
    metNPCs={},
    quests={},
    inventory={
        keys = {
            red=0,
            blue=0,
            green=0,
            gold=0,
        },
        items={},
        gold=0
    },
}
local config = require("util.conf")
local scale = config.scale_factor
local Dice = require("util.Dice")
local Bonuses = {}
local EQUIPMENT_SLOTS = {
    weapon = {field = "weapon", defaultStat="damage", defaultValue=2},
    armor = {field = "armor", defaultStat="defense", defaultValue=0}
}


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
    player.armor={}
    player.weapon={}

    player.defense=0
    player.damage=4
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
        local finalDamage = math.max(0, rawDamage-entity.defense)
        entity:takeDamage(finalDamage)
        return true, finalDamage
    end
    return false, 0
end

-- Add an item to items using pre-set def
function player:addItem(itemName, itemDef)
    -- Strength is Carry Capacity
    print(#self.inventory.items)
    if #self.inventory.items < self.force then
        if itemDef then
            table.insert(self.inventory.items, {
                name=itemDef.name,
                def=itemDef,
            })
            return true
        else
            print("WARNING: Tried to add unknown item '" .. itemName .. "' to inventory.")
            return false
        end
    end
    return false -- inventory full
end

-- Handle to remove items
function player:removeItem(itemType,itemName,count)
    if index > 0 and index <= #self.inventory.items then
        return table.remove(self.inventory.items, index)
    end
    return nil
end

-- General use method for equiping/use
function player:useItem(index)
    local item = self.inventory.items[index]
    if not item then return "Cannot use that." end

    if item.def.type==consummable and item.def.effect then
        item.def.effect(self)
        self:removeItem(index)
        return "Used " .. item.name
    elseif (EQUIPMENT_SLOTS[item.def.type]) then
        return self:toggleEquipItem(item)
    end
    return "Cannot use that"
end

function player:toggleEquipItem(item)
    local slotInfo = EQUIPMENT_SLOTS[item.def.type]
    print("PLAYER DAMAGE and ARMOR: ", player.damage, player.defense)
    if not slotInfo then return "Item is not equipable" end

    if item.def.equipped=="(Equipped)" then
        self:unequipItem(item,slotInfo)
        return "Unequipped " .. item.name
    else
        self:equipItem(item,slotInfo)
        return "Equipped " .. item.name
    end
end

function player:equipItem(item,slotInfo)
    if not slotInfo then return end

    -- Unequip current item in the slot if any
    if self[slotInfo.field] then
        self:unequipItem(self[slotInfo.field])
    end

    -- Equip new item
    self[slotInfo.field] = item
    self[slotInfo.defaultStat] = item.def[slotInfo.defaultStat]
    item.def.equipped="(Equipped)"
end

function player:unequipItem(item,slotInfo)
    if not slotInfo then return end
    self[slotInfo.field] = nil
    self[slotInfo.defaultStat] = slotInfo.defaultValue
    item.def.equipped=""
end


function player:getItem(index)
    return self.inventory.items[index]
end

function player:addKey(color)
    self.inventory.keys[color] = (self.inventory.keys[color] or 0) + 1
end

function player:addGold(count)
    self.inventory.gold = (self.inventory.gold or 0) + count 
end

function player:removeGold(count)
    self.inventory.gold = math.max(0, (self.inventory.gold or 0) - count)
end

-- Parses through inventory and returns string
function player:getInventory()
    local inventoryTable = {}
    for index,properties in pairs(self.inventory.items) do
        table.insert(inventoryTable, index .. ") " .. properties.name .. properties.def.equipped .."\n")
    end
    for color,count in pairs(self.inventory.keys) do
        if count>0 then
            table.insert(inventoryTable,color .. " key" .. "\n")
        end
    end
    table.insert(inventoryTable, self.inventory.gold .. " gold pieces\n")
    inventoryString=table.concat(inventoryTable, "")
    return inventoryTable
end
-- Get Stat Bonus
function player.getBonus(stat)
    if stat % 2 == 0 then stat=stat-1 end
    print("STAT: ", stat)
    local bonus_table={[3]=-3,[5]=-2,[7]=-1,[9]=0,[11]=1,[13]=2,[15]=3,[17]=4,[19]=5,}
    return bonus_table[stat]
end

function player:getPosition()
    return {x=player.x, y=player.y}
end

function player:takeDamage(amount)
    player.hp = player.hp-amount
end

function player:hasMetNPC(npcName)
    return player.metNPCs[npcName] or false
end

function player:meetNPC(npcName)
    player.metNPCs[npcName] = true
end

function player:getQuestStatus(questName)
    return player.quests[questName] or "not_started"
end

function player:updateQuestStatus(questName, status)
    player.quests[questName]=status
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

function player:setFinesse(finesse)
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