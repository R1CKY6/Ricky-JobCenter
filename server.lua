-- Job Center
-- Tech Development - https://discord.gg/tHAbhd94vS

if Config.Framework == 'esx' then 
    ESX = exports.es_extended:getSharedObject()
elseif Config.Framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
end

CreateCallback = function(name, cb)
    if Config.Framework == 'esx' then 
        ESX.RegisterServerCallback(name, cb)
    elseif Config.Framework == 'qbcore' then
        QBCore.Functions.CreateCallback(name, cb)
    end
end

GetDiscordId = function(source)
    local discord  = false

  for k,v in pairs(GetPlayerIdentifiers(source))do
        
      if string.sub(v, 1, string.len("discord:")) == "discord:" then
        discord = string.gsub(v, "discord:", "")
      end
    
  end

  return discord
end

GetPlayerAvatar = function(id)
    local url = nil
    PerformHttpRequest("https://discord.com/api/v8/users/"..tonumber(GetDiscordId(id)), function (errorCode, resultData, resultHeaders)
    if errorCode == 200 then
      local userData = json.decode(resultData)
      local username = userData.display_name
      local avatar = userData.avatar
  
      url = "https://cdn.discordapp.com/avatars/" .. userData.id .. "/" .. avatar .. ".png"
  else
      url = ""
  end
end, "GET", "", {Authorization = "Bot "..ConfigServer.DiscordToken})
while url == nil do Wait(0) end 
return url
end

GetJob = function(source)
    if Config.Framework == 'esx' then 
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.job.name
    elseif Config.Framework == 'qbcore' then
        local Player = QBCore.Functions.GetPlayer(source)
        return Player.PlayerData.job.name
    end
end

UpdateJob = function(source, job)
    if Config.Framework == 'esx' then 
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.setJob(job, 0)
    elseif Config.Framework == 'qbcore' then
        local Player = QBCore.Functions.GetPlayer(source)
        Player.Functions.SetJob(job, 0)
    end
end

GetName = function(source)
    if Config.Framework == 'esx' then 
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getName()
    elseif Config.Framework == 'qbcore' then
        local Player = QBCore.Functions.GetPlayer(source)
        return Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
    end
end

CreateCallback('ricky-jobcenter:getData', function(source, cb)
    local job = GetJob(source)
    local name = GetName(source)
    cb(job, name, GetPlayerAvatar(source))
end)

RegisterServerEvent('ricky-jobcenter:updateJob')
AddEventHandler('ricky-jobcenter:updateJob', function(job)
    UpdateJob(source, job)
end)
