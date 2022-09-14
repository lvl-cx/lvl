RMenu.Add("armapets","main",RageUI.CreateMenu("","Select your ~b~Pet",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"cmg_petsui","cmg_petsui"))
RMenu.Add("armapets","store",RageUI.CreateMenu("", "~b~Store", tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(), "cmg_petsui", "cmg_petsui"))
TriggerEvent("chat:addSuggestion", "/pet", "Manage your owned pets!")
local a = "HANDLER"
local b = "K9"
local c = "K9TARGET"
local d = {}
local e = false
local f = {
    purchasing = false,
    purchasingId = 0,
    viewingPet = false,
    lastViewingId = 0,
    viewingId = 0,
    cameraEnabled = false,
    cameraHandle = 0
}
local g = {Follow = 1, Stay = 2, Attack = 3, Sit = 4, Trick = 5, Shoulder = 5, Floor = 6}
local h = {active = false, id = 0, cooldown = false}
local i = {Success = 1, Error = 2, Alert = 3, Info = 4, Unknown = 5}
local j = {chooseActivePet = 1}
local k = function(l)
    RageUI.Visible(RMenu:Get("armapets", "store"), true)
    f.viewingPet = true
    if not f.cameraEnabled then
        DestroyCam(f.cameraHandle, false)
        f.cameraHandle = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        SetCamCoord(f.cameraHandle, 562.7604, 2752.879, 42.40)
        SetCamRot(f.cameraHandle, -1, -1, -84.73, 2)
        RenderScriptCams(1, 0, 0, 1, 1)
        f.cameraEnabled = true
    end
end
local m = function()
    RageUI.Visible(RMenu:Get("armapets", "store"), false)
    f.viewingPet = false
    if f.viewingId ~= 0 then
        DeleteEntity(f.viewingEntity)
        f.viewingPet = false
        f.viewingId = 0
    end
    if f.cameraEnabled then
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(f.cameraHandle, false)
        f.cameraEnabled = false
    end
end
local n = function()
end
RegisterNetEvent("ARMA:attackToggledAdmin",function(o)
    for p, q in pairs(d.pets) do
        if not o then
            d.pets[p].abilities.attack = false
            showNotification(i.Alert, "Your ability to attack has been disabled by a ~b~CMG Staff Member~w~.")
        end
    end
end)
RegisterNetEvent("ARMA:updatePetHealth",function(b, r)
    if d.pets[b].info.owned then
        d.pets[b].health = r
        RMenu:Get("armapets", "main"):SetSubtitle("~b~Pet: ~w~" .. d.pets[h.id].name .. " ~b~Health: ~w~" .. d.pets[h.id].health .. "/100")
    end
end)
function func_setPetShopWorkerPed(s)
    SetPedComponentVariation(s, 1, 0, 0, 0)
    SetPedComponentVariation(s, 2, 12, 3, 1)
    SetPedComponentVariation(s, 3, 0, 0, 0)
    SetPedComponentVariation(s, 4, 4, 0, 0)
    SetPedComponentVariation(s, 5, 0, 0, 0)
    SetPedComponentVariation(s, 6, 75, 0, 0)
    SetPedComponentVariation(s, 7, 0, 0, 0)
    SetPedComponentVariation(s, 8, 142, 0, 0)
    SetPedComponentVariation(s, 9, 0, 0, 0)
    SetPedComponentVariation(s, 10, 0, 0, 0)
    SetPedComponentVariation(s, 11, 146, 0, 0)
end
RegisterNetEvent("ARMA:buildPetCFG",function(t, u, v)
    d = v
    local w = t
    for p, q in pairs(d.pets) do
        d.pets[p].abilities.teleport = false
        d.pets[p].awaitingHealthReduction = false
        d.pets[p].info = {currentAction = 1, owned = false, dead = false, inVehicle = false}
        if u.attack then
            d.pets[p].abilities.attack = false
        end
        local x = false
        for y in pairs(w) do
            if w[y].id == p then
                x = true
                d.pets[p].name = w[y].name
                if not w[y].ownedSkills.teleport then
                    d.pets[p].abilities.teleport = false
                else
                    d.pets[p].abilities.teleport = true
                end
                if w[y].health ~= nil then
                    d.pets[p].health = tonumber(w[y].health)
                else
                    d.pets[p].health = 100
                end
            end
        end
        if x then
            d.pets[p].info.owned = true
        end
    end
    tARMA.addMarker(d.shop.coords.x,d.shop.coords.y,d.shop.coords.z,1.0001,1.0001,0.5001,31,135,173,220,20.0,31,false,false,true,nil,nil,0.0,0.0,0.0)
    tARMA.createArea("petStore", d.shop.coords, 1.5, 1.5, k, m, n, {})
    local z = tARMA.addBlip(d.shop.coords.x, d.shop.coords.y, d.shop.coords.z, 442, 26, "Pet Store")
    e = true
    local A = tARMA.createDynamicPed("mp_m_freemode_01",vector3(558.74, 2752.71, 41.85),179.45,true,"mini@strip_club@idles@bouncer@base","base",10,false,func_setPetShopWorkerPed)
end)

