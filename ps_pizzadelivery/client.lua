ESX = exports["es_extended"]:getSharedObject()

AddEventHandler('onClientResourceStart', function(ressourceName)
    if(GetCurrentResourceName() ~= ressourceName) then 
        return 
    end 
    print("" ..ressourceName.." started sucessfully")
end)


local busy = false
local pizza_screen = false
local currentzone = '' -- Do not Touch!
local pizzen = 0
local maxpizzen
local tour = 0
local ready = false
local currentcash = 0
local time = Config.MaxTime
local timerstart = false

local current_step = 0
local firststep = false
local secondstep = false

local pizzainhand = false

local clothing = false

Citizen.CreateThread(function()
    for _,_ped in pairs(Config.Start) do

        local hash = GetHashKey(_ped.ped)

        RequestModel(hash)
        while not HasModelLoaded(hash) do 
            Citizen.Wait(25)
        end

        local ped = CreatePed(4, hash,  _ped.coords.x, _ped.coords.y, _ped.coords.z - 1.0, _ped.coords.w, false, false)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        local blip = AddBlipForCoord( _ped.coords.x, _ped.coords.y, _ped.coords.z)
        SetBlipSprite(blip, 889)
        SetBlipScale(blip, 0.8)
        SetBlipDisplay(blip, 4)
        SetBlipColour(blip, 60)
        SetBlipAsShortRange(blip, true)
        Citizen.Wait(100)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(Translation[Config.Locale]['start_blip'])
        EndTextCommandSetBlipName()
    end
    while true do 
        Citizen.Wait(1)
        for k,v in pairs(Config.Start) do

            local playerped = PlayerPedId()
            local coords = GetEntityCoords(playerped)
            local v3coords = vector3(v.coords.x, v.coords.y, v.coords.z)
            local dist = #(coords - v3coords)

            if dist < 1.5 then 
                DrawText3D(v.coords.x, v.coords.y, v.coords.z, "~y~[E] "..Translation[Config.Locale]['start_blip'])
                if IsControlJustReleased(0, 38) then
                    if Config.Job.enable then 
                        ESX.TriggerServerCallback('ps_pizza:checkJob', function(hasJob)
                            if hasJob then
                                OpenPizzaMenu(v)
                            else
                                Config.Notify(Translation[Config.Locale]['dont_have_job'])
                            end
                        end)
                    else 
                        OpenPizzaMenu(v)
                    end
                end
            end
        end
    end
end)

function endjob()
    DeleteVehicle(vehicle)
    RemoveBlip(vehblip)
    busy = false
    pizza_screen = false
    currentzone = ''
    pizzen = 0
    tour = 0
    ready = false
    currentcash = 0

    
    current_step = 0
    firststep = false
    secondstep = false

    pizzainhand = false

    clothing = false
end

function OpenPizzaMenu(data)
    lib.registerContext({
        id = 'ps_pizza',
        title = Translation[Config.Locale]['menu_order'],
        icon = 'fa-solid fa-basket-shopping',
        options = {
            {
            title = Translation[Config.Locale]['menu_start'],
            colorScheme = 'green',
            description = Translation[Config.Locale]['menu_start_desc'],
            icon = 'fa-solid fa-list',
            iconColor = '#D79051',
            onSelect = function()
                if not busy and not firststep then
                    StartPizzaJob(data)
                else 
                    Config.Notify(Translation[Config.Locale]['already_started'])
                end
            end,
        },
        {
            icon = 'fa-solid fa-shirt',
            iconColor = 'yellow',
            title = Translation[Config.Locale]['change_outfit'],
            description = Translation[Config.Locale]['change_outfit_desc'],
            arrow = true,
            onSelect = function()
                applyclothing()
            end, 
        },
        {
            icon = 'fa-solid fa-ban',
            iconColor = 'red',
            title = Translation[Config.Locale]['end_job'],
            description = Translation[Config.Locale]['end_job_desc'],
            arrow = true,
            onSelect = function()
                if busy or firststep or secondstep then
                    if currentcash > 0 then 
                        Config.Notify(string.format(Translation[Config.Locale]['reward'], currentcash))
                        TriggerServerEvent("ps_pizza:getreward", currentcash)
                    end
                    endjob()
                    Config.Notify(Translation[Config.Locale]['ended_job'])
                else 
                    Config.Notify(Translation[Config.Locale]['no_job'])
                end
            end, 
        },
        }
    
    })
    lib.showContext('ps_pizza')
