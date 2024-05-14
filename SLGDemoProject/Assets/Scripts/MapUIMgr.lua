local MapUIMgr = {}

MapUIMgr.CurTile = nil
MapUIMgr.PopTile = nil

function GetMapUIMgr()
    return MapUIMgr
end

function MapUIMgr:Init()
    self.PopTile = GameObject.Create("Prefabs/UI/PopTile.zxprefab")
    self.PopTile:SetActive(false)
end

function MapUIMgr:Update()
    self:UpdatePopTile()
end

function MapUIMgr:UpdatePopTile()
    if self.CurTile then
        local tilePos = self.CurTile:GetComponent("Transform"):GetPosition()
        tilePos.y = tilePos.y + 2
        local screenPoint =  GetMapCamera().camera:WorldToScreenPoint(tilePos)
        self.PopTile:GetComponent("Transform"):SetPosition(screenPoint.x - (GlobalData.srcWidth / 2), (GlobalData.srcHeight / 2) - screenPoint.y + 80, 0)
    end
end

function MapUIMgr:SelectTile(tile)
    self.CurTile = tile
    self.PopTile:SetActive(true)
end

function MapUIMgr:UnSelectTile()
    self.CurTile = nil
    self.PopTile:SetActive(false)
end