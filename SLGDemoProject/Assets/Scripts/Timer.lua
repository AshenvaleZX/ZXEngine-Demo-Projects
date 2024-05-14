Timer = {}

Timer.mOneTimeCallBackList = {}
Timer.mIntervalCallBackList = {}

function Timer:AddOneTimeCallBack(callback, delay)
    local idx = 0
    while true do
        if self.mOneTimeCallBackList[idx] == nil then
            self.mOneTimeCallBackList[idx] = { callback = callback, delay = delay, lastTime = 0 }
            return idx
        else
            idx = idx + 1
        end
    end
end

function Timer:RemoveOneTimeCallBack(idx)
    self.mOneTimeCallBackList[idx] = nil
end

function Timer:AddIntervalCallBack(callback, interval)
    local idx = 0
    while true do
        if self.mIntervalCallBackList[idx] == nil then
            self.mIntervalCallBackList[idx] = { callback = callback, interval = interval, lastTime = 0 }
            return idx
        else
            idx = idx + 1
        end
    end
end

function Timer:RemoveIntervalCallBack(idx)
    self.mIntervalCallBackList[idx] = nil
end

function Timer:Update()
    local dt = Time.GetDeltaTime()

    for k, v in pairs(self.mOneTimeCallBackList) do
        v.lastTime = v.lastTime + dt
        if v.lastTime >= v.delay then
            v.callback()
            self.mOneTimeCallBackList[k] = nil
        end
    end

    for k, v in pairs(self.mIntervalCallBackList) do
        v.lastTime = v.lastTime + dt
        if v.lastTime >= v.interval then
            v.callback()
            v.lastTime = 0
        end
    end
end