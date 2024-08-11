local conf = require("util.conf")
local scale = conf.scale_factor
local TILE_SIZE = 16
local PIXEL_TO_TILE = 1 / scale / TILE_SIZE
local TILE_TO_PIXEL = TILE_SIZE * scale

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
        print("A DOOR!!!")
    elseif object.type=="CHEST" then
        print("BEAUTIFUL CHEST!")
        self:openChest(player,object)
        print(player:getInventory())
    end
    if object.type=="DOOR" and object.locked~=true then
        return true
    else
        return false
    end
end

-- Handle collision?



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
            if itemName=="gold" then
                player:addGold(count)
                table.insert(itemsCollected,count.." gold")
            elseif itemName:find("key") then
                local keyColor = itemName:match("(%w+)_key")
                player:addItem("key",keyColor,count)
                table.insert(itemsCollected, count .. " " ..  keyColor .. " key(s)")
            else
                player:addItem("item", itemName,count)
                table.insert(itemsCollected,count .. " " .. itemName)
            end
        end
        chest.opened = true
        chest.contents = ""
        local message = "You found: " .. table.concat(itemsCollected, ",")
        print(message)
        return true, message
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
    print("ADDED NEW OBJECT", objectType, x, y)
    print(properties.locked)
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