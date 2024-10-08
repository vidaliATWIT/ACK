local EntityManager = require("managers.entitymanager")
local conf = require("util.conf")
local GameMaster = {}
local GM = {} -- using prototypes to make this easier to read
setmetatable(GM, {__index = GameMaster})
local PriorityQueue = require("lib.PriorityQueue")
local scale = conf.scale_factor
local TILE_SIZE = 16
local PIXEL_TO_TILE = 1 / scale / TILE_SIZE
local TILE_TO_PIXEL = TILE_SIZE * scale -- also pixel size at current screen resolution
local CollisionMatrix = {} -- representation of the map with entities, player, and walls
local Enums = require("util.enums")
local UI = require("ui")
local DialogManager = require("managers.dialogManager")
local InteractableManager = require("managers.interactableManager")
local GameState = require("managers.gameState")
local MapManager = require("map/map")
local SoundManager = require("managers.soundManager")

-- Controls all aspects of game logic and accesess map, player and entity locations on map
function GameMaster.initialize(useHashTable, worldWidth, worldHeight, map, player)
    GM.turn=0 -- Handles turns
    GM.round=0
    GM.offsetX=0
    GM.offsetY=0
    GM.player=player
    GM.mapManager = MapManager
    GM.mapManager:initialize()
    GM.mapManager:loadMap("town1",'town1.lua')
    GM.mapManager:loadMap("dungeon1",'dungeon1.lua')
    GM.mapManager:loadMap("dungeon2",'dungeon2.lua')
    GM.mapManager:loadMap("dungeon3",'dungeon3.lua')
    GM.entityManager = EntityManager.new(true,1,1,nil)
    GM.interactableManager = InteractableManager:new(nil)
    GM.transitionState={active=false,alpha=0,fadingIn=false}

    SoundManager:load()

    GM.UI=UI
    GM.GameState=GameState
    GM:switchMap("town1")
end

-- Assume we load everything in GameMaster.init
function GameMaster:switchMap(newMapId)
    GM:mapSwitch(newMapId)
end

function GameMaster:executeMapSwitch()
    local newMapId = GM.pendingMapId
    GM:mapSwitch(newMapId)
end

function GameMaster:initiateMapSwitch(newMapId)
    GM.pendingMapId = newMapId
    GM.transitionState.active = true
    GM.transitionState.alpha = 0
    GM.transitionState.fadingIn = false
end

function GameMaster:mapSwitch(newMapId)
    local oldMap = GM.mapManager.currentMap
    if oldMap then
        oldMap.exitCoords = {x=GM.player.x, y=GM.player.y}
    end
    GM.mapManager:switchMap(newMapId,GM.entityManager, GM.interactableManager)
    local currentMap = GM.mapManager.currentMap

    _G.worldWidth = currentMap.width
    _G.worldHeight = currentMap.height

    GM.entityManager:updateDimensions(_G.worldWidth,_G.worldHeight)
    --GM.mapManager.currentMap:loadEntities(GM.entityManager)
    if (currentMap.currentEntities) then -- The or is because currentEntities is nil first round, but once passed, it might not be!!!
        GM.entityManager.world = currentMap.currentEntities
    else
        GM.entityManager:loadEntities(currentMap.initialEntities, currentMap.persistentState.entities)
    end 
    GM.interactableManager:loadObjects(currentMap.objects, currentMap.persistentState.objects)
    if (currentMap.exitCoords and currentMap.exitCoords.x and currentMap.exitCoords.y) then
        GM.player.targetX=currentMap.exitCoords.x
        GM.player.targetY=currentMap.exitCoords.y
    else
        GM.player.targetX = currentMap.spawnPoint.x
        GM.player.targetY = currentMap.spawnPoint.y
    end
    GM.offsetX=0
    GM.offsetY=0
    GM:initCollisionMatrix()
    GM.player:move()
end


-- Initialize Collision Matrix with walls, entities and player
function GameMaster.initCollisionMatrix()
    collisionMatrix = {}
    for x = 0, _G.worldWidth-1 do
        CollisionMatrix[x] = {}
        for y = 0, _G.worldHeight-1 do
            tile = GM.getTileAt("floor", x,y)
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

-- Called by move handles all entities in visible world
function GameMaster.nextTurn()
    -- clear dialog bubbles
    local entities = GM.entityManager:getAllEntities()
    local player_pos = {x=GM.player.x, y=GM.player.y}
    GM.player:updateStatuses()
    for _, entity in pairs(entities) do
        if GM.heuristic(entity:getPosition(), player_pos) < 10 then
            GM.handleEntityTurn(entity)
            --print(entity.name, " is being processed")
        end
    end
    GM.turn=GM.turn+1
end

-- Handles turns for entities by checking state, getting relevant world information and passing onto entities to further allocate their actions
function GameMaster.handleEntityTurn(entity)
    local next_move = nil
    print("Entity name and state and X/Y : ", entity.name, entity.state, entity.x, entity.y)
    if (entity.type==Enums.EntityType.MONSTER) then
        GM.handleStateTransition(entity)

        if entity.state==Enums.EntityState.IDLE then -- IDLE
            if entity.type==Enums.EntityType.MONSTER then
                next_move = entity:getIdleDirection()
                GM.moveEntity(entity, next_move.x, next_move.y)
            end
        elseif entity.state==Enums.EntityState.AWARE then -- AWARE AND SEARCHING
            if (entity.awareCooldown>0) then
                next_move = GM.nextMove(entity:getPosition(), entity.lastKnownPlayerPos)
                entity:decrementCooldown()
            end
        elseif entity.state==Enums.EntityState.ATTACK then -- ATTACKING
            next_move = GM.nextMove(entity:getPosition(), GM.player:getPosition())
        else
            entity.state=Enums.EntityState.IDLE
        end
        if next_move then
            GM.moveEntity(entity, next_move.x, next_move.y)
        end
    end
    
