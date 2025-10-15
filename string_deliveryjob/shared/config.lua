Config = {}

-- Delivery Service Settings (No Job Required)
Config.ServiceName = 'delivery'
Config.ServiceLabel = 'Delivery Service'

-- Van Settings
Config.VanModel = 'burrito3'
Config.GiveKeys = true -- Set to true to automatically give vehicle keys
Config.VanSpawns = {
    {
        coords = vector4(68.368186, 122.06739, 79.137809, 154.8769), -- Port of Los Santos
        label = 'Delivery Van Spawn'
    }
}

-- Loading Settings
Config.MaxItemsPerDelivery = 20
Config.LoadingTime = 5000 -- 5 seconds per item
Config.UnloadingTime = 3000 -- 3 seconds per item
Config.SpawnPhysicalBoxes = true -- Spawn actual boxes that need to be loaded manually
Config.BoxPickupTime = 2000 -- Time to pick up a box (2 seconds)
Config.BoxLoadTime = 3000 -- Time to load a box into van (3 seconds)
Config.BoxUnloadTime = 2500 -- Time to unload a box from van (2.5 seconds)
Config.BoxDeliverTime = 3000 -- Time to deliver a box to location (3 seconds)

-- Payment Settings
Config.PaymentPerItem = 150
Config.BonusPercentage = 0.15 -- 15% bonus for completing all deliveries
Config.FuelCost = 50 -- Cost to refuel van

-- Items to deliver
Config.DeliveryItems = {
    'package_small',
    'package_medium', 
    'package_large',
    'box_electronics',
    'box_clothing',
    'box_food'
}

-- Box Models for Physical Spawning (Medium boxes only)
Config.BoxModels = {
    'prop_cs_cardbox_01'
}

-- Pickup Locations (Warehouses)
Config.PickupLocations = {
    -- {
    --     name = 'Port Warehouse',
    --     coords = vec3(-1040.32, -2723.84, 20.17),
    --     heading = 240.0,
    --     blip = {
    --         sprite = 478,
    --         color = 2,
    --         scale = 0.8
    --     },
    --     items = {'package_small', 'package_medium', 'box_electronics'},
    --     boxSpawnArea = {
    --         center = vec3(-1038.0, -2725.0, 19.47),
    --         radius = 6.0
    --     },
    --     ped = {
    --         model = 's_m_m_dockwork_01',
    --         coords = vec4(-1042.5, -2721.8, 20.17, 150.0),
    --         scenario = 'WORLD_HUMAN_STAND_MOBILE'
    --     }
    -- },
    {
        name = 'Depot',
        coords = vector3(-733.6965, -2465.986, 13.940336),
        heading = 270.0,
        blip = {
            sprite = 478,
            color = 3,
            scale = 0.8
        },
        items = {'package_large', 'box_clothing', 'box_food'},
        boxSpawnArea = {
            center = vector3(-738.6152, -2470.315, 13.190724),
            radius = 6.0
        },
        ped = {
            model = 's_m_y_construct_01',
            coords = vector4(-733.6965, -2465.986, 13.940336, 60.603458),
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        }
    }
}

