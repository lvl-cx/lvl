MySQL = module("atm_mysql", "MySQL")

local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")
local Lang = module("lib/Lang")
Debug = module("lib/Debug")

local config = module("cfg/base")
local log_config = module("servercfg/cfg_webhooks")
local version = module("version")

print("^5[ATM]: ^7" .. 'Checking for ATM Updates..')

PerformHttpRequest("https://raw.githubusercontent.com/DunkoUK/dunko_atm/master/atm/version.lua",function(err,text,headers)
if err == 200 then
    text = string.gsub(text,"return ","")
    local r_version = tonumber(text)
    if version ~= r_version then
        print("^5[ATM]: ^7" .. 'A Dunko Update is available from: https://github.com/DunkoUK/dunko_atm')
    else 
        print("^5[ATM]: ^7" .. 'You are running the most up to date Dunko Version. Thanks for using Dunko_ATM and thanks to our contributors for updating the project. Support Found At: https://discord.gg/b8wQn2XqDt')
    end
else
    print("[ATM] unable to check the remote version")
end
end, "GET", "")


Debug.active = config.debug
ATM = {}
Proxy.addInterface("ATM",ATM)

tATM = {}
Tunnel.bindInterface("ATM",tATM) -- listening for client tunnel

-- load language 
local dict = module("cfg/lang/"..config.lang) or {}
ATM.lang = Lang.new(dict)

-- init
ATMclient = Tunnel.getInterface("ATM","ATM") -- server -> client tunnel

