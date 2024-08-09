local dialogTrees = require("dialog.DialogTrees")
local player = require("player")

local DialogManager = {
    currentNPC=nil,
    currentDialog=nil,
}

function DialogManager:startDialog(npc)
    self.currentNPC=npc
    self.currentDialog = dialogTrees[npc.name].greeting
end

function DialogManager:getCurrentText()
    return self.currentDialog.text
end

function DialogManager:getOptions()
    return self.currentDialog.options
end

function DialogManager:choose(optionIndex)
    local nextDialog = self.currentDialog.options[optionIndex].next
    self.currentDialog = dialogTrees[self.currentNPC.name][nextDialog]

    if self.currentDialog.effect then
        self.currentDialog.effect(player)
    end
    return #self.currentDialog.options > 0 -- return false if conversation is over
end

function DialogManager:endDialog()
    self.currentNPC=nil
    self.currentDialog=nil
end

return DialogManager