ESX = exports["es_extended"]:getSharedObject()

local PlayerData = {}
local blip = nil
local text = false
local activate = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

--Activates panic alarm. Line 30 is where you would choose your custom alarm sound. Example name would be =  alarm.ogg.
Citizen.CreateThread(function()
	while true do
		Wait(1)

		local coords = GetEntityCoords(PlayerPedId())
	
		if IsControlJustPressed(0, 74) and IsControlPressed(0, 61) then
			if ESX.GetPlayerData().job.name == 'police' or ESX.GetPlayerData().job.name == 'ambulance' then
					if activate == false then
						activate = true
						ESX.ShowNotification("The panic alarm has been activated, look on the map!")
						--TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'alarm.ogg', 0.8)
						TriggerServerEvent('alarm:on', coords)
					else
						ESX.ShowNotification('Wait a while. The panic alarm has already been triggered.')
					end
				end
		end
	end
end)

--Blip = information and style.
RegisterNetEvent('alarm:on')
AddEventHandler('alarm:on', function(locate)
			blip = AddBlipForCoord(locate)
			SetBlipSprite(blip, 459)
			SetBlipScale(blip, 1.2)
			SetBlipColour(blip, 59)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Panic Alarm")
			EndTextCommandSetBlipName(blip)
			text = true
			Wait(40000)
			RemoveBlip(blip)
			text = false
end)