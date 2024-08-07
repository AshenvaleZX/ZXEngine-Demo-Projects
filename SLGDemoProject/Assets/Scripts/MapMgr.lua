local MapMgr = {}

MapMgr.AllTiles = {}
MapMgr.AllTileIcons = {}

MapMgr.TilePrefabs = {}
MapMgr.TileIconPrefabs = {}

MapMgr.SelectedTile = nil
MapMgr.SelectedTilePos = { x = 0, y = 0, z = 0 }
MapMgr.TileFloat = 0
MapMgr.TileFloatMax = 1
MapMgr.TileFloatUp = true
MapMgr.TileFloatSpeed = 4
MapMgr.TileShowSize = 11
MapMgr.TileShowRange = { lx = 0, rx = 0, ty = 0, by = 0 }
MapMgr.TileIconShowSize = 20
MapMgr.TileIconShowRange = { lx = 0, rx = 0, ty = 0, by = 0 }

-- 已清除迷雾的区域
MapMgr.ClearedRange = { lx = 123, rx = 228, ty = 228, by = 108 }

MapMgr.TileCache = {}
MapMgr.TileIconCache = {}
MapMgr.TileActive = true
MapMgr.TileIconActive = false
MapMgr.TileScale = 1
MapMgr.TileOriginScale = 9.5
MapMgr.TileIconScale = 1
MapMgr.TileIconOriginScale = 0.6

MapMgr.TroopPrefabs = {}

MapMgr.ResourceType = 
{
    GlobalConst.TILE_RESOURCE_FARM_1,
    GlobalConst.TILE_RESOURCE_FARM_2,
    GlobalConst.TILE_RESOURCE_FARM_3,
    GlobalConst.TILE_RESOURCE_WOOD_1,
    GlobalConst.TILE_RESOURCE_WOOD_2,
    GlobalConst.TILE_RESOURCE_WOOD_3,
    GlobalConst.TILE_RESOURCE_STONE_1,
    GlobalConst.TILE_RESOURCE_STONE_2,
    GlobalConst.TILE_RESOURCE_STONE_3,
}

MapMgr.MonsterType = 
{
    GlobalConst.TILE_MONSTER_1,
    GlobalConst.TILE_MONSTER_2,
    GlobalConst.TILE_MONSTER_3,
    GlobalConst.TILE_MONSTER_4,
}

MapMgr.DecorationType = 
{
    GlobalConst.TILE_DECORATION_TOWER,
    GlobalConst.TILE_DECORATION_HILL,
    GlobalConst.TILE_DECORATION_MOUNTAIN,
    GlobalConst.TILE_DECORATION_HOUSE,
    GlobalConst.TILE_DECORATION_WATER_ISLAND,
    GlobalConst.TILE_DECORATION_WATER_ROCKS,
}

MapMgr.RandomDecorationPool = 
{
    GlobalConst.TILE_DECORATION_TOWER,
    GlobalConst.TILE_DECORATION_HILL,
    GlobalConst.TILE_DECORATION_MOUNTAIN,
    GlobalConst.TILE_DECORATION_HOUSE,
    GlobalConst.TILE_DECORATION_WATER_ISLAND,
    GlobalConst.TILE_DECORATION_WATER_ISLAND,
    GlobalConst.TILE_DECORATION_WATER_ROCKS,
    GlobalConst.TILE_DECORATION_WATER_ROCKS,
    GlobalConst.TILE_DECORATION_WATER_ROCKS,
    GlobalConst.TILE_DECORATION_WATER_ROCKS,
}

