Config  = {}

Config.Webhook = '' -- Your Webhook Link

Config.Locale = 'en' -- 'en' 'de' 

Config.Fuel = function(vehicle)
    -- exports['myFuel']:SetFuel(vehicle, 100.0)
end

Config.Notify = function(msg)
    ESX.ShowNotification(msg)
end

Config.Job = {
    enable = false,
    job = 'mechanic'
}

Config.OneTimeStore = true -- If you need to store every single Pizza to your vehicle or only 1 time to start driving

Config.TipAmount = {
    min = 50,
    max = 125,
    chance = 70,  -- 70% Chance to get Tip each Order
}

Config.MaxTime = 180 -- How many Seconds do you have for each Pizza to deliver

Config.Start = {
    {
        ped = "s_m_y_busboy_01",
        coords = vector4(287.4073, -963.3812, 29.4186, 1.0210), -- Where u can start the Job
        vehicle = "Pizzaboy",
        spawncarcoords = vector4(284.8098, -962.8560, 29.4186, 11.1863), -- Vehicle Spawn
        pizza = math.random(2,6), -- How many Pizza need to be delivered for one Job
        reward = {
            min = 250,
            max = 345,
        },
        takepizza = vector3(289.9808, -963.1663, 29.4186) -- Where you need to take the Pizza to store it after in your vehicle
    },
    {
        ped = "s_m_y_busboy_01",
        coords = vector4(537.6674, 100.8571, 96.5133, 156.3238),
        vehicle = "Pizzaboy",
        spawncarcoords = vector4(533.2356, 101.8457, 96.4713, 162.0842),
        pizza = math.random(2,6),
        reward = {
            min = 250,
            max = 345,
        },
        takepizza = vector3(536.2407, 101.8342, 96.5610)
    }
}

Config.Clothing = { -- Clothing for the Job (need to adjust to your server)
    ["male"] = {
        ["Torso"] = { id = 544, txt = 11},
        ["TShirt"] = { id = 15, txt = 0},
        ["Arms"] = { id = 0, txt = 0},
        ["Pants"] = { id = 48, txt = 1},
        ["Shoes"] = { id = 1, txt = 0},
        ["Hat"] = { id = 82, txt = 23},
    },
    ["female"] = {
        ["Torso"] = { id = 588, txt = 11},
        ["TShirt"] = { id = 15, txt = 0},
        ["Arms"] = { id = 0, txt = 0},
        ["Pants"] = { id = 3, txt = 3},
        ["Shoes"] = { id = 3, txt = 0},
        ["Hat"] = { id = 81, txt = 23},
    }
}

Config.Tour = { -- Random Coords for delivery
    vector3(134.6443, -859.3761, 30.7709),
    vector3(329.1966, -800.7078, 29.2665),
    vector3(363.4085, -711.9812, 29.2842),
    vector3(-50.8416, -1060.7284, 27.7587),
    vector3(8.2054, -916.2294, 29.9050),
    vector3(292.2191, -1078.5333, 29.4051),
    vector3(278.8123, -1028.8291, 29.2091),
    vector3(388.3311, -732.1029, 29.2905),
    vector3(311.2844, -723.1224, 29.3168),
    vector3(-47.6597, -584.4875, 37.9530),
    vector3(390.9286, -930.7908, 29.4186),
    vector3(109.5289, -1090.4315, 29.3023),
    vector3(69.7195, -1036.3375, 29.4666),
    vector3(5.6014, -985.9136, 29.3571),
    vector3(5.2576, -707.0508, 45.9727),
    vector3(102.1296, -818.0040, 31.3531),
    vector3(278.5083, -1070.3312, 29.4385),
    vector3(375.0479, -1268.1998, 32.5019),
    vector3(343.2131, -1298.4484, 32.5105),
    vector3(307.8587, -1287.0067, 30.5610),
    vector3(200.0197, -1269.0217, 29.1799),
    vector3(130.3932, -1324.6649, 29.2020),
    vector3(87.7719, -1294.9333, 29.3215),
    vector3(-189.0167, -1168.7354, 23.6723),
    vector3(30.0856, -1018.9697, 29.4390),
    vector3(68.3912, -959.5088, 29.8029),
    vector3(76.0159, -871.0499, 31.5093),
    vector3(245.0385, -677.6327, 37.7103),
    vector3(238.4448, -696.6252, 36.7899),
    vector3(317.0344, -685.3801, 29.4841),
    vector3(414.7419, -924.6269, 29.4056),
    vector3(51.5751, -1317.3892, 29.2894),
    vector3(-120.2726, -1314.0457, 29.2941),
    vector3(-120.3076, -1258.4530, 29.3086),
    vector3(114.0342, -1038.3331, 29.3022),
    vector3(135.8386, -1030.8229, 29.354),
    vector3(186.6590, -1078.4379, 29.2745),
    vector3(231.8916, -1095.0072, 29.2903),
    vector3(273.8063, -833.7184, 29.2591),
    vector3(328.6696, -875.5031, 29.2916),
    vector3(383.0110, -874.4604, 29.2848),
    vector3(488.5061, -873.6403, 25.3395),
    vector3(451.3047, -753.2877, 27.3526),
    vector3(394.0983, -700.4448, 29.2817),
    vector3(418.0431, -691.8860, 29.3456),
    vector3(394.9780, -804.4972, 29.2893),
}


