ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('xEmploi:add')
AddEventHandler('xEmploi:add', function(name, numero, text, title)
    local source = source

    if name ~= nil and numero ~= nil and text ~= nil and title ~= nil then
        MySQL.Async.execute("INSERT INTO emploi (name,numero,text,title) VALUES (@a,@b,@c,@d)",
            {
                ["a"] = name,
                ["b"] = tonumber(numero),
                ["c"] = text,
                ["d"] = title
            }, function()
                TriggerClientEvent('esx:showNotification', source, '~g~Annonce posté avec succès !')
            end)
    else
        TriggerClientEvent('esx:showNotification', source, '~r~Champ incomplet !')
    end
    
end)

local stockageServer = {}

RegisterNetEvent('xEmploi:check')
AddEventHandler('xEmploi:check', function()

    MySQL.Async.fetchAll("SELECT * FROM emploi", {}, function(result)
        if (result) then
            stockageServer = result
            TriggerClientEvent('xEmploi:result', -1, stockageServer)
        end
    end)

end)

RegisterNetEvent('xEmploi:delete')
AddEventHandler('xEmploi:delete', function()

    MySQL.Async.execute("DELETE FROM emploi", {}, function()
    end)

end)

--- Xed#1188
