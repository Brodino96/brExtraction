ESX = exports["es_extended"]:getSharedObject()

local inCooldown = false                        -- if the teleport is in cooldown
local PlayerData = {}

-- These are to optimize the script and don't let him do stuff he doesn't have to do rn
--
local checkForZone = false                      -- Checks if you are in range (if you exit teleport stops)
local counting = false                          -- If i have to count down the timer to teleport
local checkDamage = false                       -- If the script has to calculate if you got damaged or not

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    GenerateStuff()
end)

AddEventHandler("onResourceStart", function ()
    GenerateStuff()
    PlayerData = ESX.GetPlayerData()
end)

function GenerateStuff()
    Citizen.CreateThread(function ()
    
        Wait(0)
    
        for i, v in pairs(Config.location) do
    
            -- Registering zones for to interact with the
            local interactZones = CircleZone:Create(vector3(v.x, v.y, v.z), 2.0, {
                name = v.name,
                debugPoly = false,
                useZ = true,
                debugColor = {0, 255, 0}
            })

            -- Registering when you enter or leave a zone
            local insideInteractZone = false
            interactZones:onPlayerInOut(function(isPointInside, point)
                insideInteractZone = isPointInside
    
                -- Drawing text on top left of screen
                Citizen.CreateThread(function ()
                    while insideInteractZone do
    
                        Wait(0)
                        BeginTextCommandDisplayHelp("STRING")
                        AddTextComponentSubstringPlayerName(_U("inputText"))
                        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    
                        -- Opening menu
                        if IsControlJustPressed(0, 38) then         -- If he presses "E"
                            Menu(v.x, v.y, v.z)
                        end
                    end
                end)
            end)
    
            -- Registering blis in map
            if Config.blip.enabled then
                Citizen.CreateThread(function ()
                    local myBlip = AddBlipForCoord(v.x, v.y, v.z)
                    SetBlipSprite(myBlip, Config.blip.sprite)
                    SetBlipColour(myBlip, Config.blip.colour)
                    SetBlipDisplay(myBlip, Config.blip.display)
                    SetBlipScale(myBlip, Config.blip.scale)
                    SetBlipAsShortRange(myBlip, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString(_U("blipName"))
                    EndTextCommandSetBlipName(myBlip)
                end)
            end
    
        end
    
    end)
end

function Menu(originX, originY, originZ)
    -- Registering the menu
    lib.registerContext({
        id = "come_back_at_home",
        title = _U("menuTitle"),
        options = {
            {
                title = _U("option1Title"),
                description = _U("option1description"),
                onSelect = function ()
                    if Config.price.enabled then
                        Alert(originX, originY, originZ)
                    else
                        LastChecks(originX, originY, originZ)
                    end
                end
            },
            {
                title = _U("option2Title"),
                description = _U("option2description"),
                onSelect = function ()
                    print(_U("option2Title"))
                end
            }
        }
    })

    -- Opening the menu
    lib.showContext("come_back_at_home")
end

function Alert(originX, originY, originZ)

    -- Registering and opening the alert
    local alert = lib.alertDialog({
        header = _U("alertHeader"),
        content = _U("alertContent.item"),
        centered = true,
        cancel = true,
        labels = {
            confirm = _U("alertAllow"),
            cancel = _U("alertCancel")
        }
    })

    -- Doing stuff if you confirm
    if alert == "confirm" then
        LastChecks(originX, originY, originZ)
    end
end

function LastChecks(originX, originY, originZ)

    local numberOfItems = 0
    if Config.price.enabled then
        -- Checks if you have enough items
        numberOfItems = exports.ox_inventory:GetItemCount(Config.price.item, nil, false)
    else
        numberOfItems = Config.price.quantity
    end
    if numberOfItems >= Config.price.quantity then
        
        -- Checks if he should ignores the job to teleport
        if Config.ignoreJob then

            -- Actually teleporting and removing the money
            InizializeFastTravel(Config.defaultHome.x, Config.defaultHome.y, Config.defaultHome.z, originX, originY, originZ)
            if Config.price.enabled then
                TriggerServerEvent("brFastTravel:payItem")
            end

        else
            -- Stats to check for each home location
            for i, v in pairs(Config.homes) do

                -- If you have the correct job for that home it teleports you and remove the payment
                if  PlayerData.job.name == v.jobname then
                    InizializeFastTravel(v.x, v.y, v.z, originX, originY, originZ)
                    if Config.price.enabled then
                        TriggerServerEvent("brFastTravel:payItem")
                    end
                end

            end
            
        end

    else
        -- Notification :)
        lib.notify({
            title = _U("notEnoughItemsTitle"),
            description = _U("notEnoughItemsDescription"),
            type = "error",
            duration = 15000
        })
    end
end

