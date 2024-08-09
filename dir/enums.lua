local Enums = {}

Enums.EntityState = {
    IDLE="IDLE",
    AWARE="AWARE",
    ATTACK="ATTACK",
    ATTEND="ATTENDING", --NPC ONLY
    TRAINING="TRAINING", --NPC ONLY
    QUESTOFFERED="QUESTOFFERED", --NPC ONLY
}

Enums.EntityType = {
    MONSTER="MONSTER",
    NPC="NPC",
}

Enums.MonsterType = {
    GOBLIN="GOBLIN",
    DARK_ELF="DARK_ELF",
    ORC="ORC",
    CRAWLER="CRAWLER",
}

return Enums