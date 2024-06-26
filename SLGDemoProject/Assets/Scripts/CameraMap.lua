local CameraMap = NewGameLogic()

CameraMap.ClickX = 0
CameraMap.ClickY = 0
CameraMap.TileClickBlock = false

CameraMap.HeightMin = 20
CameraMap.HeightMax = 70

CameraMap.MoveSpeed = 0.056
CameraMap.MoveSpeedMin = 0.02
CameraMap.MoveSpeedMax = 0.08
CameraMap.ScrollSpeed = 3

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
    
    self.IsInit = true
    if GetMapUIMgr().IsInit then
        local coord = self:GetCurLookTilePos()
        GetMapUIMgr():SetCenterCoordinate(coord.x, coord.y)
    end
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

        for k,v in pairs(GetMapMgr().AllTiles) do
            local intersection = v.tileGO:GetComponent("Collider"):IntersectRay(ray)
            if intersection then
                GetMapMgr():SelectTile(v)
                GetMapUIMgr():SelectTile(v)
                break
            end
        end
    end

    self.isMoving = false
end

function CameraMap:OnMouseMove(args)
    local argList = Utils.StringSplit(args, '|')
    local xPos = tonumber(argList[1])
    local yPos = tonumber(argList[2])

    if not self.isMoving then
        if math.abs(xPos - self.ClickX) < 5 and math.abs(yPos - self.ClickY) < 5 then
            return
        else
            self.isMoving = true
        end
    end

    if self.firstMouse then
        self.lastX = xPos
        self.lastY = yPos
        self.firstMouse = false
    end

    local xOffset = xPos - self.lastX
    local yOffset = self.lastY - yPos

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
    self.trans:SetPosition(pos.x, pos.y, pos.z)

    pos.z = pos.z + pos.y * self.ZYRatio
    local centerCoord = GetMapMgr():PosToLogicIndex(pos)
    GetMapUIMgr():SetCenterCoordinate(centerCoord.x, centerCoord.y)
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

    self.trans:SetPosition(pos.x, pos.y, pos.z)
    self.MoveSpeed = Math.Lerp(self.MoveSpeedMin, self.MoveSpeedMax, (pos.y - self.HeightMin) / (self.HeightMax - self.HeightMin))
end

function CameraMap:GetCurLookTilePos()
    local pos = self.trans:GetPosition()
    pos.z = pos.z + pos.y * self.ZYRatio
    return GetMapMgr():PosToLogicIndex(pos)
end

return CameraMap