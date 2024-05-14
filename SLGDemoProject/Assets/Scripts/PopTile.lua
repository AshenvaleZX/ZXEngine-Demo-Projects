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

return PopTile