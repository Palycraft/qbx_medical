local sharedConfig = require 'config.shared'
local vehicleDict = 'veh@low@front_ps@idle_duck'
local vehicleAnim = 'sit'
local LastStandCuffedDict = 'dead'
local LastStandCuffedAnim = 'dead_f'
local playerState = LocalPlayer.state

function PlayUnescortedLastStandAnimation(ped)
    ClearPedTasks(ped)

    SetFacialIdleAnimOverride(ped, 'dead_1', 0)

    while DeathState == sharedConfig.deathState.LAST_STAND do
        if cache.vehicle then
            lib.requestAnimDict(vehicleDict, 5000)
            if not IsEntityPlayingAnim(ped, vehicleDict, vehicleAnim, 3) then
                TaskPlayAnim(ped, vehicleDict, vehicleAnim, 1.0, 1.0, -1, 1, 0, false, false, false)
            end
        else
            local dict = not QBX.PlayerData.metadata.ishandcuffed and LastStandDict or LastStandCuffedDict
            local anim = not QBX.PlayerData.metadata.ishandcuffed and LastStandAnim or LastStandCuffedAnim
            lib.requestAnimDict(dict, 5000)
            if not IsEntityPlayingAnim(ped, dict, anim, 3) then
                TaskPlayAnim(ped, dict, anim, 1.0, 1.0, -1, 1, 0, false, false, false)
            end
        end

        Wait(0)
    end
end

---@param ped number
function PlayEscortedLastStandAnimation(ped)
    ClearPedTasks(ped)

    SetFacialIdleAnimOverride(ped, 'dead_1', 0)

    while DeathState == sharedConfig.deathState.LAST_STAND do
        if cache.vehicle then
            lib.requestAnimDict(vehicleDict, 5000)
            if IsEntityPlayingAnim(ped, vehicleDict, vehicleAnim, 3) then
                StopAnimTask(ped, vehicleDict, vehicleAnim, 3)
            end
        else
            local dict = not QBX.PlayerData.metadata.ishandcuffed and LastStandDict or LastStandCuffedDict
            local anim = not QBX.PlayerData.metadata.ishandcuffed and LastStandAnim or LastStandCuffedAnim
            lib.requestAnimDict(dict, 5000)
            if IsEntityPlayingAnim(ped, dict, anim, 3) then
                StopAnimTask(ped, dict, anim, 3)
            end
        end

        Wait(0)
    end
end

local function playLastStandAnimation()
    if playerState.isEscorted then
        PlayEscortedLastStandAnimation(cache.ped)
    else
        PlayUnescortedLastStandAnimation()
    end
end

exports('playLastStandAnimationDeprecated', playLastStandAnimation)
