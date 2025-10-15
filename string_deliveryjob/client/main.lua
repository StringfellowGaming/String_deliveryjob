
local hasActiveSession = false
local currentVan = nil
local vanBlip = nil
local warehouseBlips = {}
local deliveryBlips = {}
local deliveryPed = nil
local isLoading = false
local currentDeliveries = {}
local warehouseZones = {}
local deliveryZones = {}
local warehousePeds = {}
local deliveryLocationPeds = {}
local spawnedBoxes = {}
local carryingBox = false
local carriedBoxModel = nil
local boxesInVan = 0
local maxBoxes = 0
local deliveryBoxesRemaining = {}


CreateThread(function()
    Wait(2000)
    CreateDeliveryPed()
    CreateDeliveryBlip()
end)


function CreateDeliveryPed()
    if deliveryPed then return end
    
    local pedData = Config.JobCenter.ped
    
    RequestModel(pedData.model)
    while not HasModelLoaded(pedData.model) do
        Wait(1)
    end
    
    deliveryPed = CreatePed(4, GetHashKey(pedData.model), pedData.coords.x, pedData.coords.y, pedData.coords.z - 1.0, pedData.coords.w, false, true)
    SetEntityHeading(deliveryPed, pedData.coords.w)
    FreezeEntityPosition(deliveryPed, true)
    SetEntityInvincible(deliveryPed, true)
    SetBlockingOfNonTemporaryEvents(deliveryPed, true)
    TaskStartScenarioInPlace(deliveryPed, pedData.scenario, 0, true)
    
   
    exports.ox_target:addLocalEntity(deliveryPed, {
        {
            name = 'delivery_session_start',
            event = 'delivery:client:openDeliveryMenu',
            icon = 'fas fa-truck',
            label = 'Start Delivery Service',
            distance = 2.5
        }
    })
end


