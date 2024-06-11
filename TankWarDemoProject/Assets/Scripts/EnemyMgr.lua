local EnemyMgr = {}

EnemyMgr.MaxEnemyCount = 3
EnemyMgr.CurEnemyCount = 0

EnemyMgr.NewEnemyInterval = 5
EnemyMgr.TimeSinceLastEnemy = 0

EnemyMgr.ActiveEnemys = {}
EnemyMgr.InactiveEnemys = {}

function GetEnemyMgr()
    return EnemyMgr
end

function EnemyMgr:Init()
    self.EnemyPrefab = Resources.LoadPrefab("Prefabs/KenneyCastle/Ram.zxprefab")
    self:NewEnemy()
end

function EnemyMgr:Update()
    if self.CurEnemyCount < self.MaxEnemyCount then
        self.TimeSinceLastEnemy = self.TimeSinceLastEnemy + Time.GetDeltaTime()
        if self.TimeSinceLastEnemy > self.NewEnemyInterval then
            self:NewEnemy()
        end
    end
end

function EnemyMgr:NewEnemy()
    local enemy = self:GetNextEnemy()
    enemy:SetActive(true)
    local script = enemy:GetComponent("GameLogic"):GetScript()
    script:SetPos({ x = -8, y = 0, z = -8 })
    self.CurEnemyCount = self.CurEnemyCount + 1
    self.TimeSinceLastEnemy = 0
end

function EnemyMgr:GetNextEnemy()
    if #self.InactiveEnemys > 0 then
        local enemy = self.InactiveEnemys[1]
        table.remove(self.InactiveEnemys, 1)
        table.insert(self.ActiveEnemys, enemy)
        return enemy
    else
        local enemy = GameObject.CreateInstance(self.EnemyPrefab)
        table.insert(self.ActiveEnemys, enemy)
        return enemy
    end
end

function EnemyMgr:RecycleEnemy(enemy)
    enemy:SetActive(false)
    for i, v in ipairs(self.ActiveEnemys) do
        if v:IdenticalTo(enemy) then
            table.remove(self.ActiveEnemys, i)
            table.insert(self.InactiveEnemys, enemy)
            break
        end
    end
    self.CurEnemyCount = self.CurEnemyCount - 1
end