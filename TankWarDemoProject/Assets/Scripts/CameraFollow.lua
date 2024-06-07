local CameraFollow = NewGameLogic()

CameraFollow.inited = false

function CameraFollow:Start()
    self.trans = self.gameObject:GetComponent("Transform")
end

function CameraFollow:Update()
    if self.inited then
        local pos = self.Tank:GetComponent("Transform"):GetPosition()
        self.trans:SetPosition(pos.x, pos.y + 15, pos.z)
    else
        self.Tank = GameObject.Find("Ballista")
        if self.Tank then
            self.inited = true
        end
    end
end

return CameraFollow