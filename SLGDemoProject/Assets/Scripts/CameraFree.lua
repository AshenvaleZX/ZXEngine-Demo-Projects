local CameraFree = NewGameLogic()

CameraFree.firstMouse = true
CameraFree.MouseSensitivity = 0.1
CameraFree.MovementSpeed = 25

function CameraFree:Start()
    self.trans = self.gameObject:GetComponent("Transform")
    EngineEvent:AddEventHandler(EngineEventType.MOUSE_BUTTON_2_DOWN, self.RegisterCameraControl, self)
    EngineEvent:AddEventHandler(EngineEventType.MOUSE_BUTTON_2_UP, self.UnregisterCameraControl, self)
end

function CameraFree:Update()

end

function CameraFree:RegisterCameraControl()
    self.firstMouse = true
    InputManager.ShowCursor(false)
    EngineEvent:AddEventHandler(EngineEventType.UPDATE_MOUSE_POS, self.MouseMoveCallBack, self)
    EngineEvent:AddEventHandler(EngineEventType.KEY_W_PRESS, self.MoveForwardCallBack, self)
    EngineEvent:AddEventHandler(EngineEventType.KEY_S_PRESS, self.MoveBackCallBack, self)
    EngineEvent:AddEventHandler(EngineEventType.KEY_A_PRESS, self.MoveLeftCallBack, self)
    EngineEvent:AddEventHandler(EngineEventType.KEY_D_PRESS, self.MoveRightCallBack, self)
end

function CameraFree:UnregisterCameraControl()
    InputManager.ShowCursor(true)
    EngineEvent:RemoveEventHandler(EngineEventType.UPDATE_MOUSE_POS, self.MouseMoveCallBack)
    EngineEvent:RemoveEventHandler(EngineEventType.KEY_W_PRESS, self.MoveForwardCallBack)
    EngineEvent:RemoveEventHandler(EngineEventType.KEY_S_PRESS, self.MoveBackCallBack)
    EngineEvent:RemoveEventHandler(EngineEventType.KEY_A_PRESS, self.MoveLeftCallBack)
    EngineEvent:RemoveEventHandler(EngineEventType.KEY_D_PRESS, self.MoveRightCallBack)
end

function CameraFree:MouseMoveCallBack(args)
    local argList = Utils.StringSplit(args, '|')
    local xpos = tonumber(argList[1])
    local ypos = tonumber(argList[2])
    if self.firstMouse then
        self.lastX = xpos
        self.lastY = ypos
        self.firstMouse = false
    end

    local xoffset = xpos - self.lastX
    local yoffset = self.lastY - ypos

    self.lastX = xpos
    self.lastY = ypos

    self:RotateAngleOfView(xoffset, yoffset)
end

function CameraFree:RotateAngleOfView(horizontalOffset, verticalOffset)
    horizontalOffset = horizontalOffset * self.MouseSensitivity
    verticalOffset = verticalOffset * self.MouseSensitivity

    local eulerAngle = self.trans:GetEulerAngles()
    eulerAngle.x = eulerAngle.x - verticalOffset
    eulerAngle.x = Math.Clamp(eulerAngle.x, -89, 89)
    eulerAngle.y = eulerAngle.y + horizontalOffset
    self.trans:SetEulerAngles(eulerAngle.x, eulerAngle.y, eulerAngle.z)
end

function CameraFree:MoveForwardCallBack()
    self:MoveCamera("Forward")
end

function CameraFree:MoveBackCallBack()
    self:MoveCamera("Back")
end

function CameraFree:MoveRightCallBack()
    self:MoveCamera("Right")
end

function CameraFree:MoveLeftCallBack()
    self:MoveCamera("Left")
end

function CameraFree:MoveCamera(dirName)
    local dir = {}
    if dirName == "Forward" then
        dir = self.trans:GetForward()
    elseif dirName == "Back" then
        dir = self.trans:GetForward()
        dir = {x = -dir.x, y = -dir.y, z = -dir.z}
    elseif dirName == "Right" then
        dir = self.trans:GetRight()
    elseif dirName == "Left" then
        dir = self.trans:GetRight()
        dir = {x = -dir.x, y = -dir.y, z = -dir.z}
    else
        return
    end

    local velocity = self.MovementSpeed * Time.GetDeltaTime()
    local pos = self.trans:GetPosition()
    pos = 
    {
        x = pos.x + dir.x * velocity,
        y = pos.y + dir.y * velocity,
        z = pos.z + dir.z * velocity,
    }
    self.trans:SetPosition(pos.x, pos.y, pos.z)
end

return CameraFree