-- Delivery Locations
-- Delivery Locations
Config.DeliveryLocations = {
    -- Original locations
    {
        name = 'Mirror Park Store', -- Done
        coords = vec3(1160.70, -312.23, 69.35),
        heading = 100.0,
        payment = 200,
        blip = {
            sprite = 478,
            color = 5,
            scale = 0.7
        },
        ped = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(1160.7388, -312.2271, 69.35501, 20.706165),
            scenario = 'WORLD_HUMAN_SMOKING'
        }
    },
    {
        name = 'Sandy Shores Shop', -- Done
        coords = vector3(1953.26, 3752.98, 32.21),
        heading = 300.0,
        payment = 250,
        blip = {
            sprite = 478,
            color = 5,
            scale = 0.7
        },
        ped = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(1953.3183, 3753.0083, 32.210853, 33.347099),
            scenario = 'WORLD_HUMAN_SMOKING'
        }
    },
    {
        name = 'Paleto Bay Store', -- Done
        coords = vec3(-378.34, 6035.55, 31.54),
        heading = 225.0,
        payment = 300,
        blip = {
            sprite = 478,
            color = 5,
            scale = 0.7
        },
        ped = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(-378.3171, 6035.5239, 31.538417, 141.21292),
            scenario = 'WORLD_HUMAN_SMOKING'
        }
    },
    {
        name = 'Vespucci Beach Shop', -- Done
        coords = vector3(-1492.437, -382.6172, 40.150112),
        heading = 133.0,
        payment = 180,
        blip = {
            sprite = 478,
            color = 5,
            scale = 0.7
        },
        ped = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(-1492.336, -382.7166, 40.156085, 147.24702),
            scenario = 'WORLD_HUMAN_STAND_IMPATIENT'
        }
    },
    {
        name = 'Davis Store', -- Done
        coords = vector3(-41.25938, -1748.157, 29.571046),
        heading = 50.0,
        payment = 25,
        blip = {
            sprite = 478,
            color = 5,
            scale = 0.7
        },
        ped = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(-41.25938, -1748.157, 29.571046, 321.94003),
            scenario = 'WORLD_HUMAN_STAND_IMPATIENT'
        }
    },
    -- Downtown Area 1
    {
        name = 'Downtown House 1', -- Done
        coords = vector3(-17.98343, -296.675, 45.747093),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_m_bevhills_01',
            coords = vector4(-17.98343, -296.675, 45.747093, 262.14834),
            scenario = 'WORLD_HUMAN_SMOKING'
        }
    },
    {
        name = 'Downtown House 2', -- Done
        coords = vector3(140.99586, -293.9532, 46.303344),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_f_y_business_01',
            coords = vector4(140.99586, -293.9532, 46.303344, 254.88475),
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        }
    },
    {
        name = 'Downtown House 3', -- Done
        coords = vector3(96.246421, -275.722, 47.439334),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_m_business_01',
            coords = vector4(96.246421, -275.722, 47.439334, 154.92529),
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        }
    },
    {
        name = 'Downtown House 4', -- Done
        coords = vector3(-28.9595, -234.0174, 46.293228),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_f_m_business_02',
            coords = vector4(-28.9595, -234.0174, 46.293228, 249.51498),
            scenario = 'WORLD_HUMAN_STAND_IMPATIENT'
        }
    },
    {
        name = 'Downtown House 5', -- Done
        coords = vector3(-115.598, -372.924, 38.129138),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_f_m_downtown_01',
            coords = vector4(-115.598, -372.924, 38.129138, 70.24916),
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        }
    },
    {
        name = 'Downtown House 6', -- Done
        coords = vector3(-22.1247, -191.9745, 52.363666),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_y_hipster_01',
            coords = vector4(-22.1247, -191.9745, 52.363666, 159.71554),
            scenario = 'WORLD_HUMAN_SMOKING'
        }
    },
    {
        name = 'Downtown House 7', -- Done
        coords = vector3(-8.179814, -155.2481, 56.641555),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_f_y_hipster_01',
            coords = vector4(-8.179814, -155.2481, 56.641555, 326.17324),
            scenario = 'WORLD_HUMAN_HANG_OUT_STREET'
        }
    },
    {
        name = 'Downtown House 8', -- Done 
        coords = vector3(18.429533, -209.4854, 52.857257),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_y_downtown_01',
            coords = vector4(18.429533, -209.4854, 52.857257, 249.6757),
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        }
    },
    {
        name = 'Downtown House 9', -- Done
        coords = vector3(159.6137, -253.6883, 51.399662),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_f_m_downtown_01',
            coords = vector4(159.6137, -253.6883, 51.399662, 161.69506),
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        }
    },
    {
        name = 'Downtown House 10', -- Done
        coords = vector3(110.84354, -243.1698, 51.399436),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_y_business_01',
            coords = vector4(110.84354, -243.1698, 51.399436, 251.06115),
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        }
    },
    {
        name = 'Downtown House 11',     -- Done
        coords = vector3(311.17034, -203.5493, 54.221771),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_y_business_01',
            coords = vector4(311.17034, -203.5493, 54.221771, 248.26924),
            scenario = 'WORLD_HUMAN_SMOKING'
        }
    },
    {
        name = 'Downtown House 12',     -- Done 
        coords = vector3(340.98916, -214.9007, 54.221767),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_f_y_business_02',
            coords = vector4(340.98916, -214.9007, 54.221767, 72.986747),
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        }
    },
    {
        name = 'Downtown House 13', -- Done
        coords = vector3(548.4273, -202.5506, 54.473583),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_y_business_02',
            coords = vector4(548.4273, -202.5506, 54.473583, 182.86424),
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        }
    },
    {
        name = 'Downtown House 14', -- Done 
        coords = vector3(313.46307, -174.3883, 58.129386),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_f_m_business_02',
            coords = vector4(313.46307, -174.3883, 58.129386, 166.7832),
            scenario = 'WORLD_HUMAN_HANG_OUT_STREET'
        }
    },
    {
        name = 'Downtown House 15', -- Done
        coords = vector3(390.16403, -75.19274, 68.180488),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_m_bevhills_02',
            coords = vector4(390.16403, -75.19274, 68.180488, 170.63713),
            scenario = 'WORLD_HUMAN_SMOKING'
        }
    },
    {
        name = 'Downtown House 16', -- Done
        coords = vector3(352.60052, -142.919, 66.688186),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_f_m_bevhills_02',
            coords = vector4(352.60052, -142.919, 66.688186, 341.9627),
            scenario = 'WORLD_HUMAN_STAND_IMPATIENT'
        }
    },
    {
        name = 'Downtown House 17', -- Done
        coords = vector3(286.01763, -160.442, 64.617034),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_y_genstreet_01',
            coords = vector4(286.01541, -160.4416, 64.617034, 68.220382),
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        }
    },
    {
        name = 'Downtown House 18', -- Done
        coords = vector3(233.37429, -141.1994, 63.763534),
        heading = 0.0,
        payment = 13,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_y_genstreet_01',
            coords = vector4(233.37429, -141.1994, 63.763534, 253.44839),
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        }
    },
    {
        name = 'Downtown House 19', -- Done
        coords = vector3(217.90007, -19.47288, 69.896385),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_m_bevhills_01',
            coords = vector4(217.90023, -19.47355, 69.896385, 161.47636),
            scenario = 'WORLD_HUMAN_SMOKING'
        }
    },
    {
        name = 'Downtown House 20', -- Done
        coords = vector3(176.43055, -65.47017, 68.436027),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_f_m_bevhills_01',
            coords = vector4(176.43055, -65.47017, 68.436027, 344.43438),
            scenario = 'WORLD_HUMAN_HANG_OUT_STREET'
        }
    },
    {
        name = 'Downtown House 21', -- Done 
        coords = vector3(156.2722, -116.9197, 62.597465),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_y_hipster_02',
            coords = vector4(156.2722, -116.9197, 62.597465, 256.46954),
            scenario = 'WORLD_HUMAN_STAND_IMPATIENT'
        }
    },
    {
        name = 'Downtown House 22', -- Done
        coords = vector3(196.91087, -162.743, 56.604312),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_f_y_hipster_02',
            coords = vector4(196.91087, -162.743, 56.604312, 351.67843),
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        }
    },
    {
        name = 'Downtown House 23', -- Done
        coords = vector3(173.1282, -25.94004, 68.346549),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_m_business_01',
            coords = vector4(173.1282, -25.94004, 68.346549, 169.54826),
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        }
    },
    {
        name = 'Downtown House 24', -- Done
        coords = vector3(111.92639, -100.0373, 60.435146),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_f_m_business_02',
            coords = vector4(111.92639, -100.0373, 60.435146, 83.304328),
            scenario = 'WORLD_HUMAN_SMOKING'
        }
    },
    {
        name = 'Downtown House 25', -- Done
        coords = vector3(87.744285, -99.31121, 59.537002),
        heading = 0.0,
        payment = 30,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_y_business_03',
            coords = vector4(87.744987, -99.3111, 59.537212, 244.79779),
            scenario = 'WORLD_HUMAN_STAND_IMPATIENT'
        }
    },
    {
        name = 'Downtown House 26', -- Done
        coords = vector3(38.69561, -71.5332, 63.934226),
        heading = 0.0,
        payment = 30,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_f_y_business_03',
            coords = vector4(38.69561, -71.5332, 63.934226, 72.856018),
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        }
    },
    {
        name = 'Downtown House 27', -- Done
        coords = vector3(-13.52283, -84.04398, 56.894294),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_y_genstreet_02',
            coords = vector4(-13.52283, -84.04398, 56.894294, 344.42822),
            scenario = 'WORLD_HUMAN_HANG_OUT_STREET'
        }
    },
    -- Midtown Area 2
    {
        name = 'Midtown House 1', -- Done
        coords = vector3(386.41192, -899.6513, 29.450811),
        heading = 0.0,
        payment = 10,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_m_skater_01',
            coords = vector4(386.41192, -899.6513, 29.450811, 182.88232),
            scenario = 'WORLD_HUMAN_SMOKING'
        }
    },
    {
        name = 'Midtown House 2', -- Done
        coords = vector3(372.47555, -827.0214, 29.292669),
        heading = 0.0,
        payment = 10,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_m_skater_01',
            coords = vector4(372.47555, -827.0214, 29.292669, 89.443656),
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        }
    },
    {
        name = 'Midtown House 3', -- Done
        coords = vector3(328.09216, -940.1608, 29.4062),
        heading = 0.0,
        payment = 10,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_y_mexthug_01',
            coords = vector4(328.09216, -940.1608, 29.4062, 183.34016),
            scenario = 'WORLD_HUMAN_HANG_OUT_STREET'
        }
    },
    {
        name = 'Midtown House 4', -- Done
        coords = vector3(309.57861, -906.966, 29.293813),
        heading = 0.0,
        payment = 10,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_y_mexthug_01',
            coords = vector4(309.57861, -906.966, 29.293813, 87.230316),
            scenario = 'WORLD_HUMAN_STAND_IMPATIENT'
        }
    },
    {
        name = 'Midtown House 5', --Done
        coords = vector3(315.14459, -684.5802, 30.039392),
        heading = 0.0,
        payment = 10,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_m_eastsa_01',
            coords = vector4(315.14459, -684.5802, 30.039392, 252.39224),
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        }
    },
    -- East Village Area 3
    {
        name = 'East Village House 1', --Done
        coords = vector3(895.99798, -144.8575, 76.91761),
        heading = 0.0,
        payment = 10,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_m_eastsa_01',
            coords = vector4(895.99798, -144.8575, 76.91761, 325.26324),
            scenario = 'WORLD_HUMAN_SMOKING'
        }
    },
    {
        name = 'East Village House 2', -- Done 
        coords = vector3(963.6369, -117.5354, 74.353065),
        heading = 0.0,
        payment = 10,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_m_eastsa_01',
            coords = vector4(963.6369, -117.5354, 74.353065, 229.02854),
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        }
    },
    {
        name = 'East Village House 3', -- Done
        coords = vector3(941.54522, -257.9633, 67.455123),
        heading = 0.0,
        payment = 15,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_y_vinewood_02',
            coords = vector4(941.54522, -257.9633, 67.455123, 150.1248),
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        }
    },
    -- Vinewood Area 4
    {
        name = 'Vinewood House 1', -- Done
        coords = vector3(-342.4227, 111.78558, 66.767791),
        heading = 0.0,
        payment = 14,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_f_m_bevhills_01',
            coords = vector4(-342.4227, 111.78558, 66.767791, 1.1809586),
            scenario = 'WORLD_HUMAN_YOGA'
        }
    },
    {
        name = 'Vinewood House 2', -- Done
        coords = vector3(-395.2312, 146.73565, 65.722778),
        heading = 0.0,
        payment = 14,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_m_bevhills_02',
            coords = vector4(-395.2312, 146.73565, 65.722778, 92.616737),
            scenario = 'WORLD_HUMAN_STAND_IMPATIENT'
        }
    },
    -- Beach Area 5
    {
        name = 'Beach House 1', -- Done
        coords = vector3(-1197.819, -738.7117, 20.639305),
        heading = 0.0,
        payment = 15,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_m_bevhills_02',
            coords = vector4(-1197.82, -738.7113, 20.639348, 31.816501),
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        }
    },
    {
        name = 'Beach House 2', -- Done
        coords = vector3(-1224.378, -711.295, 22.34291),
        heading = 0.0,
        payment = 15,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_f_y_beach_01',
            coords = vector4(-1224.378, -711.295, 22.34291, 317.56686),
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        }
    },
    -- Vinewood Hills Area 6
    {
        name = 'Vinewood Hills House 1', -- Done
        coords = vector3(-1080.459, 454.27136, 76.539787),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_m_bevhills_01',
            coords = vector4(-1080.459, 454.27136, 76.539787, 146.26689),
            scenario = 'WORLD_HUMAN_SMOKING'
        }
    },
    {
        name = 'Vinewood Hills House 2', --Done 
        coords = vector3(-1037.152, 493.06823, 81.550354),
        heading = 0.0,
        payment = 25,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_f_m_bevhills_02',
            coords = vector4(-1037.152, 493.06823, 81.550354, 261.87161),
            scenario = 'WORLD_HUMAN_STAND_IMPATIENT'
        }
    },
    -- Docks & Industrial Area 7
    {
        name = 'Docks House 1', -- Done
        coords = vector3(-50.354, -1783.216, 28.300817),
        heading = 0.0,
        payment = 16,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 's_m_m_dockwork_01',
            coords = vector4(-50.354, -1783.216, 28.300817, 139.15872),
            scenario = 'WORLD_HUMAN_SMOKING'
        }
    },
    {
        name = 'Docks House 2', -- Done
        coords = vector3(15.779458, -1881.452, 23.101634),
        heading = 0.0,
        payment = 16,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 's_m_y_dockwork_01',
            coords = vector4(15.779458, -1881.452, 23.101634, 321.73989),
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        }
    },
    -- Middle Area 8
    {
        name = 'Middle House 1', -- Done
        coords = vector3(1368.3997, 1149.2271, 113.75895),
        heading = 0.0,
        payment = 21,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_m_genfat_01',
            coords = vector4(1368.3997, 1149.2271, 113.75895, 26.39331),
            scenario = 'WORLD_HUMAN_STAND_IMPATIENT'
        }
    },
    {
        name = 'Middle House 2', -- Done
        coords = vector3(1535.9133, 2232.0607, 77.699058),
        heading = 0.0,
        payment = 21,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_m_genfat_01',
            coords = vector4(1535.9133, 2232.0607, 77.699058, 91.159072),
            scenario = 'WORLD_HUMAN_SMOKING'
        }
    },
    -- Sandy Shores Area 9
    {
        name = 'Sandy Shores House 1', -- Done
        coords = vector3(910.89782, 3644.8449, 32.677967),
        heading = 0.0,
        payment = 18,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_m_hillbilly_01',
            coords = vector4(910.89782, 3644.8449, 32.677967, 183.60003),
            scenario = 'WORLD_HUMAN_DRINKING'
        }
    },
    {
        name = 'Sandy Shores House 2', -- Done
        coords = vector3(1385.2219, 3671.944, 33.603675),
        heading = 0.0,
        payment = 18,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_m_hillbilly_01',
            coords = vector4(1385.2219, 3671.944, 33.603675, 14.613489),
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        }
    },
    -- Paleto Area 10
    {
        name = 'Paleto House 1', -- Done
        coords = vector3(1698.7803, 6426.0073, 32.763858),
        heading = 0.0,
        payment = 35,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_m_farmer_01',
            coords = vector4(1698.7803, 6426.0073, 32.763858, 152.89343),
            scenario = 'WORLD_HUMAN_HANG_OUT_STREET'
        }
    },
    {
        name = 'Paleto House 2', -- Done
        coords = vector3(416.13586, 6520.6181, 27.737827),
        heading = 0.0,
        payment = 30,
        blip = { sprite = 478, color = 5, scale = 0.7 },
        ped = {
            model = 'a_m_m_farmer_01',
            coords = vector4(416.13623, 6520.6181, 27.737747, 265.16247),
            scenario = 'WORLD_HUMAN_HANG_OUT_STREET'
        }
    }
}

