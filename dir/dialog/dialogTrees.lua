--Look into sysl-text later, it probably handles this stuff a lot better.

local DialogTrees = {
    Aimee = {
        greeting={
            text="Hello. I am unimportant in this world.",
            options = {
                {text = "Of course not! You're special to me.", next="gratitude"},
                {text = "Astute observation. Goodbye now.", next="exit"}
            }
        },
        gratitude = {
            text = "*She looks at you with tears in her eyes* Thank you...",
            options = {
                {text = "You're welcome. Bye.", next="exit"}
            }
        },
        exit = {
            text = "Bye-bye!",
            options = {} -- No options means end of conversation
        }
    },
    Lea = {
        greeting = {
            text = "Hello stranger. I can teach you, but I have to charge.",
            options = {
                {text = "Teach me something new!", next="teach_options"},
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
                print(player.name,  " got better at swinging his sword...")
            end
        },
        exit = {
            text = "Goodbye now stranger.",
            options = {}
        }
    }
}

return DialogTrees