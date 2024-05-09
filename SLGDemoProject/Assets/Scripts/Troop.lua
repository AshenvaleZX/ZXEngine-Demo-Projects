local Troop = NewGameLogic()

Troop.Height = 3
Troop.Speed = 5
Troop.TotalTime = 0
Troop.CurTime = 0
Troop.StartPos = { x = 0, y = 0, z = 0 }
Troop.EndPos = { x = 0, y = 0, z = 0 }

function Troop:Update()
    self.CurTime = self.CurTime + Time.GetDeltaTime()
    if self.CurTime > self.TotalTime then
        self.gameObject:Destroy()
    else
        local t = self.CurTime / self.TotalTime
        local pos = Math.LerpVec3(self.StartPos, self.EndPos, t)
        self.ModelTransform:SetPosition(pos)
    end
end

function Troop:Init(startPos, endPos)
    local linePos = { x = (startPos.x + endPos.x) / 2, y = self.Height, z = (startPos.z + endPos.z) / 2 }

    -- Troop Line
    self.LineGO = self.gameObject:FindChild("TroopLine")
    
    self.LineGO:GetComponent("Transform"):SetPosition(linePos)

    local lineDir = Math.SubVec3(endPos, startPos)
    local yAngle = math.atan(lineDir.x / lineDir.z) / math.pi * 180
    if lineDir.z < 0 then
        yAngle = yAngle + 180
    end
    self.LineGO:GetComponent("Transform"):SetEulerAngles(0, yAngle, 0)

    local lineLength = Math.MagnitudeVec3(lineDir)
    self.LineGO:GetComponent("Transform"):SetLocalScale(0.1, 0.1, 0.1 * lineLength)

    self.LineGO:GetComponent("MeshRenderer"):GetMaterial():SetFloat("_Length", lineLength)

    -- Troop Model
    self.ModelGO = self.gameObject:FindChild("TroopModel")
    self.ModelTransform = self.ModelGO:GetComponent("Transform")
    self.ModelTransform:SetPosition(startPos)
    self.ModelTransform:SetEulerAngles(0, yAngle, 0)

    self.StartPos = { x = startPos.x, y = self.Height, z = startPos.z }
    self.EndPos = { x = endPos.x, y = self.Height, z = endPos.z }
    self.TotalTime = lineLength / self.Speed
    self.CurTime = 0
end

return Troop