EntityManager = {}
EntityManager.__index = EntityManager

-- Manages our entities as an abstracted layer above our game-map
-- Uses array for small maps, or a hashtable for larger ones
function EntityManager.new(useHashTable, worldWidth, worldHeight)
    local self = setmetatable({}, EntityManager)
    self.useHashTable = useHashTable
    self.worldWidth = worldWidth or 16
    self.worldHeight = worldHeight or 16

    if useHashTable then
        self.world = {} -- Hash Table
    else
        self.world = {} -- 2D array
        for x = 1, worldWidth do
            self.world[x] = {}
            for y = 1, worldHeight do
                self.world[x][y] = nil
            end
        end
    end
    return self
end

function EntityManager:makeKey(x,y)
    return x .. "," .. y
end

function EntityManager:addEntity(entity)
    if self.useHashTable then
        local key = self:makeKey(entity.x,entity.y)
        if not self.world[key] then
            self.world[key] = entity
            return true
        end
    else
        if self.world[entity.x] and not self.world[entity.x][entity.y] then
            self.world[entity.x][entity.y] = entity
            return true
        end
    end
    return false
end

function EntityManager:removeEntity(entity)
    if self.useHashTable then
        local key = self:makeKey(entity.x,entity.y)
        self.world[key]=nil
    else
        if self.world[entity.x] then
            self.world[entity.x][entity.y]=nil
        end
    end
end

function EntityManager:moveEntity(entity, newX, newY)
    if newX < 1 or newX > self.worldWidth or newY < 1 or newY > self.worldHeight then
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
    else
        if not self.world[newX][newY] then
            self.world[entity.x][entity.y] = nil
            self.world[newX][newY]=entity
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

function EntityManager:getAllEntities()
    local entities = {}
    if self.useHashTable then
        for _, entity in pairs (Self.world) do
            table.insert(entities,entity)
        end
    else
        for x = 1, self.worldWidth do
            for y = 1, self.worldHeight do
                if self.world[x][y] then
                    table.insert(entities, self.world[x][y])
                end
            end
        end
    end
    return entities
end

return EntityManager