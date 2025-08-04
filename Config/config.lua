Config = {}

Config.TableName = 'lucas_refund'

Config.Commands = {
    RedeemCommand = {
        Name = "redeemrefunds",
        Description = "Claim alle refunds die open staan voor jou.",
        IsOnSteam = true,
        args = { -- Geld alleen als isOnSteam op false staat, anders gaat die op je steam kijken.
            code = {
                Name = "Refund Code",
                Description = "Wat is de code van de refund"
            },
        },
    },
    CreateRefund = {
        Name = "maakrefund",
        Description = "Claim alle refunds die open staan voor jou.",
        AcePerm = "lucas:refund:create",
        args = {
            steam = {
                Name = "Steam Id",
                Description = "Wat is het steam Id van de speler die dit moet ontvangen"
            },
            typeRefund = {
                Name = "Refund Type",
                Description = "Wat voor een refund is het (Item/Contant/Bank)"
            },
            aantalRefund = {
                Name = "Refund Aantal",
                Description = "Hoeveel van dit moet er gerefund worden"
            },
        },
    }
}