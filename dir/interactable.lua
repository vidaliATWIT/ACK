-- Interact with: Monsters, NPCs, Chests, Doors, etc...
local Interactable = {}
Interactable.__index = Interactable

function Interactable:new(o)
    o = o or {}
    setmetatable(o, self)
    
    return o
end

function Interactable:interact()
    error("Subclass must implement interact method")
end