-- Delivery Service Location
Config.JobCenter = {
    coords = vector3(78.856849, 112.5369, 81.168075),
    heading = 332.0,
    ped = {
        model = 's_m_m_trucker_01',
        coords = vector4(78.856849, 112.5369, 81.168075, 160.45103),
        scenario = 'WORLD_HUMAN_CLIPBOARD'
    },
    blip = {
        sprite = 477,
        color = 2,
        scale = 0.5,
        label = 'Delivery Service'
    }
}

-- Messages
Config.Messages = {
    session_started = 'Delivery session started! Go to a warehouse to load your van.',
    session_finished = 'All deliveries completed! You can start another session anytime.',
    van_spawned = 'Your delivery van has been spawned.',
    van_loaded = 'Items loaded into van. Check your delivery locations!',
    delivery_complete = 'Delivery completed! Payment received.',
    not_enough_items = 'You need at least 1 item to start deliveries.',
    van_full = 'Your van is full! Maximum %s items allowed.',
    loading_items = 'Loading items into van...',
    unloading_items = 'Delivering items...',
    session_cancelled = 'Delivery session cancelled.',
    boxes_spawned = 'Boxes spawned at the warehouse! Pick them up and load them into your van.',
    picking_up_box = 'Picking up box...',
    loading_box = 'Loading box into van...',
    box_loaded = 'Box loaded! %s/%s boxes in van.',
    need_to_be_near_van = 'You need to be near your van to load the box!',
    carrying_box = 'You are already carrying a box!',
    unloading_box = 'Taking box from van...',
    delivering_box = 'Delivering box...',
    box_delivered = 'Box delivered! %s/%s boxes remaining.',
    need_box_for_delivery = 'You need to get a box from your van first!',
    van_empty = 'Your van is empty! No boxes to unload.'
}