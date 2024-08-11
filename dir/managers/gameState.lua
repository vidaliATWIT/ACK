local GameState = {
    EXPLORING="EXPLORING",
    DIALOG="DIALOG",
    INVENTORY="INVENTORY",
    current="EXPLORING"
}

function GameState.set(newState)
    GameState.current=newState
end

function GameState.get()
    return GameState.current
end

return GameState