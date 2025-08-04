Citizen.CreateThread(function()
    if Config.Commands.RedeemCommand.IsOnSteam == true then
        TriggerEvent('chat:addSuggestion', '/' .. Config.Commands.RedeemCommand.Name, Config.Commands.RedeemCommand.Description, {})
        TriggerEvent('chat:addSuggestion', '/' .. Config.Commands.CreateRefund.Name, Config.Commands.CreateRefund.Description, {
            { name=Config.Commands.CreateRefund.args.steam.Name, help=Config.Commands.CreateRefund.args.steam.Description },
            { name=Config.Commands.CreateRefund.args.typeRefund.Name, help=Config.Commands.CreateRefund.args.typeRefund.Description },
            { name=Config.Commands.CreateRefund.args.aantalRefund.Name, help=Config.Commands.CreateRefund.args.aantalRefund.Description }
        })
    else
        TriggerEvent('chat:addSuggestion', '/' .. Config.Commands.RedeemCommand.Name, Config.Commands.RedeemCommand.Description, {
            { name=Config.Commands.RedeemCommand.args.code.Name, help=Config.Commands.RedeemCommand.args.code.Description }
        })
        TriggerEvent('chat:addSuggestion', '/' .. Config.Commands.CreateRefund.Name, Config.Commands.CreateRefund.Description, {
            { name=Config.Commands.CreateRefund.args.typeRefund.Name, help=Config.Commands.CreateRefund.args.typeRefund.Description },
            { name=Config.Commands.CreateRefund.args.aantalRefund.Name, help=Config.Commands.CreateRefund.args.aantalRefund.Description }
        })
    end
end)
