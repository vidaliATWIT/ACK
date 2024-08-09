local UI = {
    dialogText = "",
    dialogOptions = {},
    combatLog = {}
}

function UI:addCombatMessage(message)
    table.insert(self.combatLog,message)
    if #self.combatLog>5 then -- Keep only last 4 messeages
        table.remove(self.combatLog,1) -- 1 indexing (T-T)b
    end
end

function UI:showDialog(text, options)
    self.dialogText = text
    self.dialogOptions = options
    self.isShowingDialog=true
end

function UI:hideDialog()
    self.isShowingDialog=false
    self.dialogText=""
    self.dialogOptions={}
end

function UI:draw()
    love.graphics.setColor(love.math.colorFromBytes(37,190,26)) --Our green color

    -- dialog
    if self.isShowingDialog then
        love.graphics.printf(self.dialogText, 10, love.graphics.getHeight() - 100, love.graphics.getWidth() - 20, "left")

        for i, option in ipairs(self.dialogOptions) do
            love.graphics.printf(i .. ". " .. option.text, 10, love.graphics.getHeight() - 70 + (i-1)*20, love.graphics.getWidth() - 20, "left")
        end
    else -- combat log
        for i, message in ipairs(self.combatLog) do
            love.graphics.print(message,10,10+(i-1)*20)
        end
    end

    --love.graphics.printf(self.dialogText, 10, love.graphics.getHeight() - 50, love.graphics.getWidth() - 20, "left")
    love.graphics.setColor(1,1,1) -- reset colors lol
end

return UI