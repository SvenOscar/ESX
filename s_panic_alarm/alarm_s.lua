ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--Server event for triggering the alarm for the specified work group, for the time being only police faction.
RegisterServerEvent('alarm:on') 
AddEventHandler('alarm:on', function(coords)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' then
                TriggerClientEvent('alarm:on', xPlayers[i], coords)
        end
    end
end)