function CreateDeliveryBlip()
    local blipData = Config.JobCenter.blip
    local blip = AddBlipForCoord(Config.JobCenter.coords.x, Config.JobCenter.coords.y, Config.JobCenter.coords.z)
    
    SetBlipSprite(blip, blipData.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, blipData.scale)
    SetBlipColour(blip, blipData.color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(blipData.label)
    EndTextCommandSetBlipName(blip)
end


function CreateDeliveryLocationPed(locationIndex)
    local location = Config.DeliveryLocations[locationIndex]
    if not location or not location.ped or deliveryLocationPeds[locationIndex] then 
        return 
    end
    
    CreateThread(function()
        local pedData = location.ped
        
        RequestModel(GetHashKey(pedData.model))
        while not HasModelLoaded(GetHashKey(pedData.model)) do
            Wait(1)
        end
        
        local ped = CreatePed(4, GetHashKey(pedData.model), pedData.coords.x, pedData.coords.y, pedData.coords.z - 1.0, pedData.coords.w, false, true)
        SetEntityHeading(ped, pedData.coords.w)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskStartScenarioInPlace(ped, pedData.scenario, 0, true)
        
      
        deliveryLocationPeds[locationIndex] = ped
    end)
end


function RemoveDeliveryLocationPed(locationIndex)
    if deliveryLocationPeds[locationIndex] then
        DeletePed(deliveryLocationPeds[locationIndex])
        deliveryLocationPeds[locationIndex] = nil
    end
end


RegisterNetEvent('delivery:client:openDeliveryMenu', function()
    lib.callback('delivery:server:hasActiveSession', false, function(hasActiveSession)
        if hasActiveSession then
            ShowSessionManagementMenu()
        else
            ShowSessionStartMenu()
        end
    end)
end)

function ShowSessionStartMenu()
    local input = lib.inputDialog('Delivery Service', {
        {type = 'select', label = 'Welcome to the Delivery Service!', description = 'Anyone can make deliveries! Load packages at warehouses and deliver them around the city for payment.', options = {
            {value = 'start', label = 'Start Delivering'},
            {value = 'cancel', label = 'Cancel'}
        }}
    })
    
    if input and input[1] == 'start' then
        TriggerServerEvent('delivery:server:startJob')
    end
end

function ShowSessionManagementMenu()
    local input = lib.inputDialog('Delivery Service Management', {
        {type = 'select', label = 'Current Status: Active Session', options = {
            {value = 'stop', label = 'Stop Delivering'}
        }}
    })
    
    if input then
        if input[1] == 'stop' then
            TriggerServerEvent('delivery:server:stopJob')
        end
    end
end


function SpawnDeliveryVan()
    if currentVan then
        exports.qbx_core:Notify('You already have a van spawned!', 'error')
        return
    end
    
    local spawnPoint = Config.VanSpawns[1]
    local vehicleHash = GetHashKey(Config.VanModel)
    
    RequestModel(vehicleHash)
    while not HasModelLoaded(vehicleHash) do
        Wait(1)
    end
    
    currentVan = CreateVehicle(vehicleHash, spawnPoint.coords.x, spawnPoint.coords.y, spawnPoint.coords.z, spawnPoint.coords.w, true, false)
    
    local plate = GetVehicleNumberPlateText(currentVan)
    local netId = NetworkGetNetworkIdFromEntity(currentVan)
    
    SetEntityAsMissionEntity(currentVan, true, true)
    SetVehicleOnGroundProperly(currentVan)
    
  
    if Config.GiveKeys then
       
        TriggerEvent('vehiclekeys:client:SetOwner', plate)

        TriggerServerEvent('delivery:server:giveKeys', plate)
        
        exports.qbx_core:Notify('Vehicle keys received!', 'success')
    end
    
   
    vanBlip = AddBlipForEntity(currentVan)
    SetBlipSprite(vanBlip, 477)
    SetBlipColour(vanBlip, 2)
    SetBlipScale(vanBlip, 0.8)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Delivery Van')
    EndTextCommandSetBlipName(vanBlip)
    

    
    TriggerServerEvent('delivery:server:spawnVan', {
        plate = plate,
        netId = netId
    })
    
    CreateWarehouseBlips()
end

function CreateWarehouseBlips()
    for i, warehouse in pairs(Config.PickupLocations) do
        local blip = AddBlipForCoord(warehouse.coords.x, warehouse.coords.y, warehouse.coords.z)
        SetBlipSprite(blip, warehouse.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, warehouse.blip.scale)
        SetBlipColour(blip, warehouse.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(warehouse.name)
        EndTextCommandSetBlipName(blip)
        
        table.insert(warehouseBlips, blip)
        
       
        if warehouse.ped then
            CreateWarehousePed(i, warehouse)
        end
    end
end


function CreateWarehousePed(warehouseIndex, warehouse)
    local pedData = warehouse.ped
    
    RequestModel(GetHashKey(pedData.model))
    while not HasModelLoaded(GetHashKey(pedData.model)) do
        Wait(1)
    end
    
    local ped = CreatePed(4, GetHashKey(pedData.model), pedData.coords.x, pedData.coords.y, pedData.coords.z - 1.0, pedData.coords.w, false, true)
    SetEntityHeading(ped, pedData.coords.w)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskStartScenarioInPlace(ped, pedData.scenario, 0, true)
    

    warehousePeds[warehouseIndex] = ped
    
    
    exports.ox_target:addLocalEntity(ped, {
        {
            name = 'warehouse_worker_' .. warehouseIndex,
            event = 'delivery:client:loadItems',
            icon = 'fas fa-boxes',
            label = 'Request Load (' .. warehouse.name .. ')',
            distance = 2.5,
            warehouseIndex = warehouseIndex
        }
    })
end




RegisterNetEvent('delivery:client:loadItems', function(data)
    local warehouseIndex = data.warehouseIndex
    
    if not currentVan then
        exports.qbx_core:Notify('You need a van first!', 'error')
        return
    end
    
    if isLoading then
        exports.qbx_core:Notify('Already loading items!', 'error')
        return
    end
    
    local input = lib.inputDialog('Load Items', {
        {type = 'number', label = 'How many items to load?', description = 'Max: ' .. Config.MaxItemsPerDelivery, min = 1, max = Config.MaxItemsPerDelivery, required = true}
    })
    
    if input and input[1] then
        local itemCount = tonumber(input[1])
        if itemCount and itemCount > 0 and itemCount <= Config.MaxItemsPerDelivery then
            LoadItemsIntoVan(warehouseIndex, itemCount)
        end
    end
end)

function LoadItemsIntoVan(warehouseIndex, itemCount)
    local warehouse = Config.PickupLocations[warehouseIndex]
    
    if not currentVan then
        exports.qbx_core:Notify('You need to spawn a van first!', 'error')
        return
    end
    
    if Config.SpawnPhysicalBoxes then
        SpawnBoxesAroundVan(itemCount, warehouseIndex)
    else
   
        local playerPed = PlayerPedId()
        local vanCoords = GetEntityCoords(currentVan)
        local playerCoords = GetEntityCoords(playerPed)
        
        
        if #(playerCoords - vanCoords) > 5.0 then
            exports.qbx_core:Notify('You need to be closer to your van!', 'error')
            return
        end
        
        isLoading = true
        exports.qbx_core:Notify(Config.Messages.loading_items, 'primary')
        
  
        local totalLoadTime = itemCount * Config.LoadingTime
        if lib.progressBar then
            if lib.progressBar({
                duration = totalLoadTime,
                label = 'Loading items into van...',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                    move = true,
                    combat = true
                },
                anim = {
                    dict = 'anim@heists@box_carry@',
                    clip = 'idle'
                }
            }) then
                isLoading = false
                TriggerServerEvent('delivery:server:loadItems', warehouseIndex, itemCount)
            else
                isLoading = false
                exports.qbx_core:Notify('Loading cancelled!', 'error')
            end
        else
            
            Wait(totalLoadTime)
            isLoading = false
            TriggerServerEvent('delivery:server:loadItems', warehouseIndex, itemCount)
        end
    end
end


function SpawnBoxesAroundVan(itemCount, warehouseIndex)
    if not currentVan then return end
    
    local warehouse = Config.PickupLocations[warehouseIndex]
    if not warehouse then return end
    
    local warehouseCoords = warehouse.coords
    maxBoxes = itemCount
    boxesInVan = 0
    
   
    ClearSpawnedBoxes()
    
    CreateThread(function()
       
        local spawnArea = warehouse.boxSpawnArea or { center = warehouseCoords, radius = 5.0 }
        local spawnCenter = spawnArea.center
        
        
        local boxesPerRow = math.min(4, math.ceil(math.sqrt(itemCount))) 
        local boxSpacing = 0.9 
        local boxHeight = 0.45 
        
        for i = 1, itemCount do
            
            local baseBoxes = boxesPerRow * boxesPerRow
            local layer = math.floor((i - 1) / baseBoxes)
            local posInLayer = (i - 1) % baseBoxes
            local row = math.floor(posInLayer / boxesPerRow)
            local col = posInLayer % boxesPerRow
            
            
            local layerOffset = layer * 0.1
            
           
            local offsetX = (col - (boxesPerRow - 1) / 2) * boxSpacing + (math.random(-1, 1) * layerOffset)
            local offsetY = (row - (boxesPerRow - 1) / 2) * boxSpacing + (math.random(-1, 1) * layerOffset)
            local offsetZ = layer * boxHeight
            
            local spawnCoords = vector3(
                spawnCenter.x + offsetX,
                spawnCenter.y + offsetY,
                spawnCenter.z + offsetZ
            )
            
            
            local boxModel = Config.BoxModels[math.random(#Config.BoxModels)]
            local boxHash = GetHashKey(boxModel)
            
            RequestModel(boxHash)
            while not HasModelLoaded(boxHash) do
                Wait(1)
            end
            
         
            local box = CreateObject(boxHash, spawnCoords.x, spawnCoords.y, spawnCoords.z, true, false, false)
            
           
            local timeout = 0
            while not DoesEntityExist(box) and timeout < 50 do
                Wait(50)
                timeout = timeout + 1
            end
            
            if DoesEntityExist(box) then
                SetEntityAsMissionEntity(box, true, true)
                
       
                local baseBoxes = boxesPerRow * boxesPerRow
                local currentLayer = math.floor((i - 1) / baseBoxes)
                
                if currentLayer == 0 then
              
                    PlaceObjectOnGroundProperly(box)
                    Wait(100)
                    
             
                    local groundCoords = GetEntityCoords(box)
                    local finalZ = groundCoords.z + (currentLayer * boxHeight)
                    SetEntityCoords(box, spawnCoords.x, spawnCoords.y, finalZ, false, false, false, true)
                else
                   
                    local baseZ = spawnCenter.z 
                    local finalZ = baseZ + (currentLayer * boxHeight) + 0.5
                    SetEntityCoords(box, spawnCoords.x, spawnCoords.y, finalZ, false, false, false, true)
                end
                
                
                SetEntityCoords(box, spawnCoords.x, spawnCoords.y, spawnCoords.z, false, false, false, true)
                SetEntityRotation(box, 0.0, 0.0, 0.0, 2, true)
                FreezeEntityPosition(box, true)
                
               
                Wait(50)
                SetEntityRotation(box, 0.0, 0.0, 0.0, 2, true)
                
           
                spawnedBoxes[box] = {
                    warehouseIndex = warehouseIndex,
                    itemType = warehouse.items[math.random(#warehouse.items)],
                    loaded = false
                }
                
            
                exports.ox_target:addLocalEntity(box, {
                    {
                        name = 'pickup_box_' .. box,
                        event = 'delivery:client:pickupBox',
                        icon = 'fas fa-hand-paper',
                        label = 'Pick up Box',
                        distance = 2.0,
                        boxEntity = box
                    }
                })
                
                print('Spawned box ' .. i .. ' at warehouse')
            else
                print('Failed to spawn box ' .. i)
            end
            
            Wait(200) 
        end
        
        
        exports.qbx_core:Notify(string.format('%s boxes spawned at %s. Go pick them up!', itemCount, warehouse.name), 'success')
    end)
    
   
    exports.qbx_core:Notify('Spawning boxes at warehouse...', 'primary')
end


function ClearSpawnedBoxes()
    for box, data in pairs(spawnedBoxes) do
        if DoesEntityExist(box) then
            exports.ox_target:removeLocalEntity(box, 'pickup_box_' .. box)
            SetEntityAsMissionEntity(box, false, true)
            DeleteEntity(box)
        end
    end
    spawnedBoxes = {}
    print('Cleared all spawned boxes')
end


RegisterNetEvent('delivery:client:pickupBox', function(data)
    local boxEntity = data.boxEntity
    
    if carryingBox then
        exports.qbx_core:Notify(Config.Messages.carrying_box, 'error')
        return
    end
    
    local playerPed = PlayerPedId()
    
   
    if lib.progressBar({
        duration = Config.BoxPickupTime,
        label = Config.Messages.picking_up_box,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = 'anim@heists@box_carry@',
            clip = 'pickup'
        }
    }) then
      
        AttachEntityToEntity(boxEntity, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, -0.25, -0.1, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
        
      
        RequestAnimDict("anim@heists@box_carry@")
        while not HasAnimDictLoaded("anim@heists@box_carry@") do
            Wait(50)
        end
        TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
        
        carryingBox = true
        carriedBoxModel = boxEntity
        
      
        exports.ox_target:removeLocalEntity(boxEntity, 'pickup_box_' .. boxEntity)
        
      
        CreateVanLoadingZone()
        
        exports.qbx_core:Notify('Box picked up! Go to your van to load it.', 'success')
    end
end)


function CreateVanLoadingZone()
    if not currentVan then return end
    
    local vanLoadZone = exports.ox_target:addLocalEntity(currentVan, {
        {
            name = 'load_box_into_van',
            event = 'delivery:client:loadBoxIntoVan',
            icon = 'fas fa-truck-loading',
            label = 'Load Box into Van',
            distance = 6.0
        }
    })
end


function CreateVanUnloadingZone()
    if not currentVan then return end
    
    exports.ox_target:addLocalEntity(currentVan, {
        {
            name = 'unload_box_from_van',
            event = 'delivery:client:unloadBoxFromVan',
            icon = 'fas fa-dolly',
            label = 'Get Box from Van',
            distance = 6.0
        }
    })
end


RegisterNetEvent('delivery:client:loadBoxIntoVan', function()
    if not carryingBox or not carriedBoxModel then
        exports.qbx_core:Notify('You are not carrying a box!', 'error')
        return
    end
    
    local playerPed = PlayerPedId()
    local vanCoords = GetEntityCoords(currentVan)
    local playerCoords = GetEntityCoords(playerPed)
    
   
    if #(playerCoords - vanCoords) > 8.0 then
        exports.qbx_core:Notify(Config.Messages.need_to_be_near_van, 'error')
        return
    end
    
 
    if lib.progressBar({
        duration = Config.BoxLoadTime,
        label = Config.Messages.loading_box,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = 'anim@heists@box_carry@',
            clip = 'putdown_low'
        }
    }) then
      
        DetachEntity(carriedBoxModel, true, false)
        ClearPedTasks(GetPlayerPed(-1)) 
        DeleteEntity(carriedBoxModel)
        
        
        boxesInVan = boxesInVan + 1
        carryingBox = false
        carriedBoxModel = nil
        
        exports.qbx_core:Notify(string.format(Config.Messages.box_loaded, boxesInVan, maxBoxes), 'success')
        
        
        exports.ox_target:removeLocalEntity(currentVan, 'load_box_into_van')
        
       
        if boxesInVan >= maxBoxes then
          
            local warehouseIndex = 1 
            TriggerServerEvent('delivery:server:loadItems', warehouseIndex, maxBoxes)
        else
            
            Wait(1000)
            CreateVanLoadingZone()
        end
    end
end)


RegisterNetEvent('delivery:client:unloadBoxFromVan', function()
    if carryingBox then
        exports.qbx_core:Notify(Config.Messages.carrying_box, 'error')
        return
    end
    
    if boxesInVan <= 0 then
        exports.qbx_core:Notify(Config.Messages.van_empty, 'error')
        return
    end
    
    local playerPed = PlayerPedId()
    local vanCoords = GetEntityCoords(currentVan)
    local playerCoords = GetEntityCoords(playerPed)
    
  
    if #(playerCoords - vanCoords) > 8.0 then
        exports.qbx_core:Notify(Config.Messages.need_to_be_near_van, 'error')
        return
    end
    
    
    if lib.progressBar({
        duration = Config.BoxUnloadTime,
        label = Config.Messages.unloading_box,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = 'anim@heists@box_carry@',
            clip = 'pickup'
        }
    }) then
       
        local boxModel = Config.BoxModels[math.random(#Config.BoxModels)]
        local boxHash = GetHashKey(boxModel)
        
        RequestModel(boxHash)
        while not HasModelLoaded(boxHash) do
            Wait(1)
        end
        
       
        local playerCoords = GetEntityCoords(playerPed)
        local box = CreateObject(boxHash, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
        

        AttachEntityToEntity(box, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, -0.25, -0.1, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
        
        
        RequestAnimDict("anim@heists@box_carry@")
        while not HasAnimDictLoaded("anim@heists@box_carry@") do
            Wait(50)
        end
        TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
        
        carryingBox = true
        carriedBoxModel = box
        boxesInVan = boxesInVan - 1
        
        exports.qbx_core:Notify('Box taken from van! Find a delivery location to deliver it.', 'success')

        exports.ox_target:addLocalEntity(currentVan, 'unload_box_from_van')
       
        if boxesInVan > 0 then
            Wait(1000)
            CreateVanUnloadingZone()
        end
    end
end)


RegisterNetEvent('delivery:client:itemsLoaded', function(deliveryData)
    currentDeliveries = deliveryData
    CreateDeliveryBlips()
    RemoveWarehouseBlips()
    
   
    CreateVanUnloadingZone()
    
    exports.qbx_core:Notify('Van loaded! Go to delivery locations and get boxes from your van to deliver.', 'success')
end)

function CreateDeliveryBlips()
    for locationIndex, itemCount in pairs(currentDeliveries) do
        local location = Config.DeliveryLocations[locationIndex]
        if location and itemCount > 0 then
            local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
            SetBlipSprite(blip, location.blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, location.blip.scale)
            SetBlipColour(blip, location.blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(location.name .. ' (' .. itemCount .. ' items)')
            EndTextCommandSetBlipName(blip)
            
            deliveryBlips[locationIndex] = blip
            
          
            local zoneId = exports.ox_target:addBoxZone({
                coords = location.coords,
                size = vec3(4.0, 4.0, 2.0),
                rotation = location.heading,
                options = {
                    {
                        name = 'deliver_box_' .. locationIndex,
                        event = 'delivery:client:deliverBox',
                        icon = 'fas fa-hand-holding-box',
                        label = 'Deliver Box (' .. location.name .. ')',
                        locationIndex = locationIndex
                    }
                }
            })
            deliveryZones[locationIndex] = zoneId
            
            
            deliveryBoxesRemaining[locationIndex] = itemCount
            
           
            CreateDeliveryLocationPed(locationIndex)
        end
    end
end


RegisterNetEvent('delivery:client:deliverBox', function(data)
    local locationIndex = data.locationIndex
    
    if not carryingBox or not carriedBoxModel then
        exports.qbx_core:Notify(Config.Messages.need_box_for_delivery, 'error')
        return
    end
    
    if not currentDeliveries[locationIndex] or currentDeliveries[locationIndex] <= 0 then
        exports.qbx_core:Notify('No deliveries needed at this location!', 'error')
        return
    end
    
    local playerPed = PlayerPedId()
    
    exports.qbx_core:Notify(Config.Messages.delivering_box, 'primary')
    

    if lib.progressBar then
        if lib.progressBar({
            duration = Config.BoxDeliverTime,
            label = 'Delivering box...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true
            },
            anim = {
                dict = 'anim@heists@box_carry@',
                clip = 'putdown_low'
            }
        }) then
        
            DetachEntity(carriedBoxModel, true, false)
            ClearPedTasks(GetPlayerPed(-1)) 
            DeleteEntity(carriedBoxModel)
            carryingBox = false
            carriedBoxModel = nil
            
        
            deliveryBoxesRemaining[locationIndex] = deliveryBoxesRemaining[locationIndex] - 1
            currentDeliveries[locationIndex] = currentDeliveries[locationIndex] - 1
            
            exports.qbx_core:Notify(string.format(Config.Messages.box_delivered, deliveryBoxesRemaining[locationIndex], currentDeliveries[locationIndex] + deliveryBoxesRemaining[locationIndex]), 'success')
            
           
            TriggerServerEvent('delivery:server:completeDelivery', locationIndex, 1)
            
          
            if currentDeliveries[locationIndex] <= 0 then
                if deliveryBlips[locationIndex] then
                    RemoveBlip(deliveryBlips[locationIndex])
                    deliveryBlips[locationIndex] = nil
                end
                
                if deliveryZones[locationIndex] then
                    exports.ox_target:removeZone(deliveryZones[locationIndex])
                    deliveryZones[locationIndex] = nil
                end
                
               
                RemoveDeliveryLocationPed(locationIndex)
            else
              
                if deliveryBlips[locationIndex] then
                    BeginTextCommandSetBlipName('STRING')
                    local location = Config.DeliveryLocations[locationIndex]
                    AddTextComponentString(location.name .. ' (' .. currentDeliveries[locationIndex] .. ' items)')
                    EndTextCommandSetBlipName(deliveryBlips[locationIndex])
                end
            end
        else
            exports.qbx_core:Notify('Delivery cancelled!', 'error')
        end
    else
      
        DetachEntity(carriedBoxModel, true, false)
        ClearPedTasks(GetPlayerPed(-1)) 
        DeleteEntity(carriedBoxModel)
        carryingBox = false
        carriedBoxModel = nil
        TriggerServerEvent('delivery:server:completeDelivery', locationIndex, 1)
    end
end)


RegisterNetEvent('delivery:client:deliveryCompleted', function(locationIndex, remainingItems)
  
    currentDeliveries[locationIndex] = 0
    
   
    if deliveryBlips[locationIndex] then
        RemoveBlip(deliveryBlips[locationIndex])
        deliveryBlips[locationIndex] = nil
    end
    
  
    if deliveryZones[locationIndex] then
        exports.ox_target:removeZone(deliveryZones[locationIndex])
        deliveryZones[locationIndex] = nil
    end
    
    
    RemoveDeliveryLocationPed(locationIndex)
    
  
    local hasRemainingDeliveries = false
    for _, count in pairs(currentDeliveries) do
        if count > 0 then
            hasRemainingDeliveries = true
            break
        end
    end
    
    if not hasRemainingDeliveries then
        exports.qbx_core:Notify('All deliveries completed! Return to service center or start a new load.', 'success')
        CreateWarehouseBlips() 
    end
end)


RegisterNetEvent('delivery:client:allDelivered', function()
    RemoveDeliveryBlips()
end)


RegisterNetEvent('delivery:client:sessionStarted', function()
    hasActiveSession = true
    
    CreateThread(function()
        Wait(500) 
        SpawnDeliveryVan()
    end)
end)

RegisterNetEvent('delivery:client:sessionStopped', function()
    hasActiveSession = false
    CleanupSession()
end)


function RemoveWarehouseBlips()
    for i, blip in pairs(warehouseBlips) do
        RemoveBlip(blip)
        if warehousePeds[i] then
            exports.ox_target:removeLocalEntity(warehousePeds[i], 'warehouse_worker_' .. i)
            DeletePed(warehousePeds[i])
            warehousePeds[i] = nil
        end
    end
    warehouseBlips = {}
end

function RemoveDeliveryBlips()
    for locationIndex, blip in pairs(deliveryBlips) do
        RemoveBlip(blip)
        if deliveryZones[locationIndex] then
            exports.ox_target:removeZone(deliveryZones[locationIndex])
            deliveryZones[locationIndex] = nil
        end
    end
    deliveryBlips = {}
end

function CleanupSession()
  
    ClearSpawnedBoxes()
    
 
    if currentVan then
        if vanBlip then
            RemoveBlip(vanBlip)
            vanBlip = nil
        end
        exports.ox_target:removeLocalEntity(currentVan, 'load_box_into_van')
        exports.ox_target:removeLocalEntity(currentVan, 'unload_box_from_van')
        DeleteVehicle(currentVan)
        currentVan = nil
    end
    
    
    RemoveWarehouseBlips()
    RemoveDeliveryBlips()
    

    for locationIndex, ped in pairs(deliveryLocationPeds) do
        if DoesEntityExist(ped) then
            DeletePed(ped)
        end
    end
    

    currentDeliveries = {}
    deliveryBoxesRemaining = {}
    deliveryZones = {}
    warehousePeds = {}
    deliveryLocationPeds = {}
    carryingBox = false
    carriedBoxModel = nil
    boxesInVan = 0
    maxBoxes = 0
    isLoading = false
end




AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
   
        if carryingBox and carriedBoxModel then
            DetachEntity(carriedBoxModel, true, false)
            ClearPedTasks(GetPlayerPed(-1)) 
            DeleteEntity(carriedBoxModel)
        end
        
        CleanupSession()
        
        if deliveryPed then
            DeletePed(deliveryPed)
        end
    end
end)