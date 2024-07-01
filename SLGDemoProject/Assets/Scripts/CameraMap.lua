local CameraMap = NewGameLogic()

CameraMap.ClickX = 0
CameraMap.ClickY = 0
CameraMap.TileClickBlock = false

CameraMap.HeightMin = 20
CameraMap.HeightZoomIn = 70
CameraMap.HeightZoomOut = 90
CameraMap.HeightMax = 100
CameraMap.HeightDefault = 50
CameraMap.LastHeight = 50

CameraMap.MoveSpeed = 0.056
CameraMap.MoveSpeedMin = 0.02
CameraMap.MoveSpeedMax = 0.08
CameraMap.ScrollSpeed = 3

CameraMap.CenterCoord = { x = 0, y = 0 }

-- 相机自动滑动(松手后的)
CameraMap.velocityX = 0
CameraMap.velocityY = 0
CameraMap.velocityMax = 12000
CameraMap.velocityXRatio = 0
CameraMap.velocityYRatio = 0
CameraMap.SlowDownAcceleration = 12000

-- 相机自动滑动(滑动至指定位置)
CameraMap.AutoMoveStep = 0 -- 0:未滑动 1:滑动中 2:缩放中
CameraMap.AutoMoveSpeed = 150
CameraMap.AutoMoveTime = 0
CameraMap.AutoMoveTotalTime = 0
CameraMap.AutoMoveOrigin = { x = 0, y = 0, z = 0 }
CameraMap.AutoMoveTarget = { x = 0, y = 0, z = 0 }
CameraMap.AutoZoomSpeed = 40

-- Z除以Y的比例
CameraMap.ZYRatio = 1

CameraMap.IsInit = false

function GetMapCamera()
    return CameraMap
end

function CameraMap:Start()
    self.ZYRatio = 1 / math.tan(50 * math.pi / 180)
    self.trans = self.gameObject:GetComponent("Transform")
    self.camera = self.gameObject:GetComponent("Camera")
    EngineEvent:AddEventHandler(EngineEventType.MOUSE_BUTTON_1_DOWN, self.OnMouseLeftPress, self)
    EngineEvent:AddEventHandler(EngineEventType.MOUSE_BUTTON_1_UP, self.OnMouseLeftRelease, self)
    EngineEvent:AddEventHandler(EngineEventType.MOUSE_BUTTON_1_PRESS, self.OnMouseMove, self)
    EngineEvent:AddEventHandler(EngineEventType.UPDATE_MOUSE_SCROLL, self.OnMouseScroll, self)

    self.FogPlane = GameObject.Create("Prefabs/FogPlane.zxprefab")
    self.FogPlaneTrans = self.FogPlane:GetComponent("Transform")
    self.TerrainPlaneTrans = GameObject.Find("MapRoot/MapBase"):GetComponent("Transform")
    
    self.IsInit = true
    if GetMapUIMgr().IsInit then
        self:UpdateCurLookTilePos()
        GetMapUIMgr():SetCenterCoordinate(self.CenterCoord.x, self.CenterCoord.y)
    end
end

function CameraMap:Update()
    local dt = Time.GetDeltaTime()
    self:CheckAutoMove(dt)
end

function CameraMap:OnMouseLeftPress(args)
    local argList = Utils.StringSplit(args, '|')
    self.ClickX = tonumber(argList[1])
    self.ClickY = tonumber(argList[2])

    self.firstMouse = true
end

