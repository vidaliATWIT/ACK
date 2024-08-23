local dialogTrees = require("dialog.dialogTrees")
local player = require("player")
local SoundManager = require("managers.soundManager")

local DialogManager = {
    currentNPC=nil,
    currentDialog=nil,
}

function DialogManager:startDialog(npc)
    self.currentNPC=npc
    self.currentDialog = self:resolveDialog(dialogTrees[npc.name].greeting, npc)
end

function DialogManager:getCurrentText()
    print(self.currentNPC, self.currentDialog)
    return self:resolveText(self.currentDialog.text,self.currentNPC)
end

function DialogManager:getOptions()
    return self.currentDialog.options
end

function DialogManager:resolveText(text,npc)
    print(text)
    while type(text) == "function" do
        text = text(player)
    end
    return text
end

function DialogManager:resolveDialog(dialog, npc)
    print("resolving")
    while type(dialog) == "function" do
        dialog = dialog(player)
        dialog = dialogTrees[npc.name][dialog]
    end
    print("dialog: ", dialog)
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

    SoundManager:playClick()

    self.currentDialog = self:resolveDialog(dialogTrees[self.currentNPC.name][nextDialog])

    return #self.currentDialog.options > 0 -- return false if conversation is over
end

function DialogManager:endDialog()
    self.currentNPC=nil
    self.currentDialog=nil
end

return DialogManager