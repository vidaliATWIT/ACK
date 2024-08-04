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
local CollisionMatrix = {} -- representation of the map with entities, player, and walls

-- Controls all aspects of game logic and accesess map, player and entity locations on map
function GameMaster.initialize(useHashTable, worldWidth, worldHeight, map, player)
    GM.entityManager = EntityManager.new(useHashTable,worldWidth,worldHeight)
    GM.turn=0 -- Handles turns
    GM.round=0
    GM.offsetX=0
    GM.offsetY=0
    GM.player=player
    _G.map = map
    _G.worldWidth=worldWidth or 16
    _G.worldHeight=worldHeight or 16
end

-- Initialize Collision Matrix with walls, entities and player
function GameMaster.initCollisionMatrix()
    for x = 0, _G.worldWidth-1 do
        CollisionMatrix[x] = {}
        for y = 0, _G.worldHeight-1 do
            tile = GM.getTileAt("Floor", x,y)
            entity = GM.entityManager:getEntityAt(x,y)
            CollisionMatrix[x][y] = tile==nil or entity~=nil --Nil or true
        end
    end
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
    local tile = layer.data[y+1][x+1] -- WHY?!?! WHY IS IT TRANSPOSED?!?! WHO DID THIS?!
    return tile
end

function GameMaster.canMove(x,y)
    if true then
        -- check if where you're moving to is walkable
        local Floor = GM.getTileAt("Floor",x,y)
        local Entity = GM.entityManager:getEntityAt(x, y)
        if Entity~=nil then
            Entity:interact()
        end
        return Floor~=nil and Entity==nil
    else
       return not CollisionMatrix[x][y] 
    end
end

-- Called to add monsters
function GameMaster.addEntity(entity)
    local x, y = entity.x, entity.y
    GM.entityManager:addEntity(entity)
    if CollisionMatrix[x] then
        CollisionMatrix[x][y] = true
    end
end

function GameMaster.updateOffset(dx,dy)
    GM.offsetX=GM.offsetX+dx
    GM.offsetY=GM.offsetY+dy
end

function GameMaster.getOffset()
    return GM.offsetX, GM.offsetY
end

-- Monster Movement

function GameMaster.moveEntity(entity, newX, newY)
    -- Remove monster from current position in WorldSpace
    local x,y = entity.x, entity.y
    if newX==GM.player.x and newY==GM.player.y then
        entity:attack()
        return
    end
    if CollisionMatrix[x] and CollisionMatrix[x][y] then
        CollisionMatrix[x][y] = false
    end
    if GM.entityManager:moveEntity(entity,newX,newY) then
        CollisionMatrix[newX][newY]=true
    end
end


function GameMaster.heuristic(pos1,pos2) -- Manhattan heuristic
    local dx = math.abs(pos2.x - pos1.x)
    local dy = math.abs(pos2.y - pos1.y)
    return dx + dy
end
-- partial A* Algorithm
function GameMaster.nextMove(startPos, goal)
    local frontier = PriorityQueue('min')
    frontier:enqueue(startPos, 0)

    local iteration = 0

    local came_from = {}
    local cost_so_far = {}

    local came_from = {}
    local cost_so_far = {}
    came_from[startPos.x .. "," .. startPos.y] = nil
    cost_so_far[startPos.x .. "," .. startPos.y] = 0

    local function getNeighbors(collisionMatrix, current)
        local neighbors = {}
        local directions = {{0,1}, {1,0}, {0,-1}, {-1,0}}
        for _, dir in ipairs(directions) do
            local newX, newY = current.x + dir[1], current.y + dir[2]
            if collisionMatrix[newX] and collisionMatrix[newX][newY] == false then
                table.insert(neighbors, {x=newX, y=newY})
            end
        end
        return neighbors
    end

    local function heuristic(pos1,pos2) -- Manhattan heuristic
        local dx = math.abs(pos2.x - pos1.x)
        local dy = math.abs(pos2.y - pos1.y)
        return dx + dy
    end

    while not frontier:empty() do
        local current = frontier:dequeue()
        --print("Current position at given point:", current.x, current.y)

        if current.x == goal.x and current.y == goal.y then --finetune this
            break
        end

        for _, next in ipairs(getNeighbors(CollisionMatrix, current)) do

            local new_cost = cost_so_far[current.x .. "," .. current.y] + 1
            local next_key = next.x .. "," .. next.y
    
            if cost_so_far[next_key] == nil or new_cost < cost_so_far[next_key] then
                cost_so_far[next_key] = new_cost
                local priority = new_cost + heuristic(next,goal)
                frontier:enqueue(next,priority)
                came_from[next_key]=current
                --if iteration==2 then -- This can be bypassed but seems like an easy way to get teh first possible position
                    --return current
                --end
                --iteration=iteration+1
            end
        end
    end

    -- Get next move
    local current = goal
    local next_move = nil
    while current do
        print("CURRENT:", current.x, current.y)
        local key = current.x .. "," .. current.y
        next_move = current
        current = came_from[key]
        if current and current.x == startPos.x and current.y == startPos.y then
            return previous or next_move
        end
    end
    return next_move
end


return GM

