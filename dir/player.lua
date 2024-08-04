-- Define player table
local player = {}
local config = require("conf")
local GM = require("GameMaster")
local scale = config.scale_factor


function player:load()
    player.image = love.graphics.newImage("res/pc.png")
    player.x=1
    player.y=1
    player.targetX=player.x
    player.targetY=player.y
    player.moving=false
    player.speed=1
    player.torch_light=50
end

function player:keypressed(key)
    player.targetX=player.x
    player.targetY=player.y
    if key == "up" then
		player.targetY = player.y - player.speed
        player.moving=true
	elseif key == "down" then
		player.targetY = player.y + player.speed
        player.moving=true
	elseif key == "left" then
		player.targetX = player.x - player.speed
        player.moving=true
	elseif key == "right" then
		player.targetX = player.x + player.speed
        player.moving=true
    elseif key == "t" then
        if self.torch_light==50 then
            self.torch_light=100
        else
            self.torch_light=50
        end
    end
    return player.targetX,player.targetY
end

function player:move()
    -- called by gamemanager
    player.y=player.targetY
    player.x=player.targetX
end

function player:draw()
    love.graphics.draw(player.image,player.x, player.y, 0, scale, scale)
end

return player