RegisterNetEvent("ARMA:togglePetMenu",function(w)
    if not e then
        showNotification("Please wait before opening the pet menu.")
    else
        local B = false
        for p, q in pairs(d.pets) do
            if q.info.owned and not q.info.dead then
                B = true
            end
        end
        if h.cooldown then
            showNotification(i.Info, "Please wait before spawning in a new pet.")
        else
            if not B then
                showNotification(i.Error, "You do not own any ~b~pets~w~. Visit a ~b~pet store ~w~to purchase one.")
            else
                RageUI.Visible(RMenu:Get("armapets", "main"), true)
            end
        end
    end
end)

RegisterNetEvent("ARMA:successfulPurchase",function(C)
    PlaySoundFrontend(-1, "PROPERTY_PURCHASE", "HUD_AWARDS")
    showNotification(i.Success,"You have now ~b~purchased ~w~a ~b~" .. d.pets[C].name .. "~w~. Use /pet to spawn it in.")
    d.pets[C].info.owned = true
    d.pets[C].health = 100
end)

RegisterNetEvent("ARMA:updatePetName",function(C, D)
    PlaySoundFrontend(-1, "PROPERTY_PURCHASE", "HUD_AWARDS")
    showNotification(i.Success, "You have now changed your pet name to ~b~" .. D .. "~w~!")
    d.pets[C].name = D
    RMenu:Get("armapets", "main"):SetSubtitle(
        "~b~Pet: ~w~" .. d.pets[h.id].name .. " ~b~Health: ~w~" .. d.pets[h.id].health .. "/100"
    )
    RageUI.Visible(RMenu:Get("armapets", "main"), true)
end)

RegisterNetEvent("ARMA:updateTeleportSkillPurchased",function(C)
    d.pets[C].abilities.teleport = true
end)
RegisterNetEvent("ARMA:sendClientRagdollPet",function(E, D)
    SetPedToRagdoll(tARMA.getPlayerPed(), 12000, 12000, 0, 0, 0, 0)
    showNotification(i.Alert, "~y~~h~Alert~h~~s~: " .. "You have been attacked by a pet.")
    showNotification(i.Alert, "~b~Owner: ~w~" .. D .. "\nUser ID: ~b~" .. E)
    Citizen.Wait(1000)
    local F = tARMA.getPlayerPed()
    if not IsPedRagdoll(F) then
        SetPedToRagdoll(F, -1, -1, 0, false, false, false)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('armapets', 'store')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if f.purchasing then
                RageUI.ButtonWithStyle("Purchase " .. d.pets[f.purchasingId].name,"Purchase",{RightLabel = "£" .. getMoneyStringFormatted(d.pets[f.purchasingId].price)},true,function(G, H, I)
                    if I then
                        TriggerServerEvent("ARMA:purchasePet", f.purchasingId)
                        f.purchasing = false
                        f.purchasingId = 0
                    end
                end)
                RageUI.ButtonWithStyle("Cancel Purchase","Cancel",{},true,function(G, H, I)
                    if I then
                        f.purchasing = false
                        f.purchasingId = 0
                    end
                end)
            else
                if e then
                    local B = false
                    for p, q in pairs(d.pets) do
                        if not q.info.owned then
                            B = true
                            RageUI.ButtonWithStyle(q.name,q.description,{RightLabel = "£" .. getMoneyStringFormatted(q.price)},true,function(G, H, I)
                                if I then
                                    f.purchasing = true
                                    f.purchasingId = p
                                end
                                if H then
                                    f.viewingId = p
                                end
                            end)
                        end
                    end
                    if not B then
                        RageUI.Visible(RMenu:Get("armapets", "store"), false)
                        showNotification(i.Info, "There are no available pets for you to purchase.")
                    end
                end
            end
        end)
    end
