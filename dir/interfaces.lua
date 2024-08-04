local Interfaces = {}

-- Interact with: Monsters, NPCs, Chests, Doors, etc...
Interfaces.Interactable={
    interact = function() end
}

-- Use: Potions, Torches, Scrolls, etc...
Interfaces.Usable={
    use = function() end
}

return Interfaces