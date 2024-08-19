local SoundManager = {}

local sounds = {}

function SoundManager:load()
    print("LOADED SOUNDS")
    sounds.walkFlag = false
    sounds.hitFlag = false
    sounds.playerAttackFlag = false
    -- HIT
    sounds.playerAttack1 = love.audio.newSource("/res/sfx/HIT1.wav", "static")
    sounds.playerAttack2 = love.audio.newSource("/res/sfx/HIT2.wav", "static")
    --sounds.playerMiss1 = love.audio.newSource("/res/sfx/NOPE.wav", "static")
    -- WALK
    sounds.walk1 = love.audio.newSource("/res/sfx/WALK1.wav", "static")
    sounds.walk2 = love.audio.newSource("/res/sfx/WALK2.wav", "static")
    -- OPEN
    sounds.open1 = love.audio.newSource("/res/sfx/DOOR1.wav", "static")
    sounds.unlock1 = love.audio.newSource("/res/sfx/UNLOCK1.wav", "static")
    -- DEATH
    sounds.death1 = love.audio.newSource("/res/sfx/DEATH1.wav", "static")
    sounds.death2 = love.audio.newSource("/res/sfx/DEATH2.wav", "static")
    -- LADDER
    sounds.down1 = love.audio.newSource("/res/sfx/DOWN3.wav", "static")
    -- TALK
    sounds.talk1 = love.audio.newSource("/res/sfx/TALK1.wav", "static")
end

function SoundManager:playDescend()
    self:play("down1")
end

function SoundManager:playTalk()
    self:play("talk1")
end

function SoundManager:playMiss()
    self:play("playerMiss1")
end

function SoundManager:playHit()
    if self.hitFlag then
        self.hitFlag=false
        self:play("playerAttack1")
    else
        self.hitFlag=true
        self:play("playerAttack2")
    end
end

function SoundManager:playWalk()
    print("WALK")
    if self.walkFlag then
        self.walkFlag=false
        self:play("walk1")
    else
        self.walkFlag=true
        self:play("walk2")
    end
end

function SoundManager:playOpen()
    self:play("open1")
end

function SoundManager:playUnlock()
    self:play("unlock1")
end

function SoundManager:playDeath()
    self:play("death1")
end

function SoundManager:play(soundName)
    if sounds[soundName] then
        sounds[soundName]:play()
    else
        print("Sound not found: " .. soundName)
    end
end

return SoundManager