MapMgr.TileTypeToName = 
{
    [GlobalConst.TILE_DEFAULT]                 = "Flatland",
    [GlobalConst.TILE_CITY_1]                  = "My City",
    [GlobalConst.TILE_CITY_2]                  = "Enemy City",
    [GlobalConst.TILE_RESOURCE_FARM_1]         = "Farm Lv1",
    [GlobalConst.TILE_RESOURCE_FARM_2]         = "Farm Lv2",
    [GlobalConst.TILE_RESOURCE_FARM_3]         = "Farm Lv3",
    [GlobalConst.TILE_RESOURCE_WOOD_1]         = "Woods Lv1",
    [GlobalConst.TILE_RESOURCE_WOOD_2]         = "Woods Lv2",
    [GlobalConst.TILE_RESOURCE_WOOD_3]         = "Woods Lv3",
    [GlobalConst.TILE_RESOURCE_STONE_1]        = "Stone Lv1",
    [GlobalConst.TILE_RESOURCE_STONE_2]        = "Stone Lv2",
    [GlobalConst.TILE_RESOURCE_STONE_3]        = "Stone Lv3",
    [GlobalConst.TILE_MONSTER_1]               = "Monster Lv1",
    [GlobalConst.TILE_MONSTER_2]               = "Monster Lv2",
    [GlobalConst.TILE_MONSTER_3]               = "Monster Lv3",
    [GlobalConst.TILE_MONSTER_4]               = "Monster Lv4",
    [GlobalConst.TILE_DECORATION_TOWER]        = "Tower",
    [GlobalConst.TILE_DECORATION_HILL]         = "Hill",
    [GlobalConst.TILE_DECORATION_MOUNTAIN]     = "Mountain",
    [GlobalConst.TILE_DECORATION_HOUSE]        = "House",
    [GlobalConst.TILE_DECORATION_WATER_ISLAND] = "Island",
    [GlobalConst.TILE_DECORATION_WATER_ROCKS]  = "Water Rocks",
}

MapMgr.TileTypeToPrefab = 
{
    [GlobalConst.TILE_DEFAULT]                 = "Prefabs/KenneyHexagon/TileWater.zxprefab",
    [GlobalConst.TILE_CITY_1]                  = "Prefabs/KenneyHexagon/TileBuildingCastle.zxprefab",
    [GlobalConst.TILE_CITY_2]                  = "Prefabs/KenneyHexagon/TileBuildingCastle-B.zxprefab",
    [GlobalConst.TILE_RESOURCE_FARM_1]         = "Prefabs/KenneyHexagon/TileResourceFarm1.zxprefab",
    [GlobalConst.TILE_RESOURCE_FARM_2]         = "Prefabs/KenneyHexagon/TileResourceFarm2.zxprefab",
    [GlobalConst.TILE_RESOURCE_FARM_3]         = "Prefabs/KenneyHexagon/TileResourceFarm3.zxprefab",
    [GlobalConst.TILE_RESOURCE_WOOD_1]         = "Prefabs/KenneyHexagon/TileResourceWood1.zxprefab",
    [GlobalConst.TILE_RESOURCE_WOOD_2]         = "Prefabs/KenneyHexagon/TileResourceWood2.zxprefab",
    [GlobalConst.TILE_RESOURCE_WOOD_3]         = "Prefabs/KenneyHexagon/TileResourceWood3.zxprefab",
    [GlobalConst.TILE_RESOURCE_STONE_1]        = "Prefabs/KenneyHexagon/TileResourceStone1.zxprefab",
    [GlobalConst.TILE_RESOURCE_STONE_2]        = "Prefabs/KenneyHexagon/TileResourceStone2.zxprefab",
    [GlobalConst.TILE_RESOURCE_STONE_3]        = "Prefabs/KenneyHexagon/TileResourceStone3.zxprefab",
    [GlobalConst.TILE_MONSTER_1]               = "Prefabs/KenneyHexagon/TileMonster1.zxprefab",
    [GlobalConst.TILE_MONSTER_2]               = "Prefabs/KenneyHexagon/TileMonster2.zxprefab",
    [GlobalConst.TILE_MONSTER_3]               = "Prefabs/KenneyHexagon/TileMonster3.zxprefab",
    [GlobalConst.TILE_MONSTER_4]               = "Prefabs/KenneyHexagon/TileMonster4.zxprefab",
    [GlobalConst.TILE_DECORATION_TOWER]        = "Prefabs/KenneyHexagon/TileDecorationTower.zxprefab",
    [GlobalConst.TILE_DECORATION_HILL]         = "Prefabs/KenneyHexagon/TileDecorationHill.zxprefab",
    [GlobalConst.TILE_DECORATION_MOUNTAIN]     = "Prefabs/KenneyHexagon/TileDecorationMountain.zxprefab",
    [GlobalConst.TILE_DECORATION_HOUSE]        = "Prefabs/KenneyHexagon/TileDecorationHouse.zxprefab",
    [GlobalConst.TILE_DECORATION_WATER_ISLAND] = "Prefabs/KenneyHexagon/TileDecorationWaterIsland.zxprefab",
    [GlobalConst.TILE_DECORATION_WATER_ROCKS]  = "Prefabs/KenneyHexagon/TileDecorationWaterRocks.zxprefab",
}

