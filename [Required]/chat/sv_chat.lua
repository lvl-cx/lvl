local Tunnel = module("arma", "lib/Tunnel")
local Proxy = module("arma", "lib/Proxy")
ARMA = Proxy.getInterface("ARMA")
ARMAclient = Tunnel.getInterface("ARMA","ARMA_CHAT")

RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

local blockedWords = {
"nigger", 
"nigga", 
"wog", 
"coon", 
"paki",
"admin",
"cunt",
"faggot",
"anal",
"dick",
"kys",
"gay",
"homosexual",
"lesbian",
"suicide",
"negro",
"queef",
"queer",
"weeb",
"suck",
"tard",
"allahu akbar",
"terrorist",
"wanker",
"n1gger",
"f4ggot",
"n0nce",
"d1ck",
"h0m0",
"n1gg3r",
"h0m0s3xual",
"nazi",
"hitler",}

AddEventHandler('_chat:messageEntered', function(author, color, message)
    local source = source
    if not message or not author then
        return
    end
    if not WasEventCanceled() then
        for word in pairs(blockedWords) do
            if(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(message:lower(), "-", ""), ",", ""), "%.", ""), " ", ""), "*", ""), "+", ""):find(blockedWords[word])) then
                TriggerClientEvent('ARMA:chatFilterScaleform', source, 10, 'That word is not allowed.')
                CancelEvent()
                return
            end
        end
        TriggerClientEvent('chatMessage', -1, "Twitter @"..author..":",  { 255, 255, 255 }, message)
        ARMA.sendWebhook({'twitter', "ARMA Chat Logs", "```"..message.."```".."\n> Player Name: **"..GetPlayerName(source).."**\n> Player PermID: **"..ARMA.getUserId({source}).."**\n> Player TempID: **"..source.."**"})
    end

    print(author .. '^7: ' .. message .. '^7')
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    TriggerEvent('chatMessage', source, name, '/' .. command)

    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, name, { 255, 255, 255 }, '/' .. command) 
    end

    CancelEvent()
end)

-- command suggestions for clients
local function refreshCommands(player)
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerClientEvent('chat:addSuggestions', player, suggestions)
    end
end

AddEventHandler('chat:init', function()
    refreshCommands(source)
end)

AddEventHandler('onServerResourceStart', function(resName)
    Wait(500)

    for _, player in ipairs(GetPlayers()) do
        refreshCommands(player)
    end
end)

AddEventHandler('chatMessage', function(Source, Name, Msg)
    args = stringsplit(Msg, " ")
    CancelEvent()
    if string.find(args[1], "/") then
        local cmd = args[1]
        table.remove(args, 1)
	else
		TriggerClientEvent('chatMessage', -1, Name, { 255, 255, 255 }, Msg)
	end
end)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end