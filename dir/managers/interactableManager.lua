local conf = require("util.conf")
local scale = conf.scale_factor
local TILE_SIZE = 16
local PIXEL_TO_TILE = 1 / scale / TILE_SIZE
local TILE_TO_PIXEL = TILE_SIZE * scale
local ItemManager = require("managers/ItemManager")

InteractableManager = {}

-- TODO How to handle stacking of items?

function InteractableManager:new()
    local o = {}
    setmetatable(o,self)
    self.__index = self
    self.spawnPoints = {}
    self:initialize()
    return o
end

function InteractableManager:initialize()
    self.objects={}
end

-- Handle interactions with players
function InteractableManager:handleInteraction(player, object)
    if object.type=="DOOR" then
        if object.locked then
            return self:tryUnlockDoor(player,object)
        else
            return true
        end
    elseif object.type=="CHEST" then
        return self:openChest(player,object)
    elseif object.type=="EXIT" then
        return self:handleExit(player,object)
    end   
end

-- Handle collision?

function InteractableManager:tryUnlockDoor(player, door)
    if door and door.type=="DOOR" and door.locked then
        local requiredKey = door.color

        local keyIndex = player:findInInventory(function(item) return item.def.color==requiredKey end)
        --print(keyIndex)
        if keyIndex then
            door.locked = false
            table.remove(player.inventory.items,keyIndex)
            return true, "Door unlocked."
        else
            return false, "You need a " .. requiredKey .. " key."
        end
    end
end

-- Returns false on collision and title of new Map
function InteractableManager:handleExit(player, object)
    local nextMap = object.nextMap
    return false, nextMap..":SWITCHMAP"
end


-- Parse chest contents
function parseContents(contentString)
    --print(contentString)
    local contents = {}
    for item in contentString:gmatch("([^,]+)") do
        local itemName, count = item:match("(.+)#(%d+)")
        contents[itemName] = tonumber(count) or 1
    end
    return contents
end

-- Open chest
function InteractableManager:openChest(player,chest)
    if chest and chest.type=="CHEST" and not chest.opened and chest.contents~="" then
        local contents = parseContents(chest.contents)
        local itemsCollected = {}
        for itemName,count in pairs(contents) do
            if itemName=="gold" then -- Add gold, and stack em high
                player:addGold(count)
                table.insert(itemsCollected,count.." gold")
            else
                local itemDef = ItemManager:getItem(itemName) -- Add items (swords, armor, etc) and don't stack em high...
                if itemDef then
                    local addedCount = player:addItem(itemName, itemDef, count)
                    if addedCount>0 then
                        if addedCount==1 then
                            table.insert(itemsCollected,itemDef.name)
                        else
                            table.insert(itemsCollected, addedCount .. " " .. itemDef.name)
                        end
                    elseif addedCount < count then
                        local notAdded = count - addedCount 
                        table.insert(itemsCollected, "Couldn't pick up " .. notAdded .. " " .. itemDef.name .. " (inventory full)")
                    end
                end
            end
        end
        chest.opened = true
        chest.contents = ""
        local message = "You found: " .. table.concat(itemsCollected, ", ")
        return false, message
    else
        return false, "This chest is empty."
    end
end

function InteractableManager:getObjectAt(x,y)
    local key = self:makeKey(x,y)
    return self.objects[key]
end

function InteractableManager:removeObject(x,y)
    local key = self:makeKey(x,y)
    self.objects[key]=nil
end

function InteractableManager:makeKey(x,y)
    return x .. "," .. y
end

function InteractableManager:loadObjects(objects, persistentState)
    self.objects={}
    for key, object in pairs(objects) do
        self.objects[key] = object
        local state = persistentState[key]
        if state then
            self:applyState(object,state)
        end
    end
end

-- Handling stuff during applying state

function InteractableManager:applyState(object, state)
    object.locked = state.locked
    object.contents = state.contents
    object.color = state.color
    object.opened = state.opened
end

function InteractableManager:getObjectState(object)
    return {locked=object.locked, contents=object.contents, color=object.color, opened=object.opened}
end

-- Plural
function InteractableManager:getObjectsState()
    local state = {}
    for _, object in pairs(self.objects) do
        state[self:makeKey(object.x,object.y)] = self:getObjectState(object)
    end
    return state
end

function InteractableManager:clear()
    self.objects = {}
end

return InteractableManager