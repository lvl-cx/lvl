RegisterNetEvent("OASIS:tchat_receive")
AddEventHandler("OASIS:tchat_receive", function(message)
  SendNUIMessage({event = 'tchat_receive', message = message})
end)

RegisterNetEvent("OASIS:tchat_channel")
AddEventHandler("OASIS:tchat_channel", function(channel, messages)
  SendNUIMessage({event = 'tchat_channel', messages = messages})
end)

RegisterNUICallback('tchat_addMessage', function(data, cb)
  TriggerServerEvent('OASIS:tchat_addMessage', data.channel, data.message)
end)

RegisterNUICallback('tchat_getChannel', function(data, cb)
  TriggerServerEvent('OASIS:tchat_channel', data.channel)
end)
