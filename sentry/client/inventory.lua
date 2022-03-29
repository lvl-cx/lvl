
Citizen.CreateThread(function()
    while (true) do
      Citizen.Wait(0)
      if IsControlJustPressed(1, 182) then
        TriggerServerEvent('IFN:OpenInventory', source)
      end
    end
end)
