local QRCore = exports['qr-core']:GetCoreObject()

RegisterNetEvent("hum_delivery:payout")
AddEventHandler("hum_delivery:payout", function(cash)
    local _source = source
    local Player = QRCore.Functions.GetPlayer(source)
    Player.Functions.AddMoney('cash', cash,'legal-delivery-payout')
    print(cash)
end)