function CameraMap:OnMouseLeftRelease(args)
    -- 点击UI
    if self.TileClickBlock then
        self.TileClickBlock = false
        return
    end

    local argList = Utils.StringSplit(args, '|')
    local xPos = tonumber(argList[1])
    local yPos = tonumber(argList[2])

    if math.abs(xPos - self.ClickX) < 5 and math.abs(yPos - self.ClickY) < 5 then
        -- 已经选中地块的情况下，点任意位置取消选中
        if GetMapMgr():IsTileSelected() then
            GetMapMgr():UnSelectTile()
            return
        end

        local pos = { x = xPos, y = yPos }
        local ray = self.camera:ScreenPointToRay(pos)

        -- 自动移动到指定位置
        if self.LastHeight > self.HeightZoomIn then
            local rPos = ray:GetOrigin()
            local rDir = ray:GetDirection()

            local t = -rPos.y / rDir.y
            local intersecX = rPos.x + t * rDir.x
            local intersecZ = rPos.z + t * rDir.z

            local curPos = self.trans:GetPosition()
            local zOffset = curPos.y * self.ZYRatio

            self.AutoMoveOrigin = curPos
            self.AutoMoveTarget = { x = intersecX, y = curPos.y, z = intersecZ - zOffset }

            local dis = math.sqrt((curPos.x - self.AutoMoveTarget.x) * (curPos.x - self.AutoMoveTarget.x) + (curPos.z - self.AutoMoveTarget.z) * (curPos.z - self.AutoMoveTarget.z))
            self.AutoMoveTotalTime = dis / self.AutoMoveSpeed
            self.AutoMoveTime = 0

            self.AutoMoveStep = 1

            -- 停止拖动的自动滑动
            self.velocityX = 0
            self.velocityY = 0
        -- 点击地块
        else
            for k,v in pairs(GetMapMgr().AllTiles) do
                local intersection = v.tileGO:GetComponent("Collider"):IntersectRay(ray)
                if intersection then
                    GetMapMgr():SelectTile(v)
                    GetMapUIMgr():SelectTile(v)
                    break
                end
            end
        end
    end

    self.isDragging = false
end

function CameraMap:OnMouseMove(args)
    local argList = Utils.StringSplit(args, '|')
    local xPos = tonumber(argList[1])
    local yPos = tonumber(argList[2])

    if not self.isDragging then
        if math.abs(xPos - self.ClickX) < 5 and math.abs(yPos - self.ClickY) < 5 then
            return
        else
            self.isDragging = true
        end
    end

    if self.firstMouse then
        self.lastX = xPos
        self.lastY = yPos
        self.firstMouse = false
    end

    local xOffset = xPos - self.lastX
    local yOffset = self.lastY - yPos

    self.velocityX = xOffset / Time.GetDeltaTime()
    self.velocityY = yOffset / Time.GetDeltaTime()

    local velocity = math.sqrt(self.velocityX * self.velocityX + self.velocityY * self.velocityY)
    self.velocityXRatio = self.velocityX / velocity
    self.velocityYRatio = self.velocityY / velocity

    -- 速度限制
    if self.velocityMax < velocity then
        self.velocityX = self.velocityXRatio * self.velocityMax
        self.velocityY = self.velocityYRatio * self.velocityMax
    end
    self.SlowDownAcceleration = 2 * velocity

    self.lastX = xPos
    self.lastY = yPos

    self:MoveCamera(xOffset, yOffset)
end

function CameraMap:MoveCamera(xOffset, yOffset)
    local velocity = self.MoveSpeed
    local pos = self.trans:GetPosition()
    pos = 
    {
        x = pos.x - xOffset * velocity,
        y = pos.y,
        z = pos.z - yOffset * velocity,
    }

    self:UpdatePositon(pos)
end

