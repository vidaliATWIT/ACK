--Look into sysl-text later, it probably handles this stuff a lot better.

local function genericGreeting(npcName)
    return function(player)
        if player:hasMetNPC(npcName) then
            return "greetingKnown"
        else
            player:meetNPC(npcName)
            return "greetingNew"
        end
    end
end

local function genericQuestStatus(questName)
    return function(player)
        local status = player:getQuestStatus(questName)
        if status == "completed" then
            return "questCompleted"
        elseif status == "in_progress" then
            return "questInProgress"
        else
            return "questIntro"
        end
    end
end

local function simpleDialog(text)
    return {
        text = text,
        options = {
            {text="Goodbye.", next="exit"}
        }
    }
end

local DialogTrees = {
    Aimee = {
        greeting = function(player)
            if player:hasMetNPC("Aimee") then
                return player:getQuestStatus("AimeeEncounter")=="encouraged" and "greetingEncouraged" or "greetingNew"
            else
                player:meetNPC("Aimee")
                return "greetingNew"
            end
        end,
        greetingNew = {
            text = "Hello. I am unimportant in this world",
            options = {
                {text = "Astute observation. Goodbye now.", next="exit"},
                {text = "Don't say that! You're important to me.", next="gratitude"}
            }
        },
        greetingEncouraged = {
            text = "Oh, hello again! It's nice to see you.",
            options = {
                {text = "Likewise. Goodbye!", next = "exit"},
                {text = "How are you feeling?", next = "healthy"}
            }
        },
        gratitude = {
            text = "Thank you...",
            options = {
                {text = "You're welcome. Bye.", next="exit"}
            },
            effect = function(player)
                player:updateQuestStatus("AimeeEncounter", "encouraged")
            end
        },
        healthy = {
            text="Yes, I'm doing much better now. Thanks!",
            options = {
                {text = "Great! Bye now!", next="exit"}
            }
        },
        exit = {
            text = "Bye-bye!",
            options = {} -- No options means end of conversation
        }
    },
    Lea = {
        greeting = genericGreeting("Lea"),
        greetingNew = {
            text = "Hello stranger. I can teach you, but I have to charge.",
            options = {
                {text = "Teach me something new!", next="teach_options"},
                {text = "Uhh, no thanks. Bye.", next="exit"}
            }
        },
        greetingKnown = {
            text = "Hello again. I can teach you, but I have to charge.",
            options = {
                {text = "Teach me something new!", 
                next=function(player)
                    print("PLAYER FORCE: ", player.force)
                    if player.force>16 then
                        return "too_strong"
                    else
                        return "teach_options"
                    end
                end},
                {text = "Uhh, no thanks. Bye.", next="exit"}
            }
        },
        teach_options = {
            text = "I can teach you how to swing your sword harder. Do you accept?",
            options = {
                {text = "Yes, teach me this.", next="combat_training"},
                {text = "I'm too tired today maybe tomorrow. Bye.", next="exit"}
            }
        },
        combat_training = {
            text = "Good. You've got to feel the sword with your whole body and soul...",
            options = {
                {text = "I see... teach me more...", next = "exit"}
            },
            effect = function(player)
                player.force=player.force+1
                print(player.name,  " got better at swinging his sword... ", player.force)
            end
        },
        too_strong = {
            text = "I have already taught you all I know.",
            options = {
                {text = "I see. Goodbye.", next="exit"}
            }
        },
        exit = {
            text = "Goodbye now stranger.",
            options = {}
        }
    }
}

return DialogTrees