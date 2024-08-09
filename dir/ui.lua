local UI = {}

UI.combatLog={}
UI.dialogLine=""
UI.dialogChoices=""

function UI:addCombatMessage(message)
    table.insert(self.combatLog,message)
    if #self.combatLog>5 then -- Keep only last 4 messeages
        table.remove(self.combatLog,1) -- 1 indexing (T-T)b
    end
end

function UI:setDialogLine(line)
    self.dialogLine=line
end

function UI:draw()
    love.graphics.setColor(love.math.colorFromBytes(37,190,26)) --Our green color

    for i, message in ipairs(self.combatLog) do
        love.graphics.print(message,10,10+(i-1)*20)
    end

    love.graphics.printf(self.dialogLine, 10, love.graphics.getHeight() - 50, love.graphics.getWidth() - 20, "left")
    love.graphics.setColor(1,1,1) -- reset colors lol
end

return UI