local QRCore = exports['qr-core']:GetCoreObject()
local isDelivering = false
local JobNum
local modeltodelete
local delete = false
local p1 = nil
local p2 = nil
local p3 = nil
local p4 = nil
local p5 = nil
local timer = 0


-----blips
local blips = {
	{x=-179.51, y=627.02, z=114.09},
    {x=2939.25, y=1288.65, z=44.65},
    {x=-778.33, y=-1323.44, z=43.88},
    {x=-2324.89, y=-2406.17, z=63.85},
    {x=2485.56,y=-424.83,z=41.62},
  }

  Citizen.CreateThread(function()
	for _, info in pairs(blips) do
        local blip = N_0x554d9d53f696d002(1664425300, info.x, info.y, info.z)
        SetBlipSprite(blip, -243818172, 1)
		SetBlipScale(blip, 0.2)
		Citizen.InvokeNative(0x9CB1A1623062F402, blip,('blip'))
    end  
end)

------------ Native Prompt ------------
local DeliverPrompt
local hasAlreadyEnteredMarker, lastZone
local currentZone = nil
local sell = false
local active = false
local pressed = false

function SetupDeliverPrompt()
    Citizen.CreateThread(function()
        local str = 'Start Delivery'
        DeliverPrompt = PromptRegisterBegin()
        PromptSetControlAction(DeliverPrompt, 0xE8342FF2)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(DeliverPrompt, str)
        PromptSetEnabled(DeliverPrompt, false)
        PromptSetVisible(DeliverPrompt, false)
        PromptSetHoldMode(DeliverPrompt, true)
        PromptRegisterEnd(DeliverPrompt)
    end)
end

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
          if currentZone then
              if active == false then
                  PromptSetEnabled(DeliverPrompt, true)
                  PromptSetVisible(DeliverPrompt, true)
                  active = true
              end
              if PromptHasHoldModeCompleted(DeliverPrompt) then
                  PromptSetEnabled(DeliverPrompt, false)
                  PromptSetVisible(DeliverPrompt, false)
                 	pressed = true
                  active = false
          currentZone = nil
        end
          else
        Citizen.Wait(500)
      end
    end
end)


Citizen.CreateThread(function()
    SetupDeliverPrompt()
    while true do
        Citizen.Wait(0)
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        local isInMarker, currentZone = false
  
		for k,v in pairs(Config.MainJob) do
			local betweencoords = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.x, v.y, v.z, false)
			if betweencoords < 2 then
                isInMarker  = true
                currentZone = 'delivery'
                lastZone    = 'delivery'
            end
        end
  
        if isInMarker and not hasAlreadyEnteredMarker then
        hasAlreadyEnteredMarker = true
        TriggerEvent('hum_delivery:hasEnteredMarker', currentZone)
        end
    
        if not isInMarker and hasAlreadyEnteredMarker then
        hasAlreadyEnteredMarker = false
        TriggerEvent('hum_delivery:hasExitedMarker', lastZone)
        end
    end
  
end)

AddEventHandler('hum_delivery:hasEnteredMarker', function(zone)
    currentZone     = zone
end)
    
AddEventHandler('hum_delivery:hasExitedMarker', function(zone)
      if active == true then
          PromptSetEnabled(DeliverPrompt, false)
          PromptSetVisible(DeliverPrompt, false)
		  active = false
		  pressed = false
      end
    currentZone = nil
end)