function CameraMap:CheckAutoMove(dt)
    -- 自动移动
    if self.AutoMoveStep > 0 then
        if self.AutoMoveStep == 1 then
            self.AutoMoveTime = self.AutoMoveTime + dt

            if self.AutoMoveTime >= self.AutoMoveTotalTime then
                local pos = { x = self.AutoMoveTarget.x, y = self.AutoMoveTarget.y, z = self.AutoMoveTarget.z }
                self:UpdatePositon(pos)
                self.AutoMoveStep = 2
            else
                local pos = Math.LerpVec3(self.AutoMoveOrigin, self.AutoMoveTarget, self.AutoMoveTime / self.AutoMoveTotalTime)
                self:UpdatePositon(pos)
            end
        elseif self.AutoMoveStep == 2 then
            local pos = self:OnMouseScroll(self.AutoZoomSpeed * dt)
            if pos.y < self.HeightDefault then
                self.AutoMoveStep = 0
            end
        end
    -- 松手后的自动滑动
    else
        if self.isDragging or (self.velocityX == 0 and self.velocityY == 0) then
            return
        end

        local xOffset = self.velocityX * dt
        local yOffset = self.velocityY * dt

        self:MoveCamera(xOffset, yOffset)

        if self.SlowDownAcceleration > 10 then
            self.SlowDownAcceleration = self.SlowDownAcceleration - self.SlowDownAcceleration * dt
            if self.SlowDownAcceleration < 10 then
                self.SlowDownAcceleration = 10
            end
        end

        self.velocityX = self.velocityX - self.velocityXRatio * self.SlowDownAcceleration * dt
        if self.velocityXRatio > 0 and self.velocityX < 0.1 then
            self.velocityX = 0
        elseif self.velocityXRatio < 0 and self.velocityX > -0.1 then
            self.velocityX = 0
        end

        self.velocityY = self.velocityY - self.velocityYRatio * self.SlowDownAcceleration * dt
        if self.velocityYRatio > 0 and self.velocityY < 0.1 then
            self.velocityY = 0
        elseif self.velocityYRatio < 0 and self.velocityY > -0.1 then
            self.velocityY = 0
        end
    end
end

function CameraMap:OnMouseScroll(args)
    local delta = tonumber(args)
    local dis = delta * self.ScrollSpeed
    local pos = self.trans:GetPosition()
    local forward = self.trans:GetForward()
    pos = 
    {
        x = pos.x + forward.x * dis,
        y = pos.y + forward.y * dis,
        z = pos.z + forward.z * dis,
    }
    
    if pos.y < self.HeightMin or pos.y > self.HeightMax then
        return
    end

    if pos.y > self.HeightZoomIn and pos.y < self.HeightZoomOut then
        local scale = (pos.y - self.HeightZoomIn) / (self.HeightZoomOut - self.HeightZoomIn)
        GetMapMgr():SetAllTileIconsScale(scale)
        scale = 1 - scale
        GetMapMgr():SetAllTilesScale(scale)
    end

    -- 退出中间态，进入缩放地图
    if self.LastHeight < self.HeightZoomOut and pos.y >= self.HeightZoomOut then
        GetMapMgr():SetAllTilesActive(false)
        GetMapMgr():SetAllTileIconsScale(1)
    -- 进入中间态，退出缩放地图
    elseif self.LastHeight >= self.HeightZoomOut and pos.y < self.HeightZoomOut then
        GetMapMgr():SetAllTilesActive(true)
    -- 进入中间态，退出普通地图
    elseif self.LastHeight < self.HeightZoomIn and pos.y >= self.HeightZoomIn then
        GetMapMgr():SetAllTileIconsActive(true)
    -- 退出中间态，进入普通地图
    elseif self.LastHeight >= self.HeightZoomIn and pos.y < self.HeightZoomIn then
        GetMapMgr():SetAllTileIconsActive(false)
        GetMapMgr():SetAllTilesScale(1)
    end
    self.LastHeight = pos.y

    self.trans:SetPosition(pos.x, pos.y, pos.z)
    self.MoveSpeed = Math.Lerp(self.MoveSpeedMin, self.MoveSpeedMax, (pos.y - self.HeightMin) / (self.HeightMax - self.HeightMin))

    return pos
end

function CameraMap:UpdateCurLookTilePos()
    local pos = self.trans:GetPosition()
    pos.z = pos.z + pos.y * self.ZYRatio
    self.CenterCoord = GetMapMgr():PosToLogicIndex(pos)
end

function CameraMap:UpdatePositon(pos)
    self.trans:SetPosition(pos.x, pos.y, pos.z)

    pos.z = pos.z + pos.y * self.ZYRatio

    self.FogPlaneTrans:SetPosition(pos.x, 10, pos.z)
    self.TerrainPlaneTrans:SetPosition(pos.x, 0, pos.z)

    self.CenterCoord = GetMapMgr():PosToLogicIndex(pos)
    GetMapUIMgr():SetCenterCoordinate(self.CenterCoord.x, self.CenterCoord.y)
end

return CameraMap