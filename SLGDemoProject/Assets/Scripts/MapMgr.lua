local MapMgr = {}

MapMgr.AllTiles = {}

MapMgr.TilePrefabs = {}

MapMgr.SelectedTile = nil
MapMgr.SelectedTilePos = { x = 0, y = 0, z = 0 }
MapMgr.TileFloat = 0
MapMgr.TileFloatMax = 1
MapMgr.TileFloatUp = true
MapMgr.TileFloatSpeed = 4
MapMgr.TileShowSize = 9
MapMgr.TileShowRange = { lx = 0, rx = 0, ty = 0, by = 0 }
MapMgr.TileCache = {}

MapMgr.DecorationType = 
{
    GlobalConst.TILE_DECORATION_FOREST,
    GlobalConst.TILE_DECORATION_HILL,
    GlobalConst.TILE_DECORATION_MOUNTAIN,
    GlobalConst.TILE_DECORATION_HOUSE,
}

MapMgr.TileTypeToName = 
{
    [GlobalConst.TILE_DEFAULT]             = "Flatland",
    [GlobalConst.TILE_CITY_1]              = "My City",
    [GlobalConst.TILE_CITY_2]              = "Enemy City",
    [GlobalConst.TILE_RESOURCE_FARM]       = "Farm",
    [GlobalConst.TILE_RESOURCE_WOOD]       = "Woods",
    [GlobalConst.TILE_RESOURCE_STONE]      = "Stone Mine",
    [GlobalConst.TILE_DECORATION_FOREST]   = "Forest",
    [GlobalConst.TILE_DECORATION_HILL]     = "Hill",
    [GlobalConst.TILE_DECORATION_MOUNTAIN] = "Mountain",
    [GlobalConst.TILE_DECORATION_HOUSE]    = "House",
}

MapMgr.TileTypeToPrefab = 
{
    [GlobalConst.TILE_DEFAULT]             = "Prefabs/KenneyHexagon/TileGrass.zxprefab",
    [GlobalConst.TILE_CITY_1]              = "Prefabs/KenneyHexagon/TileBuildingCastle.zxprefab",
    [GlobalConst.TILE_CITY_2]              = "Prefabs/KenneyHexagon/TileBuildingCastle-B.zxprefab",
    [GlobalConst.TILE_RESOURCE_FARM]       = "Prefabs/KenneyHexagon/TileResourceFarm.zxprefab",
    [GlobalConst.TILE_RESOURCE_WOOD]       = "Prefabs/KenneyHexagon/TileResourceWood.zxprefab",
    [GlobalConst.TILE_RESOURCE_STONE]      = "Prefabs/KenneyHexagon/TileResourceStone.zxprefab",
    [GlobalConst.TILE_DECORATION_FOREST]   = "Prefabs/KenneyHexagon/TileDecorationForest.zxprefab",
    [GlobalConst.TILE_DECORATION_HILL]     = "Prefabs/KenneyHexagon/TileDecorationHill.zxprefab",
    [GlobalConst.TILE_DECORATION_MOUNTAIN] = "Prefabs/KenneyHexagon/TileDecorationMountain.zxprefab",
    [GlobalConst.TILE_DECORATION_HOUSE]    = "Prefabs/KenneyHexagon/TileDecorationHouse.zxprefab",
}

function GetMapMgr()
    return MapMgr
end

function MapMgr:Update()
    self:CheckTileCreate()
    self:UpdateSelectedTile()
end

function MapMgr:Init()
    self.MapRoot = GameObject.Find("MapRoot")
    self.TileChoose = GameObject.Create("Prefabs/TileChoose.zxprefab")
    self.TileChoose:GetComponent("Transform"):SetPosition(0, -0.1, 0)

    for k, v in pairs(self.TileTypeToPrefab) do
        self.TileCache[k] = {}
        self.TilePrefabs[k] = Resources.LoadPrefab(v)
    end
end

