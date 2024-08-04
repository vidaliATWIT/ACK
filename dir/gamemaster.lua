local EntityManager = require("EntityManager")
local conf = require("conf")
local GameMaster = {}
local Node = require("Node") -- Used for A*
local PriorityQueue = require("PriorityQueue")

function GameMaster.new(useHashTable, worldWidth, worldHeight, player)
    local entityManager = EntityManager.new(useHashTable,worldWidth,worldHeight)
    self.turn=0 -- Handles turns
    self.round=0
end

-- Called by move
function GameMaster:nextRound()
    if self.turn%6==0 then
        self.round = self.round+1
        -- Handle effects for next round e.g. usage dice, random encounters
    end

-- Called by move
function GameMaster:nextTurn()
    self.turn=self.turn+1
    -- Handle effects for next round
end

-- Manhattan Heuristic for A*
function GameMaster:heuristic(pos1, pos2)
    local dx = math.abs(pos1.x - pos2.x)
    local dy = math.abs(pos1.y - pos1.y)
    return dx + dy
end

-- Is called by monsters and npcs during attack phase 
function GameMaster:findPath(start_pos, end_pos)
    -- Imlement A*
    local open_set = PriorityQueue:new("max")
    local closed_set = {}
    -- Create start and end node
    start_node = Node:new{parent=nil, position=start_pos}
    start_node.g = start_node.h = start_node.f = 0
    end_node = Node:new{parent=nil, position=end_pos}
    end_node.g = end_node.h = end_node.f = 0
    -- add start_node to open_set
    open_set.insert(start_node)
    -- add stop condition
    outer_iterations = 0


end

