local NPCMove0 = NewGameLogic()

NPCMove0.Radius = 0.2
NPCMove0.HalfLength = 0.18
NPCMove0.Speed = 0.5
NPCMove0.Step = 1
NPCMove0.CurTime = 0
NPCMove0.TotalTime = 0

function NPCMove0:Start()
    self.trans = self.gameObject:GetComponent("Transform")
    self.OriginHeight = self.trans:GetLocalPosition().y

    local sqrt2 = math.sqrt(2)
    self.Line1PointSX = -self.HalfLength / sqrt2 - self.Radius / sqrt2
    self.Line1PointSZ =  self.HalfLength / sqrt2 - self.Radius / sqrt2
    self.Line1PointEX =  self.HalfLength / sqrt2 - self.Radius / sqrt2
    self.Line1PointEZ = -self.HalfLength / sqrt2 - self.Radius / sqrt2

    self.Line2PointSX =  self.HalfLength / sqrt2 + self.Radius / sqrt2
    self.Line2PointSZ = -self.HalfLength / sqrt2 + self.Radius / sqrt2
    self.Line2PointEX = -self.HalfLength / sqrt2 + self.Radius / sqrt2
    self.Line2PointEZ =  self.HalfLength / sqrt2 + self.Radius / sqrt2

    self.LineTime = self.HalfLength * 2 / self.Speed
    self.RoundTime = self.Radius * math.pi / self.Speed

    self.Step = math.random(1, 4)
    if self.Step == 1 or self.Step == 3 then
        self.TotalTime = self.LineTime
    else
        self.TotalTime = self.RoundTime
    end
    self.CurTime = math.random() * self.TotalTime
end

function NPCMove0:Update()
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

function NPCMove0:LineMove1()
    self.trans:SetLocalEulerAngles(0, 135, 0)

    local pX = Math.Lerp(self.Line1PointSX, self.Line1PointEX, self.CurTime / self.TotalTime)
    local pZ = Math.Lerp(self.Line1PointSZ, self.Line1PointEZ, self.CurTime / self.TotalTime)
    self.trans:SetLocalPosition(pX, self.OriginHeight, pZ)
end

function NPCMove0:LineMove2()
    self.trans:SetLocalEulerAngles(0, -45, 0)

    local pX = Math.Lerp(self.Line2PointSX, self.Line2PointEX, self.CurTime / self.TotalTime)
    local pZ = Math.Lerp(self.Line2PointSZ, self.Line2PointEZ, self.CurTime / self.TotalTime)
    self.trans:SetLocalPosition(pX, self.OriginHeight, pZ)
end

function NPCMove0:RoundMove1()
    local radian = (self.CurTime / self.TotalTime + 0.75) * math.pi
    local degree = -radian * 180 / math.pi - 90
    self.trans:SetLocalEulerAngles(0, degree, 0)

    local pX = self.Radius * math.sin(radian)
    local pZ = self.Radius * math.cos(radian)
    pX = -pX + self.Radius
    pZ =  pZ - self.Radius
    self.trans:SetLocalPosition(pX, self.OriginHeight, pZ)
end

function NPCMove0:RoundMove2()
    local radian = (self.CurTime / self.TotalTime + 0.75) * math.pi
    local degree = -radian * 180 / math.pi + 90
    self.trans:SetLocalEulerAngles(0, degree, 0)

    local pX = self.Radius * math.sin(radian)
    local pZ = self.Radius * math.cos(radian)
    pX =  pX - self.Radius
    pZ = -pZ + self.Radius
    self.trans:SetLocalPosition(pX, self.OriginHeight, pZ)
end

return NPCMove0