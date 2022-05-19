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

local Tunnel = module("arma", "lib/Tunnel")
local Proxy = module("arma", "lib/Proxy")
local htmlEntities = module("arma", "lib/htmlEntities")

ARMAbm = {}
ARMA = Proxy.getInterface("ARMA")
ARMAclient = Tunnel.getInterface("ARMA","ARMA_basic_menu")
BMclient = Tunnel.getInterface("ARMA_basic_menu","ARMA_basic_menu")
ARMAbsC = Tunnel.getInterface("ARMA_barbershop","ARMA_basic_menu")
Tunnel.bindInterface("arma_basic_menu",ARMAbm)

local Lang = module("arma", "lib/Lang")
local cfg = module("arma", "cfg/base")
local lang = Lang.new(module("arma", "cfg/lang/"..cfg.lang) or {})

Citizen.CreateThread(function()
  while true do 
    ARMA.defInventoryItem({"body_armor","Level 4 Body Armor","Intact body armor.",
    function(args)
      local choices = {}

      choices["Equip"] = {function(player,choice)
        local user_id = ARMA.getUserId({player})
        if user_id ~= nil then
          BMclient.getArmour(player,{},function(armour)
            if armour < 95 then
              if ARMA.tryGetInventoryItem({user_id, "body_armor", 1, true}) then
    		        BMclient.setArmour(player,{95,true})
                TriggerEvent('ARMA:RefreshInventory', player)
                ARMA.closeMenu({player})
              end
            else
              ARMAclient.notify(player,{'~r~You already have Max Armour!'})
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
    ARMA.defInventoryItem({"body_armor2","Level 2 Body Armor","Intact body armor.",
    function(args)
      local choices = {}

      choices["Equip"] = {function(player,choice)
        local user_id = ARMA.getUserId({player})
        if user_id ~= nil then
          BMclient.getArmour(player,{},function(armour)
            if armour < 50 then
              if ARMA.tryGetInventoryItem({user_id, "body_armor2", 1, true}) then
                TriggerEvent('ARMA:RefreshInventory', player)
    		        BMclient.setArmour(player,{50,true})
                ARMA.closeMenu({player})
              end
            else
              ARMAclient.notify(player,{'~r~You already have Max Armour!'})
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
    ARMA.defInventoryItem({"body_armor3","Level 1 Body Armor","Intact body armor.",
    function(args)
      local choices = {}

      choices["Equip"] = {function(player,choice)
        local user_id = ARMA.getUserId({player})
        if user_id ~= nil then
          BMclient.getArmour(player,{},function(armour)
            if armour < 25 then
              if ARMA.tryGetInventoryItem({user_id, "body_armor3", 1, true}) then
    		        BMclient.setArmour(player,{25,true})
                TriggerEvent('ARMA:RefreshInventory', player)
                ARMA.closeMenu({player})
              end
            else
              ARMAclient.notify(player,{'~r~You already have Max Armour!'})
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
  local user_id = ARMA.getUserId({source})
  if not ARMA.hasPermission({user_id, 'police.menu'}) then
    BMclient.getArmour(source,{},function(armour)
      if not isStoring2[source] then
        isStoring2[source] = true
        if armour > 90 then
          ARMA.giveInventoryItem({user_id, "body_armor", 1, true})
	        BMclient.setArmour(source,{0,false})
          SetTimeout(3000,function()
            isStoring2[source] = false
        end)
        else
          if armour > 49 then

            ARMA.giveInventoryItem({user_id, "body_armor2", 1, true})
            BMclient.setArmour(source,{0,false})

            SetTimeout(3000,function()
              isStoring2[source] = false
          end)
          else
            if armour > 24 then
            
              ARMA.giveInventoryItem({user_id, "body_armor3", 1, true})
              BMclient.setArmour(source,{0,false})

              SetTimeout(3000,function()
                isStoring2[source] = false
            end)
            else
              ARMAclient.notify(source,{'~r~You do not have enough Armour to store!'})
                SetTimeout(3000,function()
                  isStoring2[source] = false
              end)
            end
          end
        end
      else
        ARMAclient.notify(source,{"~r~Storing Cooldown."})
    end

    end)
  else
    ARMAclient.notify(source,{"~r~You cannot store armour when clocked on."})
  end
end)


Citizen.CreateThread(function()
  while true do 
    ARMA.defInventoryItem({"morphine","Morphine","",
    function(args)
      local choices = {}

      choices["Equip"] = {function(player,choice)
        local user_id = ARMA.getUserId({player})
        if user_id ~= nil then
          BMclient.getHealth(player,{},function(armour)
           
              if ARMA.tryGetInventoryItem({user_id, "morphine", 1, true}) then
    		        TriggerClientEvent('morphine', player)
                TriggerEvent('ARMA:RefreshInventory', player)
                ARMA.closeMenu({player})
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




