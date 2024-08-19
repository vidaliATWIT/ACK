local conf = require("util.conf")
local scale = conf.scale_factor
local TILE_SIZE = 16
local PIXEL_TO_TILE = 1 / scale / TILE_SIZE
local TILE_TO_PIXEL = TILE_SIZE * scale

Map = {}
Map.__index = Map

-- Maps have TileData, Entities, and InteractableObjects

function Map:new(id,tileData,entityData,objectData,spawnPoint,mapData)
    local self = setmetatable({},Map)
    self.id = id
    self.tiles = {
        floor=tileData.floor,
        walls=tileData.walls,
        interactables = tileData.interactables
    }
    self.initialEntities = entityData
    self.currentEntities = nil
    self.objects = objectData
    self.spawnPoint = spawnPoint
    self.persistentState = {entities={},objects={}}
    self.width = tileData.width
    self.height = tileData.height
    self.map = mapData
    self.exitCoords = {}
    return self
end

function Map:loadEntities(entityManager)
    if currentEntities then
        entityManager.entities=self.currentEntities
    else
        entityManager:loadEntities(self.entities)
    end
end

function Map:loadObjects(objectManager)
    objectManager:loadObjects(self.objects)
end

function Map:isTileWalkable(x,y)
    return self.tiles.floor[y][x] and not self.entities.get(x,y)
end

-- Calls draw on the STI function
function Map:draw(x,y,scale,scale)
    self.map:draw(x,y,scale,scale)
end

-- MapManager
MapManager = {
    maps = {},
    currentMap = nil
}

function MapManager:initialize()
    self.maps={}
    self.currentMap=nil
end

function MapManager:loadMap(mapId, tilemapFile)
    local mapData = sti(tilemapFile)
    local tileData = {
        floor = mapData.layers["Floor"].data,
        walls = mapData.layers["Walls"].data,
        interactables = mapData.layers["Interactable"].data,
        width = mapData.width,
        height = mapData.height
    }
    local entityData = self:parseSpawnPoints(mapData)
    local objectData = self:parseInteractablePoints(mapData)
    local playerSpawn = self:parsePlayerSpawn(mapData)

    self.maps[mapId] = Map:new(mapId, tileData, entityData, objectData, playerSpawn,mapData) -- Npt how itll work but just to get the template going
end

function MapManager:draw(x,y,scale,scale)
    self.currentMap:draw(x,y,scale,scale)
end

function MapManager:makeKey(x,y)
    return x .. "," .. y
end

function MapManager:parseSpawnPoints(mapData)
    local entities = {}
    for _, object in ipairs(mapData.layers["SpawnPoints"].objects) do
        table.insert(entities, {
            x = object.x / TILE_SIZE,
            y = object.y / TILE_SIZE,
            type = object.properties.Type,
            subType = object.properties.SubType,
            name = object.properties.Name or "None"
        })
    end
    return entities
end

-- Retrieve InteractableObjects
function MapManager:parseInteractablePoints(mapData)
    local objects = {}
    for _, object in ipairs(mapData.layers["Interactable"].objects) do
        local key = self:makeKey(object.x/TILE_SIZE,object.y/TILE_SIZE)
        objects[key] = {
            type=object.properties.Type,
            x = object.x / TILE_SIZE,
            y = object.y / TILE_SIZE,
            locked = object.properties.Locked,
            color = object.properties.Color,
            contents = object.properties.Content,
            opened = object.properties.Opened,
            nextMap = object.properties.NextMap,
        }
    end
    return objects
end

function MapManager:parsePlayerSpawn(mapData)
    local spawnCoords = {}
    for _, object in ipairs(mapData.layers["PlayerSpawn"].objects) do
        spawnCoords = {x=object.x/TILE_SIZE,y=object.y/TILE_SIZE}
    end
    return spawnCoords
end

function MapManager:switchMap(newMapId, entityManager, objectManager)
    if self.currentMap then
        self:saveMapState(self.currentMap.id, entityManager, objectManager) --Unloads objects and entities saving the state
    end

    if not self.maps[newMapId] then
        error("Map " .. newMapId .. " not loaded.")
    end

    self.currentMap = self.maps[newMapId]
end

-- Initialize Collision Matrix with walls, entities and player
function MapManager:initCollisionMatrix()
    for x = 0, self.currentMap.width-1 do
        CollisionMatrix[x] = {}
        for y = 0, self.currentMap.height-1 do
            tile = GM.getTileAt("Floor", x,y)
            entity = GM.entityManager:getEntityAt(x,y)
            CollisionMatrix[x][y] = tile==nil or entity~=nil --Nil or true
        end
    end
end

function MapManager:saveMapState(mapId, entityManager, objectManager)
    local map = self.maps[mapId]
    map.persistentState.entities = entityManager:getEntitiesState()
    map.currentEntities = entityManager.world
    --print("Current Entities: ", map.currentEntities)
    map.persistentState.objects = objectManager:getObjectsState()
end

-- 
function MapManager:removeEntity(entity, entityManager)
    if self.currentMap.currentEntities then
        local key = entityManager:makeKey(entity.x,entity.y)
        self.currentMap.currentEntities[key]=nil
    end
end

function MapManager:getPlayerSpawn()
    return self.currentMap.spawnPoint
end

return MapManager