end

function StartPizzaJob(data)
    maxpizzen = data.pizza
    globaldata = data
    Config.Notify(Translation[Config.Locale]['store_pizza_in_veh'])
    local hash = GetHashKey(data.vehicle)
    RequestModel(hash)
    while not HasModelLoaded(hash) do 
        Citizen.Wait(25)
    end
    vehicle = CreateVehicle(hash, data.spawncarcoords.x, data.spawncarcoords.y, data.spawncarcoords.z, data.spawncarcoords.w, true, false)
    Config.Fuel(vehicle)
    vehblip = AddBlipForEntity(vehicle)
    SetBlipSprite(vehblip, 533)
    SetBlipColour(vehblip, 60)
    SetBlipScale(vehblip, 1.0)
    SetBlipAsShortRange(vehblip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Translation[Config.Locale]['blip_vehicle'])
    EndTextCommandSetBlipName()
    firststep = true
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if firststep then 
            local playerped = PlayerPedId()
            local coords = GetEntityCoords(playerped)
            local dist = #(coords - globaldata.takepizza)
            if dist < 10 then 
                _DrawMarker(1, globaldata.takepizza.x, globaldata.takepizza.y, globaldata.takepizza.z - 1.0, 252, 186, 3, 100, false, false)
                if dist < 2 then 
                    DrawText3D(globaldata.takepizza.x, globaldata.takepizza.y, globaldata.takepizza.z, "[E] "..Translation[Config.Locale]['take_pizza'])
                    if IsControlJustReleased(0, 38) then 
                        if not IsPedInAnyVehicle(playerped, true) then
                            Citizen.Wait(500)

                            RequestModel(GetHashKey('prop_pizza_box_02'))
                            while not HasModelLoaded(GetHashKey('prop_pizza_box_02')) do 
                                Citizen.Wait(25)
                            end

                            RequestAnimDict('anim@heists@box_carry@')
                            while not HasAnimDictLoaded('anim@heists@box_carry@') do
                                Citizen.Wait(1)
                            end
                            TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 1.0, -8.0, -1, 49, 0, false, false, false)

                            pizza = CreateObject(GetHashKey("prop_pizza_box_02"), 0, 0, 0, true, true, true) -- creates object
                            AttachEntityToEntity(pizza, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 28422), 0.0100, -0.1000, -0.1590, 20.0000007, 0.0, 0.0, true, true, false, true, 1, true)
                            SetEntityNoCollisionEntity(pizza, playerped, false)

                            firststep = false 
                            secondstep = true

                        end
                    end
                end
            end
        end
        if secondstep then 
            local playerped = PlayerPedId()
            local coords = GetEntityCoords(playerped)
            local trunkpos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "exhaust"))
            local dist = #(coords - trunkpos)
            if dist < 1.5 then 
                DrawText3D(trunkpos.x, trunkpos.y, trunkpos.z, "[E] "..Translation[Config.Locale]['store_pizza'])
                if IsControlJustReleased(0, 38) then 
                    if not IsPedInAnyVehicle(playerped, true) then
                        Citizen.Wait(500)
                        DeleteEntity(pizza)
                        ClearPedTasks(playerped)
                        secondstep = false
                        if not Config.OneTimeStore then
                            current_step = current_step + 1
                            Config.Notify(string.format(Translation[Config.Locale]['store_status'], current_step, maxpizzen))
                            if current_step >= maxpizzen then
                                Config.Notify(Translation[Config.Locale]['start_drive'])
                                StartRandomRoute()
                            else 
                                firststep = true
                            end
                        else 
                            Config.Notify(Translation[Config.Locale]['start_drive'])
                            StartRandomRoute()
                        end
                    end
                end
            end
        end
    end