function MapMgr:AddTroop(startPos, endPos, type)
    local troopLine = nil
    
    if type == GlobalConst.MARCH_TYPE_SOLO or type == GlobalConst.MARCH_TYPE_SOLO_RETURN then
        troopLine = GameObject.Create("Prefabs/Troop.zxprefab")
    elseif type == GlobalConst.MARCH_TYPE_RALLY or type == GlobalConst.MARCH_TYPE_RALLY_RETURN then
        troopLine = GameObject.Create("Prefabs/TroopRally.zxprefab")
    elseif type == GlobalConst.MARCH_TYPE_GATHER or type == GlobalConst.MARCH_TYPE_GATHER_RETURN then
        troopLine = GameObject.Create("Prefabs/TroopGather.zxprefab")
    elseif type == GlobalConst.MARCH_TYPE_SCOUT or type == GlobalConst.MARCH_TYPE_SCOUT_RETURN then
        troopLine = GameObject.Create("Prefabs/TroopScout.zxprefab")
    end

    if troopLine then
        local time = troopLine:GetComponent("GameLogic"):GetScript():Init(startPos, endPos)

        if type == GlobalConst.MARCH_TYPE_SOLO then
            Timer:AddOneTimeCallBack(function()
                GetMapMgr():AddTroop(endPos, startPos, GlobalConst.MARCH_TYPE_SOLO_RETURN)
            end, time)
        elseif type == GlobalConst.MARCH_TYPE_RALLY then
            Timer:AddOneTimeCallBack(function()
                GetMapMgr():AddTroop(endPos, startPos, GlobalConst.MARCH_TYPE_RALLY_RETURN)
            end, time)
        elseif type == GlobalConst.MARCH_TYPE_SCOUT then
            Timer:AddOneTimeCallBack(function()
                GetMapMgr():AddTroop(endPos, startPos, GlobalConst.MARCH_TYPE_SCOUT_RETURN)
            end, time)
        end
    end
end

function MapMgr:MarchToTile(tile, type)
    local startPos = { x = 0, y = 0, z = 0 }
    local tilePos = tile:GetComponent("Transform"):GetPosition()
    self:AddTroop(startPos, tilePos, type)
end

function MapMgr:MarchToSelectedTile(type)
    if self.SelectedTile then
        self:MarchToTile(self.SelectedTile.tileGO, type)
    end
end

function MapMgr:SelectTile(tile)
    if self.SelectedTile then
        self.SelectedTile.tileGO:GetComponent("Transform"):SetPosition(self.SelectedTilePos)
    end

    local tilePos = tile.tileGO:GetComponent("Transform"):GetPosition()
    self.TileFloat = 0
    self.TileFloatUp = true
    self.SelectedTile = tile
    self.SelectedTilePos = { x = tilePos.x, y = tilePos.y, z = tilePos.z }

    tilePos.y = 2
    self.TileChoose:GetComponent("Transform"):SetPosition(tilePos)
end

function MapMgr:UnSelectTile()
    if self.SelectedTile then
        self.SelectedTile.tileGO:GetComponent("Transform"):SetPosition(self.SelectedTilePos)
    end

    self.TileFloat = 0
    self.TileFloatUp = true
    self.SelectedTile = nil
    self.SelectedTilePos = { x = 0, y = 0, z = 0 }
    self.TileChoose:GetComponent("Transform"):SetPosition(0, -0.1, 0)

    GetMapUIMgr():UnSelectTile()
end

function MapMgr:UpdateSelectedTile()
    if self.SelectedTile then
        self.TileFloat = self.TileFloat + self.TileFloatSpeed * Time.GetDeltaTime()
        local height = (math.sin(self.TileFloat) + 1) * 0.5 * self.TileFloatMax

        local tilePos = 
        {
            x = self.SelectedTilePos.x,
            y = 2 + height,
            z = self.SelectedTilePos.z
        }
        self.TileChoose:GetComponent("Transform"):SetPosition(tilePos)

        tilePos.y = self.SelectedTilePos.y + height
        self.SelectedTile.tileGO:GetComponent("Transform"):SetPosition(tilePos)
    end
end

function MapMgr:IsTileSelected()
    return self.SelectedTile ~= nil
end