end

-- Helper function to encapsulate handling states
function GameMaster.handleStateTransition(entity)
    local distance = GM.heuristic(entity:getPosition(), GM.player:getPosition())
    if (entity:scan(distance)) then 
        entity.lastKnownPlayerPos=GM.player:getPosition()
        local isVisible = GM:bresenhamLOS(entity:getPosition(), entity.lastKnownPlayerPos)
        entity:search(isVisible) 
    end
end

function GameMaster.getTileAt(layerName, x, y)
    local layer = MapManager.currentMap.tiles[layerName]
    if not layer then
        error("Layer not found: " .. layerName)
    end
    local tile = layer[y+1][x+1] -- WHY?!?! WHY IS IT TRANSPOSED?!?! WHO DID THIS?!
    return tile
end

-- Handles player move
function GameMaster.canMove(x,y)
    if true then
        -- check if where you're moving to is walkable
        local floor = GM.getTileAt("floor",x,y)
        local entity = GM.entityManager:getEntityAt(x, y)
        print("THERE SHOULD BE AN ENTITY HERE AT: ", entity, x,y)
        local object = GM.interactableManager:getObjectAt(x,y)
        if object ~= nil then
            local objectOpen, message = GM.interactableManager:handleInteraction(GM.player,object)
            if message then
                if string.find(message,"SWITCHMAP") then -- EXIT
                    local nextMap = string.match(message, "^([^:]+)")
                    SoundManager:playDescend()
                    GM:initiateMapSwitch(nextMap)
                    print(nextMap)
                else
                    SoundManager:playOpen()
                    UI:addCombatMessage(message)
                end
            end
            return objectOpen
        end
        if entity~=nil then
            GM.handleInteraction(entity, GM.player)
        end
        return floor~=nil and entity==nil
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

function GameMaster.handleInteraction(entity, player)
    local interaction = entity:interact(player)
    if interaction.type=="combat" then
        local hit, damage = interaction.result.hit, interaction.result.damage
        --print(entity.name, " HP: ", entity.hp)
        GM.displayHit(hit, damage, GM.player.name, entity.name)
        if entity:isAlive()==false then
            SoundManager:playDeath()
            GM.handleEntityDeath(entity)
        end
    elseif interaction.type=="dialog" then
        SoundManager:playTalk()
        DialogManager:startDialog(entity)
        GM.displayDialog()
        GM.GameState.set("DIALOG")
    end
end

-- Monster Movement

function GameMaster.moveEntity(entity, newX, newY)
    -- Remove monster from current position in WorldSpace
    local x,y = entity.x, entity.y
    if newX==GM.player.x and newY==GM.player.y then -- Only fire if state is attacking
        hit, damage = entity:attack(GM.player)
        GM.displayHit(hit, damage, entity.name, GM.player.name)
        return
    end
    if CollisionMatrix[x] and CollisionMatrix[x][y] then
        CollisionMatrix[x][y] = false
    end
    if GM.entityManager:moveEntity(entity,newX,newY) then
        CollisionMatrix[newX][newY]=true
    end
end


-- Handles death of an entity
function GameMaster.handleEntityDeath(entity)
    local message = string.format("%s perished.", entity.name)
    UI:addCombatMessage(message)
    CollisionMatrix[entity.x][entity.y]=false
    GM.entityManager:removeEntity(entity) -- 
    --GM.mapManager:removeEntity(entity, GM.entityManager)
end

function GameMaster.isGameOver()
    return GM.player.isAlive()~=true
end

function GameMaster.displayHit(hit, damage, attacker_name, target_name)
    local message
    if hit then
        message = string.format("%s hit %s for %d points of damage!", attacker_name, target_name, damage)
    else
        SoundManager:playMiss()
        message = string.format("%s missed...", attacker_name)
    end
    UI:addCombatMessage(message)
end

function GameMaster.displayDialog(npc_name, dialog)
    print("OUR DIALOG TEXT IS : ", DialogManager:getCurrentText())
    local dialogText=DialogManager:getCurrentText()
    local options=DialogManager:getOptions()

    UI:showDialog(dialogText,options)
end

function GameMaster.handleDialogChoice(optionIndex)
    local dialogContinues = DialogManager:choose(optionIndex)
    if dialogContinues then
        GM.displayDialog()
    else
        GameState.set("EXPLORING")
        DialogManager:endDialog()
        UI:hideDialog()
    end
end


-- Bresenham line of sight
function GameMaster:bresenhamLOS(pos1, pos2)
    local x1,y1 = pos1.x, pos1.y
    local x2,y2 = pos2.x, pos2.y
    local dx = math.abs(x2 - x1)
    local sx = x1 < x2 and 1 or (x1 > x2 and -1 or 0)
    local dy = math.abs(y2 - y1)
    local sy = y1 < y2 and 1 or (y1 > y2 and -1 or 0)
    e = dx + dy

    while true do
        --print("Checking point:", x1, y1)
        if GM.getTileAt("walls", x1, y1) then
            --print("Wall found at:", x1, y1)
            return false  -- Line of sight is blocked
        end
        if x1==x2 and y1==y2 then
            return true
        end
        e2 = 2*e
        if e2>-dy then
            e = e - dy
            x1 = x1 + sx
        end
        if e2 < dx then
            e = e + dx
            y1 = y1 + sy
        end
    end
end

function GameMaster.heuristic(pos1,pos2) -- Manhattan distance
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
            end
        end
    end

    -- Get next move
    local current = goal
    local next_move = nil
    while current do
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