end)

function currentPet()
    if not h then
        return
    end
    return d.pets[h.id]
end
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('armapets', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if inOrganHeist then
                RageUI.Visible(RMenu:Get("armapets", "main"), false)
                return
            end
            if not h.active then
                for p, q in pairs(d.pets) do
                    if q.info.owned then
                        RageUI.Button("Spawn " .. q.name,"Press to spawn",{},function(G, H, I)
                            if I then
                                if q.info.dead then
                                    showNotification(i.Info, "Please wait before spawning in " .. q.name .. ".")
                                elseif h.cooldown then
                                    showNotification(i.Info, "Please wait before spawning in a pet.")
                                else
                                    petCreate(p)
                                end
                            end
                        end)
                    end
                end
            else
                if currentPet().info.inVehicle then
                    RageUI.Button("Remove from vehicle","Remove pet from vehicle",{},function(G, H, I)
                        if I then
                            removePetFromVehicle()
                        end
                    end)
                else
                    if d.pets[h.id].health == nil or d.pets[h.id].health > 1 and not d.pets[h.id].onShoulder then
                        if not (currentPet().info.currentAction == g.Follow) then
                            RageUI.Button("Follow","Pet will follow you",{},function(G, H, I)
                                if I then
                                    petFollow()
                                end
                            end)
                        end
                        if not (currentPet().info.currentAction == g.Stay) then
                            RageUI.Button("Stay","Pet will stay",{},function(G, H, I)
                                if I then
                                    showNotification(i.Info, currentPet().name .. " is now staying.")
                                    petStay()
                                end
                            end)
                        end
                        if d.pets[h.id].abilities.sit and not (currentPet().info.currentAction == g.Sit) then
                            RageUI.Button("Sit","Pet will sit",{},function(G, H, I)
                                if I then
                                    showNotification(i.Info, currentPet().name .. " is now sitting.")
                                    petSit()
                                end
                            end)
                        end
                        if d.pets[h.id].abilities.teleport then
                            RageUI.Button("Teleport","Teleport pet to you",{},function(G, H, I)
                                if I then
                                    tpPet()
                                    showNotification(i.Info, "Pet has now been teleported to you.")
                                end
                            end)
                        end
                        if d.pets[h.id].abilities.attack and not (currentPet().info.currentAction == g.Attack) then
                            RageUI.Button("Attack","Pet will attack",{},function(G, H, I)
                                if I then
                                    selectAttackTargetPet()
                                end
                            end)
                        end
                        if not (currentPet().info.currentAction == g.Attack) then
                            RageUI.Button("Put in vehicle","Put pet from vehicle",{},function(G, H, I)
                                if I then
                                    putPetInVehicle()
                                end
                            end)
                            if d.pets[h.id].abilities.paw then
                                RageUI.Button("Paw Trick","Pet will lift paw",{},function(G, H, I)
                                    if I then
                                        petPerformTrick(d.pets[h.id].animations.paw)
                                    end
                                end)
                            end
                            if d.pets[h.id].abilities.sleep then
                                RageUI.Button("Sleep Trick","Pet will sleep",{},function(G, H, I)
                                    if I then
                                        petPerformTrick(d.pets[h.id].animations.sleep)
                                    end
                                end)
                            end
                        end
                    end
                    if d.pets[h.id].onShoulder and d.pets[h.id].info.currentAction == g.Shoulder then
                        RageUI.Button("Place on ground","Place your pet on the ground",{},function(G, H, I)
                            if I then
                                petOnGround()
                            end
                        end)
                    end
                    if d.pets[h.id].onShoulder and d.pets[h.id].info.currentAction == g.Floor then
                        RageUI.Button("Place on right shoulder","Place your pet on your right shoulder",{},function(G, H, I)
                            if I then
                                petOnShoulder(true)
                            end
                        end)
                        RageUI.Button("Place on left shoulder","Place your pet on your left shoulder",{},function(G, H, I)
                            if I then
                                petOnShoulder(false)
                            end
                        end)
                    end
                    if d.pets[h.id].health ~= nil and d.pets[h.id].health < 100 then
                        RageUI.Button("Feed Pet","Feed your current pet",{},function(G, H, I)
                            if I then
                                TriggerServerEvent("ARMA:feedPet", h.id)
                            end
                        end)
                    end
                    RageUI.Button("Delete Pet","Deletes your current pet",{},function(G, H, I)
                        if I then
                            RageUI.Visible(RMenu:Get("armapets", "main"), false)
                            petDelete()
                        end
                    end)
                    if d.pets[h.id] ~= nil and d.pets[h.id].abilities ~= nil and not d.pets[h.id].abilities.teleport and not d.pets[h.id].onShoulder then
                        RageUI.ButtonWithStyle("Purchase Teleport Feature","Purchase",{RightLabel = "£" .. getMoneyStringFormatted(d.pets[h.id].skillPrices.teleport)},true,function(G, H, I)
                            if I then
                                TriggerServerEvent("ARMA:purchaseTeleportSkill", h.id)
                            end
                        end)
                    end
                    RageUI.ButtonWithStyle("Change Name","Purchase",{RightLabel = "£" .. getMoneyStringFormatted(d.shop.changeNamePrice)},true,function(G, H, I)
                        if I then
                            TriggerServerEvent("ARMA:changePetName", h.id)
                            RageUI.CloseAll()
                        end
                    end)
                end
            end
        end)
    end