function InizializeFastTravel(x, y, z, originX, originY, originZ)

    -- This starts a timer, if you have my script
    TriggerEvent("revolt:timerstart", Config.timeToTeleport, _U("timerFirstText"), _U("timerSecondText"), 4, 0.5, 0.5, 0.85)

    -- Notification :)
    lib.notify({
        title = _U("notificationTitle"),
        description = _U("notificationDescription"),
        type = "inform",
        duration = 15000
    })

    -- The actual timer
    Citizen.CreateThread(function ()
        counting = true
        local timer = Config.timeToTeleport
        checkDamage = true

        while counting do
            Wait(1000)
            timer = timer - 1
            if timer == 0 then
                timer = Config.timeToTeleport

                counting = false
                checkForZone = false
                checkDamage = false

                Teleport(x, y, z)
                TriggerEvent("revolt:timerstop")
            end
        end
    end)

    -- If you took damage
    Citizen.CreateThread(function ()
        local myLife = GetEntityHealth(GetPlayerPed(-1))

        while checkDamage do
            Wait(0)

            if myLife ~= GetEntityHealth(GetPlayerPed(-1)) then

                counting = false
                checkForZone = false
                checkDamage = false

                timer = Config.timeToTeleport
                -- Notification :)
                lib.notify({
                    title = _U("gotDamagedTitle"),
                    description = _U("gotDamagedDescription"),
                    type = "error",
                    duration = 15000
                })
                TriggerEvent("revolt:timerstop")
                TriggerServerEvent("brFastTravel:getMoneyBack")
            end
        end

    end)

    -- If you leave the defined zone
    Citizen.CreateThread(function ()
        checkForZone = true

        while checkForZone do
            Wait(0)
            local myCoords = GetEntityCoords(GetPlayerPed(-1))
            local distance = GetDistanceBetweenCoords(myCoords.x, myCoords.y, myCoords.z, originX, originY, originZ, true)
            
            if distance > Config.maxDistanceToTeleport then

                counting = false
                checkForZone = false
                checkDamage = false

                -- Notification :)
                lib.notify({
                    title = _U("failureTitle"),
                    description = _U("failureDescription"),
                    type = "error",
                    duration = 15000
                })
                TriggerEvent("revolt:timerstop")
                TriggerServerEvent("brFastTravel:getMoneyBack")
            end
        end
    end)
end

-- Guess what, imma teleport your ass
function Teleport(x, y, z)

    DoScreenFadeOut(1000)

    Wait(1100)

    SetEntityCoords(GetPlayerPed(-1), x, y, z, true, false, false, false)
    Wait(700)
    DoScreenFadeIn(1000)

    Wait(1000)

    -- Notification :)
    lib.notify({
        title = _U("successTitle"),
        description = _U("successDescription"),
        type = "success",
        duration = 15000
    })

end

-- PEDS MAKER

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		for i, v in pairs(Config.location) do
			local playerCoords = GetEntityCoords(PlayerPedId())
			local dist = GetDistanceBetweenCoords(v.x, v.y, v.z, playerCoords.x, playerCoords.y, playerCoords.z, true)
            
			if dist < 100.0 and not v.isRendered then
				local ped = NearPed(v.model, v.x, v.y, v.z, v.heading, v.gender, v.animDict, v.animName, v.scenario)
				v.ped = ped
				v.isRendered = true
			end
			
			if dist >= 100.0 and v.isRendered then
				if true then
					for i = 255, 0, -51 do
						Citizen.Wait(50)
						SetEntityAlpha(v.ped, i, false)
					end
				end
				DeletePed(v.ped)
				v.ped = nil
				v.isRendered = false
			end
		end
	end
end)

-- Idk, go ask sjpfeiffer
function NearPed(model, x, y, z, heading, gender, animDict, animName, scenario)
	local genderNum = 0
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
		Citizen.Wait(1)
	end
	
	-- Convert plain language genders into what fivem uses for ped types.
	if gender == 'male' then
		genderNum = 4
	elseif gender == 'female' then 
		genderNum = 5
	else
		print("No gender provided! Check your configuration!")
	end	

	--Check if someones coordinate grabber thingy needs to subract 1 from Z or not.
	if Config.MinusOne then 
		ped = CreatePed(genderNum, GetHashKey(model), x, y, z - 1, heading, false, true)
		
	else
		ped = CreatePed(genderNum, GetHashKey(v.model), x, y, z, heading, false, true)
	end
	
	SetEntityAlpha(ped, 0, false)

	FreezeEntityPosition(ped, true) --Don't let the ped move.

	SetEntityInvincible(ped, true) --Don't let the ped die.

	SetBlockingOfNonTemporaryEvents(ped, true) --Don't let the ped react to his surroundings.

	--Add an animation to the ped, if one exists.
	if animDict and animName then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(1)
		end
		TaskPlayAnim(ped, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
	end

	if scenario then
		TaskStartScenarioInPlace(ped, scenario, 0, true) -- begins peds animation
	end
	
	if true then
		for i = 0, 255, 51 do
			Citizen.Wait(50)
			SetEntityAlpha(ped, i, false)
		end
	end

	return ped
end