local MapUIMgr = {}

MapUIMgr.CurTile = nil
MapUIMgr.PopTile = nil

MapUIMgr.IsInit = false

function GetMapUIMgr()
    return MapUIMgr
end

function MapUIMgr:Init()
    self.PopTile = GameObject.Create("Prefabs/UI/PopTile.zxprefab")
    self.PopTile:SetActive(false)

    self.CoordinateUI = GameObject.Create("Prefabs/UI/Coordinate.zxprefab")
    self.CoordinateText = self.CoordinateUI:FindChild("Text"):GetComponent("UITextRenderer")

    self.IsInit = true
    if GetMapCamera().IsInit then
        local coord = GetMapCamera():GetCurLookTilePos()
        self:SetCenterCoordinate(coord.x, coord.y)
    end
end

function MapUIMgr:Update()
    self:UpdatePopTile()
end

function MapUIMgr:UpdatePopTile()
    if self.CurTile then
        local tilePos = self.CurTile.tileGO:GetComponent("Transform"):GetPosition()
        tilePos.y = tilePos.y + 2
        local screenPoint =  GetMapCamera().camera:WorldToScreenPoint(tilePos)
        self.PopTile:GetComponent("Transform"):SetPosition(screenPoint.x - (GlobalData.srcWidth / 2), (GlobalData.srcHeight / 2) - screenPoint.y + 80, 0)
    end
end

function MapUIMgr:SelectTile(tile)
    self.CurTile = tile
    self.PopTile:SetActive(true)
    self.PopTile:GetComponent("GameLogic"):GetScript():SetTileInfo(tile)
end

function MapUIMgr:UnSelectTile()
    self.CurTile = nil
    self.PopTile:SetActive(false)
end

function MapUIMgr:SetCenterCoordinate(x, y)
    self.CoordinateText:SetText("(" .. x .. "," .. y .. ")")
end