-- Job Center
-- Tech Development - https://discord.gg/tHAbhd94vS

if Config.Framework == 'esx' then 
    ESX = exports.es_extended:getSharedObject()
elseif Config.Framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
end


Callback = function(name, ...)
    if Config.Framework == 'esx' then 
        ESX.TriggerServerCallback(name, ...)
    elseif Config.Framework == 'qbcore' then
        QBCore.Functions.TriggerCallback(name, ...)
    end
end

if Config.Framework == 'esx' then 
    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function(job)
        SendNUIMessage({
            type = "UPDATE_CURRENTJOB",
            myJob = job.name
        })
    end)
elseif Config.Framework == 'qbcore' then
    RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
        SendNUIMessage({
            type = "UPDATE_CURRENTJOB",
            myJob = val.job.name
        })
    end)
end


RegisterNUICallback('changeJob', function(data, cb)
    TriggerServerEvent('ricky-jobcenter:updateJob', data.job)
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
end)


OpenJobCenter = function()
    Callback('ricky-jobcenter:getData', function(myJob, name, avatar)
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = 'SET_CONFIG',
            config = Config
        })
        SendNUIMessage({
            type = 'OPEN',
            jobs = Config.Jobs,
            myJob = myJob,
            name = name,
            avatar = avatar
        })
    end)
end

local sleep = 1000
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(sleep)
    for k,v in pairs(Config.Coords) do 
      DrawMarker(1, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 1.0,1.0,0.5, 255, 255, 255, 100, 0, 0, 0, 0)
      local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x, v.y, v.z, true)
      if distance < 5.5 then
        sleep = 1
        ShowHelpNotification(Config.Lang[Config.Language]["open_menu"])
        if IsControlJustReleased(0, 38) then
          OpenJobCenter()
        end
      else
        sleep = 1000
      end
    end
   end
end)
