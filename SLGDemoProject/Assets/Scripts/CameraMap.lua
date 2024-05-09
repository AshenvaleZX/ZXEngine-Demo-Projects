local CameraMap = NewGameLogic()

CameraMap.ClickX = 0
CameraMap.ClickY = 0
CameraMap.ScrollSpeed = 500
CameraMap.MovementSpeed = 25

function CameraMap:Start()
    self.trans = self.gameObject:GetComponent("Transform")
    self.camera = self.gameObject:GetComponent("Camera")
    EngineEvent:AddEventHandler(EngineEventType.MOUSE_BUTTON_1_DOWN, self.OnMouseLeftPress, self)
    EngineEvent:AddEventHandler(EngineEventType.MOUSE_BUTTON_1_UP, self.OnMouseLeftRelease, self)
    EngineEvent:AddEventHandler(EngineEventType.UPDATE_MOUSE_POS, self.OnMouseMove, self)
    EngineEvent:AddEventHandler(EngineEventType.UPDATE_MOUSE_SCROLL, self.OnMouseScroll, self)
end

function CameraMap:OnMouseLeftPress(args)
    local argList = Utils.StringSplit(args, '|')
    self.ClickX = tonumber(argList[1])
    self.ClickY = tonumber(argList[2])

    self.isMoving = true
    self.firstMouse = true
end

function CameraMap:OnMouseLeftRelease(args)
    local argList = Utils.StringSplit(args, '|')
    local xPos = tonumber(argList[1])
    local yPos = tonumber(argList[2])

    if math.abs(xPos - self.ClickX) < 5 and math.abs(yPos - self.ClickY) < 5 then
        local pos = { x = xPos, y = yPos }
        local ray = self.camera:ScreenPointToRay(pos)

        for k,v in pairs(GetMapMgr().AllTiles) do
            local intersection = v:GetComponent("Collider"):IntersectRay(ray)
            if intersection then
                GetMapMgr():SelectTile(v)
                break
            end
        end
    end

    self.isMoving = false
end

function CameraMap:OnMouseMove(args)
    if not self.isMoving then
        return
    end

    local argList = Utils.StringSplit(args, '|')
    local xPos = tonumber(argList[1])
    local yPos = tonumber(argList[2])

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
    local velocity = self.MovementSpeed * Time.GetDeltaTime()
    local pos = self.trans:GetPosition()
    pos = 
    {
        x = pos.x - xOffset * velocity,
        y = pos.y,
        z = pos.z - yOffset * velocity,
    }
    self.trans:SetPosition(pos.x, pos.y, pos.z)
end

function CameraMap:OnMouseScroll(args)
    local delta = tonumber(args)
    local dis = delta * self.ScrollSpeed * Time.GetDeltaTime()
    local pos = self.trans:GetPosition()
    local forward = self.trans:GetForward()
    pos = 
    {
        x = pos.x + forward.x * dis,
        y = pos.y + forward.y * dis,
        z = pos.z + forward.z * dis,
    }
    self.trans:SetPosition(pos.x, pos.y, pos.z)
end

return CameraMap