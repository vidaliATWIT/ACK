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
    _G.map:draw(GM.offsetX*TILE_SIZE,GM.offsetY*TILE_SIZE,scale,scale)
    goblin:draw()
    drawFog()
    player:draw()
end

function love.keypressed(key)
    -- handle input
    local targetX, targetY = player:keypressed(key) -- screen coords
    if GM.canMove(targetX, targetY) then
        -- If scrolling scroll
        if targetX+(TILE_TO_PIXEL)>=_G.width then
            GM.updateOffset(-1,0)
        elseif targetX-(TILE_TO_PIXEL)<0 then
            GM.updateOffset(1,0)
        elseif targetY+(TILE_TO_PIXEL)>=_G.height then
            GM.updateOffset(0,-1)
        elseif targetY-(TILE_TO_PIXEL)<0 then
            GM.updateOffset(0,1)
        else -- else move player
            player:move()
        --end
        end
    end
end
