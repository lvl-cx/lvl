local a = nil
local b = {}
local c = ""
local function checkOutfits()
    if next(b) then
        return true
    end
    return false
end
RMenu.Add("oasiswardrobe","mainmenu",RageUI.CreateMenu("", "", tOASIS.getRageUIMenuWidth(), tOASIS.getRageUIMenuHeight(), "banners", "cstore"))
RMenu:Get("oasiswardrobe", "mainmenu"):SetSubtitle("~b~HOME")
RMenu.Add("oasiswardrobe","listoutfits",RageUI.CreateSubMenu(RMenu:Get("oasiswardrobe", "mainmenu"),"","~b~Wardrobe",tOASIS.getRageUIMenuWidth(),tOASIS.getRageUIMenuHeight()))
RMenu.Add("oasiswardrobe","equip",RageUI.CreateSubMenu(RMenu:Get("oasiswardrobe", "listoutfits"),"","~b~Wardrobe",tOASIS.getRageUIMenuWidth(),tOASIS.getRageUIMenuHeight()))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('oasiswardrobe', 'mainmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Button("List Outfits","",{RightLabel = "→→→"},checkOutfits(),function(d, e, f)
            end,RMenu:Get("oasiswardrobe", "listoutfits"))
            RageUI.Button("Save Outfit","",{RightLabel = "→→→"},true,function(d, e, f)
                if f then
                    c = getGenericTextInput("outfit name:")
                    if c then
                        if not tOASIS.isPlayerInAnimalForm() then
                            TriggerServerEvent("OASIS:saveWardrobeOutfit", c)
                        else
                            tOASIS.notify("~r~Cannot save animal in wardrobe.")
                        end
                    else
                        tOASIS.notify("~r~Invalid outfit name")
                    end
                end
            end)
            RageUI.Button("Get Outfit Code","Gets a code for your current outfit which can be shared with other players.",{RightLabel = "→→→"},true,function(d, e, f)
                if f then
                    if tOASIS.isPlusClub() or tOASIS.isPlatClub() then
                        TriggerServerEvent("OASIS:getCurrentOutfitCode")
                    else
                        tOASIS.notify("~y~You need to be a subscriber of OASIS Plus or OASIS Platinum to use this feature.")
                        tOASIS.notify("~y~Available @ store.oasisv.co.uk")
                    end
                end
            end,nil)
        end, function()
        end)
    end
    if RageUI.Visible(RMenu:Get('oasiswardrobe', 'listoutfits')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            if b ~= {} then
                for g, h in pairs(b) do
                    RageUI.Button(g,"",{RightLabel = "→→→"},true,function(d, e, f)
                        if f then
                            c = g
                        end
                    end,RMenu:Get("oasiswardrobe", "equip"))
                end
            else
                RageUI.Button("~r~No outfits saved","",{RightLabel = "→→→"},true,function(d, e, f)
                end,RMenu:Get("oasiswardrobe", "mainmenu"))
            end
        end, function()
        end)
    end
    if RageUI.Visible(RMenu:Get('oasiswardrobe', 'equip')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Button("Equip Outfit","",{RightLabel = "→→→"},true,function(d, e, f)
                if f then
                    TriggerServerEvent("OASIS:equipWardrobeOutfit", c)
                end
            end,RMenu:Get("oasiswardrobe", "listoutfits"))
            RageUI.Button("Delete Outfit","",{RightLabel = "→→→"},true,function(d, e, f)
                if f then
                    TriggerServerEvent("OASIS:deleteWardrobeOutfit", c)
                end
            end,RMenu:Get("oasiswardrobe", "listoutfits"))
        end, function()
        end)
    end
end)

local function i()
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get('oasiswardrobe', 'mainmenu'), true)
end
local function j()
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("oasiswardrobe", "mainmenu"), false)
end
RegisterNetEvent("OASIS:openOutfitMenu",function(k)
    if k then
        b = k
    else
        TriggerServerEvent("OASIS:initWardrobe")
    end
    i()
end)
RegisterNetEvent("OASIS:refreshOutfitMenu",function(k)
    b = k
end)
RegisterNetEvent("OASIS:closeOutfitMenu",function()
    j()
end)