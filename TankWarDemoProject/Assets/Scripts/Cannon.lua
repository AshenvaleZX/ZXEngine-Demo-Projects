local Cannon = NewGameLogic()

Cannon.CurPos = { x = 0, y = 0, z = 0 }
Cannon.MoveDir = { x = 0, y = 0, z = 0 }
Cannon.MoveSpeed = 4

function Cannon:Start()
    self.trans = self.gameObject:GetComponent("Transform")
end

function Cannon:Update()
    local velocity = self.MoveSpeed * Time.GetDeltaTime()
    self.CurPos = 
    {
        x = self.CurPos.x + self.MoveDir.x * velocity,
        y = 0.3,
        z = self.CurPos.z + self.MoveDir.z * velocity,
    }

    self.trans:SetPosition(self.CurPos)

    if self:CheckCollision() then
        GetCannonMgr():RecycleCannon(self.gameObject)
    end
end

function Cannon:CheckCollision()
    local borderCheckSize = MapConfig.Size - 0.5
    if self.CurPos.x < -borderCheckSize or self.CurPos.x > borderCheckSize or self.CurPos.z < -borderCheckSize or self.CurPos.z > borderCheckSize then
        return true
    end

    for k,v in pairs(GetMapMgr().AllBuildings) do
        if math.abs(self.CurPos.x - v.pos.x) < 0.4 and math.abs(self.CurPos.z - v.pos.y) < 0.4 then
            return true
        end
    end

    return false
end

return Cannon