
local activeJobs = {}
local playerVans = {}


RegisterNetEvent('delivery:server:startJob', function()
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    
    if not Player then return end
    
    if activeJobs[src] then
        exports.qbx_core:Notify(src, 'You already have an active delivery session!', 'error')
        return
    end
    
  
    activeJobs[src] = {
        playerId = src,
        vanLoaded = false,
        deliveriesCompleted = 0,
        totalEarnings = 0,
        items = {},
        currentDeliveries = {}
    }
    
    TriggerClientEvent('delivery:client:sessionStarted', src)
    exports.qbx_core:Notify(src, Config.Messages.session_started, 'success')
end)

RegisterNetEvent('delivery:server:stopJob', function()
    local src = source
    
    if activeJobs[src] then
      
        activeJobs[src] = nil
        if playerVans[src] then
            playerVans[src] = nil
        end
        
        TriggerClientEvent('delivery:client:sessionStopped', src)
        exports.qbx_core:Notify(src, Config.Messages.session_cancelled, 'error')
    end
end)

RegisterNetEvent('delivery:server:spawnVan', function(spawnData)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    
    if not Player or not activeJobs[src] then return end
  
    playerVans[src] = {
        plate = spawnData.plate,
        netId = spawnData.netId,
        loaded = false,
        items = {}
    }
    

    if Config.GiveKeys then
        TriggerClientEvent('vehiclekeys:client:SetOwner', src, spawnData.plate)
        TriggerClientEvent('qb-vehiclekeys:client:AddKeys', src, spawnData.plate)
    end
    
    exports.qbx_core:Notify(src, Config.Messages.van_spawned, 'success')
end)

RegisterNetEvent('delivery:server:loadItems', function(warehouseIndex, itemCount)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    
    if not Player or not activeJobs[src] or not playerVans[src] then return end
    
    local warehouse = Config.PickupLocations[warehouseIndex]
    if not warehouse then return end
    
 
    if playerVans[src].loaded then
        exports.qbx_core:Notify(src, 'Van is already loaded!', 'error')
        return
    end
    

    if itemCount > Config.MaxItemsPerDelivery then
        exports.qbx_core:Notify(src, string.format(Config.Messages.van_full, Config.MaxItemsPerDelivery), 'error')
        return
    end
    
 
    local loadedItems = {}
    for i = 1, itemCount do
        local randomItem = warehouse.items[math.random(#warehouse.items)]
        table.insert(loadedItems, {
            name = randomItem,
            amount = 1,
            deliveryLocation = math.random(#Config.DeliveryLocations)
        })
    end
    

    playerVans[src].items = loadedItems
    playerVans[src].loaded = true
    activeJobs[src].items = loadedItems
    activeJobs[src].vanLoaded = true
    
 
    local deliveryData = {}
    for i, item in pairs(loadedItems) do
        deliveryData[item.deliveryLocation] = (deliveryData[item.deliveryLocation] or 0) + 1
    end
    
    TriggerClientEvent('delivery:client:itemsLoaded', src, deliveryData)
    exports.qbx_core:Notify(src, Config.Messages.van_loaded, 'success')
end)

RegisterNetEvent('delivery:server:completeDelivery', function(locationIndex, itemsDelivered)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    
    if not Player or not activeJobs[src] or not playerVans[src] then return end
    
    local location = Config.DeliveryLocations[locationIndex]
    if not location then return end
    

    local payment = location.payment * itemsDelivered
    local jobData = activeJobs[src]

    jobData.deliveriesCompleted = jobData.deliveriesCompleted + itemsDelivered
    jobData.totalEarnings = jobData.totalEarnings + payment
    

    local remainingItems = {}
    local deliveredCount = 0
    
    for _, item in pairs(playerVans[src].items) do
        if item.deliveryLocation == locationIndex and deliveredCount < itemsDelivered then
            deliveredCount = deliveredCount + 1
        else
            table.insert(remainingItems, item)
        end
    end
    
    playerVans[src].items = remainingItems
    
   
    Player.Functions.AddMoney('cash', payment)
    
 
    local allDelivered = #remainingItems == 0
    if allDelivered then
       
        local bonus = math.floor(jobData.totalEarnings * Config.BonusPercentage)
        Player.Functions.AddMoney('cash', bonus)
        jobData.totalEarnings = jobData.totalEarnings + bonus
        
        TriggerClientEvent('delivery:client:allDelivered', src)
        exports.qbx_core:Notify(src, string.format('All deliveries completed! Total earned: $%s (including $%s bonus)', jobData.totalEarnings, bonus), 'success')
    else
        exports.qbx_core:Notify(src, string.format('Delivery completed! Earned: $%s', payment), 'success')
    end
    
    TriggerClientEvent('delivery:client:deliveryCompleted', src, locationIndex, remainingItems)
end)

RegisterNetEvent('delivery:server:giveKeys', function(plate)
    local src = source
    
   
    if GetResourceState('qb-vehiclekeys') == 'started' then
        TriggerClientEvent('qb-vehiclekeys:client:AddKeys', src, plate)
    elseif GetResourceState('vehiclekeys') == 'started' then
        TriggerClientEvent('vehiclekeys:client:SetOwner', src, plate)
    elseif exports.qbx_core then
      
        local Player = exports.qbx_core:GetPlayer(src)
        if Player then
            TriggerClientEvent('qb-vehiclekeys:client:AddKeys', src, plate)
        end
    end
end)


lib.callback.register('delivery:server:getJobData', function(source)
    return activeJobs[source]
end)

lib.callback.register('delivery:server:getVanData', function(source)
    return playerVans[source]
end)

lib.callback.register('delivery:server:hasActiveSession', function(source)
    return activeJobs[source] ~= nil
end)


AddEventHandler('playerDropped', function(reason)
    local src = source
    if activeJobs[src] then
        activeJobs[src] = nil
    end
    if playerVans[src] then
        playerVans[src] = nil
    end
end)


lib.addCommand('delivery', {
    help = 'Start a delivery session',
    restricted = false
}, function(source, args, raw)
    TriggerEvent('delivery:server:startJob', source)
end)

lib.addCommand('stopdelivery', {
    help = 'Stop current delivery session',
    restricted = false
}, function(source, args, raw)
    TriggerEvent('delivery:server:stopJob', source)
end)

lib.addCommand('deliverykeys', {
    help = 'Get keys for your delivery van',
    restricted = false
}, function(source, args, raw)
    local src = source
    if playerVans[src] then
        local plate = playerVans[src].plate
        TriggerEvent('delivery:server:giveKeys', src, plate)
        exports.qbx_core:Notify(src, 'Vehicle keys given for plate: ' .. plate, 'success')
    else
        exports.qbx_core:Notify(src, 'You don\'t have an active delivery van!', 'error')
    end
end)