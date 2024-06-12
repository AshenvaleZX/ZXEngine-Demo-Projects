local ScoreMgr = NewGameLogic()

ScoreMgr.Score = 0

function GetScoreMgr()
    return ScoreMgr
end

function ScoreMgr:Start()
    self.ScoreText = self.gameObject:FindChild("Panel/Text"):GetComponent("UITextRenderer")
end

function ScoreMgr:SetScore(score)
    self.Score = score
    self.ScoreText:SetText("Score: " .. self.Score)
end

function ScoreMgr:AddScore(score)
    self.Score = self.Score + score
    self.ScoreText:SetText("Score: " .. self.Score)
end

return ScoreMgr