local monster = require("entity.monster")
local npc = require("entity.npc")
local conf = require("util.conf")
local scale = conf.scale_factor
local TILE_SIZE = 16
local PIXEL_TO_TILE = 1 / scale / TILE_SIZE
local TILE_TO_PIXEL = TILE_SIZE * scale
EntityManager = {}
EntityManager.__index = EntityManager


-- Manages our entities as an abstracted layer above our game-map
-- Uses array for small maps, or a hashtable for larger ones
function EntityManager.new(useHashTable)
    local self = setmetatable({}, EntityManager)
    self.useHashTable = useHashTable

    if useHashTable then
        self.world = {} -- Hash Table
    end
    return self
end

function EntityManager:addEntity(entity)
    if self.useHashTable then
        local key = self:makeKey(entity.x,entity.y)
        if not self.world[key] then
            self.world[key] = entity
            return true
        end
    end
    return false
end

function EntityManager:removeEntity(entity)
    --print("We're removing ", entity.name, " at ", entity.x, entity.y)
    if self.useHashTable then
        local key = self:makeKey(entity.x,entity.y)
        self.world[key]=nil
    end
end

function EntityManager:moveEntity(entity, newX, newY)
    --print("We're moving ", entity.name, " to ", entity.x, entity.y)
    if newX < 1 or newX > self.worldWidth or newY < 1 or newY > self.worldHeight then
        print("Out of bounds!")
        return false
    end

    if self.useHashTable then
        local oldKey = self:makeKey(entity.x,entity.y)
        local newKey = self:makeKey(newX,newY)
        if not self.world[newKey] then
            self.world[oldKey]=nil
            self.world[newKey]=entity
            entity.x,entity.y=newX,newY
            return true
        end
    end
    return false
end

function EntityManager:getEntityAt(x,y)
    if self.useHashTable then
        return self.world[self:makeKey(x,y)]
    else
        return self.world[x] and self.world[x][y]
    end
end

function EntityManager:getNeighbors(x,y)
    local neighbors = {}
    for dx = -1, 1 do
        for dy = -1, 1 do
            local checkX, checkY = x + dx, y + dy
            if checkX >= 1 and checkX <= self.worldWidth and checkY >= 1 and checkY <= self.worldHeight then
                local entity = self:getEntityAt(checkX,checkY)
                if entity then
                    table.insert(neighbors, entity)
                end
            end
        end
    end
    return neighbors
end

function EntityManager:getEntitiesInRange(startX, startY, endX, endY)
    local entities = {}
    if self.useHashTable then
        for key, entity in pairs(self.world) do
            if entity.x >= startX and entity.x <= endX and
            entity.y >= startY and entity.y <= endY then
                table.insert(entities,entity)
            end
        end
    end
    return entities
end

function EntityManager:getAllEntities()
    local entities = {}
    if self.useHashTable then
        for _, entity in pairs (self.world) do
            table.insert(entities,entity)
        end
    end
    return entities
end

function EntityManager:spawnMonsters()
    local monsterSpawnPoints = self:getSpawnPoints("MONSTER")
    for _, spawnPoint in ipairs(monsterSpawnPoints) do
        --print(spawnPoint.subType)
        local newMonster = monster:new(spawnPoint.subType, spawnPoint.x, spawnPoint.y)
        --print(newMonster.name, newMonster.x, newMonster.y)
        self:addEntity(newMonster)
    end
end

function EntityManager:spawnNPCs()
    local NPCSpawnPoints = self:getSpawnPoints("NPC")
    for _, spawnPoint in ipairs(NPCSpawnPoints) do
        --print(spawnPoint.subType)
        local newNPC = npc:new(spawnPoint.subType, spawnPoint.name, spawnPoint.x, spawnPoint.y)
        --print(newNPC.name, newNPC.x, newNPC.y)
        self:addEntity(newNPC)
    end
end

function EntityManager:loadEntities(spawnPoints, persistentState)
    self.world = {}
    for _, spawnPoint in ipairs(spawnPoints) do
        local entity
        if spawnPoint.type=="MONSTER" then
            entity = monster:new(spawnPoint.subType, spawnPoint.x, spawnPoint.y)
        elseif spawnPoint.type == "NPC" then
            entity = npc:new(spawnPoint.subType, spawnPoint.name, spawnPoint.x, spawnPoint.y)
        end

        if entity then -- Check if we have a persistent state for this entity
            local state = persistentState[self:makeKey(spawnPoint.x,spawnPoint.y)]
            if state then
                print("APPLYING STATE")
                entity:applyState(state)
            end

            if entity:isAlive() then
                print()
                self:addEntity(entity)
            end
        end
    end
end

function EntityManager:getEntitiesState()
    local state = {}
    for _, entity in pairs(self.world) do
        state[self:makeKey(entity.x,entity.y)] = entity:getState()
    end
    return state
end

function EntityManager:makeKey(x,y)
    return x .. "," .. y
end

function EntityManager:updateDimensions(width,height)
    self.worldWidth=width
    self.worldHeight=height
end

function EntityManager:clear()
    self.world = {}
end

return EntityManager