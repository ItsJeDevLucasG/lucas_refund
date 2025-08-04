ESX = exports["es_extended"]:getSharedObject()

local isOnSteam = Config.Commands.RedeemCommand.IsOnSteam
local tableName = Config.TableName
local acePerm = Config.Commands.CreateRefund.AcePerm

local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"

function randomString(length)
    if length > 0 then
        return string.random(length - 1) .. charset:sub(math.random(1, #charset), 1)
    else
        return ""
    end
end

function sendDiscordEmbed(title, description)
    local webhookUrl = Config.Webhook

    if webhookUrl == nil or webhookUrl == '' then
        return
    end

    local embed = {
        embeds = {
            {
                title = title,
                description = description,
                color = 0x3498db
            }
        }
    }

    PerformHttpRequest(webhookUrl, function(err, text, headers)
        if err ~= 200 then
            print("Er is een fout opgetreden. Foutcode: " .. err)
        end
    end, "POST", json.encode(embed), {["Content-Type"] = "application/json"})
end

RegisterCommand(Config.Commands.RedeemCommand.Name, function(source, args, rawCommand)
    if isOnSteam then
        local xPlayer = ESX.GetPlayerFromId(source)
        local steam = GetPlayerIdentifierByType(source, 'steam')

        MySQL.Async.fetchAll('SELECT * FROM ' .. tableName .. ' WHERE steam_id = @steam', { ['@steam'] = steam }, function(result)
            if #result > 0 then
                for i in pairs(result) do
                    exports.ox_inventory:AddItem(source, result[i].itemName, result[i].amount)
                    TriggerClientEvent('lucas:refund:sendNotify', source, 'success', 'Je hebt je refund van: ' .. result[i].amount .. 'x ' .. result[i].itemName .. ' geclaimed.')
                    sendDiscordEmbed('Refund Geclaimed', 'Er is een refund geclaimed door: **' .. GetPlayerName(source) .. ' (' .. source .. ')**\n\nItem: **' .. result[i].itemName .. '**\nAantal: **' .. result[i].aantal .. '**')
                end
            else
                TriggerClientEvent('lucas:refund:sendNotify', source, 'error', 'Er staan geen refunds klaar voor u.')
                return
            end
        end)
    else
        local xPlayer = ESX.GetPlayerFromId(source)
        local steam = GetPlayerIdentifierByType(source, 'steam')

        MySQL.Async.fetchAll('SELECT * FROM ' .. tableName .. ' WHERE refund_code = @code', { ['@code'] = args[1] }, function(result)
            if #result > 0 then
                for i in pairs(result) do
                    exports.ox_inventory:AddItem(source, result[i].itemName, result[i].amount)
                    TriggerClientEvent('lucas:refund:sendNotify', source, 'success', 'Je hebt je refund van: ' .. result[i].amount .. 'x ' .. result[i].itemName .. ' geclaimed.')
                    sendDiscordEmbed('Refund Geclaimed', 'Er is een refund geclaimed door: **' .. GetPlayerName(source) .. ' (' .. source .. ')**\n\nItem: **' .. result[i].itemName .. '**\nAantal: **' .. result[i].aantal .. '**')
                end
            else
                TriggerClientEvent('lucas:refund:sendNotify', source, 'error', 'Er staan geen refunds klaar voor u.')
                return
            end
        end)
    end
end)

RegisterCommand(Config.Commands.CreateRefund.Name, function(source, args, rawCommand)
    if IsAceAllowed(source, acePerm) then
        if isOnSteam then
            local adminSteam = GetPlayerIdentifierByType(source, 'steam')

            MySQL.Async.execute('INSERT INTO ' .. tableName .. ' (admin, steam_id, itemName, amount) VALUES (@admin, @steam_id, @itemName, @amount)', { ['@admin'] = adminSteam, ['@steam_id'] = args[1], ['@itemName'] = string.lower(args[2]), ['@amount'] = string.lower(args[3]) },
            function(affectedRows)
                if affectedRows > 0 then
                    TriggerClientEvent('lucas:refund:sendNotify', source, 'success', 'De refund is uitgeschreven.')
                    sendDiscordEmbed('Refund Systeem', 'Er is een nieuwe refund uitgeschreven\n**Informatie:**\n\nAdmin: **' .. adminName .. ' (' .. source .. ')**\nItem: **' .. string.lower(args[1]) .. '**\nAantal: ' .. string.lower(args[2]) .. '**\n\nSteamId: ||**' .. args[1] .. '**||')
                else
                    TriggerClientEvent('lucas:refund:sendNotify', source, 'error', 'Er ging iets mis bij de refund uitschrijven.')
                end
            end)
        else
            local code = randomString(15)
            local adminSteam = GetPlayerIdentifierByType(source, 'steam')
            local adminName = GetPlayerName(source)

            MySQL.Async.execute('INSERT INTO ' .. tableName .. ' (admin, refund_code, itemName, amount) VALUES (@admin, @refund_code, @itemName, @amount)', { ['@admin'] = adminSteam, ['@refund_code'] = code, ['@itemName'] = string.lower(args[1]), ['@amount'] = string.lower(args[2]) },
            function(affectedRows)
                if affectedRows > 0 then
                    TriggerClientEvent('lucas:refund:sendNotify', source, 'success', 'De refund is uitgeschreven. Code: ' .. code .. '. De code is ook gecopieerd naar je kladblok.')
                    TriggerClientEvent('lucas:refund:copy', code)
                    sendDiscordEmbed('Refund Systeem', 'Er is een nieuwe refund uitgeschreven\n**Informatie:**\n\nAdmin: **' .. adminName .. ' (' .. source .. ')**\nItem: **' .. string.lower(args[1]) .. '**\nAantal: ' .. string.lower(args[2]) .. '**\n\nCode: ||**' .. code .. '**||')
                else
                    TriggerClientEvent('lucas:refund:sendNotify', source, 'error', 'Er ging iets mis bij de refund uitschrijven.')
                end
            end)
        end
    else    
        TriggerClientEvent('lucas:refund:sendNotify', source, 'error', 'Je hebt geen toestemming om deze command te gebruiken.')
        return
    end
end)
