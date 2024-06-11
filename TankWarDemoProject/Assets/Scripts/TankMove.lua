local TankMove = NewGameLogic()

TankMove.CollisionSize = 0.6
TankMove.CurPos = { x = 0, y = 0, z = 0 }
TankMove.CurDir = { x = 1, y = 0, z = 0 }
TankMove.MoveSpeed = 2
TankMove.MoveDirStack = {}

function GetTank()
    return TankMove
end

function TankMove:Start()
    self.trans = self.gameObject:GetComponent("Transform")
    self.CurPos = self.trans:GetPosition()

    EngineEvent:AddEventHandler(EngineEventType.KEY_W_DOWN, self.PushMoveDir, self, "Up")
    EngineEvent:AddEventHandler(EngineEventType.KEY_S_DOWN, self.PushMoveDir, self, "Down")
    EngineEvent:AddEventHandler(EngineEventType.KEY_A_DOWN, self.PushMoveDir, self, "Left")
    EngineEvent:AddEventHandler(EngineEventType.KEY_D_DOWN, self.PushMoveDir, self, "Right")

    EngineEvent:AddEventHandler(EngineEventType.KEY_W_UP, self.PopMoveDir, self, "Up")
    EngineEvent:AddEventHandler(EngineEventType.KEY_S_UP, self.PopMoveDir, self, "Down")
    EngineEvent:AddEventHandler(EngineEventType.KEY_A_UP, self.PopMoveDir, self, "Left")
    EngineEvent:AddEventHandler(EngineEventType.KEY_D_UP, self.PopMoveDir, self, "Right")

    EngineEvent:AddEventHandler(EngineEventType.KEY_SPACE_UP, self.Fire, self)
end

function TankMove:Update()
    if #self.MoveDirStack > 0 then
        self:Move(self.MoveDirStack[1])
    end
end

function TankMove:PushMoveDir(engine, dir)
    table.insert(self.MoveDirStack, 1, dir)
end

function TankMove:PopMoveDir(engine, dir)
    for i,v in ipairs(self.MoveDirStack) do
        if v == dir then
            table.remove(self.MoveDirStack, i)
            break
        end
    end
end

function TankMove:Fire()
    GetCannonMgr():FireCannon(self.CurPos, self.CurDir, GlobalConst.CANNON_MINE)
end

function TankMove:Move(dirName)
    local rot = 0
    if dirName == "Up" then
        rot = -90
        self.CurDir = { x =  0, y = 0, z =  1 }
    elseif dirName == "Down" then
        rot = 90
        self.CurDir = { x =  0, y = 0, z = -1 }
    elseif dirName == "Right" then
        rot = 0
        self.CurDir = { x =  1, y = 0, z =  0 }
    elseif dirName == "Left" then
        rot = 180
        self.CurDir = { x = -1, y = 0, z =  0 }
    else
        return
    end

    self.trans:SetEulerAngles(0, rot, 0)

    local velocity = self.MoveSpeed * Time.GetDeltaTime()
    local newPos = 
    {
        x = self.CurPos.x + self.CurDir.x * velocity,
        y = self.CurPos.y + self.CurDir.y * velocity,
        z = self.CurPos.z + self.CurDir.z * velocity,
    }
    
    if self:CheckCollision(newPos) then
        return
    end

    self.CurPos = newPos
    self.trans:SetPosition(self.CurPos)
end

function TankMove:CheckCollision(pos)
    local borderCheckSize = MapConfig.Size - 0.5 - self.CollisionSize
    if pos.x < -borderCheckSize or pos.x > borderCheckSize or pos.z < -borderCheckSize or pos.z > borderCheckSize then
        return true
    end

    for k,v in pairs(GetMapMgr().AllBuildings) do
        if math.abs(pos.x - v.pos.x) < (0.4 + self.CollisionSize) and math.abs(pos.z - v.pos.y) < (0.4 + self.CollisionSize) then
            return true
        end
    end

    return false
end

function TankMove:OnHit()
    self.trans:SetPosition(0, 0, -3)
    self.CurPos = { x = 0, y = 0, z = -3 }
end

return TankMove