Config = {}

Config.DoorHeading = 215.52 -- Change this to the proper heading to look at the door you start the runs with
Config.Price = 1000 -- Amount you have to pay to start a run 
Config.CokeEffectTime = 60000 -- Time in ms the effects of coke will last for
Config.BrickAmount = math.random(7,10) -- Change the numbers to how much coke you want players to receive after breaking down bricks
Config.BrickRemove = 1 -- Amount of brick you want to take after processing

Config.Locations = {
	[1] = { 
		fuel = {x = 4508.69, y = -4509.32, z = 4.84}, -- location of the jerry can/waypoint
		plane = {x = 2134.27, y = 4781.79, z = 40.97, h = 218.87}, -- Plane Location
		delivery = {x = 2916.86, y = 1476.89, z = -0.43}, -- Delivery Location
		hangar = {x = 4508.69, y = -4509.32, z = 4.84}, -- Plane Parking Location
		parking = {x = 4508.69, y = -4509.32, z = 4.84, h = 23.31}, -- Dont Mess
	[2] = { 
		fuel = {x = 4508.69, y = -4509.32, z = 4.84},
		plane = {x = 736.6801, y = 2973.17, z = 93.81644, h = 284.13},
		delivery = {x = -195.8702, y = 7051.156, z = 0.8857441},
		hangar = {x = 4508.69, y = -4509.32, z = 4.84},
		parking = {x = 4508.69, y = -4509.32, z = 4.84, h = 23.31},															
	},
	[3] = { 
		fuel = {x = 4508.69, y = -4509.32, z = 4.84},
		plane = {x = 736.6801, y = 2973.17, z = 93.81644, h = 284.13},
		delivery = {x = -1865.63, y = 4660.856, z = 0.6967332},
		hangar = {x = 4508.69, y = -4509.32, z = 4.84},
		parking = {x = 4508.69, y = -4509.32, z = 4.84, h = 23.31},															
	},
	[4] = { 
		fuel = {x = 4508.69, y = -4509.32, z = 4.84},
		plane = {x = 736.6801, y = 2973.17, z = 93.81644, h = 284.13},
		delivery = {x = -2158.379, y = 2596.311, z = 1.746785},
		hangar = {x = 4508.69, y = -4509.32, z = 4.84},
		parking = {x = 4508.69, y = -4509.32, z = 4.84, h = 23.31},														
	},
    }
}
