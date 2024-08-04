local player = require("player")
local config = require("conf")
local monster = require("monster")
local EntityManager = require("EntityManager")
local scale = config.scale_factor
local TILE_SIZE = 16
local PIXEL_TO_TILE = 1 / config.scale_factor / TILE_SIZE
local TILE_TO_PIXEL = TILE_SIZE * config.scale_factor -- also pixel size at current screen resolution

function canMove(x,y)
    -- check if where you're moving to is walkable
    local tileX, tileY = math.floor(x*PIXEL_TO_TILE),math.floor(y*PIXEL_TO_TILE)
    local Floor = getTileAt("Floor",tileX,tileY)
    local Entity = entityManager:getEntityAt(x, y)
    if Entity~=nil then
        Entity:interact()
    end
    return Floor~=nil and Entity==nil
end

function getTileAt(layerName, x, y)
    local layer = _G.map.layers[layerName]
    if not layer then
        error("Layer not found: " .. layerName)
    end
    local tile = layer.data[y+1-_G.offsetY][x+1-_G.offsetX] -- WHY?!?! WHY IS IT TRANSPOSED?!?! WHO DID THIS?!
    return tile
end

function love.load()
    -- Screen Setup
    _G.width = 1024
    _G.height = 768
    _G.offsetX = 0
    _G.offsetY = 0
    love.window.setMode(_G.width, _G.height)
    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    -- Map Setup
    sti = require 'lib/sti'
    _G.map = sti('tilemap.lua')
    -- Player Setup
    player.load()
    -- Entity Setup
    entityManager = EntityManager.new(true, 16, 16)
    goblin = monster:new{name="goblin",y=1,x=5,sprite_path="/res/darkelf1.png"}
    entityManager:addEntity(goblin)
end

function love.update(dt)
    -- game logic here
end


function getFogIntensity(x,y)
    local dx = (x - player.x) / scale
    local dy = (y - player.y) / scale
    local distanceSq = math.sqrt(dx*dx+dy*dy)

    local intensity = math.min(1.0,distanceSq/player.torch_light)
    return intensity
end

function drawFog()
    -- we want to move in Grid Square Incremenets 
    for y = 0, _G.height, TILE_TO_PIXEL do
        for x = 0, _G.width, TILE_TO_PIXEL do
            local fogIntensity = getFogIntensity(x, y)
            love.graphics.setColor(0,0,0,fogIntensity)
            love.graphics.rectangle("fill",x,y,TILE_TO_PIXEL,TILE_TO_PIXEL)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
end

 
function love.draw()
    -- game rendering here
    --_G.map:draw(0,0, 4, 4)
    _G.map:draw(_G.offsetX*TILE_SIZE,_G.offsetY*TILE_SIZE,scale,scale)
    goblin:draw()
    drawFog()
    player:draw()
end

function love.keypressed(key)
    -- handle input
    local targetX, targetY = player:keypressed(key) -- screen coords
    if canMove(targetX, targetY) then
        -- If scrolling scroll
        if targetX+(TILE_TO_PIXEL)>=_G.width then
            _G.offsetX=_G.offsetX-1
        elseif targetX-(TILE_TO_PIXEL)<0 then
            _G.offsetX=_GoffsetX+1
        elseif targetY+(TILE_TO_PIXEL)>=_G.height then
            _G.offsetY=_G.offsetY-1
        elseif targetY-(TILE_TO_PIXEL)<0 then
            _G.offsetY=_G.offsetY+1
        else -- else move player
            player:move()
        --end
        end
    end
end