-------------------- BEGIN DELIVERY SYSTEM --------------------
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		for k,v in pairs(Config.MainJob) do
			local wag
			local betweencoords = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.x, v.y, v.z, false)
			if betweencoords < 2.2 then
                if pressed then
                    ResetMission()
					timer = 1200000
					JobNum = k
					
                    if JobNum == 1 then
						RemoveBlip(p1)
						p1 = N_0x554d9d53f696d002(1664425300, Config.Point1.x, Config.Point1.y, Config.Point1.z)
						SetBlipSprite(p1, -44057202, 1)
						Citizen.InvokeNative(0x9CB1A1623062F402, p1, "Delivery")
						isDelivering = true
						pressed = false
						wag = Config.Cart1
						wagon(wag)
                        StartGpsMultiRoute(6, true, true)
                        AddPointToGpsMultiRoute(Config.Point1.x, Config.Point1.y, Config.Point1.z)
                        SetGpsMultiRouteRender(true)
					
                    elseif JobNum == 2 then
						RemoveBlip(p2)
						p2 = N_0x554d9d53f696d002(1664425300, Config.Point2.x, Config.Point2.y, Config.Point2.z)
						SetBlipSprite(p2, -44057202, 1)
						Citizen.InvokeNative(0x9CB1A1623062F402, p2, "Delivery")
						isDelivering = true
						pressed = false
						wag = Config.Cart2
						wagon(wag)
                        StartGpsMultiRoute(6, true, true)
                        AddPointToGpsMultiRoute(Config.Point2.x, Config.Point2.y, Config.Point2.z)
                        SetGpsMultiRouteRender(true)
					
                    elseif JobNum == 3 then
						RemoveBlip(p3)
						print("w8rwer")
						p3 = N_0x554d9d53f696d002(1664425300, Config.Point3.x, Config.Point3.y, Config.Point3.z)
						SetBlipSprite(p3, -44057202, 1)
						Citizen.InvokeNative(0x9CB1A1623062F402, p3, "Delivery")
						isDelivering = true
						pressed = false
						wag = Config.Cart3
						wagon(wag)
                        StartGpsMultiRoute(6, true, true)
                        AddPointToGpsMultiRoute(Config.Point3.x, Config.Point3.y, Config.Point3.z)
                        SetGpsMultiRouteRender(true)
					
                    elseif JobNum == 4 then
						RemoveBlip(p4)
						p4 = N_0x554d9d53f696d002(1664425300, Config.Point4.x, Config.Point4.y, Config.Point4.z)
						SetBlipSprite(p4, -44057202, 1)
						Citizen.InvokeNative(0x9CB1A1623062F402, p4, "Delivery")
						isDelivering = true
						pressed = false
						wag = Config.Cart4
						wagon(wag)
                        StartGpsMultiRoute(6, true, true)
                        AddPointToGpsMultiRoute(Config.Point4.x, Config.Point4.y, Config.Point4.z)
                        SetGpsMultiRouteRender(true)
					
                    elseif JobNum == 5 then
                        RemoveBlip(p5)
                        p5 = N_0x554d9d53f696d002(1664425300, Config.Point5.x, Config.Point5.y, Config.Point5.z)  
                        SetBlipSprite(p5, -44057202, 1)                      
                        Citizen.InvokeNative(0x9CB1A1623062F402, p5, "Delivery")
                        isDelivering = true
                        pressed = false
                        wag = Config.Cart5
                        shinewagon(wag)
                        StartGpsMultiRoute(6, true, true)
                        AddPointToGpsMultiRoute(Config.Point5.x, Config.Point5.y, Config.Point5.z)
                        SetGpsMultiRouteRender(true)
                    end
				end
			end
		end
	end
end)

