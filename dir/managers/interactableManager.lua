local conf = require("util.conf")
local scale = conf.scale_factor
local TILE_SIZE = 16
local PIXEL_TO_TILE = 1 / scale / TILE_SIZE
local TILE_TO_PIXEL = TILE_SIZE * scale
local ItemManager = require("managers/ItemManager")

InteractableManager = {}

-- TODO string to table to parse out contents

function InteractableManager:new(mapData)
    local o = {}
    setmetatable(o,self)
    self.__index = self
    self.mapData = mapData
    self.spawnPoints = {}
    self:initialize()
    self:spawnObjects()
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
        end
    elseif object.type=="CHEST" then
        return self:openChest(player,object)
    end
    if object.type=="DOOR" and object.locked~=true then
        return true
    else
        return false
    end
end

-- Handle collision?

function InteractableManager:tryUnlockDoor(player, door)
    if door and door.type=="DOOR" and door.locked then
        local requiredKey = door.color
        print("COLOR: ".. door.color)
        print("PLAYER KEYS: " .. player.inventory.keys[requiredKey])
        if player.inventory.keys[requiredKey] and player.inventory.keys[requiredKey] > 0 then
            door.locked=false
            player.inventory.keys[requiredKey] = player.inventory.keys[requiredKey]-1
            return true, "Door unlocked!"
        end
        return false, "You need a " .. requiredKey .. " key."
    end
end

-- Parse chest contents
function parseContents(contentString)
    print(contentString)
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
            elseif itemName:find("key") then -- Add key and stack em high
                local keyColor = itemName:match("(%w+)_key")
                player:addKey(keyColor)
                table.insert(itemsCollected, count .. " " ..  keyColor .. " key(s)")
            else
                local itemDef = ItemManager:getItem(itemName) -- Add items (swords, armor, etc) and don't stack em high...
                if itemDef then
                    if player:addItem(itemName, itemDef) then
                        table.insert(itemsCollected, itemDef.name)
                    else
                        table.insert(itemsCollected, "Couldn't pick up " .. itemDef.name .. " (inventory full)")
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

function InteractableManager:addObject(objectType,x,y,properties)
    local key = self:makeKey(x,y)
    self.objects[key] = {
        type=objectType,
        x=x,
        y=y,
        locked=properties.locked,
        color=properties.color,
        contents=properties.contents,
        opened=properties.opened,
    }
end

-- Iterates through map data to spawn items
function InteractableManager:spawnObjects()
    for _, object in ipairs(self.mapData.layers["Interactable"].objects) do
        self:addObject(
            object.properties.Type,
            object.x/TILE_SIZE,
            object.y/TILE_SIZE,
            {
                locked=object.properties.Locked,
                contents=object.properties.Content,
                color=object.properties.Color,
                opened=object.properties.Opened,
            }
        )
    end
end

return InteractableManager