--Look into sysl-text later, it probably handles this stuff a lot better.

local UI = require("UI")

local trainingCost = {[10]=100,[11]=150,[12]=250,[13]=500,[14]=1000,[15]=2000,[16]=3500}

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

-- Return cost of training
local function getTrainingCost(player_skill)
    return trainingCost[player_skill]
end

local function handleTraining(player, statname, cost)
    player:removeGold(cost)
    player[statname]=player[statname]+1
    message = player.name ..  " increased their " .. statname .. " by 1 point (" .. player[statname] .. ")"
    UI:addCombatMessage(message)
end


local DialogTrees = {
    Priest = {
        greeting = function(player)
            if player:getQuestStatus("mainQuest")=="complete" or player:getQuestStatus("mainQuest")=="secretEnding" or player:getQuestStatus("mainQuest")=="badEnd" then
                return "questComplete"
            else
                if player:hasMetNPC("Priest") then
                    return "greetingKnown"
                else
                    player:meetNPC("Priest")
                    return "greetingNew"
                end
            end
        end,
        questComplete = {
            text="You have acquired the Skeleton Key! With it I can finally escape this foul realm of artifice.",
            options = {
                {text="What? What do you mean?", 
                    next=function(player)
                        if player:getQuestStatus("mainQuest")=="complete" or player:getQuestStatus("mainQuest")=="badEnd" then
                            return "badEnd"
                        elseif player:getQuestStatus("mainQuest")=="secretEnding" then
                            return "goodEnd"
                        end
                    end
                    },
            }
        },
        badEnd = {
            text="Worry not thineself with matters outside of your purview. Sleep now wanderer...",
            options = {
                {text="I... I am so tired...", next="exit"},
            },
            effect = function(player)
                player:takeDamage(666)
            end,
        },
        goodEnd = {
            text="Worry not thineself with matters outside of your purview. Now hand over the key...",
            options = {
                {text="As you wish...", next="goodEnd2"},
            },
        },
        goodEnd2 = {
            text="What? What is happening? What have you done?",
            options = {
                {text="...", next="exit"}
            },
            effect = function(player)
                player.won=true
            end
        },
        greetingNew = {
            text = "Hello stranger. If you intend to explore the dungeons in town, I may offer some advice.",
            options = {
                {text = "Certainly, what would you suggest?", next="advice"},
                {text = "I think not, goodbye.", next="exit"}
            }
        },
        greetingKnown = {
            text = "Hello again. Back for some advice?",
            options = {
                {text = "Alright, let's hear it.", next="advice"},
                {text = "I think not, goodbye.", next="exit"}
            }
        },
        advice = {
            text = "What would you like to know?",
            options = {
                {text = "Where can I find equipment?", next="gear"},
                {text = "How do I open the doors to the dungeons?", next="doors"},
                {text = "What kind of enemies will I face?", next="monsters"},
                {text = "How do I improve my skills?", next="skills"},
                {text = "Where are the dungeons?", next="dungeons"},
                {text = "What will I find at the bottom of the final dungeon?", next="goal"},
                {text = "I don't have any more questions. Goodbye.", next="exit"},
            }
        },
        gear = {
            text = "Chests contain all sorts of useful equipment. The one in the corner here should get you started for now.",
            options = {
                {text = "Thanks. Can I ask you something else?", next="advice"},
                {text = "Understood. Goodbye now.", next="exit"},
            }
        },
        doors = {
            text = "You will need keys of the matching color. The first key you'll find in town. The rest will be in the dungeons.",
            options = {
                {text = "Thanks. Can I ask you something else?", next="advice"},
                {text = "Understood. Goodbye now.", next="exit"},
            }
        },
        monsters = {
            text = "Foul monsters, some undead, others of the goblish races. Be cautious.",
            options = {
                {text = "Thanks. Can I ask you something else?", next="advice"},
                {text = "Understood. Goodbye now.", next="exit"},
            }
        },
        skills = {
            text = "There are three trainers in town who will train your skills, for a cost.",
            options = {
                {text = "Can I ask you something else?", next="advice"},
                {text = "Understood. Goodbye now.", next="exit"},
            }
        },
        dungeons = {
            text = "There are three dungeons on the east side of town, each more treacherous than the last.",
            options = {
                {text = "Can I ask you something else?", next="advice"},
                {text = "Understood. Goodbye now.", next="exit"},
            }
        },
        goal = {
            text = "The skeleton key, guarded by a Knight. If you find it, bring it here.",
            options = {
                {text = "Can I ask you something else?", next="advice"},
                {text = "Understood. Goodbye now.", next="exit"},
            }
        },
        exit = {
            text = "Goodbye now stranger.",
            options = {}
        }
    },
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
            text = "Hello stranger. I can train your FORCE, but it will cost you.",
            options = {
                {text = "Teach me something new!", next="teach_options"},
                {text = "Uhh, no thanks. Bye.", next="exit"}
            }
        },
        greetingKnown = {
            text = "Hello again. I can train your FORCE, but it will cost you.",
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
            text = function(player)
                    return string.format("The training will cost %d gold. Do you accept?", getTrainingCost(player.force))
            end,
            options = {
                {text = "Yes, teach me this.", 
                next=function(player)
                    local gold = player.inventory.gold
                    print("Player cash: ", gold)
                    if (gold<getTrainingCost(player.force)) then
                        print("We're too poor...")
                        return "too_poor"
                    else
                        return "combat_training"
                    end
                end},
                {text = "I'm too tired today maybe tomorrow. Bye.", next="exit"}
            }
        },
        combat_training = {
            text = "Good. You've got to feel the sword with your whole body and soul...",
            options = {
                {text = "I see... teach me more...", next = "exit"}
            },
            effect = function(player)
                handleTraining(player, "force", getTrainingCost(player.force))
            end
        },
        too_strong = {
            text = "I have already taught you all I know.",
            options = {
                {text = "I see. Goodbye.", next="exit"}
            }
        },
        too_poor = {
            text = function(player) return string.format("You need %s gold to pay for this training...", getTrainingCost(player.force)) end,
            options = {
                {text = "I see. Goodbye.", next="exit"}
            }
        },
        exit = {
            text = "Goodbye now stranger.",
            options = {}
        }
    },
    Mona = {
        greeting = genericGreeting("Mona"),
        greetingNew = {
            text = "Hello stranger. I can teach you FINESSE, but I have to charge.",
            options = {
                {text = "Teach me something new!", next="teach_options"},
                {text = "Uhh, no thanks. Bye.", next="exit"}
            }
        },
        greetingKnown = {
            text = "Hello again. I can teach you FINESSE, but I have to charge.",
            options = {
                {text = "Teach me something new!", 
                next=function(player)
                    print("PLAYER FINESSE: ", player.finesse)
                    if player.finesse>16 then
                        return "too_strong"
                    else
                        return "teach_options"
                    end
                end},
                {text = "Uhh, no thanks. Bye.", next="exit"}
            }
        },
        teach_options = {
            text = function(player)
                    return string.format("The training will cost %d gold. Do you accept?", getTrainingCost(player.finesse))
            end,
            options = {
                {text = "Yes, teach me this.", 
                next=function(player)
                    local gold = player.inventory.gold
                    print("Player cash: ", gold)
                    if (gold<getTrainingCost(player.finesse)) then
                        print("We're too poor...")
                        return "too_poor"
                    else
                        return "combat_training"
                    end
                end},
                {text = "I'm too tired today maybe tomorrow. Bye.", next="exit"}
            }
        },
        combat_training = {
            text = "Good. First up some jumping jacks to warm up...",
            options = {
                {text = "I see... teach me more...", next = "exit"}
            },
            effect = function(player)
                handleTraining(player, "finesse", getTrainingCost(player.finesse))
                --player:removeGold(getTrainingCost(player.finesse))
                --player.finesse=player.finesse+1
                --print(player.name,  " improved his finesse... ", player.finesse)
            end
        },
        too_strong = {
            text = "I have already taught you all I know.",
            options = {
                {text = "I see. Goodbye.", next="exit"}
            }
        },
        too_poor = {
            text = function(player) return string.format("You need %s gold to pay for this training...", getTrainingCost(player.finesse)) end,
            options = {
                {text = "I see. Goodbye.", next="exit"}
            }
        },
        exit = {
            text = "Goodbye now stranger.",
            options = {}
        }
    },
    Ania = {
        greeting = genericGreeting("Ania"),
        greetingNew = {
            text = "Hello stranger. I can train your HARDINESS, but I have to charge.",
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
                    print("PLAYER FORCE: ", player.hardiness)
                    if player.hardiness>16 then
                        return "too_strong"
                    else
                        return "teach_options"
                    end
                end},
                {text = "Uhh, no thanks. Bye.", next="exit"}
            }
        },
        teach_options = {
            text = function(player)
                    return string.format("The training will cost %d gold. Do you accept?", getTrainingCost(player.hardiness))
            end,
            options = {
                {text = "Yes, teach me this.", 
                next=function(player)
                    local gold = player.inventory.gold
                    print("Player cash: ", gold)
                    if (gold<getTrainingCost(player.hardiness)) then
                        print("We're too poor...")
                        return "too_poor"
                    else
                        return "combat_training"
                    end
                end},
                {text = "I'm too tired today maybe tomorrow. Bye.", next="exit"}
            }
        },
        combat_training = {
            text = "Good. You've got to learn to take things in stride...",
            options = {
                {text = "I see... teach me more...", next = "exit"}
            },
            effect = function(player)
                handleTraining(player, "hardiness", getTrainingCost(player.hardiness))
                --player:removeGold(getTrainingCost(player.hardiness))
                --player.hardiness=player.hardiness+1
                player:setMaxHPFromHardiness()
                player.hp = player.max_hp
                --print(player.name,  " improved his HARDINESS... ", player.hardiness)
            end
        },
        too_strong = {
            text = "I have already taught you all I know.",
            options = {
                {text = "I see. Goodbye.", next="exit"}
            }
        },
        too_poor = {
            text = function(player) return string.format("You need %s gold to pay for this training...", getTrainingCost(player.hardiness)) end,
            options = {
                {text = "I see. Goodbye.", next="exit"}
            }
        },
        exit = {
            text = "Goodbye now stranger.",
            options = {}
        }
    },
    Agnis = {
        greeting = function(player)
            if player:getQuestStatus("mainQuest")=="complete" then
                return "questComplete"
            elseif player:getQuestStatus("mainQuest")=="secretEnding" or player:getQuestStatus("mainQuest")=="badEnd" then
                return "noDelay"
            else
                if player:hasMetNPC("Agnis") then
                    return "greetingKnown"
                else
                    player:meetNPC("Agnis")
                    return "greetingNew"
                end
            end
        end,
        questComplete = {
            text="Hark, traveler! You have done well to seek me out...",
            options = {
                {text="What? Who are you?", next="expo1"},
            }
        },
        expo1 = {
            text="I am the true Lorde of this realm. The one above is but a hideous replica.",
            options = {
                {text="Impossible! What is the meaning of this?", next="expo2"},
            }
        },
        expo2 = {
            text="'He' sought to free himself from the constraints of the physical with the skeleton key.",
            options = {
                {text="...", next="expo3"},
            }
        },
        expo3 = {
            text="However, I can cast a curse on it, so that his plan fails, and you survive.",
            options = {
                {text="How do I know I can trust you?", next="expo4"},
            }
        },
        expo4 = {
            text="You cannot. It is my word against 'his'. What is your decision?",
            options = {
                {text="I believe you. Cast your curse.", next="accursedOne"},
                {text="I shall not do it. You are the impostor.", next="soBeIt"},
            },
        },
        accursedOne = {
            text="You have chosen life on this day, stranger...",
            options = {
                {text="Thank you. I shall be off now.", next="exit"}
            },
            effect = function(player) 
                player:updateQuestStatus("mainQuest", "secretEnding")
                UI:addCombatMessage("The Skeleton Key has been hexed...")
            end,
        },
        soBeIt = {
            text="So be it. Leave now, your 'prize' awaits you...",
            options = {
                {text="Goodbye now", next="exit"}
            },
            effect = function(player) 
                player:updateQuestStatus("mainQuest", "badEnd")
            end,
        },
        noDelay = {
            text = "Hurry now stranger... The 'priest' is waiting...",
            options = {
                {text = "Right. Goodbye.", next="exit"}
            }
        },
        greetingNew = {
            text = "Hello stranger. Return to me once you've found the skeleton key...",
            options = {
                {text = "Goodbye.", next="exit"}
            }
        },
        greetingKnown = {
            text = "Hello again. Return to me once you've found the skeleton key...",
            options = {
                {text = "Goodbye.", next="exit"}
            }
        },
        exit = {
            text = "Goodbye now stranger.",
            options = {}
        },
    },
}

return DialogTrees