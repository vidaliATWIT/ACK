local player = require("player")
local conf = require("conf")
local monster = require("monster")
local GM = require("GameMaster")
local scale = conf.scale_factor
local TILE_SIZE = 16
local PIXEL_TO_TILE = 1 / scale / TILE_SIZE
local TILE_TO_PIXEL = TILE_SIZE * scale

function love.load()
    -- Screen Setup
    _G.width = 1024
    _G.height = 768
    _G.offsetX = 0
    _G.offsetY = 0
    _G.screenTilesX=_G.width*PIXEL_TO_TILE -- Easy reference for how many grid squares are visible in each axis
    _G.screenTilesY=_G.height*PIXEL_TO_TILE
    love.window.setMode(_G.width, _G.height)
    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    -- Map Setup
    sti = require 'lib/sti'
    _G.map = sti('tilemap.lua')
    -- Player Setup
    player.load()
    -- Gamemaster setup
    GM.initialize(true,16,16,_G.map,player)
    -- Entity Setup
    goblin = monster:new{name="goblin",y=1,x=5,sprite_path="/res/darkelf1.png"}
    GM.addEntity(goblin)
    GM.initCollisionMatrix()
end

function love.update(dt)
    -- game logic here
end


function getFogIntensity(x,y)
    local dx = (x - (player.x+GM.offsetX)*TILE_TO_PIXEL) / scale
    local dy = (y - (player.y+GM.offsetY)*TILE_TO_PIXEL) / scale
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

function drawEntity(entity, isPlayer)
    local screenX = (entity.x + GM.offsetX) * TILE_TO_PIXEL
    local screenY = (entity.y + GM.offsetY) * TILE_TO_PIXEL

    if screenX >= 0 and screenX < love.graphics.getWidth() and screenY >= 0 and screenY < love.graphics.getHeight() then
        local sprite = isPlayer and entity.image or entity.sprite
        love.graphics.draw(sprite, screenX, screenY, 0, scale, scale)
    end
end

 
function love.draw()
    -- game rendering here
    _G.map:draw(GM.offsetX*TILE_SIZE,GM.offsetY*TILE_SIZE,scale,scale)
    for _, entity in pairs(GM.entityManager.world) do
        drawEntity(entity, false)
    end
    drawFog()
    --love.graphics.draw(player.image,player.x*TILE_TO_PIXEL, player.y*TILE_TO_PIXEL, 0, scale, scale)
    drawEntity(player,true)
end

function love.keypressed(key)
    -- handle input
    print("--------------------------------------")
    local targetX, targetY = player:keypressed(key) -- screen coords
    if GM.canMove(targetX, targetY) then
        player:move()

        local newScreenX = (player.x + GM.offsetX) * TILE_TO_PIXEL
        local newScreenY = (player.y + GM.offsetY) * TILE_TO_PIXEL
        
        local scrollX, scrollY = 0, 0
        
        if newScreenX < TILE_TO_PIXEL then
            scrollX = 1
        elseif newScreenX > _G.width - 2 * TILE_TO_PIXEL then
            scrollX = -1
        end
        
        if newScreenY < TILE_TO_PIXEL then
            scrollY = 1
        elseif newScreenY > _G.height - 2 * TILE_TO_PIXEL then
            scrollY = -1
        end
        
        if scrollX ~= 0 or scrollY ~= 0 then
            GM.updateOffset(scrollX, scrollY)
        end
    end

    print("Player COORDS", player.x, player.y)
    local monster_pos = {x=goblin.x, y=goblin.y}
    local player_pos = {x=player.x, y=player.y}
    --print(GM.heuristic(monster_pos,player_pos))
    local next_move = GM.nextMove(monster_pos, player_pos)
    print("NEXT MOVE?!", next_move.x, next_move.y)
    GM.moveEntity(goblin, next_move.x, next_move.y)
end