-------------------- FINISH DELIVERY SYSTEM --------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
        local function DrawText3D(x, y, z, text)
            local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
        
            SetTextScale(0.35, 0.35)
            SetTextFontForCurrentCommand(1)
            SetTextColor(255, 255, 255, 215)
            local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
            SetTextCentre(1)
            DisplayText(str,_x,_y)
        end
		if isDelivering then
			for k,v in pairs(Config.FinishJob) do
				local b2 = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.x, v.y, v.z, false)
				if b2 <= 25 and isDelivering then
                    if JobNum == 1 then DrawText3D(588.15, 1684.95, 187.520, "Press [X] To Deliver") -- Job 1
                         
                    end 
                    if JobNum == 2 then DrawText3D(1420.15,383.93,90.33,     "Press [X] To Deliver") -- Job 2
                        
                    end
                    if JobNum == 3 then DrawText3D(1792.18, 391.68, 43.88, "Press [X] To Deliver") -- Job 3
                         
                    end
                    if JobNum == 4 then DrawText3D(-3686.81, 2627.33, 13.43, "Press [X] To Deliver") -- Job 4
                    
                    end
                    if JobNum == 5 then DrawText3D(1415.56, -2295.74, 43.08, "Press [X] To Deliver") -- Job 5 [Moonshine] 
                    
                    end
                    if whenKeyJustPressed(keys["X"]) then
                        if IsPedInAnyVehicle(playerPed, false) then
                            local vehicle = GetVehiclePedIsIn(playerPed, false)
                            local model = GetEntityModel(vehicle)
                            if model == 1770617692  then 
								if JobNum == 1 then
                                    TriggerServerEvent('hum_delivery:payout', Config.Cash1)
									isDelivering = false
									JobNum = nil
									RemoveBlip(p1)
                                    deletewagon() 
                                    SetGpsMultiRouteRender(false)
								end
							
								if JobNum == 2 then
									TriggerServerEvent('hum_delivery:payout', Config.Cash2)
									isDelivering = false
									JobNum = nil
									RemoveBlip(p2)
                                    deletewagon() 
                                    SetGpsMultiRouteRender(false)
								end

								if JobNum == 3 then
									TriggerServerEvent('hum_delivery:payout', Config.Cash3)
									isDelivering = false
									JobNum = nil
									RemoveBlip(p3)
                                    deletewagon()
                                    SetGpsMultiRouteRender(false)
								end
									

								if JobNum == 4 then                                   
                                    TriggerServerEvent('hum_delivery:payout', Config.Cash4)
									isDelivering = false
									JobNum = nil
									RemoveBlip(p4)
                                    deletewagon()
                                    SetGpsMultiRouteRender(false)
                                end
                            else
                                if model == -1753201617 then
                                    if JobNum == 5 then
                                        TriggerServerEvent('hum_delivery:payout', Config.Cash5)
                                        isDelivering = false
                                        JobNum = nil
                                        RemoveBlip(p5)
                                        deletewagon()
                                        SetGpsMultiRouteRender(false)
                                    end
                                end
                            end
                        
                        else
                            print("missing vehicle")
                        end
					end
				end
			end
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if isDelivering and timer <= 0 then
			isDelivering = false
			RemoveBlip(p1)
			RemoveBlip(p2)
			RemoveBlip(p3)
			RemoveBlip(p4)
            RemoveBlip(p5)
			p1 = nil
			p2 = nil
			p3 = nil
			p4 = nil
            p5 = nil
			JobNum = nil
            deletewagon()
            SetGpsMultiRouteRender(false)
		else
			timer = timer - 1000
		end
	end
end)


function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
	SetTextCentre(centre)
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
	Citizen.InvokeNative(0xADA9255D, 1);
    DisplayText(str, x, y)
end


function wagon(wag)
    local ped = PlayerPedId()
    local car_start = GetEntityCoords(ped)
    local car_name = "chuckwagon002x"
    local carHash = GetHashKey(car_name)
    RequestModel(carHash)

    while not HasModelLoaded(carHash) do
        Citizen.Wait(0)
    end

    local car = CreateVehicle(carHash, wag.x, wag.y, wag.z, wag.h, true, false)
	SetVehicleOnGroundProperly(car)
	Wait(200)
    SetPedIntoVehicle(ped, car, -1)
	SetModelAsNoLongerNeeded(carHash)
	modeltodelete = car
    if IsPedInAnyVehicle(ped) then
        local cart = GetVehiclePedIsIn(ped)
        Citizen.InvokeNative(0xD80FAF919A2E56EA, cart, -1742109836)
        Citizen.InvokeNative(0xC0F0417A90402742, cart, GetHashKey("pg_teamster_chuckwagon002x_lightupgrade1")) 
    else
        print("error: not in vehicle")
    end
end

function shinewagon(wag)
    local ped = PlayerPedId()
    local car_start = GetEntityCoords(ped)
    local car_name = "supplywagon"
    local carHash = GetHashKey(car_name)
    RequestModel(carHash)

    while not HasModelLoaded(carHash) do
        Citizen.Wait(0)
    end

    local car = CreateVehicle(carHash, wag.x, wag.y, wag.z, wag.h, true, false)
	SetVehicleOnGroundProperly(car)
	Wait(200)
    SetPedIntoVehicle(ped, car, -1)
	SetModelAsNoLongerNeeded(carHash)
	modeltodelete = car
    if IsPedInAnyVehicle(ped) then
        local cart = GetVehiclePedIsIn(ped)
        Citizen.InvokeNative(0xD80FAF919A2E56EA, cart, 1793592017)
    else
        print("error: not in vehicle")
    end
end
function deletewagon()
	local entity = modeltodelete
    NetworkRequestControlOfEntity(entity)
    local timeout = 2000
    while timeout > 0 and not NetworkHasControlOfEntity(entity) do
        Wait(100)
        timeout = timeout - 100
    end
    SetEntityAsMissionEntity(entity, true, true)
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
    
    if (DoesEntityExist(entity)) then 
		DeleteEntity(entity)
		modeltodelete = nil
	end
	modeltodelete = nil