end)

Citizen.CreateThread(function()
    while true do
        if f.viewingPet then
            f.lastViewingId = f.viewingId
            if f.viewingId ~= 0 then
                tARMA.loadModel(d.pets[f.viewingId].model)
                drawNativeText("You are viewing the ~b~" .. d.pets[f.viewingId].name .. "~w~.")
                if not d.pets[f.viewingId].abilities.attack then
                    if d.pets[f.viewingId].onShoulder then
                        drawNativeText("This pet can only go on your ~b~shoulder ~w~.")
                    else
                        drawNativeText("This pet ~b~cannot ~w~attack.")
                    end
                end
                local s = tARMA.getPlayerPed()
                local J = CreatePed(28, d.pets[f.viewingId].model, 564.83, 2753.28, 41.89, 81.06, false, false)
                f.viewingEntity = J
                SetEntityNoCollisionEntity(J, s, false)
                TaskStandStill(J, 100000)
                while f.viewingId == f.lastViewingId do
                    SetEntityHeading(J, GetEntityHeading(J) - 0.3)
                    Wait(0)
                end
                if d.pets[f.viewingId] ~= nil and d.pets[f.viewingId].model ~= nil then
                    SetModelAsNoLongerNeeded(d.pets[f.viewingId].model)
                end
                if DoesEntityExist(f.viewingEntity) then
                    DeleteEntity(f.viewingEntity)
                end
            end
        end
        Wait(0)
    end
end)
local function K(L, ...)
    local M = NetworkGetNetworkIdFromEntity(h.handle)
    if M ~= 0 then
        TriggerServerEvent("ARMA:receivePetCommand", h.id, M, L, ...)
    end
end
function petOnGround()
    if d.pets[h.id].onShoulder and d.pets[h.id].info.currentAction == g.Shoulder then
        d.pets[h.id].info.currentAction = g.Floor
        K("petOnGround", GetPlayerServerId(PlayerId()))
        showNotification(i.Success, currentPet().name .. " is now on the ground")
    end
end
function petOnShoulder(N)
    if d.pets[h.id].onShoulder then
        d.pets[h.id].info.currentAction = g.Shoulder
        K("petOnShoulder", GetPlayerServerId(PlayerId()), N)
        showNotification(i.Success, currentPet().name .. " is now on your shoulder.")
    end
end
function tpPet()
    K("tpPet", GetPlayerServerId(PlayerId()))
end
local O = function(P)
    local Q = {}
    local R = GetGameTimer() / 200
    Q.r = math.floor(math.sin(R * P + 0) * 127 + 128)
    Q.g = math.floor(math.sin(R * P + 2) * 127 + 128)
    Q.b = math.floor(math.sin(R * P + 4) * 127 + 128)
    return Q
