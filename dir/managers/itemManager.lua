ItemManager = {
    items = {
        healthPotion = {
            name="Health Potion",
            type="consumable",
            value=10,
            effect=function(player) player:heal(5) end
        },
        ironSword = {
            name="Iron Sword",
            type="weapon",
            value=20,
            damage=6,
            equipped=""
        },
        leatherArmor = {
            name="Leather Armor",
            type="armor",
            value=40,
            defense=2,
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