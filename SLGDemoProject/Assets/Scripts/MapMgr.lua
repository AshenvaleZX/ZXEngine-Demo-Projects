local MapMgr = {}

MapMgr.AllTiles = {}
MapMgr.TileCreateNum = 0

MapMgr.SelectedTile = nil
MapMgr.SelectedTilePos = { x = 0, y = 0, z = 0 }
MapMgr.TileFloat = 0
MapMgr.TileFloatMax = 1
MapMgr.TileFloatUp = true
MapMgr.TileFloatSpeed = 4

MapMgr.DecorationType = 
{
    GlobalConst.TILE_DECORATION_FOREST,
    GlobalConst.TILE_DECORATION_HILL,
    GlobalConst.TILE_DECORATION_MOUNTAIN,
    GlobalConst.TILE_DECORATION_HOUSE,
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
    self.TileCreateNum = MapConfig.Size.x * MapConfig.Size.y
    self.MapRoot = GameObject.Find("MapRoot")
    self.TileChoose = GameObject.Create("Prefabs/TileChoose.zxprefab")
    self.TileChoose:GetComponent("Transform"):SetPosition(0, -0.1, 0)
end

function MapMgr:AddTroop(startPos, endPos, type)
    local troopLine = nil
    
    if type == GlobalConst.MARCH_TYPE_SOLO then
        troopLine = GameObject.Create("Prefabs/Troop.zxprefab")
    elseif type == GlobalConst.MARCH_TYPE_RALLY then
        troopLine = GameObject.Create("Prefabs/TroopRally.zxprefab")
    elseif type == GlobalConst.MARCH_TYPE_GATHER then
        troopLine = GameObject.Create("Prefabs/TroopGather.zxprefab")
    elseif type == GlobalConst.MARCH_TYPE_SCOUT then
        troopLine = GameObject.Create("Prefabs/TroopScout.zxprefab")
    end

    if troopLine then
        troopLine:GetComponent("GameLogic"):GetScript():Init(startPos, endPos)
    end
end

function MapMgr:SelectTile(tile)
    if self.SelectedTile then
        self.SelectedTile:GetComponent("Transform"):SetPosition(self.SelectedTilePos)
    end

    local tilePos = tile:GetComponent("Transform"):GetPosition()
    self.TileFloat = 0
    self.TileFloatUp = true
    self.SelectedTile = tile
    self.SelectedTilePos = { x = tilePos.x, y = tilePos.y, z = tilePos.z }

    tilePos.y = 2
    self.TileChoose:GetComponent("Transform"):SetPosition(tilePos)

    local tType = math.random(1, 4)
    local startPos = { x = 0, y = 0, z = 0 }
    self:AddTroop(startPos, tilePos, tType)
end

function MapMgr:UnSelectTile()
    if self.SelectedTile then
        self.SelectedTile:GetComponent("Transform"):SetPosition(self.SelectedTilePos)
    end

    self.TileFloat = 0
    self.TileFloatUp = true
    self.SelectedTile = nil
    self.SelectedTilePos = { x = 0, y = 0, z = 0 }
    self.TileChoose:GetComponent("Transform"):SetPosition(0, -0.1, 0)
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
        self.SelectedTile:GetComponent("Transform"):SetPosition(tilePos)
    end
end

function MapMgr:CheckTileCreate()
    if self.TileCreateNum > 0 then
        -- 第i行第j列，坐上角为起点(1,1)
        local i = MapConfig.Size.y - math.ceil(self.TileCreateNum / MapConfig.Size.x) + 1
        local j = MapConfig.Size.x - (self.TileCreateNum - 1) % MapConfig.Size.x

        local tile = nil
        local tileType = nil
        if MapConfig.Data[i] and MapConfig.Data[i][j] then
            tileType = MapConfig.Data[i][j].TileType
        end

        if tileType then
            local prefab = MapMgr.TileTypeToPrefab[tileType]
            tile = GameObject.Create(prefab)
        else
            local rnd = math.random(1, 16)
            if rnd < 5 then
                local prefab = MapMgr.TileTypeToPrefab[MapMgr.DecorationType[rnd]]
                tile = GameObject.Create(prefab)
            else
                tile = GameObject.Create("Prefabs/KenneyHexagon/TileGrass.zxprefab")
            end
        end

        if tile then
            tile:SetParent(self.MapRoot)
            tile:GetComponent("Transform"):SetPosition(self:LogicIndexToPos(i, j))

            local key = i .. "_" .. j
            self.AllTiles[key] = tile

            tile:SetName("Tile_" .. key)
        end

        self.TileCreateNum = self.TileCreateNum - 1
    end
end

function MapMgr:LogicIndexToPos(x, y)
    local midX = math.ceil(MapConfig.Size.x / 2)
    local midY = math.ceil(MapConfig.Size.y / 2)

    if x % 2 == 1 then
        midY = midY + 0.5
    end

    return { x = (y - midY) * 10, y = 0, z = (midX - x) * 8.66 }
end