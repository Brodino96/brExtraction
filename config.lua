Config = {}

Config.Locale = "it"                            -- "it" or "en" (See locales folder)

Config.timeToTeleport = 30                      -- In seconds
Config.maxDistanceToTeleport = 10               -- In meters
Config.price = {
    item = "burger",                           -- Id of the item used as a currency
    quantity = 4                               -- Number of items necessary
}

Config.ignoreJob = true                         -- If "true" will ignore any job and go straight to Config.defaultHome
Config.defaultHome = { x = 1975.47, y = 3820.39, z = 33.44, heading = 138.89 }


Config.homes = {                                -- Orientation doesn't do anything for now
    { jobname = "police", x = 451.34, y = -923.19, z = 28.46, heading = 179.38 },        -- Compares your current job with everyone of these, when it finds a match will teleport the player to those coords
    { jobname = "ems", x = 212.06, y = 564.632, z = 43.87, heading = 255.58 },
}

Config.MinusOne = true                          -- If you use txadmin or esx /coords keep this on true, basically it does (z - 1) because i need feet position and some methodes to get coords give you head coords
Config.location = {

    { name = "subway", x = -851.94, y = -159.46, z = 19.95, heading = 300.00,                   -- Use different names because i need them to differentiate markers
    model = "a_m_m_tramp_01", gender = "male", animDict = "random@drunk_driver_1",
    animName = "drunk_driver_stand_loop_dd1", isRendered = true, ped = nil },

    { name = "storage", x = 1137.52, y = -1337.47, z = 34.65, heading = 320.31,
    model = "a_m_m_tramp_01", gender = "male", animDict = "random@drunk_driver_1",
    animName = "drunk_driver_stand_loop_dd1", isRendered = true, ped = nil }
}

Config.blip = {                                 -- For blip NAME check locales
    enabled = true,                             -- If blips should appear on the map
    sprite = 792,                               -- https://docs.fivem.net/docs/game-references/blips/#blips
    colour = 2,                                 -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
    display = 5,                                -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
    scale = 0.7                                 -- The dimension of the blip
}