end
function selectAttackTargetPet()
    RageUI.Visible(RMenu:Get("armapets", "main"), false)
    Citizen.CreateThread(function()
        d.pets[h.id].info.currentAction = g.Attack
        local S = setupDogScaleform("instructional_buttons")
        showNotification(i.Info, "Aim at the ~b~target ~s~and press ENTER to begin the attack.")
        local T = PlayerId()
        while true do
            if h.id == 0 then
                break
            end
            if d.pets[h.id].info.currentAction == g.Attack then
                local B, U = GetEntityPlayerIsFreeAimingAt(T)
                if B then
                    if IsEntityAPed(U) and U ~= d.pets[h.id].info.handle then
                        DrawScaleformMovieFullscreen(S, 255, 255, 255, 255, 0)
                        local V = GetEntityCoords(U, true)
                        local W = O(0.5)
                        DrawMarker(1,V.x,V.y,V.z - 1.02,0,0,0,0,0,0,0.7,0.7,1.5,W.r,W.g,W.b,200,0,0,2,0,0,0,0)
                        if IsControlJustPressed(1, 18) then
                            local X = d.pets[h.id].info.handle
                            local M = NetworkGetNetworkIdFromEntity(X)
                            local Y = NetworkGetNetworkIdFromEntity(U)
                            if M ~= 0 and Y ~= 0 then
                                TriggerServerEvent("ARMA:startPetAttack", h.id, M, Y)
                                d.pets[h.id].info.isAttacking = true
                                S = setupDogScaleform("instructional_buttons")
                                showNotification(i.Info, "Attack has started, press ~b~DEL ~s~to stop the attack.")
                                while h.id ~= 0 and d.pets[h.id].info.isAttacking do
                                    Citizen.Wait(0)
                                end
                            end
                        end
                    end
                end
            else
                break
            end
            Wait(0)
        end
    end)
end
RegisterNetEvent("ARMA:disablePetAttacking",function(Z)
    d.pets[Z].info.isAttacking = false
    showNotification(i.Alert, "The attack has finished.")
end)
function petPerformTrick(_)
    d.pets[h.id].info.currentAction = g.Trick
    K("petPerformTrick", _.dict, _.base)
end
function petCreate(b)
    local s = tARMA.getPlayerPed()
    tARMA.loadModel(d.pets[b].model)
    local a0 = GetOffsetFromEntityInWorldCoords(s, 0.0, 1.0, 0.0)
    local a1 = GetEntityHeading(s)
    d.pets[b].info.handle = CreatePed(28, d.pets[b].model, a0.x, a0.y, a0.z, a1, true, true)
    while not DoesEntityExist(d.pets[b].info.handle) do
        Wait(0)
    end
    SetModelAsNoLongerNeeded(d.pets[b].model)
    if DoesEntityExist(d.pets[b].info.handle) then
        if d.pets[b].movementRate ~= nil then
            SetPedMoveRateOverride(d.pets[b].info.handle, d.pets[b].movementRate)
        end
        SetBlockingOfNonTemporaryEvents(d.pets[b].info.handle, 1)
        d.pets[b].info.active = true
        h.active = true
        h.id = b
        h.handle = d.pets[b].info.handle
        petFollow()
        RMenu:Get("armapets", "main"):SetSubtitle("~b~Pet: ~w~" .. d.pets[h.id].name)
        if d.pets[h.id].health ~= nil then
            RMenu:Get("armapets", "main"):SetSubtitle("~b~Pet: ~w~" .. d.pets[h.id].name .. " ~b~Health: ~w~" .. d.pets[h.id].health .. "/100")
        end
        showNotification(i.Success, currentPet().name .. " has now been created.")
    end
end
function petDelete()
    K("petDelete")
    h.active = false
    h.id = 0
    h.cooldown = true
    RMenu:Get("armapets", "main"):SetSubtitle("Select your ~b~Pet")
    SetTimeout(20000,function()
        h.cooldown = false
        showNotification(i.Success, "You are now able to spawn in a pet again.")
    end)
end
function petFollow()
    if not d.pets[h.id].onShoulder then
        showNotification(i.Info, currentPet().name .. " is now following.")
        K("petFollow", GetPlayerServerId(PlayerId()))
        d.pets[h.id].info.currentAction = g.Follow
    else
        petOnShoulder()
    end
end
function petStay()
    K("petStay")
    d.pets[h.id].info.currentAction = g.Stay
