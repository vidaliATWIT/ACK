local dialogTrees = require("dialog.DialogTrees")
local player = require("player")

local DialogManager = {
    currentNPC=nil,
    currentDialog=nil,
}

function DialogManager:startDialog(npc)
    self.currentNPC=npc
    self.currentDialog = self:resolveDialog(dialogTrees[npc.name].greeting, npc)
end

function DialogManager:getCurrentText()
    return self.currentDialog.text
end

function DialogManager:getOptions()
    return self.currentDialog.options
end

function DialogManager:resolveDialog(dialog, npc)
    while type(dialog) == "function" do
        dialog = dialog(player)
        dialog = dialogTrees[npc.name][dialog]
    end
    return dialog
end

function DialogManager:choose(optionIndex)
    local nextDialog = self.currentDialog.options[optionIndex].next
    if self.currentDialog.effect then
        self.currentDialog.effect(player)
    end

    if type(nextDialog) == "function" then
        nextDialog = nextDialog(player)
    end

    self.currentDialog = self:resolveDialog(dialogTrees[self.currentNPC.name][nextDialog])

    return #self.currentDialog.options > 0 -- return false if conversation is over
end

function DialogManager:endDialog()
    self.currentNPC=nil
    self.currentDialog=nil
end

return DialogManager