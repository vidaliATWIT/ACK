Dice = {}

function Dice.roll(sides)
    return math.random(1,sides)
end

function Dice.rollMultiple(number, sides)
    local total = 0
    for i = 1, number do
        total=total+Dice.roll(sides)
    end
    return total
end

function Dice.rollUnder(stat)
    return Dice.roll(20)<=stat
end

function Dice.getBonus(stat)
    return
end

return Dice