end)

function StartRandomRoute()
    random_d = Config.Tour[math.random(#Config.Tour)]
    local random = math.random(100,1000)
    busy = true
    pizza_screen = true
    time = Config.MaxTime
    timerstart = true
    blip_d = AddBlipForCoord(random_d.x, random_d.y, random_d.z)
    SetBlipSprite(blip_d, 411)
    SetBlipScale(blip_d, 0.8)
    SetBlipDisplay(blip_d, 4)
    SetBlipColour(blip_d, 60)
    SetBlipAsShortRange(blip_d, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(string.format(Translation[Config.Locale]['blip_current_order'], random))
    EndTextCommandSetBlipName()
    SetBlipRoute(blip_d, true)
    ready = true
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if busy then 
            local playerped = PlayerPedId()
            local coords = GetEntityCoords(playerped)
            local dist3 = #(coords - random_d)
            if dist3 < 50 and ready then
                _DrawMarker(1, random_d.x, random_d.y, random_d.z - 1.0, 252, 186, 3, 100, false, false)
                if pizzainhand then
                    if dist3 < 1.5 and ready then
                        DrawText3D(random_d.x, random_d.y, random_d.z, "[E] "..Translation[Config.Locale]['deliver_order'])
                        if IsControlJustReleased(0, 38) then 
                            if not IsPedInAnyVehicle(playerped, true) then
                                if busy then 
                                    local rnd_cash = math.random(globaldata.reward.min, globaldata.reward.max)
                                    currentcash = currentcash + rnd_cash
                                    local rnd_tip = math.random(1,100)
                                    if rnd_tip < Config.TipAmount.chance then
                                        local rnd_tip_amount = math.random(Config.TipAmount.min, Config.TipAmount.max)
                                        PlaySoundFrontend(-1, "REMOTE_PLYR_CASH_COUNTER_COMPLETE", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
                                        Config.Notify(string.format(Translation[Config.Locale]['tip'], rnd_tip_amount))
                                        TriggerServerEvent("ps_pizza:gettip", rnd_tip_amount)
                                    end
                                    pizzen = pizzen + 1
                                    RemoveBlip(blip_d)
                                    pizzainhand = false
                                    DeleteEntity(pizza)
                                    ClearPedTasks(playerped)
                                    if pizzen >= maxpizzen then 
                                        ready = false
                                        timerstart = false
                                        pizza_screen = false
                                        Config.Notify(Translation[Config.Locale]['drive_back'])
                                    else 
                                        Config.Notify(Translation[Config.Locale]['drive_next'])
                                        StartRandomRoute()
                                    end
                                end
                            end
                        end
                    end
                end
            end
            local trunkpos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "exhaust"))
            local dist = #(coords - trunkpos)
            local dist2 = #(coords - random_d)
            if dist < 1.5 and dist2 < 100 then 
                if ready then
                    if not pizzainhand then
                        if not IsPedInAnyVehicle(playerped, true) then
                            DrawText3D(trunkpos.x, trunkpos.y, trunkpos.z, "[E] "..Translation[Config.Locale]['take_pizza'])
                            if IsControlJustReleased(0, 38) then 
                                RequestModel(GetHashKey('prop_pizza_box_02'))
                                while not HasModelLoaded(GetHashKey('prop_pizza_box_02')) do 
                                    Citizen.Wait(25)
                                end
                                RequestAnimDict('anim@heists@box_carry@')
                                while not HasAnimDictLoaded('anim@heists@box_carry@') do
                                    Citizen.Wait(1)
                                end
                        
                                TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 1.0, -8.0, -1, 49, 0, false, false, false)
                                pizza = CreateObject(GetHashKey("prop_pizza_box_02"), 0, 0, 0, true, true, true) -- creates object
                                AttachEntityToEntity(pizza, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 28422), 0.0100, -0.1000, -0.1590, 20.0000007, 0.0, 0.0, true, true, false, true, 1, true)
                                SetEntityNoCollisionEntity(pizza, playerped, false)
                                pizzainhand = true
                            end
                        end
                    else 
                        if not IsPedInAnyVehicle(playerped, true) then
                            DrawText3D(trunkpos.x, trunkpos.y, trunkpos.z, "[E] "..Translation[Config.Locale]['store_pizza'])
                            if IsControlJustReleased(0, 38) then 
                                DeleteEntity(pizza)
                                ClearPedTasks(PlayerPedId())
                                pizzainhand = false
                            end
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if timerstart then 
            if time > 0 then 
                time = time - 1
                Citizen.Wait(1000)
            else 
                timerstart = false
                Config.Notify(Translation[Config.Locale]['pizza_cold'])
                pizzen = pizzen + 1
                RemoveBlip(blip_d)
                if pizzen >= maxpizzen then 
                    ready = false
                    pizza_screen = false
                    Config.Notify(Translation[Config.Locale]['drive_back'])
                else 
                    StartRandomRoute()
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if pizza_screen then
            ShowScreenText(string.format(Translation[Config.Locale]['screen_order_status'], pizzen, maxpizzen, time))
        end
    end
