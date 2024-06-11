local CannonMgr = {}

CannonMgr.ActiveCannons = {}
CannonMgr.InactiveCannons = {}

function GetCannonMgr()
    return CannonMgr
end

function CannonMgr:Init()
    self.CannonPrefab = Resources.LoadPrefab("Prefabs/Cannon.zxprefab")
end

function CannonMgr:FireCannon(pos, dir, type)
    local cannon = self:GetNextCannon()
    cannon:SetActive(true)
    local script = cannon:GetComponent("GameLogic"):GetScript()
    script.Type = type
    script.CurPos = pos
    script.MoveDir = dir
end

function CannonMgr:GetNextCannon()
    if #self.InactiveCannons > 0 then
        local cannon = self.InactiveCannons[1]
        table.remove(self.InactiveCannons, 1)
        table.insert(self.ActiveCannons, cannon)
        return cannon
    else
        local cannon = GameObject.CreateInstance(self.CannonPrefab)
        table.insert(self.ActiveCannons, cannon)
        return cannon
    end
end

function CannonMgr:RecycleCannon(cannon)
    cannon:SetActive(false)
    for i, v in ipairs(self.ActiveCannons) do
        if v:IdenticalTo(cannon) then
            table.remove(self.ActiveCannons, i)
            table.insert(self.InactiveCannons, cannon)
            break
        end
    end
end