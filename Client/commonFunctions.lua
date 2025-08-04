RegisterNetEvent('lucas:refund:sendNotify')
AddEventHandler('lucas:refund:sendNotify', function(notifyType, notifyDescription)
    lib.notify({ type = notifyType, title = 'Refunds', description = notifyDescription })
end)

RegisterNetEvent('lucas:refund:copy')
AddEventHandler('lucas:refund:copy', function(copyContent)
    SendNUIMessage({
        type = 'clipboard',
        data = ''..streetHash..''
    })
end)