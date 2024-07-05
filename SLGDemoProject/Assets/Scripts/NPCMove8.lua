local NPCMove8 = NewGameLogic()

NPCMove8.Radius = 0.2
NPCMove8.Speed = 0.5
NPCMove8.Step = 1
NPCMove8.CurTime = 0
NPCMove8.TotalTime = 0

function NPCMove8:Start()
    self.trans = self.gameObject:GetComponent("Transform")
    self.OriginHeight = self.trans:GetLocalPosition().y

    self.LinePointPos = self.Radius / math.sqrt(2)
    self.LineTime = self.Radius * 2 / self.Speed
    self.RoundTime = self.Radius * 1.5 * math.pi / self.Speed

    self.Step = math.random(1, 4)
    if self.Step == 1 or self.Step == 3 then
        self.TotalTime = self.LineTime
    else
        self.TotalTime = self.RoundTime
    end
    self.CurTime = math.random() * self.TotalTime
end

function NPCMove8:Update()
    if self.CurTime >= self.TotalTime then
        self.CurTime = 0

        self.Step = self.Step + 1
        if self.Step > 4 then
            self.Step = 1
        end
        
        if self.Step == 1 or self.Step == 3 then
            self.TotalTime = self.LineTime
        else
            self.TotalTime = self.RoundTime
        end
    end

    if self.Step == 1 then
        self:LineMove1()
    elseif self.Step == 2 then
        self:RoundMove1()
    elseif self.Step == 3 then
        self:LineMove2()
    elseif self.Step == 4 then
        self:RoundMove2()
    end

    self.CurTime = self.CurTime + Time.GetDeltaTime()
end

function NPCMove8:LineMove1()
    self.trans:SetLocalEulerAngles(0, 0, 0)

    local curPos = Math.Lerp(-self.LinePointPos, self.LinePointPos, self.CurTime / self.TotalTime)
    self.trans:SetLocalPosition(0, self.OriginHeight, curPos)
end

function NPCMove8:LineMove2()
    self.trans:SetLocalEulerAngles(0, -90, 0)

    local curPos = Math.Lerp(self.LinePointPos, -self.LinePointPos, self.CurTime / self.TotalTime)
    self.trans:SetLocalPosition(curPos, self.OriginHeight, 0)
end

function NPCMove8:RoundMove1()
    local radian = self.CurTime / self.TotalTime * math.pi * 1.5
    local degree = radian * 180 / math.pi
    self.trans:SetLocalEulerAngles(0, degree, 0)

    local pX = self.Radius * math.cos(radian)
    local pZ = self.Radius * math.sin(radian)
    pX = -pX + self.Radius
    pZ =  pZ + self.Radius
    self.trans:SetLocalPosition(pX, self.OriginHeight, pZ)
end

function NPCMove8:RoundMove2()
    local radian = self.CurTime / self.TotalTime * math.pi * 1.5
    local degree = -radian * 180 / math.pi - 90
    self.trans:SetLocalEulerAngles(0, degree, 0)

    local pX = self.Radius * math.sin(radian)
    local pZ = self.Radius * math.cos(radian)
    pX = -pX - self.Radius
    pZ =  pZ - self.Radius
    self.trans:SetLocalPosition(pX, self.OriginHeight, pZ)
end

return NPCMove8