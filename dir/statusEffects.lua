STATUS_EFFECTS = {
    poisoned = {
        effect = function(entity)
            entity.hp = math.max(1, entity.hp - 1)
        end,
        onApply = function(entity)
            print("POISONED!")
        end,
        onRemove = function(entity)
            print("NO LONGER POISONED")
        end,
        statusString = "POISONED"
    },
    strengthened = {
        onApply = function(entity)
            entity.damage = entity.damage + 2
        end,
        onRemove = function(entity)
            entity.damage = entity.damage -2
        end,
        statusString = "STRENGTHENED"
    },
    agile = {
        onApply = function(entity)
            entity.finesse = entity.finesse + 2
        end,
        onRemove = function(entity)
            entity.finesse = entity.finesse -2
        end,
        statusString = "AGILE"
    },
}

return STATUS_EFFECTS