MapMgr.TileTypeToIconPrefab = 
{
    [GlobalConst.TILE_CITY_1]              = "Prefabs/KenneyHexagon/TileIconCity1.zxprefab",
    [GlobalConst.TILE_CITY_2]              = "Prefabs/KenneyHexagon/TileIconCity2.zxprefab",
    [GlobalConst.TILE_RESOURCE_FARM_1]     = "Prefabs/KenneyHexagon/TileIconResFarm.zxprefab",
    [GlobalConst.TILE_RESOURCE_FARM_2]     = "Prefabs/KenneyHexagon/TileIconResFarm.zxprefab",
    [GlobalConst.TILE_RESOURCE_FARM_3]     = "Prefabs/KenneyHexagon/TileIconResFarm.zxprefab",
    [GlobalConst.TILE_RESOURCE_WOOD_1]     = "Prefabs/KenneyHexagon/TileIconResWood.zxprefab",
    [GlobalConst.TILE_RESOURCE_WOOD_2]     = "Prefabs/KenneyHexagon/TileIconResWood.zxprefab",
    [GlobalConst.TILE_RESOURCE_WOOD_3]     = "Prefabs/KenneyHexagon/TileIconResWood.zxprefab",
    [GlobalConst.TILE_RESOURCE_STONE_1]    = "Prefabs/KenneyHexagon/TileIconResStone.zxprefab",
    [GlobalConst.TILE_RESOURCE_STONE_2]    = "Prefabs/KenneyHexagon/TileIconResStone.zxprefab",
    [GlobalConst.TILE_RESOURCE_STONE_3]    = "Prefabs/KenneyHexagon/TileIconResStone.zxprefab",
    [GlobalConst.TILE_MONSTER_1]           = "Prefabs/KenneyHexagon/TileIconMonster.zxprefab",
    [GlobalConst.TILE_MONSTER_2]           = "Prefabs/KenneyHexagon/TileIconMonster.zxprefab",
    [GlobalConst.TILE_MONSTER_3]           = "Prefabs/KenneyHexagon/TileIconMonster.zxprefab",
    [GlobalConst.TILE_MONSTER_4]           = "Prefabs/KenneyHexagon/TileIconMonster.zxprefab",
}