Translation = {
    ['de'] = {
        ['start_blip'] = 'Pizza Job',
        ['menu_order'] = 'Pizza Job',
        ['menu_start'] = 'Start',
        ['menu_start_desc'] = 'Starte den Job',
        ['already_started'] = 'Du hast den Job bereits gestartet',
        ['change_outfit'] = 'Kleidung wechseln',
        ['change_outfit_desc'] = 'Wechsel deine Kleidung zum Job Outfit',
        ['end_job'] = 'Job beenden',
        ['end_job_desc'] = 'Beende den aktiven Job',
        ['ended_job'] = 'Job beendet',
        ['no_job'] = 'Du bist gerade in keinen aktiven Job',
        ['store_pizza_in_veh'] = 'Lade die Bestellungen in dein Fahrzeug ein',
        ['blip_vehicle'] = 'Pizzaboten - Fahrzeug',
        ['take_pizza'] = 'Pizza nehmen',
        ['store_pizza'] = 'Pizza einpacken',
        ['store_status'] = 'Bestellung %s/%s eingepackt',
        ['start_drive'] = 'Fahre nun los und liefere die Bestellungen aus',
        ['blip_current_order'] = 'Lieferung Nr. %s',
        ['deliver_order'] = 'Bestellung ausliefern',
        ['drive_back'] = 'Deine Route ist fertig. Fahre nun zurück zur Abgabe',
        ['drive_next'] = 'Weiter zur nächsten Bestellung!',
        ['pizza_cold'] = 'Du hast die aktuelle Bestellung kalt werden lassen.',
        ['done_tour'] = 'Deine Route ist fertig. Fahre nun zurück zur Abgabe',
        ['screen_order_status'] = 'Bestellung ~g~$s~s~/~g~%s~s~\nZeit bis Abgabe: ~r~%s~s~ Sekunden',
        ['tip'] = 'Du hast Trinkgeld in Höhe von %s$ erhalten',
        ['reward'] = 'Du hast deinen Lohn in Höhe von %s$ erhalten',
        ['webhook_done_job'] = '**%s** hat den Pizzajob erledigt und **%s$** erhalten',
        ['dont_have_job'] = 'Du hast nicht den richtigen Job dafür',
    },
    ['en'] = {
        ['start_blip'] = 'Pizza Job',
        ['menu_order'] = 'Order',
        ['menu_start'] = 'Start',
        ['menu_start_desc'] = 'Start the job',
        ['already_started'] = 'You have already started the job',
        ['change_outfit'] = 'Change Outfit',
        ['change_outfit_desc'] = 'Change to job outfit',
        ['end_job'] = 'End Job',
        ['end_job_desc'] = 'End the current job',
        ['ended_job'] = 'Job ended',
        ['no_job'] = 'You are not currently on an active job',
        ['store_pizza_in_veh'] = 'Load the pizza into your vehicle',
        ['blip_vehicle'] = 'Pizza Delivery Vehicle',
        ['take_pizza'] = 'Take Pizza',
        ['store_pizza'] = 'Store Pizza',
        ['store_status'] = 'Order %s/%s packed',
        ['start_drive'] = 'Start driving and deliver the Pizza',
        ['blip_current_order'] = 'Delivery No. %s',
        ['deliver_order'] = 'Order',
        ['drive_back'] = 'Your Tour is complete. Drive back to get your Reward',
        ['drive_next'] = 'Go to the next order!',
        ['pizza_cold'] = 'The Pizza was getting cold. Next order...',
        ['screen_order_status'] = 'Order ~g~%s~s~/~g~%s~s~\nTime until Pizza is getting cold: ~r~%s~s~ seconds',
        ['tip'] = 'You received a tip: %s$',
        ['reward'] = 'You received your payment of %s$',
        ['webhook_done_job'] = '**%s** completed the pizza job and received **%s$**',
        ['dont_have_job'] = 'You dont have the required Job!',
    }
    
}
