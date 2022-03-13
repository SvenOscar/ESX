ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--Event for purchasing items/weapons.
RegisterServerEvent('s_blackmarket:buy')
AddEventHandler('s_blackmarket:buy', function(isweapon, item, price)
    local xPlayer        = ESX.GetPlayerFromId(source)
	local money          = xPlayer.getMoney(source)
	local ammo 			 = 250

	if isweapon then
		xPlayer.addWeapon(item, ammo)
		xPlayer.removeMoney(price)
	else
		xPlayer.addInventoryItem(item, 1)
		xPlayer.removeMoney(price)
	end
end)