function MapMgr:CheckTileCreate()
    self:UpdateCurShowTiles()

    local tileToCreate = {}
    for i = self.TileShowRange.lx, self.TileShowRange.rx do
        for j = self.TileShowRange.by, self.TileShowRange.ty do
            local key = i * 1000 + j
            if self.AllTiles[key] == nil then
                table.insert(tileToCreate, { x = i, y = j })
            end
        end
    end

    local tileToCollect = {}
    for k, v in pairs(self.AllTiles) do
        if v.pos.x < self.TileShowRange.lx or v.pos.x > self.TileShowRange.rx or v.pos.y < self.TileShowRange.by or v.pos.y > self.TileShowRange.ty then
            v.tileGO:SetActive(false)
            table.insert(tileToCollect, k)
            table.insert(self.TileCache[v.type], v)
        end
    end
    for i, v in ipairs(tileToCollect) do
        self.AllTiles[v] = nil
    end

    for i, v in ipairs(tileToCreate) do
        local tileType = nil
        if MapConfig.Data[v.x] and MapConfig.Data[v.x][v.y] then
            tileType = MapConfig.Data[v.x][v.y].TileType
        end

        if tileType == nil then
            local rnd = math.random(1, 16)
            if rnd < 5 then
                tileType = MapMgr.DecorationType[rnd]
            else
                tileType = GlobalConst.TILE_DEFAULT
            end
        end

        local cacheNum = #self.TileCache[tileType]
        if cacheNum > 0 then
            local tile = self.TileCache[tileType][cacheNum]
            table.remove(self.TileCache[tileType], cacheNum)

            tile.pos = { x = v.x, y = v.y }
            tile.tileGO:SetActive(true)
            tile.tileGO:GetComponent("Transform"):SetPosition(self:LogicIndexToPos(v.x, v.y))

            local key = v.x * 1000 + v.y
            self.AllTiles[key] = tile

            tile.tileGO:SetName("Tile_" .. v.x .. "_" .. v.y .. "_" .. self.TileTypeToName[tileType])
        else
            local prefab = MapMgr.TilePrefabs[tileType]
            local tileGO = GameObject.CreateInstance(prefab)
            tileGO:SetParent(self.MapRoot)
            tileGO:GetComponent("Transform"):SetPosition(self:LogicIndexToPos(v.x, v.y))

            local key = v.x * 1000 + v.y
            self.AllTiles[key] = 
            {
                tileGO = tileGO,
                type = tileType,
                pos = { x = v.x, y = v.y }
            }

            tileGO:SetName("Tile_" .. v.x .. "_" .. v.y .. "_" .. self.TileTypeToName[tileType])
        end
    end
end

function MapMgr:LogicIndexToPos(x, y)
    local midX = math.ceil(MapConfig.Size / 2)
    local midY = math.ceil(MapConfig.Size / 2)

    if y % 2 == 1 then
        midX = midX + 0.5
    end

    return { x = (x - midX) * 10, y = 0, z = (y - midY) * 8.66 }
end

function MapMgr:PosToLogicIndex(pos)
    local midX = math.ceil(MapConfig.Size / 2)
    local midY = math.ceil(MapConfig.Size / 2)

    local logicX = (pos.x / 10) + midX
    local logicY = (pos.z / 8.66) + midY

    if logicX % 2 == 1 then
        logicY = logicY - 0.5
    end

    logicX = math.floor(logicX + 0.5)
    logicY = math.floor(logicY + 0.5)

    return { x = logicX, y = logicY }
end

function MapMgr:UpdateCurShowTiles()
    local center = GetMapCamera().CenterCoord
    self.TileShowRange.lx = Math.Clamp(center.x - self.TileShowSize, 0, MapConfig.Size)
    self.TileShowRange.rx = Math.Clamp(center.x + self.TileShowSize, 0, MapConfig.Size)
    self.TileShowRange.by = Math.Clamp(center.y - self.TileShowSize, 0, MapConfig.Size)
    self.TileShowRange.ty = Math.Clamp(center.y + self.TileShowSize, 0, MapConfig.Size)
end

function MapMgr:OnDestroy()
    for k, v in pairs(self.TilePrefabs) do
        Resources.ReleasePrefab(v)
    end
end