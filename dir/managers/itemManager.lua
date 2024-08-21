ItemManager = {
    items = {
        healthPotion = {
            name="Health Potion",
            type="consumable",
            value=10,
            effect=function(player) player:heal(5) end
        },
        strengthPotion = {
            name="Strength Potion",
            type="consumable",
            value=20,
            effect=function(player) player:addStatus("strengthened", 10) end
        },
        speedPotion = {
            name="Speed Potion",
            type="consumable",
            value=20,
            effect=function(player) player:addStatus("agile", 10) end
        },
        ironSword = {
            name="Iron Sword",
            type="weapon",
            value=20,
            damage=6,
            equipped=""
        },
        steelSword = {
            name="Steel Sword",
            type="weapon",
            value=20,
            damage=8,
            equipped="",

        },
        silverSword = {
            name="Silver Sword",
            type="weapon",
            value=200,
            damage=12,
            equipped="",
            ability={type="BLESSED"}
        },
        poisonedDagger = {
            name="Poisoned Dagger",
            type="weapon",
            value=200,
            damage=4,
            equipped="",
            ability={type="POISONED",10}
        },
        leatherArmor = {
            name="Leather Armor",
            type="armor",
            value=40,
            defense=2,
            equipped=""
        },
        chainArmor = {
            name="Chain Armor",
            type="armor",
            value=40,
            defense=4,
            equipped=""
        },
        plateArmor = {
            name="Plate Armor",
            type="armor",
            value=90,
            defense=6,
            equipped=""
        },
        silverArmor = {
            name="Silver Armor",
            type="armor",
            value=300,
            defense=9,
            equipped=""
        },
        redKey = { name="Red Key", type="key", value=0, color="red" },
        blueKey = { name="Blue Key", type="key",value=0, color="blue"},
        greenKey = { name="Green Key", type="key",value=0, color="green"},
        goldKey = { name="Gold Key", type="key",value=0, color="gold"},
        skeletonKey = { name = "Skeleton Key", type="key", value=666, color="redbluegreenyellow"}
    }
}

-- Basic item definition, includes static use function for all
function ItemManager:defineItem(name, properties)
    self.items[name] = setmetatable(properties, {
        __index = {
            use = function(self,player)
                if self.type == "consumable" and self.effect then
                    self.effect(player)
                elseif self.type == "weapon" then
                    player:equipWeapon(self)
                elseif self.type == "armor" then
                    player:equipArmor(self)
                end
            end,
        }
    })
end

function ItemManager:getItem(name)
    return self.items[name]
end

return ItemManager
-- Base Item Definitions