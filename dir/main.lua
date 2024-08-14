local player = require("player")
local conf = require("util.conf")
local monster = require("entity.monster")
local GM = require("managers.GameMaster")
local scale = conf.scale_factor
local TILE_SIZE = 16
local PIXEL_TO_TILE = 1 / scale / TILE_SIZE
local TILE_TO_PIXEL = TILE_SIZE * scale
local UI = require("UI")
local readyToQuit = false
local gameStarted = false
local debug=true


function love.load()
    -- Screen Setup
    _G.width = 1024
    _G.height = 768
    love.window.setMode(_G.width, _G.height)
    love.graphics.setDefaultFilter("nearest", "nearest", 1)

    -- Map Setup
    sti = require 'lib/sti'

    if debug then
        resetGame()
    else    
        UI:initialize()
        UI:showMainMenu()
    end
end

function love.update(dt)
    -- game logic here
    if gameStarted then
        handleScrolling()
        UI:updateHp(player.hp)
        if not player.isAlive() then
            UI:showGameOver()
            GM.GameState.set("GAMEOVER")
        end
    end
end

-- Game Reset
function resetGame()
        _G.offsetX = 0
        _G.offsetY = 0
        _G.screenTilesX=_G.width*PIXEL_TO_TILE -- Easy reference for how many grid squares are visible in each axis
        _G.screenTilesY=_G.height*PIXEL_TO_TILE
        gameStarted=true
        -- UI RESET
        UI:initialize()

        _G.map = sti('tilemap2.lua')
        -- Player Setup
        player.load()
        player:init({x=1,y=5})
        -- Gamemaster setup
        GM.initialize(true,32,32,_G.map,player)
        GM.GameState.set("EXPLORING")
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
    if gameStarted and GM.GameState.get()~="GAMEOVER" then
        local startX = -GM.offsetX
        local startY = -GM.offsetY
        local endX = math.ceil((startX + _G.width*PIXEL_TO_TILE))
        local endY = math.ceil((startY + _G.height*PIXEL_TO_TILE))
        visibleEntities = GM.entityManager:getEntitiesInRange(startX, startY, endX, endY)

        _G.map:draw(GM.offsetX*TILE_SIZE,GM.offsetY*TILE_SIZE,scale,scale)
        for _, entity in pairs(visibleEntities) do
            drawEntity(entity, false)
        end
        drawFog()
        --love.graphics.draw(player.image,player.x*TILE_TO_PIXEL, player.y*TILE_TO_PIXEL, 0, scale, scale)
        drawEntity(player,true)
    end
    UI:draw()
end

function love.keypressed(key)
    -- handle input
    --print(GM.turn)
    if not gameStarted then
        handleMainMenuInput(key)
    elseif GM.GameState.get()=="DIALOG" then
        handleDialogInput(key)
    elseif GM.GameState.get()=="EXPLORING" then
        handleExplorationInput(key)
    elseif GM.GameState.get()=="INVENTORY" then
        handleInventoryInput(key)
    elseif GM.GameState.get()=="GAMEOVER" then
        handleGameOverInput(key)
    elseif GM.GameState.get()=="CHARSHEET" then
        handleCharsheetInput(key)
    end
end

function handleMainMenuInput(key)
    if key=='s' or key=='enter' then
        resetGame()
    elseif key=='q' or key=='escape' then
        handleQuit()
    end
end

function handleGameOverInput(key)
    if key=='y' or key=='enter' then
        resetGame()
    elseif key=='n' or key=='escape' then
        handleQuit()
    end
end

function handleDialogInput(key)
    local choice = tonumber(key)
    if choice and choice <= #GM.UI.dialogOptions then
        GM.handleDialogChoice(choice)
    elseif key == "escape" then
        --GM.DialogManager:endDialog()
        --GM.UI:hideDialog()
    end
end

function handleExplorationInput(key)
    print("--------------------------------------")
    if key=='i' then
        GM.GameState.set("INVENTORY")
        UI:showInventory(player:getInventory())
    elseif key=='r' then
        resetGame()
    elseif key=='k' then
        player:takeDamage(666)
    elseif key=='c' then
        GM.GameState.set("CHARSHEET")
        UI:showCharsheet(player:getStats())
    end

    local targetX, targetY = player:keypressed(key) -- screen coords

    if GM.canMove(targetX, targetY) then
        player:move()
    end
    GM.nextTurn()
end

function handleInventoryInput(key)
    if key == "escape" or key=="i" or key=="q" then
        GM.UI:hideInventory()
        GM.GameState.set("EXPLORING")
    elseif tonumber(key) then
        local choice = tonumber(key)
        print(choice)
        message = player:useItem(choice)
        UI:addCombatMessage(message)
        GM.UI:hideInventory()
        GM.GameState.set("EXPLORING")
    end
end

function handleCharsheetInput(key)
    if key=="escape" or key=="c" or key=="q" then
        UI:hideCharsheet()
        GM.GameState.set("EXPLORING")
    end
end

function handleScrolling()
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

function handleQuit()
    love.event.quit("quit")
end

function love.quit()
    if readyToQuit then
        -- ALT: 
        print("'ACK!'\nANOTHER DREG HANGS LIMP FROM THE JAWS OF COWARDICE!")
        return false
    end
end
   

