AStar = {}

AStar.BanList = {}
AStar.MapSize = MapConfig.Size

local function IsSamePos(pos1, pos2)
    return pos1.x == pos2.x and pos1.z == pos2.z
end

local function IsSameNode(node1, node2)
    return IsSamePos(node1.pos, node2.pos)
end

local function IsValidPos(pos)
    local size = AStar.MapSize
    return pos.x >= -size and pos.x <= size and pos.z >= -size and pos.z <= size
end

local function GetHeuristic(pos, destination)
    return math.abs(pos.x - destination.x) + math.abs(pos.z - destination.z)
end

local function GetNodeWithLowestF(list)
    local node = list[1]
    for _, v in ipairs(list) do
        if v.g + v.h < node.g + node.h then
            node = v
        end
    end
    return node
end

local function RemoveFromNodeList(list, node)
    for i, v in ipairs(list) do
        if IsSameNode(v, node) then
            table.remove(list, i)
            break
        end
    end
end

local function IsInNodeList(list, node)
    for _, v in ipairs(list) do
        if IsSameNode(v, node) then
            return true
        end
    end
    return false
end

local function GetNeighborNodes(node)
    local neighborNodes = {}
    local x = node.pos.x
    local z = node.pos.z

    local pos = { x = x - 1, z = z }
    if IsValidPos(pos) then
        table.insert(neighborNodes, { pos = pos, g = 0, h = 0, parent = nil })
    end

    pos = { x = x + 1, z = z }
    if IsValidPos(pos) then
        table.insert(neighborNodes, { pos = pos, g = 0, h = 0, parent = nil })
    end

    pos = { x = x, z = z - 1 }
    if IsValidPos(pos) then
        table.insert(neighborNodes, { pos = pos, g = 0, h = 0, parent = nil })
    end

    pos = { x = x, z = z + 1 }
    if IsValidPos(pos) then
        table.insert(neighborNodes, { pos = pos, g = 0, h = 0, parent = nil })
    end

    return neighborNodes
end

function AStar.AddBanPos(x, z)
    table.insert(AStar.BanList, { pos = { x = x, z = z }, g = 0, h = 0, parent = nil })
end

function AStar.GetPathList(start, destination)
    local openNodeList = {}
    local closeNodeList = {}
    local pathList = {}
    
    local startNode = { pos = start, g = 0, h = GetHeuristic(start, destination), parent = nil }
    table.insert(openNodeList, startNode)

    while #openNodeList > 0 do
        local currentNode = GetNodeWithLowestF(openNodeList)

        if IsSamePos(currentNode.pos, destination) then
            local node = currentNode
            while node.parent do
                table.insert(pathList, node.pos)
                node = node.parent
            end
            return pathList
        end

        RemoveFromNodeList(openNodeList, currentNode)
        table.insert(closeNodeList, currentNode)

        local neighborNodes = GetNeighborNodes(currentNode)
        for _, neighborNode in ipairs(neighborNodes) do
            if IsInNodeList(closeNodeList, neighborNode) or IsInNodeList(AStar.BanList, neighborNode) then
                -- Ignore this neighbor node
            else
                local g = currentNode.g + 1
                if not IsInNodeList(openNodeList, neighborNode) then
                    neighborNode.g = g
                    neighborNode.h = GetHeuristic(neighborNode.pos, destination)
                    neighborNode.parent = currentNode
                    table.insert(openNodeList, neighborNode)
                elseif g < neighborNode.g then
                    neighborNode.g = g
                    neighborNode.parent = currentNode
                end
            end
        end
    end

    return nil
end