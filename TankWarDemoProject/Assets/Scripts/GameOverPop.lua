local GameOverPop = NewGameLogic()

function GetGameOverPop()
    return GameOverPop
end

function GameOverPop:Start()
    self.ScoreText = self.gameObject:FindChild("Panel/ScoreText"):GetComponent("UITextRenderer")

    self.BtnYesGO = self.gameObject:FindChild("Panel/BtnYes")
    self.BtnYesGO:GetComponent("UIButton"):SetClickCallBack(self.OnBtnClick, self)

    self.BtnNoGO = self.gameObject:FindChild("Panel/BtnNo")
    self.BtnNoGO:GetComponent("UIButton"):SetClickCallBack(self.OnBtnClick, self)

    self.gameObject:SetActive(false)
end

function GameOverPop:Show()
    GetGameMgr().Paused = true
    self.gameObject:SetActive(true)
    self.ScoreText:SetText("Final Score: " .. GetScoreMgr().Score)
end

function GameOverPop:OnBtnClick()
    GetGameMgr():Restart()
    self.gameObject:SetActive(false)
end

return GameOverPop