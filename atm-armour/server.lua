--[[
    FiveM Scripts
    Copyright C 2018  Sighmir

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    at your option any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

local Tunnel = module("atm", "lib/Tunnel")
local Proxy = module("atm", "lib/Proxy")
local htmlEntities = module("atm", "lib/htmlEntities")

ATMbm = {}
ATM = Proxy.getInterface("ATM")
ATMclient = Tunnel.getInterface("ATM","ATM_basic_menu")
BMclient = Tunnel.getInterface("ATM_basic_menu","ATM_basic_menu")
ATMbsC = Tunnel.getInterface("ATM_barbershop","ATM_basic_menu")
Tunnel.bindInterface("atm_basic_menu",ATMbm)

local Lang = module("atm", "lib/Lang")
local cfg = module("atm", "cfg/base")
local lang = Lang.new(module("atm", "cfg/lang/"..cfg.lang) or {})

Citizen.CreateThread(function()
  while true do 
    ATM.defInventoryItem({"body_armor","Level 4 Body Armor","Intact body armor.",
    function(args)
      local choices = {}

      choices["Equip"] = {function(player,choice)
        local user_id = ATM.getUserId({player})
        if user_id ~= nil then
          BMclient.getArmour(player,{},function(armour)
            if armour < 95 then
              if ATM.tryGetInventoryItem({user_id, "body_armor", 1, true}) then
    		        BMclient.setArmour(player,{95,true})
                TriggerEvent('ATM:RefreshInventory', player)
                ATM.closeMenu({player})
              end
            else
              ATMclient.notify(player,{'~r~You already have Max Armour!'})
            end
          end)
        end
      end}

      return choices
    end,
    5.00})
    Citizen.Wait(3000)
  end
end)



Citizen.CreateThread(function()
  while true do 
    ATM.defInventoryItem({"body_armor2","Level 2 Body Armor","Intact body armor.",
    function(args)
      local choices = {}

      choices["Equip"] = {function(player,choice)
        local user_id = ATM.getUserId({player})
        if user_id ~= nil then
          BMclient.getArmour(player,{},function(armour)
            if armour < 50 then
              if ATM.tryGetInventoryItem({user_id, "body_armor2", 1, true}) then
                TriggerEvent('ATM:RefreshInventory', player)
    		        BMclient.setArmour(player,{50,true})
                ATM.closeMenu({player})
              end
            else
              ATMclient.notify(player,{'~r~You already have Max Armour!'})
            end
          end)
        end
      end}

      return choices
    end,
    5.00})
    Citizen.Wait(3000)
  end
end)

Citizen.CreateThread(function()
  while true do 
    ATM.defInventoryItem({"body_armor3","Level 1 Body Armor","Intact body armor.",
    function(args)
      local choices = {}

      choices["Equip"] = {function(player,choice)
        local user_id = ATM.getUserId({player})
        if user_id ~= nil then
          BMclient.getArmour(player,{},function(armour)
            if armour < 25 then
              if ATM.tryGetInventoryItem({user_id, "body_armor3", 1, true}) then
    		        BMclient.setArmour(player,{25,true})
                TriggerEvent('ATM:RefreshInventory', player)
                ATM.closeMenu({player})
              end
            else
              ATMclient.notify(player,{'~r~You already have Max Armour!'})
            end
          end)
        end
      end}

      return choices
    end,
    5.00})
    Citizen.Wait(3000)
  end
end)


local isStoring2 = {}
RegisterCommand("storearmour", function(source)
  local user_id = ATM.getUserId({source})
  if not ATM.hasPermission({user_id, 'police.menu'}) then
    BMclient.getArmour(source,{},function(armour)
      if not isStoring2[source] then
        isStoring2[source] = true
        if armour > 90 then
          ATM.giveInventoryItem({user_id, "body_armor", 1, true})
	        BMclient.setArmour(source,{0,false})
          SetTimeout(3000,function()
            isStoring2[source] = false
        end)
        else
          if armour > 49 then

            ATM.giveInventoryItem({user_id, "body_armor2", 1, true})
            BMclient.setArmour(source,{0,false})

            SetTimeout(3000,function()
              isStoring2[source] = false
          end)
          else
            if armour > 24 then
            
              ATM.giveInventoryItem({user_id, "body_armor3", 1, true})
              BMclient.setArmour(source,{0,false})

              SetTimeout(3000,function()
                isStoring2[source] = false
            end)
            else
              ATMclient.notify(source,{'~r~You do not have enough Armour to store!'})
                SetTimeout(3000,function()
                  isStoring2[source] = false
              end)
            end
          end
        end
      else
        ATMclient.notify(source,{"~r~Storing Cooldown."})
    end

    end)
  else
    ATMclient.notify(source,{"~r~You cannot store armour when clocked on."})
  end
end)


Citizen.CreateThread(function()
  while true do 
    ATM.defInventoryItem({"morphine","Morphine","",
    function(args)
      local choices = {}

      choices["Equip"] = {function(player,choice)
        local user_id = ATM.getUserId({player})
        if user_id ~= nil then
          BMclient.getHealth(player,{},function(armour)
           
              if ATM.tryGetInventoryItem({user_id, "morphine", 1, true}) then
    		        TriggerClientEvent('morphine', player)
                TriggerEvent('ATM:RefreshInventory', player)
                ATM.closeMenu({player})
              end
 
          
          end)
        end
      end}

      return choices
    end,
    5.00})
    Citizen.Wait(3000)
  end
end)




