local NPCMoveSquare = NewGameLogic()

NPCMoveSquare.Radius = 0.2
NPCMoveSquare.HalfLength = 0.16
NPCMoveSquare.Speed = 0.5
NPCMoveSquare.Step = 1
NPCMoveSquare.CurTime = 0
NPCMoveSquare.TotalTime = 0

function NPCMoveSquare:Start()
    self.trans = self.gameObject:GetComponent("Transform")
    self.OriginHeight = self.trans:GetLocalPosition().y

    self.LineTime = self.HalfLength * 2 / self.Speed
    self.RoundTime = self.Radius * math.pi * 0.5 / self.Speed

    self.Step = math.random(1, 8)
    if self.Step % 2 == 0 then
        self.TotalTime = self.LineTime
    else
        self.TotalTime = self.RoundTime
    end
    self.CurTime = math.random() * self.TotalTime
end

function NPCMoveSquare:Update()
    if self.CurTime >= self.TotalTime then
        self.CurTime = 0

        self.Step = self.Step + 1
        if self.Step > 8 then
            self.Step = 1
        end
        
        if self.Step % 2 == 0 then
            self.TotalTime = self.LineTime
        else
            self.TotalTime = self.RoundTime
        end
    end

    if self.Step == 1 then
        self:LineMoveX(1)
    elseif self.Step == 2 then
        self:RoundMove(0)
    elseif self.Step == 3 then
        self:LineMoveZ(1)
    elseif self.Step == 4 then
        self:RoundMove(1)
    elseif self.Step == 5 then
        self:LineMoveX(-1)
    elseif self.Step == 6 then
        self:RoundMove(2)
    elseif self.Step == 7 then
        self:LineMoveZ(-1)
    elseif self.Step == 8 then
        self:RoundMove(3)
    end

    self.CurTime = self.CurTime + Time.GetDeltaTime()
end

function NPCMoveSquare:LineMoveX(dir)
    self.trans:SetLocalEulerAngles(0, dir * 90, 0)

    local pX = Math.Lerp(-dir * self.HalfLength, dir * self.HalfLength, self.CurTime / self.TotalTime)
    self.trans:SetLocalPosition(pX, self.OriginHeight, -dir * (self.HalfLength + self.Radius))
end

function NPCMoveSquare:LineMoveZ(dir)
    self.trans:SetLocalEulerAngles(0, (1 - dir) * 90, 0)

    local pZ = Math.Lerp(-dir * self.HalfLength, dir * self.HalfLength, self.CurTime / self.TotalTime)
    self.trans:SetLocalPosition(dir * (self.HalfLength + self.Radius), self.OriginHeight, pZ)
end

function NPCMoveSquare:RoundMove(step)
    local radian = (self.CurTime / self.TotalTime + step - 2) * math.pi * 0.5
    local degree = -radian * 180 / math.pi - 90
    self.trans:SetLocalEulerAngles(0, degree, 0)

    local rDirX = step < 2 and 1 or -1
    local rDirZ = (step == 1 or step == 2) and 1 or -1

    local pX = self.Radius * math.sin(radian)
    local pZ = self.Radius * math.cos(radian)
    pX = -pX + rDirX * self.HalfLength
    pZ =  pZ + rDirZ * self.HalfLength
    self.trans:SetLocalPosition(pX, self.OriginHeight, pZ)
end

return NPCMoveSquare