end)










function applyclothing()
    local playerPed = PlayerPedId()
    RequestAnimDict("clothingshirt")
    while not HasAnimDictLoaded("clothingshirt") do 
        Citizen.Wait(25)
    end 
    TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 1.0, -1.0, -1, 1, 1, true, true, true)
    Citizen.Wait(2000)
    ClearPedTasks(playerPed)
    if not clothing then
        clothing = true
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            if skin.sex == 0 then
                SetPedComponentVariation(playerPed, 11, Config.Clothing['male']['Torso'].id , Config.Clothing['male']['Torso'].txt , 2)  -- Torso
                SetPedComponentVariation(playerPed, 8, Config.Clothing['male']['TShirt'].id , Config.Clothing['male']['TShirt'].txt , 2) -- Shirt
                SetPedComponentVariation(playerPed, 3, Config.Clothing['male']['Arms'].id , Config.Clothing['male']['Arms'].txt , 2) -- Arms
                SetPedComponentVariation(playerPed, 4, Config.Clothing['male']['Pants'].id , Config.Clothing['male']['Pants'].txt , 2) -- Pants
                SetPedComponentVariation(playerPed, 6, Config.Clothing['male']['Shoes'].id , Config.Clothing['male']['Shoes'].txt , 2) -- Shoes
                SetPedPropIndex(playerPed, 0, Config.Clothing['male']['Hat'].id , Config.Clothing['male']['Hat'].txt, true) -- Hat
            else 
                SetPedComponentVariation(playerPed, 11, Config.Clothing['female']['Torso'].id , Config.Clothing['female']['Torso'].txt , 2)  -- Torso
                SetPedComponentVariation(playerPed, 8, Config.Clothing['female']['TShirt'].id , Config.Clothing['female']['TShirt'].txt , 2) -- Shirt
                SetPedComponentVariation(playerPed, 3, Config.Clothing['female']['Arms'].id , Config.Clothing['female']['Arms'].txt , 2) -- Arms
                SetPedComponentVariation(playerPed, 4, Config.Clothing['female']['Pants'].id , Config.Clothing['female']['Pants'].txt , 2) -- Pants
                SetPedComponentVariation(playerPed, 6, Config.Clothing['female']['Shoes'].id , Config.Clothing['female']['Shoes'].txt , 2) -- Shoes
                SetPedPropIndex(playerPed, 0, Config.Clothing['female']['Hat'].id , Config.Clothing['female']['Hat'].txt, true) -- Hat
            end 
        end)
    else 
        clothing = false
        resetclothes()
    end
    lib.showContext('ps_pizza')
end

function resetclothes()
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
end

function ShowScreenText(text, pos)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.015, 0.675)
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 370
	DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
	ClearDrawOrigin()
end

function _DrawMarker(id, x, y, z, r, g, b, alpha, updown, rotate)
    DrawMarker(id, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.2, 1.2, 0.6, r, g, b, alpha, updown, 0, 2, rotate, 0, 0, 0)
end
