ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    for k,v in pairs (Config.Position) do
        local pe = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(pe, Config.Blips.Model)
        SetBlipColour(pe, Config.Blips.Couleur)
        SetBlipScale(pe, Config.Blips.Taille)
        SetBlipAsShortRange(pe, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(Config.Blips.Name)
        EndTextCommandSetBlipName(pe)
    end
end)

--- Xed#1188