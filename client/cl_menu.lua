ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

-- KeyboardInput

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)

    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    
    blockinput = true 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Somme", ExampleText, "", "", "", MaxStringLenght) 
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end 
         
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end

-- Event

local stockageClient = {}

RegisterNetEvent('xEmploi:result')
AddEventHandler('xEmploi:result', function(stockageServer)
    stockageClient = stockageServer
end)

-- Menu

local open = false
local mainMenu = RageUI.CreateMenu('Pole emploie', 'interaction', nil, nil, 'root_cause1', 'img_blue')
local subMenu1 = RageUI.CreateSubMenu(mainMenu, 'Pole emploie', 'interaction')
mainMenu.Display.Header = true
mainMenu.Closed = function()
    open = false
    FreezeEntityPosition(PlayerPedId(), false)
end

function menu()
    if open then 
        open = false
        RageUI.Visible(mainMenu, false)
    else
        open = true
        RageUI.Visible(mainMenu, true)
        Citizen.CreateThread(function()
            while open do
                RageUI.IsVisible(mainMenu, function()                    
                    RageUI.Button('Déposer une offre d\'emploi', '~r~Les offres se réinitialise automatiquement tous les '..((Config.TimeToDelete)/60000)..'min !', {RightLabel = "→"}, true, {
                        onSelected = function()
                            local name = KeyboardInput('Votre identité', '', 10)
                            local numero = KeyboardInput('Votre numéro', '', 10)
                            local text = KeyboardInput('Détails de l\'offre', '', 255)
                            local title = KeyboardInput('Titre de l\'offre', '', 20)
                            TriggerServerEvent('xEmploi:add', name, numero, text, title)
                        end
                    })
                    RageUI.Line()
                    RageUI.Button('Consulter les offres d\'emploi', '~r~Les offres se réinitialise automatiquement tous les '..((Config.TimeToDelete)/60000)..'min !', {RightLabel = "→"}, true, {
                        onSelected = function()
                            TriggerServerEvent('xEmploi:check')
                        end
                    }, subMenu1)
                end)
                RageUI.IsVisible(subMenu1, function()
                    for k,v in pairs(stockageClient) do
                        RageUI.Button(v.title, 'Par: ~b~'..v.name..'~s~, Contact: ~b~'..v.numero, {RightLabel = "→"}, true, {
                            onSelected = function()
                                ESX.ShowNotification('~b~Annonce~s~: '..v.text)
                            end
                        })
                    end
                end)
                Wait(0)
            end
        end)
    end
end

-- Ouvrir le menu

Citizen.CreateThread(function()
    while true do
        local wait = 750
        for k in pairs(Config.Position) do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			local pos = Config.Position
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

            if dist <= Config.MarkerDistance then
                wait = 0
                DrawMarker(Config.MarkerType, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.MarkerSizeLargeur, Config.MarkerSizeEpaisseur, Config.MarkerSizeHauteur, Config.MarkerColorR, Config.MarkerColorG, Config.MarkerColorB, Config.MarkerOpacite, Config.MarkerSaute, true, p19, Config.MarkerTourne)  
            end

			if dist <= 1.0 then
				wait = 0
				Visual.Subtitle(Config.Text, 1)
				if IsControlJustPressed(1,51) then
					FreezeEntityPosition(PlayerPedId(-1), true)
					menu()
				end
			end
        end
        Citizen.Wait(wait)
    end
end)

-- Delete annonce

Citizen.CreateThread(function()
    while true do
        Wait(Config.TimeToDelete)
        TriggerServerEvent('xEmploi:delete')
    end
end)

--- Xed#1188