end
function putPetInVehicle()
    local a2 = tARMA.getNearestVehicle(7.0)
    if a2 ~= -1 and a2 ~= nil and a2 ~= 0 then
        local a3 = NetworkGetNetworkIdFromEntity(a2)
        if a3 ~= 0 then
            K("putPetInVehicle", a3)
        end
        d.pets[h.id].info.inVehicle = true
        d.pets[h.id].info.insideVehicleHandle = a2
        showNotification(i.Info, "Pet is now inside the vehicle")
    else
        showNotification(i.Error, "No nearby vehicle found.")
    end
end
function removePetFromVehicle()
    if IsPedInAnyVehicle(tARMA.getPlayerPed(), true) then
        showNotification(i.Error, "You must be outside the vehicle.")
    else
        K("removePetFromVehicle", GetPlayerServerId(PlayerId()))
        showNotification(i.Info, currentPet().name .. " is now removed from the vehicle.")
        d.pets[h.id].info.inVehicle = false
    end
end
function petSit()
    local a4 = d.pets[h.id].animations.sit.dict
    local a5 = d.pets[h.id].animations.sit.base
    K("petSit", a4, a5)
end
function petAttack()
    local a4 = d.pets[h.id].animations.sit.dict
    local a5 = d.pets[h.id].animations.sit.base
    K("petAttack", a4, a5)
end
local function a6(C, a7, D)
    ClearPedTasks(h.handle)
    tARMA.loadAnimDict(a7)
    TaskPlayAnim(C, a7, D, 8.0, -8.0, -1, 2, 0.0, false, false, false)
    RemoveAnimDict(a7)
end
local function a8(C)
    DeleteEntity(C)
end
local function a9(C, aa)
    local ab = GetPlayerFromServerId(aa)
    if ab == -1 then
        return
    end
    local ac = GetPlayerPed(ab)
    if ac == 0 then
        return
    end
    ClearPedTasks(C)
    TaskFollowToOffsetOfEntity(C, ac, 0.0, 0.0, 0.0, 7.0, -1, 10.0, true)
end
local function ad(C)
    ClearPedTasks(C)
end
local function ae(C, a3)
    if not NetworkDoesNetworkIdExist(a3) then
        return
    end
    local a2 = NetworkGetEntityFromNetworkId(a3)
    if a2 == 0 then
        return
    end
    ClearPedTasks(C)
    local af = GetEntityBoneIndexByName(a2, "seat_dside_r")
    if af == -1 then
        af = GetEntityBoneIndexByName(a2, "seat_pside_f")
    end
    AttachEntityToEntity(C, a2, af, 0.0, -0.1, 0.4, 0.0, 0.0, 0.0, 0, false, false, true, 0, true)
end
local function ag(C, aa)
    local ab = GetPlayerFromServerId(aa)
    if ab == -1 then
        return
    end
    local ac = GetPlayerPed(ab)
    if ac == 0 then
        return
    end
    ClearPedTasks(C)
    local a0 = GetEntityCoords(ac, true)
    DetachEntity(C, true, true)
    SetEntityCoords(C, a0.x, a0.y, a0.z - 1.0, 0.0, 0.0, 0.0, false)
    a9(C, aa)
end
local function ah(C, a7, D)
    ClearPedTasks(C)
    tARMA.loadAnimDict(a7)
    TaskPlayAnim(C, a7, D, 8.0, -8.0, -1, 2, 0.0, false, false, false)
    RemoveAnimDict(a7)
end
local function ai(C, a7, D)
    ClearPedTasks(C)
    tARMA.loadAnimDict(a7)
    TaskPlayAnim(C, a7, D, 8.0, -8.0, -1, 2, 0.0, false, false, false)
    RemoveAnimDict(a7)
end
local function aj(C, aa)
    local ab = GetPlayerFromServerId(aa)
    if ab == -1 then
        return
    end
    local ac = GetPlayerPed(ab)
    if ac == 0 then
        return
    end
    DetachEntity(C)
    TaskFollowToOffsetOfEntity(C, ac, 0.0, 0.0, 0.0, 1.0, -1, 10.0, true)
    ClearPedTasks(C)
end
local function ak(C, aa, N)
    local ab = GetPlayerFromServerId(aa)
    if ab == -1 then
        return
    end
    local ac = GetPlayerPed(ab)
    if ac == 0 then
        return
    end
    if N then
        AttachEntityToEntity(C,ac,GetPedBoneIndex(ac, 24818),0.17,0.0,-0.18,0.0,90.0,0.0,false,false,false,true,1,true)
    else
        AttachEntityToEntity(C,ac,GetPedBoneIndex(ac, 24818),0.17,0.0,0.2,0.0,90.0,0.0,false,false,false,true,1,true)
    end
