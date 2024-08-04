local EntityManager = require("EntityManager")
local conf = require("conf")
local GameMaster = {}
local GM = {} -- using prototypes to make this easier to read
setmetatable(GM, {__index = GameMaster})
local Node = require("Node") -- Used for A*
local PriorityQueue = require("lib/PriorityQueue")
local scale = conf.scale_factor
local TILE_SIZE = 16
local PIXEL_TO_TILE = 1 / scale / TILE_SIZE
local TILE_TO_PIXEL = TILE_SIZE * scale -- also pixel size at current screen resolution

-- Controls all aspects of game logic and accesess map, player and entity locations on map
function GameMaster.initialize(useHashTable, worldWidth, worldHeight, map, player)
    GM.entityManager = EntityManager.new(useHashTable,worldWidth,worldHeight)
    GM.turn=0 -- Handles turns
    GM.round=0
    GM.offsetX=0
    GM.offsetY=0
    GM.player=player
    _G.map = map
end

-- Called by move
function GameMaster.nextRound()
    if GM.turn%6==0 then
        GM.round = GM.round+1
        -- Handle effects for next round e.g. usage dice, random encounters
    end
end

-- Called by move
function GameMaster.nextTurn()
    GM.turn=GM.turn+1
    -- Handle effects for next round
end

function GameMaster.getTileAt(layerName, x, y)
    local layer = _G.map.layers[layerName]
    if not layer then
        error("Layer not found: " .. layerName)
    end
    local tile = layer.data[y+1-GM.offsetY][x+1-GM.offsetX] -- WHY?!?! WHY IS IT TRANSPOSED?!?! WHO DID THIS?!
    return tile
end

function GameMaster.canMove(x,y)
    -- check if where you're moving to is walkable
    local tileX, tileY = math.floor(x*PIXEL_TO_TILE),math.floor(y*PIXEL_TO_TILE)
    local Floor = GM.getTileAt("Floor",tileX,tileY)
    local Entity = GM.entityManager:getEntityAt(x, y)
    if Entity~=nil then
        Entity:interact()
    end
    return Floor~=nil and Entity==nil
end

-- Called to add monsters
function GameMaster.addEntity(entity)
    GM.entityManager:addEntity(entity)
end

function GameMaster.updateOffset(dx,dy)
    GM.offsetX=GM.offsetX+dx
    GM.offsetY=GM.offsetY+dy
end

function GameMaster.getOffset()
    return GM.offsetX, GM.offsetY
end


-- Manhattan Heuristic for A*
function GameMaster:heuristic(pos1, pos2)
    local dx = math.abs(pos1.x - pos2.x)
    local dy = math.abs(pos1.y - pos1.y)
    return dx + dy
end

return GM

