ESX = exports["es_extended"]:getSharedObject()

--List of all items/weapons that the menu will offer. Remember to set isweapon to false/true depending on wether you are adding a item/weapon to the list.
--I have listed a list featuring examples. If you wish to add lines, then you create a new row and add the following number. 
local goods = {
    [1] = {label = "Knife (250,000 $)", value = "WEAPON_KNIFE", price = 250000, name = "WEAPON_KNIFE", isweapon = true},
    [2] = {label = "Pistol (1,500,000 $)", value = "WEAPON_PISTOL", price = 1500000, name = "WEAPON_PISTOL", isweapon = true},
    [3] = {label = "AK-47 (4,000,000 $)", value = "WEAPON_ASSAULTRIFLE", price = 4000000, name = "WEAPON_ASSAULTRIFLE", isweapon = true},
    [4] = {label = "Bulletproofvest (65,000 $)", value = "armor", price = 65000, name = "armor", isweapon = false},
    [5] = {label = "Lockpick (3,000 $)", value = "lockpick", price = 3000, name = "lockpick", isweapon = false},
}

--Dealer Ped coordinates.
local Dealer = { x = 85.26, y = 3719.25, z = 39.75, rotation = 63.55, NetworkSync = true}

Citizen.CreateThread(function()
  modelHash = GetHashKey("g_m_y_lost_02")
  RequestModel(modelHash)
  while not HasModelLoaded(modelHash) do
       Wait(1)
  end
  CreateDealer() 
end)

function CreateDealer()
	created_ped = CreatePed(0, modelHash , Dealer.x,Dealer.y,Dealer.z - 1, Dealer.rotation, Dealer.NetworkSync)
	FreezeEntityPosition(created_ped, true)
	SetEntityInvincible(created_ped, true)
	SetBlockingOfNonTemporaryEvents(created_ped, true)
	TaskStartScenarioInPlace(created_ped, "WORLD_HUMAN_SMOKING", 0, true)
end

--Blackmarket menu
function goodsmenu()

    local elements = {}

    for i=1, #goods, 1 do
        table.insert(elements, goods[i])
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'goods',
        {
            title    = 'Blackmarket dealer',
            align    = 'center',
            elements = elements,
        },
        function(data, menu)

            if data.current.value ~= nil then
                if hasMoney(data.current.price) then
                    TriggerServerEvent('s_blackmarket:buy', data.current.isweapon, data.current.name, data.current.price)
                    ESX.ShowNotification('You bought '.. data.current.label)
                else
                    ESX.ShowNotification('You cant afford this product!')
                end
            end           
        end,
        function(data, menu)
            menu.close()
        end
    )
end

--Blackmarket circle & help text.
Citizen.CreateThread(function()
    while true do
      Citizen.Wait(8)
       for k, v in pairs(Config.BlackMarkets) do
          local coords = GetEntityCoords(GetPlayerPed(-1))
          local dist = GetDistanceBetweenCoords(coords, v, true)
            
          if Config.Type ~= -1 and dist < Config.DrawDistance then
            if Config.drawmarker then  
            DrawMarker(6, v.x, v.y, v.z-0.95, 0, 0, 0.1, 0, 0, 0, 1.0, 1.0, 1.0, 0, 128, 255, 200, 0, 0, 0, 0)
            end
            
            if dist <= 1 then
		--ESX.ShowHelpNotification(Config["Strings"]["openMarket"])
                ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to open the blackmarket.")
            end

            if IsControlJustReleased(0, 38) then
                goodsmenu()
            end
        end
      end
    end
  end)

--Check if player has money amount.
hasMoney = function(money)
    local playerMoney = ESX.GetPlayerData().money

    if playerMoney >= money then
        return true
    end

    return false
end