end
local function al(C, aa)
    local ab = GetPlayerFromServerId(aa)
    if ab == -1 then
        return
    end
    local ac = GetPlayerPed(ab)
    if ac == 0 then
        return
    end
    local a0 = GetEntityCoords(ac, true)
    SetEntityCoords(C, a0.x, a0.y, a0.z - 1.0, 0.0, 0.0, 0.0, false)
end
RegisterNetEvent("ARMA:receivePetCommand",function(M, L, ...)
    if not NetworkDoesNetworkIdExist(M) then
        return
    end
    local C = NetworkGetEntityFromNetworkId(M)
    if C == 0 then
        return
    end
    if L == "petPerformTrick" then
        a6(C, ...)
    elseif L == "petDelete" then
        a8(C, ...)
    elseif L == "petFollow" then
        a9(C, ...)
    elseif L == "petStay" then
        ad(C, ...)
    elseif L == "putPetInVehicle" then
        ae(C, ...)
    elseif L == "removePetFromVehicle" then
        ag(C, ...)
    elseif L == "petSit" then
        ah(C, ...)
    elseif L == "petAttack" then
        ai(C, ...)
    elseif L == "petOnGround" then
        aj(C, ...)
    elseif L == "petOnShoulder" then
        ak(C, ...)
    elseif L == "tpPet" then
        al(C, ...)
    end
end)
function showNotification(am, an)
    print(am,an)
    BeginTextCommandThefeedPost("STRING")
    if am == i.Success then
        AddTextComponentSubstringPlayerName("~g~~h~Success~h~~s~: " .. an)
    elseif am == i.Error then
        AddTextComponentSubstringPlayerName("~r~~h~Error~h~~s~: " .. an)
    elseif am == i.Alert then
        AddTextComponentSubstringPlayerName("~y~~h~Alert~h~~s~: " .. an)
    elseif am == i.Unknown then
        AddTextComponentSubstringPlayerName(an)
    elseif am == i.Info then
        AddTextComponentSubstringPlayerName("~b~~h~Info~h~~s~: " .. an)
    else
        AddTextComponentSubstringPlayerName(an)
    end
    EndTextCommandThefeedPostTicker(false, false)
end
function func_petHandler(l)
    if h.active then
        if DoesEntityExist(h.handle) and IsEntityDead(h.handle) then
            drawNativeText("Your pet has ~b~died~w~, please wait before respawning.")
            showNotification(i.Alert, "Please wait 5 minutes before respawning the pet.")
            SetTimeout(300000,function()
                d.pets[h.id].info.dead = false
            end)
            d.pets[h.id].info.dead = true
            h.active = false
            RMenu:Get("armapets", "main"):SetSubtitle("Select your ~b~Pet")
        else
            if not d.pets[h.id].awaitingHealthReduction and d.pets[h.id].health < 1 then
                d.pets[h.id].awaitingHealthReduction = true
                SetTimeout(300000,function()
                    local ao = d.pets[h.id].health
                    local ap = ao - 10
                    if ap < 2 then
                        ap = 1
                        showNotification(i.Alert,"You must feed your pet to continue using it. Head to a pet store!")
                    end
                    d.pets[h.id].health = ap
                    d.pets[h.id].awaitingHealthReduction = false
                    TriggerServerEvent("ARMA:updatePetHealthServer", h.id, ap)
                    RMenu:Get("armapets", "main"):SetSubtitle("~b~Pet: ~w~" .. d.pets[h.id].name .. " ~b~Health: ~w~" .. d.pets[h.id].health .. "/100")
                end)
            end
        end
    else
        if f.cameraEnabled then
            if not RageUI.Visible(RMenu:Get("armapets", "store")) then
                RenderScriptCams(false, false, 0, 1, 0)
                if f.cameraHandle ~= nil or f.cameraHandle ~= 0 then
                    DestroyCam(f.cameraHandle, false)
                end
                f.cameraEnabled = false
                f.viewingPet = false
            end
        end
    end
end
function tARMA.hasPetSpawned()
    return h.active
end
tARMA.createThreadOnTick(func_petHandler)
