QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('hn-multijob:server:getjobs', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Jobs = {}
    local err = false
    local result = MySQL.Sync.fetchAll('SELECT * FROM `hn_multijob` WHERE `id` = @citizenid', {['@citizenid'] = Player.PlayerData.citizenid})
    if result[1] ~= nil then
        Jobs['jobs'] = {}
        for k, v in pairs(result[1]) do
            if k == 'jobs' then
                local job, check = CheckMaxJobs(json.decode(v))
                Jobs['jobs'] = job
                print(check)
                if check > Config.maxJobs then
                    TriggerClientEvent('QBCore:Notify', src, 'Bugg detected, please contact a developer', 'error')
                    err = true
                end

            end
            if k =='active' then
                if Player.PlayerData.job.name ~= 'unemployed' then
                    Jobs['active'] = Player.PlayerData.job.name
                else
                    Jobs['active'] = v
                end
            end
            if err then 
                TriggerEvent('hn-multijob:server:savejobs', Jobs, src)
            end

        end
        if Player.PlayerData.job.name ~= 'unemployed' then
            Jobs['jobs'][Player.PlayerData.job.name] = {}
            Jobs['jobs'][Player.PlayerData.job.name].grade = Player.PlayerData.job.grade.level
            Jobs['jobs'][Player.PlayerData.job.name].label = Player.PlayerData.job.label
        end

        TriggerEvent('hn-multijob:server:savejobs', Jobs, src)
    elseif Player.PlayerData.job.name ~= 'unemployed' then
        Jobs['jobs'] = {}
        Jobs['jobs'][Player.PlayerData.job.name] = {}
            Jobs['jobs'][Player.PlayerData.job.name].grade = Player.PlayerData.job.grade.level
            Jobs['jobs'][Player.PlayerData.job.name].label = Player.PlayerData.job.label
        Jobs['active'] = Player.PlayerData.job.name
        TriggerEvent('hn-multijob:server:savejobs', Jobs, src)
    end
    cb(Jobs)
end)

RegisterNetEvent('hn-multijob:server:savejobs', function(jobs, id)
    local src = tonumber(id) or source
    local Player = QBCore.Functions.GetPlayer(src)
    local keys = {'id', 'jobs', 'active'}
    local keyvalues = {'@citizenid', '@jobs', '@active'}
    local values = {['@citizenid'] = Player.PlayerData.citizenid, ['@jobs'] = json.encode(jobs['jobs']), ['@active'] = jobs['active']}
    local duplicateupdate = 'id=@citizenid, jobs = @jobs, active = @active'
    MySQL.Async.execute('INSERT INTO `hn_multijob` ('..table.concat(keys, ',')..') VALUES ('..table.concat(keyvalues, ',')..') ON DUPLICATE KEY UPDATE '..duplicateupdate, values)
end)

RegisterNetEvent('hn-multijob:server:setjob', function(Jbos,job)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.SetJob(job, Jbos.jobs[job].grade)

end)

QBCore.Commands.Add("addjobs", "ADD Job Menu", {{name= 'id', help='Player ID'},{name = 'job', help= 'job name'},  {name= 'grade', help= 'job grade'}}, true, function(source, args)
    local src =  source
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]) or src)
    local Jobs = {}
    Jobs['jobs'] = {}
    if not  QBCore.Shared.Jobs[tostring(args[2])] then return TriggerClientEvent('QBCore:Notify', src, 'Job does not exist', 'error') end
    local result = MySQL.Sync.fetchAll('SELECT * FROM `hn_multijob` WHERE `id` = @citizenid', {['@citizenid'] = Player.PlayerData.citizenid})
    if result[1] ~= nil then
        for k, v in pairs(result[1]) do
            if k == 'jobs' then
                Jobs['jobs'], check = CheckMaxJobs(json.decode(v))
                if check >= Config.maxJobs then
                    return TriggerClientEvent('QBCore:Notify', src, 'Max Jobs reached', 'error')
                end
                Jobs['jobs'][tostring(args[2])] = tonumber(args[3])
                Jobs['jobs'][tostring(args[2])] = {}
                Jobs['jobs'][tostring(args[2])].grade =  tonumber(args[3])
                Jobs['jobs'][tostring(args[2])].label =  QBCore.Shared.Jobs[tostring(args[2])].label
            end 
            if k =='active' then
                Jobs['active'] = Player.PlayerData.job.name
            end
        end
    end
    TriggerEvent('hn-multijob:server:savejobs', Jobs, tonumber(args[1]) or src)
    TriggerClientEvent('QBCore:Notify', src, 'Job Added', 'success')
    TriggerClientEvent('hn-multijob:client:udpate', Jobs)
end, 'admin')

function CheckMaxJobs(table)
    local count = 0
    for k, v in pairs(table) do
        count = count + 1
    end
    if count > Config.maxJobs then
        local newtable = {}
        local i = 1
        for k, v in pairs(table) do
            if i <= Config.maxJobs then
                newtable[k] = v
            end
            i = i + 1
        end
        return newtable, count
    else
        return table, count
    end
end