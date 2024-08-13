local UI = {
    dialogText = "",
    dialogOptions = {},
    combatLog = {},
    inventoryTable={},
}

function UI:initialize()
    self.dialogText=""
    self.dialogOptions={}
    self.combatLog={}
    self.inventoryTable={}
    self.state=""
    self.menuFont = love.graphics.newFont(24)
    self.infoFont = love.graphics.newFont(12)
end

function UI:addCombatMessage(message)
    table.insert(self.combatLog,message)
    if #self.combatLog>5 then -- Keep only last 4 messeages
        table.remove(self.combatLog,1) -- 1 indexing (T-T)b
    end
end

function UI:showDialog(text, options)
    love.graphics.setFont(self.infoFont)
    self.dialogText = text
    self.dialogOptions = options
    self.state="dialog"
end

function UI:hideDialog()
    self.state=""
    self.dialogText=""
    self.dialogOptions={}
end

function UI:showInventory(inventoryTable)
    love.graphics.setFont(self.infoFont)
    self.inventoryTable=inventoryTable
    self.state="inventory"
end

function UI:hideInventory()
    self.isShowingInventory=false
    self.state=""
    self.inventoryTable={}
end

function UI:showMainMenu()
    self.state="mainmenu"
end

function UI:hideUI()
    self.state=""
end

function UI:showGameOver()
    self.state="gameover"
end


function UI:drawGameOver()
    local height = love.graphics.getHeight()
    local width = love.graphics.getWidth()
    love.graphics.setFont(self.menuFont)
    love.graphics.printf("DEATH COMES. PERSIST IN YOUR DELUSIONS?", 0, height/4, width, "center")
    love.graphics.printf("Y)es",0,height/3, width, "center")
    love.graphics.printf("N)o",0,height/2, width, "center")
end

function UI:drawMainMenu()
    local height = love.graphics.getHeight()
    local width = love.graphics.getWidth()
    love.graphics.setFont(self.menuFont)
    love.graphics.printf("ACK!", 0, height/4, width, "center")
    love.graphics.printf("S)tart",0,height/3, width, "center")
    love.graphics.printf("Q)uit",0,height/2, width, "center")
end

function UI:draw()
    love.graphics.setColor(love.math.colorFromBytes(37,190,26)) --Our green color
    -- dialog
    if self.state=="mainmenu" then
        self:drawMainMenu()
    elseif self.state=="gameover" then
        self:drawGameOver()
    elseif self.state=="dialog" then
        love.graphics.printf(self.dialogText, 10, love.graphics.getHeight() - 100, love.graphics.getWidth() - 20, "left")

        for i, option in ipairs(self.dialogOptions) do
            love.graphics.printf(i .. ". " .. option.text, 10, love.graphics.getHeight() - 70 + (i-1)*20, love.graphics.getWidth() - 20, "left")
        end
    elseif self.state=="inventory" then -- Inventory
        self:drawInventory()
    else -- combat log
        love.graphics.setFont(self.infoFont)
        for i, message in ipairs(self.combatLog) do
            love.graphics.print(message,10,10+(i-1)*20)
        end
    end

    --love.graphics.printf(self.dialogText, 10, love.graphics.getHeight() - 50, love.graphics.getWidth() - 20, "left")
    love.graphics.setColor(1,1,1) -- reset colors lol
end

function UI:drawInventory()
    love.graphics.print("INVENTORY",10,10)
    local usableItems = {}
    local otherItems = {}
    for i, item in ipairs(self.inventoryTable) do
        if item:match("^%d+%)") then
            table.insert(usableItems,item)
        else
            table.insert(otherItems,item)
        end
    end
    local separatorY = 30
    love.graphics.line(10, separatorY, 200, separatorY)

    for i, item in ipairs(usableItems) do
        love.graphics.print(item, 10, 40 + (i-1)*20)
    end
    separatorY = 40 + #usableItems * 20
    if (#usableItems~=0) then
        love.graphics.line(10, separatorY, 200, separatorY)  -- Adjust width as needed
    end
    
    for i, info in ipairs(otherItems) do
        love.graphics.print(info, 10, separatorY + 10 + (i-1)*20)
    end
end

return UI