ATM.users = {} -- will store logged users (id) by first identifier
ATM.rusers = {} -- store the opposite of users
ATM.user_tables = {} -- user data tables (logger storage, saved to database)
ATM.user_tmp_tables = {} -- user tmp data tables (logger storage, not saved)
ATM.user_sources = {} -- user sources 
-- queries
Citizen.CreateThread(function()
    Wait(1000) -- Wait for GHMatti to Initialize
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS atm_users(
    id INTEGER AUTO_INCREMENT,
    last_login VARCHAR(100),
    whitelisted BOOLEAN,
    banned BOOLEAN,
    bantime VARCHAR(100) NOT NULL DEFAULT "",
    banreason VARCHAR(1000) NOT NULL DEFAULT "",
    banadmin VARCHAR(100) NOT NULL DEFAULT "",
    CONSTRAINT pk_user PRIMARY KEY(id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS atm_user_ids (
    identifier VARCHAR(100) NOT NULL,
    user_id INTEGER,
    banned BOOLEAN,
    CONSTRAINT pk_user_ids PRIMARY KEY(identifier)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS atm_user_tokens (
    token VARCHAR(200),
    user_id INTEGER,
    banned BOOLEAN  NOT NULL DEFAULT 0,
    CONSTRAINT pk_user_tokens PRIMARY KEY(token)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS atm_user_data(
    user_id INTEGER,
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_user_data PRIMARY KEY(user_id,dkey),
    CONSTRAINT fk_user_data_users FOREIGN KEY(user_id) REFERENCES atm_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS atm_srv_data(
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_srv_data PRIMARY KEY(dkey)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS atm_user_moneys(
    user_id INTEGER,
    wallet INTEGER,
    bank INTEGER,
    CONSTRAINT pk_user_moneys PRIMARY KEY(user_id),
    CONSTRAINT fk_user_moneys_users FOREIGN KEY(user_id) REFERENCES atm_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS atm_user_business(
    user_id INTEGER,
    name VARCHAR(30),
    description TEXT,
    capital INTEGER,
    laundered INTEGER,
    reset_timestamp INTEGER,
    CONSTRAINT pk_user_business PRIMARY KEY(user_id),
    CONSTRAINT fk_user_business_users FOREIGN KEY(user_id) REFERENCES atm_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS atm_user_vehicles(
    user_id INTEGER,
    vehicle VARCHAR(100),
    vehicle_plate varchar(255) NOT NULL,
    rented BOOLEAN NOT NULL DEFAULT 0,
    rentedid varchar(200) NOT NULL DEFAULT '',
    rentedtime varchar(2048) NOT NULL DEFAULT '',
    CONSTRAINT pk_user_vehicles PRIMARY KEY(user_id,vehicle),
    CONSTRAINT fk_user_vehicles_users FOREIGN KEY(user_id) REFERENCES atm_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS atm_user_homes(
    user_id INTEGER,
    home VARCHAR(100),
    number INTEGER,
    CONSTRAINT pk_user_homes PRIMARY KEY(user_id),
    CONSTRAINT fk_user_homes_users FOREIGN KEY(user_id) REFERENCES atm_users(id) ON DELETE CASCADE,
    UNIQUE(home,number)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS atm_user_identities(
    user_id INTEGER,
    registration VARCHAR(100),
    phone VARCHAR(100),
    firstname VARCHAR(100),
    name VARCHAR(100),
    age INTEGER,
    CONSTRAINT pk_user_identities PRIMARY KEY(user_id),
    CONSTRAINT fk_user_identities_users FOREIGN KEY(user_id) REFERENCES atm_users(id) ON DELETE CASCADE,
    INDEX(registration),
    INDEX(phone)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS atm_warnings (
    warning_id INT AUTO_INCREMENT,
    user_id INT,
    warning_type VARCHAR(25),
    duration INT,
    admin VARCHAR(100),
    warning_date DATE,
    reason VARCHAR(2000),
    PRIMARY KEY (warning_id)
    )
    ]])
    MySQL.SingleQuery("ALTER TABLE atm_users ADD IF NOT EXISTS bantime varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE atm_users ADD IF NOT EXISTS banreason varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE atm_users ADD IF NOT EXISTS banadmin varchar(100) NOT NULL DEFAULT ''; ")
    MySQL.SingleQuery("ALTER TABLE atm_user_vehicles ADD IF NOT EXISTS rented BOOLEAN NOT NULL DEFAULT 0;")
    MySQL.SingleQuery("ALTER TABLE atm_user_vehicles ADD IF NOT EXISTS rentedid varchar(200) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE atm_user_vehicles ADD IF NOT EXISTS rentedtime varchar(2048) NOT NULL DEFAULT '';")
    MySQL.createCommand("ATMls/create_modifications_column", "alter table atm_user_vehicles add if not exists modifications text not null")
	MySQL.createCommand("ATMls/update_vehicle_modifications", "update atm_user_vehicles set modifications = @modifications where user_id = @user_id and vehicle = @vehicle")
	MySQL.createCommand("ATMls/get_vehicle_modifications", "select modifications from atm_user_vehicles where user_id = @user_id and vehicle = @vehicle")
	MySQL.execute("ATMls/create_modifications_column")
    print("[ATM] init base tables")
end)






MySQL.createCommand("ATM/create_user","INSERT INTO atm_users(whitelisted,banned) VALUES(false,false)")
MySQL.createCommand("ATM/add_identifier","INSERT INTO atm_user_ids(identifier,user_id) VALUES(@identifier,@user_id)")
MySQL.createCommand("ATM/userid_byidentifier","SELECT user_id FROM atm_user_ids WHERE identifier = @identifier")
MySQL.createCommand("ATM/identifier_all","SELECT * FROM atm_user_ids WHERE identifier = @identifier")
MySQL.createCommand("ATM/select_identifier_byid_all","SELECT * FROM atm_user_ids WHERE user_id = @id")

MySQL.createCommand("ATM/set_userdata","REPLACE INTO atm_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
MySQL.createCommand("ATM/get_userdata","SELECT dvalue FROM atm_user_data WHERE user_id = @user_id AND dkey = @key")

MySQL.createCommand("ATM/set_srvdata","REPLACE INTO atm_srv_data(dkey,dvalue) VALUES(@key,@value)")
MySQL.createCommand("ATM/get_srvdata","SELECT dvalue FROM atm_srv_data WHERE dkey = @key")

MySQL.createCommand("ATM/get_banned","SELECT banned FROM atm_users WHERE id = @user_id")
MySQL.createCommand("ATM/set_banned","UPDATE atm_users SET banned = @banned, bantime = @bantime,  banreason = @banreason,  banadmin = @banadmin WHERE id = @user_id")
MySQL.createCommand("ATM/set_identifierbanned","UPDATE atm_user_ids SET banned = @banned WHERE identifier = @iden")
MySQL.createCommand("ATM/getbanreasontime", "SELECT * FROM atm_users WHERE id = @user_id")

MySQL.createCommand("ATM/get_whitelisted","SELECT whitelisted FROM atm_users WHERE id = @user_id")
MySQL.createCommand("ATM/set_whitelisted","UPDATE atm_users SET whitelisted = @whitelisted WHERE id = @user_id")
MySQL.createCommand("ATM/set_last_login","UPDATE atm_users SET last_login = @last_login WHERE id = @user_id")
MySQL.createCommand("ATM/get_last_login","SELECT last_login FROM atm_users WHERE id = @user_id")

--Token Banning 
MySQL.createCommand("ATM/add_token","INSERT INTO atm_user_tokens(token,user_id) VALUES(@token,@user_id)")
MySQL.createCommand("ATM/check_token","SELECT user_id, banned FROM atm_user_tokens WHERE token = @token")
MySQL.createCommand("ATM/check_token_userid","SELECT token FROM atm_user_tokens WHERE user_id = @id")
MySQL.createCommand("ATM/ban_token","UPDATE atm_user_tokens SET banned = @banned WHERE token = @token")
--Token Banning

-- init tables


-- identification system

--- sql.
-- cbreturn user id or nil in case of error (if not found, will create it)
function ATM.getUserIdByIdentifiers(ids, cbr)
    local task = Task(cbr)
    
    if ids ~= nil and #ids then
        local i = 0
        
        -- search identifiers
        local function search()
            i = i+1
            if i <= #ids then
                if not config.ignore_ip_identifier or (string.find(ids[i], "ip:") == nil) then  -- ignore ip identifier
                    MySQL.query("ATM/userid_byidentifier", {identifier = ids[i]}, function(rows, affected)
                        if #rows > 0 then  -- found
                            task({rows[1].user_id})
                        else -- not found
                            search()
                        end
                    end)
                else
                    search()
                end
            else -- no ids found, create user
                MySQL.query("ATM/create_user", {}, function(rows, affected)
                    if rows.affectedRows > 0 then
                        local user_id = rows.insertId
                        -- add identifiers
                        for l,w in pairs(ids) do
                            if not config.ignore_ip_identifier or (string.find(w, "ip:") == nil) then  -- ignore ip identifier
                                MySQL.execute("ATM/add_identifier", {user_id = user_id, identifier = w})
                            end
                        end
                        
                        task({user_id})
                    else
                        task()
                    end
                end)
            end
        end
        
        search()
    else
        task()
    end
end

-- return identification string for the source (used for non ATM identifications, for rejected players)
function ATM.getSourceIdKey(source)
    local ids = GetPlayerIdentifiers(source)
    local idk = "idk_"
    for k,v in pairs(ids) do
        idk = idk..v
    end
    
    return idk
end

function ATM.getPlayerEndpoint(player)
    return GetPlayerEP(player) or "0.0.0.0"
end

function ATM.getPlayerName(player)
    return GetPlayerName(player) or "unknown"
end

--- sql

function ATM.ReLoadChar(source)
    local name = GetPlayerName(source)
    local ids = GetPlayerIdentifiers(source)
    ATM.getUserIdByIdentifiers(ids, function(user_id)
        if user_id ~= nil then  
            ATM.StoreTokens(source, user_id) 
            if ATM.rusers[user_id] == nil then -- not present on the server, init
                ATM.users[ids[1]] = user_id
                ATM.rusers[user_id] = ids[1]
                ATM.user_tables[user_id] = {}
                ATM.user_tmp_tables[user_id] = {}
                ATM.user_sources[user_id] = source
                ATM.getUData(user_id, "ATM:datatable", function(sdata)
                    local data = json.decode(sdata)
                    if type(data) == "table" then ATM.user_tables[user_id] = data end
                    local tmpdata = ATM.getUserTmpTable(user_id)
                    ATM.getLastLogin(user_id, function(last_login)
                        tmpdata.last_login = last_login or ""
                        tmpdata.spawns = 0
                        local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                        MySQL.execute("ATM/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                        print("[ATM] "..name.." joined (Perm ID: "..user_id..")")
                        TriggerEvent("ATM:playerJoin", user_id, source, name, tmpdata.last_login)
                        TriggerClientEvent("ATM:CheckIdRegister", source)
                    end)
                end)
            else -- already connected
                print("[ATM] "..name.." re-joined (Perm ID: "..user_id..")")
                TriggerEvent("ATM:playerRejoin", user_id, source, name)
                TriggerClientEvent("ATM:CheckIdRegister", source)
                local tmpdata = ATM.getUserTmpTable(user_id)
                tmpdata.spawns = 0
            end
        end
    end)
end
RegisterCommand("getmyid", function(source)
    TriggerClientEvent('chatMessage', source, "[Server]", {255, 255, 255}, " Perm ID: " .. ATM.getUserId(source) , "alert")
end)

-- This can only be used server side and is for the ATM bot. 
exports("atmbot", function(method_name, params, cb)
    if cb then 
        cb(ATM[method_name](table.unpack(params)))
    else 
        return ATM[method_name](table.unpack(params))
    end
end)

RegisterNetEvent("ATM:CheckID")
AddEventHandler("ATM:CheckID", function()
    local user_id = ATM.getUserId(source)
    if not user_id then
        ATM.ReLoadChar(source)
    end
end)

function ATM.isBanned(user_id, cbr)
    local task = Task(cbr, {false})
    
    MySQL.query("ATM/get_banned", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].banned})
        else
            task()
        end
    end)
end

--- sql

--- sql
function ATM.isWhitelisted(user_id, cbr)
    local task = Task(cbr, {false})
    
    MySQL.query("ATM/get_whitelisted", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].whitelisted})
        else
            task()
        end
    end)
end

--- sql
function ATM.setWhitelisted(user_id,whitelisted)
    MySQL.execute("ATM/set_whitelisted", {user_id = user_id, whitelisted = whitelisted})
end

--- sql
function ATM.getLastLogin(user_id, cbr)
    local task = Task(cbr,{""})
    MySQL.query("ATM/get_last_login", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].last_login})
        else
            task()
        end
    end)
end

function ATM.fetchBanReasonTime(user_id,cbr)
    MySQL.query("ATM/getbanreasontime", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then 
            cbr(rows[1].bantime, rows[1].banreason, rows[1].banadmin)
        end
    end)
end

function ATM.setUData(user_id,key,value)
    MySQL.execute("ATM/set_userdata", {user_id = user_id, key = key, value = value})
end

function ATM.getUData(user_id,key,cbr)
    local task = Task(cbr,{""})
    
    MySQL.query("ATM/get_userdata", {user_id = user_id, key = key}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

function ATM.setSData(key,value)
    MySQL.execute("ATM/set_srvdata", {key = key, value = value})
end

function ATM.getSData(key, cbr)
    local task = Task(cbr,{""})
    
    MySQL.query("ATM/get_srvdata", {key = key}, function(rows, affected)
        if rows and #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

-- return user data table for ATM internal persistant connected user storage
function ATM.getUserDataTable(user_id)
    return ATM.user_tables[user_id]
end

function ATM.getUserTmpTable(user_id)
    return ATM.user_tmp_tables[user_id]
end

function ATM.isConnected(user_id)
    return ATM.rusers[user_id] ~= nil
end

function ATM.isFirstSpawn(user_id)
    local tmp = ATM.getUserTmpTable(user_id)
    return tmp and tmp.spawns == 1
end

function ATM.getUserId(source)
    if source ~= nil then
        local ids = GetPlayerIdentifiers(source)
        if ids ~= nil and #ids > 0 then
            return ATM.users[ids[1]]
        end
    end
    
    return nil
end

-- return map of user_id -> player source
function ATM.getUsers()
    local users = {}
    for k,v in pairs(ATM.user_sources) do
        users[k] = v
    end
    
    return users
end

-- return source or nil
function ATM.getUserSource(user_id)
    return ATM.user_sources[user_id]
end

function ATM.IdentifierBanCheck(source,user_id,cb)
    for i,v in pairs(GetPlayerIdentifiers(source)) do 
        MySQL.query('ATM/identifier_all', {identifier = v}, function(rows)
            for i = 1,#rows do 
                if rows[i].banned then 
                    if user_id ~= rows[i].user_id then 
                        cb(true, rows[i].user_id)
                    end 
                end
            end
        end)
    end
end

function ATM.BanIdentifiers(user_id, value)
    MySQL.query('ATM/select_identifier_byid_all', {id = user_id}, function(rows)
        for i = 1, #rows do 
            MySQL.execute("ATM/set_identifierbanned", {banned = value, iden = rows[i].identifier })
        end
    end)
end

function ATM.setBanned(user_id,banned,time,reason, admin)
    if banned then
        webhook = log_config.banlog
        if webhook ~= nil then
            if webhook ~= 'none' then
                PerformHttpRequest(webhook, function(err, text, headers) end, "POST", json.encode({username = "Dunko ATM Logs", embeds = {{["color"] = "15158332", ["title"] = 'Someone Has Been Banned', ["description"] = 'Players Perm-ID: **' .. user_id .. '**\nReason Player Was Banned: **' .. reason .. '**\nBanning Admin: **' ..admin .. '**', ["footer"] = {["text"] = "Time - "..os.date("%x %X %p"),}}}}), { ["Content-Type"] = "application/json" })
            end
        end
        MySQL.execute("ATM/set_banned", {user_id = user_id, banned = banned, bantime = time, banreason = reason, banadmin = admin})
        ATM.BanIdentifiers(user_id, true)
        ATM.BanTokens(user_id, true) 
    else
        webhook = log_config.unbanlog
        if webhook ~= nil then
            if webhook ~= 'none' then
                PerformHttpRequest(webhook, function(err, text, headers) end, "POST", json.encode({username = "Dunko ATM Logs", embeds = {{["color"] = "15158332", ["title"] = 'Someone Has Been Unbanned', ["description"] = 'Players Perm-ID: **' .. user_id .. '**', ["footer"] = {["text"] = "Time - "..os.date("%x %X %p"),}}}}), { ["Content-Type"] = "application/json" })
            end
        end
        MySQL.execute("ATM/set_banned", {user_id = user_id, banned = banned, bantime = "", banreason =  "", banadmin =  ""})
        ATM.BanIdentifiers(user_id, false)
        ATM.BanTokens(user_id, false) 
    end 
end

function ATM.ban(adminsource,permid,time,reason)
    local adminPermID = ATM.getUserId(adminsource)
    local getBannedPlayerSrc = ATM.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            ATM.setBanned(permid,true,banTime,reason, GetPlayerName(adminsource) .. " | ID Of Admin: " .. adminPermID)
            ATM.kick(getBannedPlayerSrc,"You have been banned from this server. Your ban expires in: " .. os.date("%c", banTime) .. " Reason: " .. reason .. " | Banning Admin: " ..  GetPlayerName(adminsource) .. " | ID Of Admin: " .. adminPermID ) 
            ATMclient.notify(adminsource,{"~g~Successfully banned Perm ID:" .. permid})
        else 
            ATMclient.notify(adminsource,{"~g~Successfully banned Perm ID:" .. permid})
            ATM.setBanned(permid,true,"perm",reason, GetPlayerName(adminsource) .. " | ID Of Admin: " .. adminPermID)
            ATM.kick(getBannedPlayerSrc,"You have been banned from this server. Your ban expires in: " .. "Never, you've been permanently banned." .. " Reason: " .. reason .. " | Banning Admin: " ..  GetPlayerName(adminsource) .. " | ID Of Admin: " .. adminPermID ) 
        end
    else 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            ATMclient.notify(adminsource,{"~g~Successfully banned Perm ID:" .. permid})
            ATM.setBanned(permid,true,banTime,reason, GetPlayerName(adminsource) .. " | ID Of Admin: " .. adminPermID)
        else 
            ATMclient.notify(adminsource,{"~g~Successfully banned Perm ID:" .. permid})
            ATM.setBanned(permid,true,"perm",reason, GetPlayerName(adminsource) .. " | ID Of Admin: " .. adminPermID)
        end
    end
end

function ATM.banConsole(permid,time,reason)
    local adminPermID = "Console Ban"
    local getBannedPlayerSrc = ATM.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            ATM.setBanned(permid,true,banTime,reason,  'Console' .. " | ID Of Admin: " .. adminPermID)
            ATM.kick(getBannedPlayerSrc,"You have been banned from this server. Your ban expires in: " .. os.date("%c", banTime) .. " Reason: " .. reason .. " | BanningAdmin: " ..  'Console' .. " | ID Of Admin: " .. adminPermID ) 
            print("~g~Successfully banned Perm ID:" .. permid)
        else 
            print("~g~Successfully banned Perm ID:" .. permid)
            ATM.setBanned(permid,true,"perm",reason,  'Console' .. " | ID Of Admin: " .. adminPermID)
            ATM.kick(getBannedPlayerSrc,"You have been banned from this server. Your ban expires in: " .. "Never, you've been permanently banned." .. " Reason: " .. reason .. " | BanningAdmin: " ..  'Console' .. " | ID Of Admin: " .. adminPermID ) 
        end
    else 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            print("~g~Successfully banned Perm ID:" .. permid)
            ATM.setBanned(permid,true,banTime,reason, 'Console' .. " | ID Of Admin: " .. adminPermID)
        else 
            print("~g~Successfully banned Perm ID:" .. permid)
            ATM.setBanned(permid,true,"perm",reason, 'Console' .. " | ID Of Admin: " .. adminPermID)
        end
    end
end

-- To use token banning you need the latest artifacts.
function ATM.StoreTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            MySQL.query("ATM/check_token", {token = token}, function(rows)
                if token and rows and #rows <= 0 then 
                    MySQL.execute("ATM/add_token", {token = token, user_id = user_id})
                end        
            end)
        end
    end
end


function ATM.CheckTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local banned = false;
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            local rows = MySQL.asyncQuery("ATM/check_token", {token = token, user_id = user_id})
                if #rows > 0 then 
                if rows[1].banned then 
                    return rows[1].banned, rows[1].user_id
                end
            end
        end
    else 
        return false; 
    end
end

function ATM.BanTokens(user_id, banned) 
    if GetNumPlayerTokens then 
        MySQL.query("ATM/check_token_userid", {id = user_id}, function(id)
            for i = 1, #id do 
                MySQL.execute("ATM/ban_token", {token = id[i].token, banned = banned})
            end
        end)
    end
end


function ATM.kick(source,reason)
    webhook = log_config.kicklog
    local user_id = ATM.getUserId(source)
    local playername = GetPlayerName(source)
    if webhook ~= nil then
        if webhook ~= 'none' then
            PerformHttpRequest(webhook, function(err, text, headers) end, "POST", json.encode({username = "Dunko ATM Logs", embeds = {{["color"] = "15158332", ["title"] = playername .. ' Has Been Kicked', ["description"] = 'Players Perm-ID: **' .. user_id .. '**\nReason Player Was Kicked: **' .. reason .. '**', ["footer"] = {["text"] = "Time - "..os.date("%x %X %p"),}}}}), { ["Content-Type"] = "application/json" })
        end
    end
    DropPlayer(source,reason)
end

-- tasks

function task_save_datatables()
    TriggerEvent("ATM:save")
    
    Debug.pbegin("ATM save datatables")
    for k,v in pairs(ATM.user_tables) do
        ATM.setUData(k,"ATM:datatable",json.encode(v))
    end
    
    Debug.pend()
    SetTimeout(config.save_interval*1000, task_save_datatables)
end
task_save_datatables()

-- handlers

AddEventHandler("playerConnecting",function(name,setMessage, deferrals)
    deferrals.defer()
    
    local source = source
    Debug.pbegin("playerConnecting")
    local ids = GetPlayerIdentifiers(source)
    
    if ids ~= nil and #ids > 0 then
        deferrals.update("[ATM] Checking identifiers...")
        ATM.getUserIdByIdentifiers(ids, function(user_id)
            ATM.IdentifierBanCheck(source, user_id, function(status, id)
                if status then
                    print("[ATM] User rejected for attempting to evade. Perm ID: " .. user_id .. " | (Ignore joined message, they were rejected)") 
                    deferrals.done("[ATM]: You are banned from this server, please do not try to evade your ban. If you believe this was an error quote your Perm ID which is: " .. id)
                    return 
                end
            end)
            -- if user_id ~= nil and ATM.rusers[user_id] == nil then -- check user validity and if not already connected (old way, disabled until playerDropped is sure to be called)
            if user_id ~= nil then -- check user validity 
                deferrals.update("[ATM] Fetching Tokens...")
                ATM.StoreTokens(source, user_id) 
                deferrals.update("[ATM] Checking banned...")
                ATM.isBanned(user_id, function(banned)
                    if not banned then
                        deferrals.update("[ATM] Checking whitelisted...")
                        ATM.isWhitelisted(user_id, function(whitelisted)
                            if not config.whitelist or whitelisted then
                                Debug.pbegin("playerConnecting_delayed")
                                if ATM.rusers[user_id] == nil then -- not present on the server, init
                                    if ATM.CheckTokens(source, user_id) then 
                                        deferrals.done("[ATM]: You are banned from this server, please do not try to evade your ban.")
                                    end
                                    ATM.users[ids[1]] = user_id
                                    ATM.rusers[user_id] = ids[1]
                                    ATM.user_tables[user_id] = {}
                                    ATM.user_tmp_tables[user_id] = {}
                                    ATM.user_sources[user_id] = source
                                    
                                    -- load user data table
                                    deferrals.update("[ATM] Loading datatable...")
                                    ATM.getUData(user_id, "ATM:datatable", function(sdata)
                                        local data = json.decode(sdata)
                                        if type(data) == "table" then ATM.user_tables[user_id] = data end
                                        
                                        -- init user tmp table
                                        local tmpdata = ATM.getUserTmpTable(user_id)
                                        
                                        deferrals.update("[ATM] Getting last login...")
                                        ATM.getLastLogin(user_id, function(last_login)
                                            tmpdata.last_login = last_login or ""
                                            tmpdata.spawns = 0
                                            
                                            -- set last login
                                            local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                            MySQL.execute("ATM/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                            
                                            -- trigger join
                                            print("[ATM] "..name.." joined (Perm ID: "..user_id..")")
                                            TriggerEvent("ATM:playerJoin", user_id, source, name, tmpdata.last_login)
                                            deferrals.done()
                                        end)
                                    end)
                                else -- already connected
                                    if ATM.CheckTokens(source, user_id) then 
                                        deferrals.done("[ATM]: You are banned from this server, please do not try to evade your ban.")
                                    end
                                    print("[ATM] "..name.." re-joined (Perm ID: "..user_id..")")
                                    TriggerEvent("ATM:playerRejoin", user_id, source, name)
                                    deferrals.done()
                                    
                                    -- reset first spawn
                                    local tmpdata = ATM.getUserTmpTable(user_id)
                                    tmpdata.spawns = 0
                                end
                                
                                Debug.pend()
                            else
                                print("[ATM] "..name.." rejected: not whitelisted (Perm ID: "..user_id..")")
                                deferrals.done("[ATM] Not whitelisted (Perm ID: "..user_id..").")
                            end
                        end)
                    else
                        deferrals.update("[ATM] Fetching Tokens...")
                        ATM.StoreTokens(source, user_id) 
                        ATM.fetchBanReasonTime(user_id,function(bantime, banreason, banadmin)
                            if tonumber(bantime) then 
                                local timern = os.time()
                                if timern > tonumber(bantime) then 
                                    deferrals.update('Your ban has expired. Please do not violate this server\'s rules again. You will now be automatically connected!')
                                    Wait(2000)
                                    ATM.setBanned(user_id,false)
                                    if ATM.rusers[user_id] == nil then -- not present on the server, init
                                        -- init entries
                                        ATM.users[ids[1]] = user_id
                                        ATM.rusers[user_id] = ids[1]
                                        ATM.user_tables[user_id] = {}
                                        ATM.user_tmp_tables[user_id] = {}
                                        ATM.user_sources[user_id] = source
                                        
                                        -- load user data table
                                        deferrals.update("[ATM] Loading datatable...")
                                        ATM.getUData(user_id, "ATM:datatable", function(sdata)
                                            local data = json.decode(sdata)
                                            if type(data) == "table" then ATM.user_tables[user_id] = data end
                                            
                                            -- init user tmp table
                                            local tmpdata = ATM.getUserTmpTable(user_id)
                                            
                                            deferrals.update("[ATM] Getting last login...")
                                            ATM.getLastLogin(user_id, function(last_login)
                                                tmpdata.last_login = last_login or ""
                                                tmpdata.spawns = 0
                                                
                                                -- set last login
                                                local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                                MySQL.execute("ATM/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                
                                                -- trigger join
                                                print("[ATM] "..name.." joined after his ban expired. (Perm ID: "..user_id..")")
                                                TriggerEvent("ATM:playerJoin", user_id, source, name, tmpdata.last_login)
                                                deferrals.done()
                                            end)
                                        end)
                                    else -- already connected
                                        print("[ATM] "..name.." re-joined after his ban expired. (Perm ID: "..user_id..")")
                                        TriggerEvent("ATM:playerRejoin", user_id, source, name)
                                        deferrals.done()
                                        
                                        -- reset first spawn
                                        local tmpdata = ATM.getUserTmpTable(user_id)
                                        tmpdata.spawns = 0
                                    end
                                    return 
                                end
                                print("[ATM] "..name.." rejected: banned (Perm ID: "..user_id..")")
                                deferrals.done("[ATM] You have been banned from this server.\nYour ban will expire on the: " .. os.date("%c", bantime) .. "\nReason: " .. banreason .. "\n\nBanning Admin: " .. banadmin)
                            else 
                                print("[ATM] "..name.." rejected: banned (Perm ID: "..user_id..")")
                                deferrals.done("[ATM] You have been banned from this server.\nYour ban will expire: Never, you have been permanently banned \nReason: " .. banreason .. "\n\nBanning Admin: " .. banadmin)
                            end
                        end)
                    end
                end)
            else
                print("[ATM] "..name.." rejected: identification error")
                deferrals.done("[ATM] Identification error.")
            end
        end)
    else
        print("[ATM] "..name.." rejected: missing identifiers")
        deferrals.done("[ATM] Missing identifiers.")
    end
    Debug.pend()
end)

AddEventHandler("playerDropped",function(reason)
    local source = source
    local user_id = ATM.getUserId(source)
    local playername = GetPlayerName(source)
    webhook = log_config.leavelog
    if webhook ~= nil then
        if webhook ~= 'none' then
            PerformHttpRequest(webhook, function(err, text, headers) end, "POST", json.encode({username = "Dunko ATM Logs", embeds = {{["color"] = "15158332", ["title"] = playername .. ' Has Left The Server', ["description"] = 'His Perm-ID: **' .. user_id .. '\n** His Source Id: **' .. source .. '**', ["footer"] = {["text"] = "Time - "..os.date("%x %X %p"),}}}}), { ["Content-Type"] = "application/json" })
        end
    end
    if user_id ~= nil then
        TriggerEvent("ATM:playerLeave", user_id, source)
        
        -- save user data table
        ATM.setUData(user_id,"ATM:datatable",json.encode(ATM.getUserDataTable(user_id)))
        
        print("[ATM] "..GetPlayerName(source).." disconnected (Perm ID: "..user_id..")")
        ATM.users[ATM.rusers[user_id]] = nil
        ATM.rusers[user_id] = nil
        ATM.user_tables[user_id] = nil
        ATM.user_tmp_tables[user_id] = nil
        ATM.user_sources[user_id] = nil
        print('[ATM] Saved data for: ' .. GetPlayerName(source) .. " (Perm ID: "..user_id..")")
    else 
        print('[ATM] SEVERE ERROR: Failed to save data for: ' .. GetPlayerName(source) .. ' (NIL ID)')
    end
    ATMclient.removePlayer(-1,{source})
end)

RegisterServerEvent("ATMcli:playerSpawned")
AddEventHandler("ATMcli:playerSpawned", function()
    Debug.pbegin("playerSpawned")
    -- register user sources and then set first spawn to false
    local user_id = ATM.getUserId(source)
    local player = source
    if user_id ~= nil then
        ATM.user_sources[user_id] = source
        local tmp = ATM.getUserTmpTable(user_id)
        tmp.spawns = tmp.spawns+1
        local first_spawn = (tmp.spawns == 1)
        if first_spawn then
            for k,v in pairs(ATM.user_sources) do
                ATMclient.addPlayer(source,{v})
            end
            ATMclient.addPlayer(-1,{source})
        end
        TriggerEvent("ATM:playerSpawn",user_id,player,first_spawn)
    end
    Debug.pend()
end)

RegisterServerEvent("ATM:playerDied")
