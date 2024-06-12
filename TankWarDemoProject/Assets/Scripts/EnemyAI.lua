local EnemyAI = NewGameLogic()

EnemyAI.CollisionSize = 0.6
EnemyAI.CurPos = { x = 0, y = 0, z = 0 }
EnemyAI.CurDir = { x = 1, y = 0, z = 0 }
EnemyAI.MoveSpeed = 2

EnemyAI.PathList = {}
EnemyAI.LastPos = { x = 0, z = 0 }
EnemyAI.NextPos = nil
EnemyAI.CurDirName = ""

EnemyAI.FireTime = 0
EnemyAI.FireInterval = 2

function EnemyAI:Start()
    self.trans = self.gameObject:GetComponent("Transform")
    self.CurPos = self.trans:GetPosition()
    self.LastPos = { x = math.floor(self.CurPos.x + 0.5), z = math.floor(self.CurPos.z + 0.5) }

    self:UpdatePath()
    self:UpdateNextPos()
end

function EnemyAI:SetPos(pos)
    if self.trans then
        self.trans:SetPosition(pos)
        self.CurPos = pos
        self.LastPos = { x = math.floor(self.CurPos.x + 0.5), z = math.floor(self.CurPos.z + 0.5) }
    end
end

function EnemyAI:Update()
    if GetGameMgr().Paused then
        return
    end
    
    self:Move(self.CurDirName)

    if self.CurDirName == "Right" then
        if self.CurPos.x > self.NextPos.x then
            self:UpdateNextPos()
        end
    elseif self.CurDirName == "Left" then
        if self.CurPos.x < self.NextPos.x then
            self:UpdateNextPos()
        end
    elseif self.CurDirName == "Up" then
        if self.CurPos.z > self.NextPos.z then
            self:UpdateNextPos()
        end
    elseif self.CurDirName == "Down" then
        if self.CurPos.z < self.NextPos.z then
            self:UpdateNextPos()
        end
    end

    self.FireTime = self.FireTime + Time.GetDeltaTime()
    if self.FireTime >= self.FireInterval then
        self:Fire()
        self.FireTime = 0
    end
end

function EnemyAI:UpdateNextPos()
    if #self.PathList > 0 then
        if self.NextPos then
            self.LastPos = self.NextPos
        end
        self.NextPos = self.PathList[#self.PathList]
        table.remove(self.PathList, #self.PathList)

        if self.NextPos.x > self.LastPos.x then
            self.CurDirName = "Right"
        elseif self.NextPos.x < self.LastPos.x then
            self.CurDirName = "Left"
        elseif self.NextPos.z > self.LastPos.z then
            self.CurDirName = "Up"
        elseif self.NextPos.z < self.LastPos.z then
            self.CurDirName = "Down"
        end
    else
        self:UpdatePath()
        self:UpdateNextPos()
    end
end

function EnemyAI:UpdatePath()
    local valideSize = MapConfig.Size - 1

    local curCoord = 
    {
        x = math.floor(self.CurPos.x + 0.5),
        z = math.floor(self.CurPos.z + 0.5)
    }

    local destination = 
    {
        x = math.random(-valideSize, valideSize),
        z = math.random(-valideSize, valideSize)
    }

    -- 随机生成一个目标点，直到目标点是合法的，且不是当前位置
    while not (GetMapMgr():ValidatePos(destination) and (curCoord.x ~= destination.x or curCoord.z ~= destination.z)) do
        destination = 
        {
            x = math.random(-valideSize, valideSize),
            z = math.random(-valideSize, valideSize)
        }
    end

    self.PathList = AStar.GetPathList(curCoord, destination)
end

function EnemyAI:Fire()
    GetCannonMgr():FireCannon(self.CurPos, self.CurDir, GlobalConst.CANNON_ENEMY)
end

function EnemyAI:Move(dirName)
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
    
    self.CurPos = newPos
    self.trans:SetPosition(self.CurPos)
end

return EnemyAI