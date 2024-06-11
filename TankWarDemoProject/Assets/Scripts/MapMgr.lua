local MapMgr = {}

MapMgr.AllBuildings = {}
MapMgr.BuildingPrefabs = {}

MapMgr.BuildingTypeToName = 
{
    [GlobalConst.BUILDING_WALL] = "Wall",
    [GlobalConst.BUILDING_WALL_CORNER] = "WallCorner",
    [GlobalConst.BUILDING_TOWER_1] = "TowerCircle",
    [GlobalConst.BUILDING_TOWER_2] = "TowerSquare",
    [GlobalConst.BUILDING_TOWER_3] = "TowerHexagon",
    [GlobalConst.BUILDING_TOWER_4] = "TowerSquare2",
    [GlobalConst.BUILDING_WALL_HALF] = "WallHalf",
    [GlobalConst.BUILDING_WALL_HALF_TOWER] = "WallHalfTower",
    [GlobalConst.BUILDING_WALL_CORNER_HALF_TOWER] = "WallCornerHalfTower",
}

MapMgr.BuildingTypeToPrefab = 
{
    [GlobalConst.BUILDING_WALL] = "Prefabs/KenneyCastle/BuildingWall.zxprefab",
    [GlobalConst.BUILDING_WALL_CORNER] = "Prefabs/KenneyCastle/BuildingWallCorner.zxprefab",
    [GlobalConst.BUILDING_TOWER_1] = "Prefabs/KenneyCastle/TowerCircle.zxprefab",
    [GlobalConst.BUILDING_TOWER_2] = "Prefabs/KenneyCastle/TowerSquare.zxprefab",
    [GlobalConst.BUILDING_TOWER_3] = "Prefabs/KenneyCastle/TowerHexagon.zxprefab",
    [GlobalConst.BUILDING_TOWER_4] = "Prefabs/KenneyCastle/TowerSquare2.zxprefab",
    [GlobalConst.BUILDING_WALL_HALF] = "Prefabs/KenneyCastle/BuildingWallHalf.zxprefab",
    [GlobalConst.BUILDING_WALL_HALF_TOWER] = "Prefabs/KenneyCastle/BuildingWallHalfTower.zxprefab",
    [GlobalConst.BUILDING_WALL_CORNER_HALF_TOWER] = "Prefabs/KenneyCastle/BuildingWallCornerHalfTower.zxprefab",
}

function GetMapMgr()
    return MapMgr
end

function MapMgr:Init()
    self.MapRoot = GameObject.Find("MapRoot")
    self.Tank = GameObject.Create("Prefabs/KenneyCastle/Ballista.zxprefab")

    for k, v in pairs(self.BuildingTypeToPrefab) do
        self.BuildingPrefabs[k] = Resources.LoadPrefab(v)
    end

    local wallSize = MapConfig.Size - 1
    local wallPrefab = MapMgr.BuildingPrefabs[GlobalConst.BUILDING_WALL]
    for x = -wallSize, wallSize do
        local upWall = GameObject.CreateInstance(wallPrefab)
        upWall:SetParent(self.MapRoot)
        upWall:GetComponent("Transform"):SetPosition(x, 0, MapConfig.Size)
        upWall:GetComponent("Transform"):SetEulerAngles(0, -90, 0)
        upWall:SetName("UpWall_" .. x)

        local downWall = GameObject.CreateInstance(wallPrefab)
        downWall:SetParent(self.MapRoot)
        downWall:GetComponent("Transform"):SetPosition(x, 0, -MapConfig.Size)
        downWall:GetComponent("Transform"):SetEulerAngles(0, 90, 0)
        downWall:SetName("DownWall_" .. x)
    end

    for z = -wallSize, wallSize do
        local leftWall = GameObject.CreateInstance(wallPrefab)
        leftWall:SetParent(self.MapRoot)
        leftWall:GetComponent("Transform"):SetPosition(-MapConfig.Size, 0, z)
        leftWall:GetComponent("Transform"):SetEulerAngles(0, 180, 0)
        leftWall:SetName("LeftWall_" .. z)

        local rightWall = GameObject.CreateInstance(wallPrefab)
        rightWall:SetParent(self.MapRoot)
        rightWall:GetComponent("Transform"):SetPosition(MapConfig.Size, 0, z)
        rightWall:GetComponent("Transform"):SetEulerAngles(0, 0, 0)
        rightWall:SetName("RightWall_" .. z)
    end

    local cornerPrefab = MapMgr.BuildingPrefabs[GlobalConst.BUILDING_WALL_CORNER]
    local corner = GameObject.CreateInstance(cornerPrefab)
    corner:SetParent(self.MapRoot)
    corner:GetComponent("Transform"):SetPosition(-MapConfig.Size, 0, MapConfig.Size)
    corner:GetComponent("Transform"):SetEulerAngles(0, 180, 0)
    corner:SetName("Corner_1")

    corner = GameObject.CreateInstance(cornerPrefab)
    corner:SetParent(self.MapRoot)
    corner:GetComponent("Transform"):SetPosition(MapConfig.Size, 0, MapConfig.Size)
    corner:GetComponent("Transform"):SetEulerAngles(0, -90, 0)
    corner:SetName("Corner_2")

    corner = GameObject.CreateInstance(cornerPrefab)
    corner:SetParent(self.MapRoot)
    corner:GetComponent("Transform"):SetPosition(-MapConfig.Size, 0, -MapConfig.Size)
    corner:GetComponent("Transform"):SetEulerAngles(0, 90, 0)
    corner:SetName("Corner_3")

    corner = GameObject.CreateInstance(cornerPrefab)
    corner:SetParent(self.MapRoot)
    corner:GetComponent("Transform"):SetPosition(MapConfig.Size, 0, -MapConfig.Size)
    corner:GetComponent("Transform"):SetEulerAngles(0, 0, 0)
    corner:SetName("Corner_4")

    for x, row in pairs(MapConfig.Data) do
        for z, cell in pairs(row) do

            local prefab = MapMgr.BuildingPrefabs[cell.BuildingType]
            local building = GameObject.CreateInstance(prefab)

            if building then
                building:SetParent(self.MapRoot)
                building:GetComponent("Transform"):SetPosition(x, 0 ,z)
                building:GetComponent("Transform"):SetEulerAngles(0, cell.Rot, 0)
    
                local key = tonumber(x) .. "_" .. tonumber(z)
    
                self.AllBuildings[key] = 
                {
                    buildingGO = building,
                    type = cell.BuildingType,
                    pos = { x = x, y = z }
                }
    
                building:SetName("Tile_" .. key .. "_" .. self.BuildingTypeToName[cell.BuildingType])
            end
        end
    end
end