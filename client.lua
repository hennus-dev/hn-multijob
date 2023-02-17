QBCore = exports['qb-core']:GetCoreObject()

local Jobs = {}
local PlayerData = nil
local focus = false
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.TriggerCallback('hn-multijob:server:getjobs', function(result)
        Jobs = result
    end)
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
    if Jobs['jobs'] ~= nil then
        Jobs['jobs'][JobInfo.name] = {grade = JobInfo.grade.level, label = JobInfo.label}
    else
        Jobs['jobs'] = {}
        Jobs['jobs'][JobInfo.name] = {grade = JobInfo.grade.level, label = JobInfo.label}
    end
    Jobs['active'] = JobInfo.name
    TriggerServerEvent('hn-multijob:server:savejobs', Jobs)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    TriggerServerEvent('hn-multijob:server:savejobs', Jobs)
    Jobs = {}
    PlayerData = nil
end)

RegisterNetEvent('hn-multijob:client:udpate', function(jb)
    Jobs = jb
end)

RegisterNUICallback('selectJob', function(job, cb)
    Jobs['active'] = job
    cb(Jobs)
    -- setjob 
    TriggerServerEvent('hn-multijob:server:setjob', Jobs, job)
    TriggerServerEvent('hn-multijob:server:savejobs', Jobs)
end)

DisableControl = function()
    while focus do 
        if not focus then
            break
        end
        DisableControlAction(0, 1, focus)
        DisableControlAction(0, 2, focus) 
        DisableControlAction(0, 142, focus)
        DisableControlAction(0, 18, focus)
        DisableControlAction(0, 322, focus)
        DisableControlAction(0, 106, focus) 
        DisableControlAction(0, 114, focus)
        DisableControlAction(0, 176, focus)
        DisableControlAction(0, 177, focus)
        DisableControlAction(0, 222, focus)
        DisableControlAction(0, 223, focus)
        DisableControlAction(0, 225, focus)
        DisableControlAction(0, 257, focus)
        DisableControlAction(0, 24, focus)
        DisableControlAction(0, 25, focus)
        DisableControlAction(0, 192, focus)
        DisableControlAction(0, 37, focus)
        DisableControlAction(0, 289, focus)
        DisableControlAction(0, 288, focus)
        DisableControlAction(0, 45, focus)
        DisableControlAction(0, 140, focus)
        DisableControlAction(0, 141, focus)
        DisableControlAction(0, 44, focus)
        DisableControlAction(0, 23, focus)
        DisableControlAction(0, 47, focus)
        Wait (1)
    end
end

function OpenMenu(bool)
    focus = bool
    SetNuiFocus(bool, bool)
    CreateThread(DisableControl)
    SetNuiFocusKeepInput(bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
        jobs = Jobs
    })
end

RegisterCommand(Config.CommandMenu, function()
    if #Jobs == 0 then
        if PlayerData == nil then  PlayerData = QBCore.Functions.GetPlayerData() end
        QBCore.Functions.TriggerCallback('hn-multijob:server:getjobs', function(result)
            Jobs = result
        end)
        Wait(200)
        return  OpenMenu(not focus)

    end
    OpenMenu(not focus)
end)