MapMgr.TroopTypeToPrefab = 
{
    [GlobalConst.MARCH_TYPE_SOLO]          = "Prefabs/Troop.zxprefab",
    [GlobalConst.MARCH_TYPE_SOLO_RETURN]   = "Prefabs/Troop.zxprefab",
    [GlobalConst.MARCH_TYPE_RALLY]         = "Prefabs/TroopRally.zxprefab",
    [GlobalConst.MARCH_TYPE_RALLY_RETURN]  = "Prefabs/TroopRally.zxprefab",
    [GlobalConst.MARCH_TYPE_GATHER]        = "Prefabs/TroopGather.zxprefab",
    [GlobalConst.MARCH_TYPE_GATHER_RETURN] = "Prefabs/TroopGather.zxprefab",
    [GlobalConst.MARCH_TYPE_SCOUT]         = "Prefabs/TroopScout.zxprefab",
    [GlobalConst.MARCH_TYPE_SCOUT_RETURN]  = "Prefabs/TroopScout.zxprefab",
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

    for k, v in pairs(self.TileTypeToIconPrefab) do
        self.TileIconCache[k] = {}
        self.TileIconPrefabs[k] = Resources.LoadPrefab(v)
    end

    for k, v in pairs(self.TroopTypeToPrefab) do
        self.TroopPrefabs[k] = Resources.LoadPrefab(v)
    end

    -- 初始化地图配置
    for i = 1, MapConfig.Size do
        for j = 1, MapConfig.Size do
            if MapConfig.Data[i] and MapConfig.Data[i][j] then
                -- 保持原配置
            else
                local rnd = math.random(1, 80)
                local tileType = nil
                if rnd <= 9 then
                    tileType = self.ResourceType[rnd]
                elseif rnd <= 13 then
                    tileType = self.MonsterType[rnd - 9]
                elseif rnd == 14 then
                    if i >= self.ClearedRange.lx and i <= self.ClearedRange.rx and j >= self.ClearedRange.by and j <= self.ClearedRange.ty then
                        tileType = GlobalConst.TILE_CITY_2
                    end
                end

                if tileType then
                    if not MapConfig.Data[i] then
                        MapConfig.Data[i] = {}
                    end
                    MapConfig.Data[i][j] = { TileType = tileType }
                end
            end
        end
    end
end

function MapMgr:AddTroop(startPos, endPos, type)
    local troopLine = GameObject.CreateInstance(self.TroopPrefabs[type])
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

    local iconToCreate = {}
    for i = self.TileIconShowRange.lx, self.TileIconShowRange.rx do
        for j = self.TileIconShowRange.by, self.TileIconShowRange.ty do
            -- 已清除迷雾的区域才显示图标
            if i >= self.ClearedRange.lx and i <= self.ClearedRange.rx and j >= self.ClearedRange.by and j <= self.ClearedRange.ty then
                local tileType = nil
                if MapConfig.Data[i] and MapConfig.Data[i][j] then
                    tileType = MapConfig.Data[i][j].TileType
                end
                -- 有配置才需要创建
                if tileType and self.TileTypeToIconPrefab[tileType] then
                    local key = i * 1000 + j
                    if self.AllTileIcons[key] == nil then
                        table.insert(iconToCreate, { x = i, y = j })
                    end
                end
            end
        end
    end

    -- 回收不在显示范围内的地块
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

    -- 回收不在显示范围内的地块图标
    local iconToCollect = {}
    for k, v in pairs(self.AllTileIcons) do
        if v.pos.x < self.TileIconShowRange.lx or v.pos.x > self.TileIconShowRange.rx or v.pos.y < self.TileIconShowRange.by or v.pos.y > self.TileIconShowRange.ty then
            v.iconGO:SetActive(false)
            table.insert(iconToCollect, k)
            table.insert(self.TileIconCache[v.type], v)
        end
    end
    for i, v in ipairs(iconToCollect) do
        self.AllTileIcons[v] = nil
    end

    -- 创建地块
    for i, v in ipairs(tileToCreate) do
        local tileType = nil
        if MapConfig.Data[v.x] and MapConfig.Data[v.x][v.y] then
            tileType = MapConfig.Data[v.x][v.y].TileType
        end

        if tileType == nil then
            local rnd = math.random(1, 50)
            if rnd <= 10 then
                tileType = MapMgr.RandomDecorationPool[rnd]
            else
                tileType = GlobalConst.TILE_DEFAULT
            end
        end

        local cacheNum = #self.TileCache[tileType]
        if cacheNum > 0 then
            local tile = self.TileCache[tileType][cacheNum]
            table.remove(self.TileCache[tileType], cacheNum)

            tile.pos = { x = v.x, y = v.y }
            tile.tileGO:SetActive(self.TileActive)
            tile.tileGO:GetComponent("Transform"):SetPosition(self:LogicIndexToPos(v.x, v.y, 0))

            local scale = self.TileOriginScale * self.TileScale
            tile.tileGO:GetComponent("Transform"):SetLocalScale(scale, scale, scale)

            local key = v.x * 1000 + v.y
            self.AllTiles[key] = tile

            tile.tileGO:SetName("Tile_" .. v.x .. "_" .. v.y .. "_" .. self.TileTypeToName[tileType])
        else
            local prefab = MapMgr.TilePrefabs[tileType]
            local tileGO = GameObject.CreateInstance(prefab)
            tileGO:SetParent(self.MapRoot)
            tileGO:SetActive(self.TileActive)
            tileGO:GetComponent("Transform"):SetPosition(self:LogicIndexToPos(v.x, v.y, 0))

            local scale = self.TileOriginScale * self.TileScale
            tileGO:GetComponent("Transform"):SetLocalScale(scale, scale, scale)

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
    
    -- 创建地块图标
    for i, v in ipairs(iconToCreate) do
        local tileType = nil
        if MapConfig.Data[v.x] and MapConfig.Data[v.x][v.y] then
            tileType = MapConfig.Data[v.x][v.y].TileType
        end

        if tileType and self.TileTypeToIconPrefab[tileType] then
            local iconCacheNum = #self.TileIconCache[tileType]
            if iconCacheNum > 0 then
                local icon = self.TileIconCache[tileType][iconCacheNum]
                table.remove(self.TileIconCache[tileType], iconCacheNum)

                icon.pos = { x = v.x, y = v.y }
                icon.iconGO:SetActive(self.TileIconActive)
                icon.iconGO:GetComponent("Transform"):SetPosition(self:LogicIndexToPos(v.x, v.y, 1))

                local scale = self.TileIconOriginScale * self.TileIconScale
                icon.iconGO:GetComponent("Transform"):SetLocalScale(scale, scale, scale)

                local key = v.x * 1000 + v.y
                self.AllTileIcons[key] = icon

                icon.iconGO:SetName("TileIcon_" .. v.x .. "_" .. v.y .. "_" .. self.TileTypeToName[tileType])
            else
                local iconPrefab = MapMgr.TileIconPrefabs[tileType]
                local iconGO = GameObject.CreateInstance(iconPrefab)
                iconGO:SetParent(self.MapRoot)
                iconGO:SetActive(self.TileIconActive)
                iconGO:GetComponent("Transform"):SetPosition(self:LogicIndexToPos(v.x, v.y, 1))

                local scale = self.TileIconOriginScale * self.TileIconScale
                iconGO:GetComponent("Transform"):SetLocalScale(scale, scale, scale)

                local key = v.x * 1000 + v.y
                self.AllTileIcons[key] = 
                {
                    iconGO = iconGO,
                    type = tileType,
                    pos = { x = v.x, y = v.y }
                }

                iconGO:SetName("TileIcon_" .. v.x .. "_" .. v.y .. "_" .. self.TileTypeToName[tileType])
            end
        end
    end
end

function MapMgr:LogicIndexToPos(x, y, h)
    local midX = math.ceil(MapConfig.Size / 2)
    local midY = math.ceil(MapConfig.Size / 2)

    if y % 2 == 1 then
        midX = midX + 0.5
    end

    return { x = (x - midX) * 10, y = h, z = (y - midY) * 8.66 }
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
    self.TileIconShowRange.lx = Math.Clamp(center.x - self.TileIconShowSize, 0, MapConfig.Size)
    self.TileIconShowRange.rx = Math.Clamp(center.x + self.TileIconShowSize, 0, MapConfig.Size)
    self.TileIconShowRange.by = Math.Clamp(center.y - self.TileIconShowSize, 0, MapConfig.Size)
    self.TileIconShowRange.ty = Math.Clamp(center.y + self.TileIconShowSize, 0, MapConfig.Size)
end

function MapMgr:SetAllTilesActive(active)
    self.TileActive = active
    for k, v in pairs(self.AllTiles) do
        v.tileGO:SetActive(active)
    end
end

function MapMgr:SetAllTileIconsActive(active)
    self.TileIconActive = active
    for k, v in pairs(self.AllTileIcons) do
        v.iconGO:SetActive(active)
    end
end

function MapMgr:SetAllTilesScale(scale)
    self.TileScale = scale
    local s = self.TileOriginScale * scale
    for k, v in pairs(self.AllTiles) do
        v.tileGO:GetComponent("Transform"):SetLocalScale(s, s, s)
    end
end

function MapMgr:SetAllTileIconsScale(scale)
    self.TileIconScale = scale
    local s = self.TileIconOriginScale * scale
    for k, v in pairs(self.AllTileIcons) do
        v.iconGO:GetComponent("Transform"):SetLocalScale(s, s, s)
    end
end

function MapMgr:OnDestroy()
    for k, v in pairs(self.TilePrefabs) do
        Resources.ReleasePrefab(v)
    end
end