end

function whenKeyJustPressed(key)  ---iscontorlpressed does not work while in vehicle
    if Citizen.InvokeNative(0x580417101DDB492F, 0, key) then
        return true
    else
        return false
    end
end

--prevents the native bugging if you restart script
AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	RemoveBlip(p1)
	RemoveBlip(p2)
	RemoveBlip(p3)
	RemoveBlip(p4)
    RemoveBlip(p5)
	p1 = nil
	p2 = nil
	p3 = nil
    p4 = nil
    p5 = nil
    SetGpsMultiRouteRender(false)
end)

function ResetMission()
    RemoveBlip(p1)
    RemoveBlip(p2)
    RemoveBlip(p3)
    RemoveBlip(p4)
    p1 = nil
    p2 = nil
    p3 = nil
    p5 = nil
    SetGpsMultiRouteRender(false)
    isDelivering = false
	JobNum = nil
    deletewagon()
end



keys = {
    -- Letters
    ["A"] = 0x7065027D,
    ["B"] = 0x4CC0E2FE,
    ["C"] = 0x9959A6F0,
    ["D"] = 0xB4E465B4,
    ["E"] = 0xCEFD9220,
    ["F"] = 0xB2F377E8,
    ["G"] = 0x760A9C6F,
    ["H"] = 0x24978A28,
    ["I"] = 0xC1989F95,
    ["J"] = 0xF3830D8E,
    -- Missing K, don't know if anything is actually bound to it
    ["L"] = 0x80F28E95,
    ["M"] = 0xE31C6A41,
    ["N"] = 0x4BC9DABB, -- Push to talk key
    ["O"] = 0xF1301666,
    ["P"] = 0xD82E0BD2,
    ["Q"] = 0xDE794E3E,
    ["R"] = 0xE30CD707,
    ["S"] = 0xD27782E3,
    -- Missing T
    ["U"] = 0xD8F73058,
    ["V"] = 0x7F8D09B8,
    ["W"] = 0x8FD015D8,
    ["X"] = 0x8CC9CD42,
    -- Missing Y
    ["Z"] = 0x26E9DC00,

    -- Symbol Keys
    ["RIGHTBRACKET"] = 0xA5BDCD3C,
    ["LEFTBRACKET"] = 0x430593AA,
    -- Mouse buttons
    ["MOUSE1"] = 0x07CE1E61,
    ["MOUSE2"] = 0xF84FA74F,
    ["MOUSE3"] = 0xCEE12B50,
    ["MWUP"] = 0x3076E97C,
    -- Modifier Keys
    ["CTRL"] = 0xDB096B85,
    ["TAB"] = 0xB238FE0B,
    ["SHIFT"] = 0x8FFC75D6,
    ["SPACEBAR"] = 0xD9D0E1C0,
    ["ENTER"] = 0xC7B5340A,
    ["BACKSPACE"] = 0x156F7119,
    ["LALT"] = 0x8AAA0AD4,
    ["DEL"] = 0x4AF4D473,
    ["PGUP"] = 0x446258B6,
    ["PGDN"] = 0x3C3DD371,
    -- Function Keys
    ["F1"] = 0xA8E3F467,
    ["F4"] = 0x1F6D95E5,
    ["F6"] = 0x3C0A40F2,
    -- Number Keys
    ["1"] = 0xE6F612E4,
    ["2"] = 0x1CE6D9EB,
    ["3"] = 0x4F49CC4C,
    ["4"] = 0x8F9F9E58,
    ["5"] = 0xAB62E997,
    ["6"] = 0xA1FDE2A6,
    ["7"] = 0xB03A913B,
    ["8"] = 0x42385422,
    -- Arrow Keys
    ["DOWN"] = 0x05CA7C52,
    ["UP"] = 0x6319DB71,
    ["LEFT"] = 0xA65EBAB4,
    ["RIGHT"] = 0xDEB34313,
  }


-- RegisterCommand('checkv', function(source, args)
--     local playerPed = PlayerPedId()
--     local vehicle = GetVehiclePedIsIn(playerPed, false)
--     local model = GetEntityModel(vehicle)
--     if model == -824257932 then
--     end
-- end)
