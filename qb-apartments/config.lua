-- Apartments = {}

-- Apartments.Starting = true

-- Apartments.SpawnOffset = 30

-- Apartments.Locations = {
--     ["apartment1"] = {
--         name = "apartment1",
--         label = "South Rockford Drive",
--         coords = {
--             enter = vector4(-667.372, -1106.034, 14.629, 65.033),
--         }
--     },
--     ["apartment2"] = {
--         name = "apartment2",
--         label = "Morningwood Blvd",
--         coords = {
--             enter = vector4(-1288.046, -430.126, 35.077, 305.348),
--         }
--     },
--     ["apartment3"] = {
--         name = "apartment3",
--         label = "Integrity Way",
--         coords = {
--             enter = vector4(269.075, -640.672, 42.02, 70.01),
--         }
--     },
--     ["apartment4"] = {
--         name = "apartment4",
--         label = "Tinsel Towers",
--         coords = {
--             enter = vector4(-621.016, 46.677, 43.591, 179.36),
--         }
--     },
--     ["apartment5"] = {
--         name = "apartment5",
--         label = "Fantastic Plaza",
--         coords = {
--             enter = vector4(291.517, -1078.674, 29.405, 270.75),
--         }
--     },
-- }

-- Apartments.Language = {
--     ['enter'] = 'Enter Apartment',
--     ['ring_doorbell'] = 'Ring Doorbell',
--     ['logout'] = 'Logout Character',
--     ['change_outfit'] = 'Change Outfit',
--     ['open_stash'] = 'Open Stash',
--     ['move_here'] = 'Move Here',
--     ['open_door'] = 'Open Door',
--     ['leave'] = 'Leave Apartment',
--     ['at_the_door'] = 'Someone is at the door!',
--     ['to_far_from_door'] = 'You are to far away from the Doorbell',
--     ['close_menu'] = "⬅ Close Menu",
--     ['tennants'] = 'Tennants',
--     ['nobody_home'] = 'There is nobody home..',
--     ['receive_apart'] = "You got a apartment",
--     ['changed_apart'] = "You moved apartments"
-- }



Apartments = {} -- Don't touch

Apartments.SpawnOffset = 30 -- Don't touch

Apartments.Locations = {
    ["apartment1"] = { -- Needs to be unique
        name = "apartment1", -- Apartment id
        label = "South Rockford Drive", -- Apartment Label (for Blip and other stuff)
        coords = {
            enter = {x = -667.372, y = -1106.034, z = 14.629, h = 65.033}, -- Enter Apartment Marker Location
            doorbell = {x = -667.601, y = -1107.354, z = 15.133, h = 65.033}, -- Exit Apartment Marker Location
        }
    },
    ["apartment2"] = {
        name = "apartment2",
        label = "Morningwood Blvd",
        coords = {
            enter = {x = -1288.046, y = -430.126, z = 35.077, h = 305.348},
            doorbell = {x = -667.682, y = -1105.876, z = 14.629, h = 65.033},
        }
    },
    ["apartment3"] = {
        name = "apartment3",
        label = "Integrity Way",
        coords = {
            enter = {x = 269.075, y = -640.672, z = 42.02, h = 70.01},
            doorbell = {x = -667.682, y = -1105.876, z = 14.629, h = 65.033},
        }
    },
    ["apartment4"] = {
        name = "apartment4",
        label = "Tinsel Towers",
        coords = {
            enter = {x = -621.016, y = 46.677, z = 43.591, h = 179.36},
            doorbell = {x = -667.682, y = -1105.876, z = 14.629, h = 65.033},
        }
    },
    ["apartment5"] = {
        name = "apartment5",
        label = "Fantastic Plaza",
        coords = {
            enter = {x = 291.517, y = -1078.674, z = 29.405, h = 270.75},
            doorbell = {x = -667.682, y = -1105.876, z = 14.629, h = 65.033},
        }
    },
}


Apartments.Language = {
    ['enter'] = 'Enter Apartment',
    ['ring_doorbell'] = 'Ring Doorbell',
    ['logout'] = 'Logout Character',
    ['change_outfit'] = 'Change Outfit',
    ['open_stash'] = 'Open Stash',
    ['move_here'] = 'Move Here',
    ['open_door'] = 'Open Door',
    ['leave'] = 'Leave Apartment',
    ['at_the_door'] = 'Someone is at the door!',
    ['to_far_from_door'] = 'You are to far away from the Doorbell',
    ['close_menu'] = "⬅ Close Menu",
    ['tennants'] = 'Tennants',
    ['nobody_home'] = 'There is nobody home..',
    ['receive_apart'] = "You got a apartment",
    ['changed_apart'] = "You moved apartments"
}
