local PopTile = NewGameLogic()

function PopTile:Start()
    self.BtnScoutGO = self.gameObject:FindChild("Panel/BtnYellow")
    self.BtnScoutGO:GetComponent("UIButton"):SetClickCallBack(self.OnBtnScoutClick, self)

    self.BtnAttackGO = self.gameObject:FindChild("Panel/BtnRed")
    self.BtnAttackGO:GetComponent("UIButton"):SetClickCallBack(self.OnBtnAttackClick, self)
end

function PopTile:OnBtnScoutClick()
    GetMapCamera().TileClickBlock = true
    GetMapMgr():MarchToSelectedTile(GlobalConst.MARCH_TYPE_SCOUT)
    GetMapMgr():UnSelectTile()
end

function PopTile:OnBtnAttackClick()
    GetMapCamera().TileClickBlock = true
    GetMapMgr():MarchToSelectedTile(GlobalConst.MARCH_TYPE_SOLO)
    GetMapMgr():UnSelectTile()
end

function PopTile:SetTileInfo(tile)
    if self.NameTextCom == nil then
        self.NameTextCom = self.gameObject:FindChild("Panel/TileInfo/Name"):GetComponent("UITextRenderer")
    end
    if self.PosTextCom == nil then
        self.PosTextCom = self.gameObject:FindChild("Panel/TileInfo/Coordinate"):GetComponent("UITextRenderer")
    end

    self.NameTextCom:SetText(GetMapMgr().TileTypeToName[tile.type])
    self.PosTextCom:SetText("(" .. tile.pos.x .. "," .. tile.pos.y .. ")")
end

return PopTile