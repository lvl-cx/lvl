MySQL = module("lvl_mysql", "MySQL")

local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")
local Lang = module("lib/Lang")
Debug = module("lib/Debug")

local config = module("cfg/base")
local log_config = module("servercfg/cfg_webhooks")
local version = module("version")

print("^5[LVL]: ^7" .. 'Checking for LVL Updates..')

PerformHttpRequest("https://raw.githubusercontent.com/DunkoUK/dunko_lvl/master/lvl/version.lua",function(err,text,headers)
if err == 200 then
    text = string.gsub(text,"return ","")
    local r_version = tonumber(text)
    if version ~= r_version then
        print("^5[LVL]: ^7" .. 'A Dunko Update is available from: https://github.com/DunkoUK/dunko_lvl')
    else 
        print("^5[LVL]: ^7" .. 'You are running the most up to date Dunko Version. Thanks for using Dunko_LVL and thanks to our contributors for updating the project. Support Found At: https://discord.gg/b8wQn2XqDt')
    end
else
    print("[LVL] unable to check the remote version")
end
end, "GET", "")


Debug.active = config.debug
LVL = {}
Proxy.addInterface("LVL",LVL)

tLVL = {}
Tunnel.bindInterface("LVL",tLVL) -- listening for client tunnel

-- load language 
local dict = module("cfg/lang/"..config.lang) or {}
LVL.lang = Lang.new(dict)

-- init
LVLclient = Tunnel.getInterface("LVL","LVL") -- server -> client tunnel

LVL.users = {} -- will store logged users (id) by first identifier
LVL.rusers = {} -- store the opposite of users
LVL.user_tables = {} -- user data tables (logger storage, saved to database)
LVL.user_tmp_tables = {} -- user tmp data tables (logger storage, not saved)
LVL.user_sources = {} -- user sources 
-- queries
Citizen.CreateThread(function()
    Wait(1000) -- Wait for GHMatti to Initialize
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS lvl_users(
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
    CREATE TABLE IF NOT EXISTS lvl_user_ids (
    identifier VARCHAR(100) NOT NULL,
    user_id INTEGER,
    banned BOOLEAN,
    CONSTRAINT pk_user_ids PRIMARY KEY(identifier)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS lvl_user_tokens (
    token VARCHAR(200),
    user_id INTEGER,
    banned BOOLEAN  NOT NULL DEFAULT 0,
    CONSTRAINT pk_user_tokens PRIMARY KEY(token)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS lvl_user_data(
    user_id INTEGER,
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_user_data PRIMARY KEY(user_id,dkey),
    CONSTRAINT fk_user_data_users FOREIGN KEY(user_id) REFERENCES lvl_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS lvl_srv_data(
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_srv_data PRIMARY KEY(dkey)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS lvl_user_moneys(
    user_id INTEGER,
    wallet INTEGER,
    bank INTEGER,
    CONSTRAINT pk_user_moneys PRIMARY KEY(user_id),
    CONSTRAINT fk_user_moneys_users FOREIGN KEY(user_id) REFERENCES lvl_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS lvl_user_business(
    user_id INTEGER,
    name VARCHAR(30),
    description TEXT,
    capital INTEGER,
    laundered INTEGER,
    reset_timestamp INTEGER,
    CONSTRAINT pk_user_business PRIMARY KEY(user_id),
    CONSTRAINT fk_user_business_users FOREIGN KEY(user_id) REFERENCES lvl_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS lvl_user_vehicles(
    user_id INTEGER,
    vehicle VARCHAR(100),
    vehicle_plate varchar(255) NOT NULL,
    rented BOOLEAN NOT NULL DEFAULT 0,
    rentedid varchar(200) NOT NULL DEFAULT '',
    rentedtime varchar(2048) NOT NULL DEFAULT '',
    CONSTRAINT pk_user_vehicles PRIMARY KEY(user_id,vehicle),
    CONSTRAINT fk_user_vehicles_users FOREIGN KEY(user_id) REFERENCES lvl_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS lvl_user_homes(
    user_id INTEGER,
    home VARCHAR(100),
    number INTEGER,
    CONSTRAINT pk_user_homes PRIMARY KEY(user_id),
    CONSTRAINT fk_user_homes_users FOREIGN KEY(user_id) REFERENCES lvl_users(id) ON DELETE CASCADE,
    UNIQUE(home,number)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS lvl_user_identities(
    user_id INTEGER,
    registration VARCHAR(100),
    phone VARCHAR(100),
    firstname VARCHAR(100),
    name VARCHAR(100),
    age INTEGER,
    CONSTRAINT pk_user_identities PRIMARY KEY(user_id),
    CONSTRAINT fk_user_identities_users FOREIGN KEY(user_id) REFERENCES lvl_users(id) ON DELETE CASCADE,
    INDEX(registration),
    INDEX(phone)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS lvl_warnings (
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
    MySQL.SingleQuery("ALTER TABLE lvl_users ADD IF NOT EXISTS bantime varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE lvl_users ADD IF NOT EXISTS banreason varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE lvl_users ADD IF NOT EXISTS banadmin varchar(100) NOT NULL DEFAULT ''; ")
    MySQL.SingleQuery("ALTER TABLE lvl_user_vehicles ADD IF NOT EXISTS rented BOOLEAN NOT NULL DEFAULT 0;")
    MySQL.SingleQuery("ALTER TABLE lvl_user_vehicles ADD IF NOT EXISTS rentedid varchar(200) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE lvl_user_vehicles ADD IF NOT EXISTS rentedtime varchar(2048) NOT NULL DEFAULT '';")
    MySQL.createCommand("LVLls/create_modifications_column", "alter table lvl_user_vehicles add if not exists modifications text not null")
	MySQL.createCommand("LVLls/update_vehicle_modifications", "update lvl_user_vehicles set modifications = @modifications where user_id = @user_id and vehicle = @vehicle")
	MySQL.createCommand("LVLls/get_vehicle_modifications", "select modifications from lvl_user_vehicles where user_id = @user_id and vehicle = @vehicle")
	MySQL.execute("LVLls/create_modifications_column")
    print("[LVL] init base tables")
end)






MySQL.createCommand("LVL/create_user","INSERT INTO lvl_users(whitelisted,banned) VALUES(false,false)")
MySQL.createCommand("LVL/add_identifier","INSERT INTO lvl_user_ids(identifier,user_id) VALUES(@identifier,@user_id)")
MySQL.createCommand("LVL/userid_byidentifier","SELECT user_id FROM lvl_user_ids WHERE identifier = @identifier")
MySQL.createCommand("LVL/identifier_all","SELECT * FROM lvl_user_ids WHERE identifier = @identifier")
MySQL.createCommand("LVL/select_identifier_byid_all","SELECT * FROM lvl_user_ids WHERE user_id = @id")

MySQL.createCommand("LVL/set_userdata","REPLACE INTO lvl_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
MySQL.createCommand("LVL/get_userdata","SELECT dvalue FROM lvl_user_data WHERE user_id = @user_id AND dkey = @key")

MySQL.createCommand("LVL/set_srvdata","REPLACE INTO lvl_srv_data(dkey,dvalue) VALUES(@key,@value)")
MySQL.createCommand("LVL/get_srvdata","SELECT dvalue FROM lvl_srv_data WHERE dkey = @key")

MySQL.createCommand("LVL/get_banned","SELECT banned FROM lvl_users WHERE id = @user_id")
MySQL.createCommand("LVL/set_banned","UPDATE lvl_users SET banned = @banned, bantime = @bantime,  banreason = @banreason,  banadmin = @banadmin WHERE id = @user_id")
MySQL.createCommand("LVL/set_identifierbanned","UPDATE lvl_user_ids SET banned = @banned WHERE identifier = @iden")
MySQL.createCommand("LVL/getbanreasontime", "SELECT * FROM lvl_users WHERE id = @user_id")

MySQL.createCommand("LVL/get_whitelisted","SELECT whitelisted FROM lvl_users WHERE id = @user_id")
MySQL.createCommand("LVL/set_whitelisted","UPDATE lvl_users SET whitelisted = @whitelisted WHERE id = @user_id")
MySQL.createCommand("LVL/set_last_login","UPDATE lvl_users SET last_login = @last_login WHERE id = @user_id")
MySQL.createCommand("LVL/get_last_login","SELECT last_login FROM lvl_users WHERE id = @user_id")

--Token Banning 
MySQL.createCommand("LVL/add_token","INSERT INTO lvl_user_tokens(token,user_id) VALUES(@token,@user_id)")
MySQL.createCommand("LVL/check_token","SELECT user_id, banned FROM lvl_user_tokens WHERE token = @token")
MySQL.createCommand("LVL/check_token_userid","SELECT token FROM lvl_user_tokens WHERE user_id = @id")
MySQL.createCommand("LVL/ban_token","UPDATE lvl_user_tokens SET banned = @banned WHERE token = @token")
--Token Banning

-- init tables


-- identification system

--- sql.
-- cbreturn user id or nil in case of error (if not found, will create it)
function LVL.getUserIdByIdentifiers(ids, cbr)
    local task = Task(cbr)
    
    if ids ~= nil and #ids then
        local i = 0
        
        -- search identifiers
        local function search()
            i = i+1
            if i <= #ids then
                if not config.ignore_ip_identifier or (string.find(ids[i], "ip:") == nil) then  -- ignore ip identifier
                    MySQL.query("LVL/userid_byidentifier", {identifier = ids[i]}, function(rows, affected)
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
                MySQL.query("LVL/create_user", {}, function(rows, affected)
                    if rows.affectedRows > 0 then
                        local user_id = rows.insertId
                        -- add identifiers
                        for l,w in pairs(ids) do
                            if not config.ignore_ip_identifier or (string.find(w, "ip:") == nil) then  -- ignore ip identifier
                                MySQL.execute("LVL/add_identifier", {user_id = user_id, identifier = w})
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

-- return identification string for the source (used for non LVL identifications, for rejected players)
function LVL.getSourceIdKey(source)
    local ids = GetPlayerIdentifiers(source)
    local idk = "idk_"
    for k,v in pairs(ids) do
        idk = idk..v
    end
    
    return idk
end

function LVL.getPlayerEndpoint(player)
    return GetPlayerEP(player) or "0.0.0.0"
end

function LVL.getPlayerName(player)
    return GetPlayerName(player) or "unknown"
end

--- sql

function LVL.ReLoadChar(source)
    local name = GetPlayerName(source)
    local ids = GetPlayerIdentifiers(source)
    LVL.getUserIdByIdentifiers(ids, function(user_id)
        if user_id ~= nil then  
            LVL.StoreTokens(source, user_id) 
            if LVL.rusers[user_id] == nil then -- not present on the server, init
                LVL.users[ids[1]] = user_id
                LVL.rusers[user_id] = ids[1]
                LVL.user_tables[user_id] = {}
                LVL.user_tmp_tables[user_id] = {}
                LVL.user_sources[user_id] = source
                LVL.getUData(user_id, "LVL:datatable", function(sdata)
                    local data = json.decode(sdata)
                    if type(data) == "table" then LVL.user_tables[user_id] = data end
                    local tmpdata = LVL.getUserTmpTable(user_id)
                    LVL.getLastLogin(user_id, function(last_login)
                        tmpdata.last_login = last_login or ""
                        tmpdata.spawns = 0
                        local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                        MySQL.execute("LVL/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                        print("[LVL] "..name.." joined (Perm ID: "..user_id..")")
                        TriggerEvent("LVL:playerJoin", user_id, source, name, tmpdata.last_login)
                        TriggerClientEvent("LVL:CheckIdRegister", source)
                    end)
                end)
            else -- already connected
                print("[LVL] "..name.." re-joined (Perm ID: "..user_id..")")
                TriggerEvent("LVL:playerRejoin", user_id, source, name)
                TriggerClientEvent("LVL:CheckIdRegister", source)
                local tmpdata = LVL.getUserTmpTable(user_id)
                tmpdata.spawns = 0
            end
        end
    end)
end
RegisterCommand("getmyid", function(source)
    TriggerClientEvent('chatMessage', source, "[Server]", {255, 255, 255}, " Perm ID: " .. LVL.getUserId(source) , "alert")
end)

-- This can only be used server side and is for the LVL bot. 
exports("lvlbot", function(method_name, params, cb)
    if cb then 
        cb(LVL[method_name](table.unpack(params)))
    else 
        return LVL[method_name](table.unpack(params))
    end
end)

RegisterNetEvent("LVL:CheckID")
AddEventHandler("LVL:CheckID", function()
    local user_id = LVL.getUserId(source)
    if not user_id then
        LVL.ReLoadChar(source)
    end
end)

function LVL.isBanned(user_id, cbr)
    local task = Task(cbr, {false})
    
    MySQL.query("LVL/get_banned", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].banned})
        else
            task()
        end
    end)
end

--- sql

--- sql
function LVL.isWhitelisted(user_id, cbr)
    local task = Task(cbr, {false})
    
    MySQL.query("LVL/get_whitelisted", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].whitelisted})
        else
            task()
        end
    end)
end

--- sql
function LVL.setWhitelisted(user_id,whitelisted)
    MySQL.execute("LVL/set_whitelisted", {user_id = user_id, whitelisted = whitelisted})
end

--- sql
function LVL.getLastLogin(user_id, cbr)
    local task = Task(cbr,{""})
    MySQL.query("LVL/get_last_login", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].last_login})
        else
            task()
        end
    end)
end

function LVL.fetchBanReasonTime(user_id,cbr)
    MySQL.query("LVL/getbanreasontime", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then 
            cbr(rows[1].bantime, rows[1].banreason, rows[1].banadmin)
        end
    end)
end

function LVL.setUData(user_id,key,value)
    MySQL.execute("LVL/set_userdata", {user_id = user_id, key = key, value = value})
end

function LVL.getUData(user_id,key,cbr)
    local task = Task(cbr,{""})
    
    MySQL.query("LVL/get_userdata", {user_id = user_id, key = key}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

function LVL.setSData(key,value)
    MySQL.execute("LVL/set_srvdata", {key = key, value = value})
end

function LVL.getSData(key, cbr)
    local task = Task(cbr,{""})
    
    MySQL.query("LVL/get_srvdata", {key = key}, function(rows, affected)
        if rows and #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

-- return user data table for LVL internal persistant connected user storage
function LVL.getUserDataTable(user_id)
    return LVL.user_tables[user_id]
end

function LVL.getUserTmpTable(user_id)
    return LVL.user_tmp_tables[user_id]
end

function LVL.isConnected(user_id)
    return LVL.rusers[user_id] ~= nil
end

function LVL.isFirstSpawn(user_id)
    local tmp = LVL.getUserTmpTable(user_id)
    return tmp and tmp.spawns == 1
end

function LVL.getUserId(source)
    if source ~= nil then
        local ids = GetPlayerIdentifiers(source)
        if ids ~= nil and #ids > 0 then
            return LVL.users[ids[1]]
        end
    end
    
    return nil
end

-- return map of user_id -> player source
function LVL.getUsers()
    local users = {}
    for k,v in pairs(LVL.user_sources) do
        users[k] = v
    end
    
    return users
end

-- return source or nil
function LVL.getUserSource(user_id)
    return LVL.user_sources[user_id]
end

function LVL.IdentifierBanCheck(source,user_id,cb)
    for i,v in pairs(GetPlayerIdentifiers(source)) do 
        MySQL.query('LVL/identifier_all', {identifier = v}, function(rows)
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

function LVL.BanIdentifiers(user_id, value)
    MySQL.query('LVL/select_identifier_byid_all', {id = user_id}, function(rows)
        for i = 1, #rows do 
            MySQL.execute("LVL/set_identifierbanned", {banned = value, iden = rows[i].identifier })
        end
    end)
end

function LVL.setBanned(user_id,banned,time,reason, admin)
    if banned then
        webhook = log_config.banlog
        if webhook ~= nil then
            if webhook ~= 'none' then
                PerformHttpRequest(webhook, function(err, text, headers) end, "POST", json.encode({username = "Dunko LVL Logs", embeds = {{["color"] = "15158332", ["title"] = 'Someone Has Been Banned', ["description"] = 'Players Perm-ID: **' .. user_id .. '**\nReason Player Was Banned: **' .. reason .. '**\nBanning Admin: **' ..admin .. '**', ["footer"] = {["text"] = "Time - "..os.date("%x %X %p"),}}}}), { ["Content-Type"] = "application/json" })
            end
        end
        MySQL.execute("LVL/set_banned", {user_id = user_id, banned = banned, bantime = time, banreason = reason, banadmin = admin})
        LVL.BanIdentifiers(user_id, true)
        LVL.BanTokens(user_id, true) 
    else
        webhook = log_config.unbanlog
        if webhook ~= nil then
            if webhook ~= 'none' then
                PerformHttpRequest(webhook, function(err, text, headers) end, "POST", json.encode({username = "Dunko LVL Logs", embeds = {{["color"] = "15158332", ["title"] = 'Someone Has Been Unbanned', ["description"] = 'Players Perm-ID: **' .. user_id .. '**', ["footer"] = {["text"] = "Time - "..os.date("%x %X %p"),}}}}), { ["Content-Type"] = "application/json" })
            end
        end
        MySQL.execute("LVL/set_banned", {user_id = user_id, banned = banned, bantime = "", banreason =  "", banadmin =  ""})
        LVL.BanIdentifiers(user_id, false)
        LVL.BanTokens(user_id, false) 
    end 
end

function LVL.ban(adminsource,permid,time,reason)
    local adminPermID = LVL.getUserId(adminsource)
    local getBannedPlayerSrc = LVL.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            LVL.setBanned(permid,true,banTime,reason, GetPlayerName(adminsource) .. " | ID Of Admin: " .. adminPermID)
            LVL.kick(getBannedPlayerSrc,"You have been banned from this server. Your ban expires in: " .. os.date("%c", banTime) .. " Reason: " .. reason .. " | Banning Admin: " ..  GetPlayerName(adminsource) .. " | ID Of Admin: " .. adminPermID ) 
            LVLclient.notify(adminsource,{"~g~Successfully banned Perm ID:" .. permid})
        else 
            LVLclient.notify(adminsource,{"~g~Successfully banned Perm ID:" .. permid})
            LVL.setBanned(permid,true,"perm",reason, GetPlayerName(adminsource) .. " | ID Of Admin: " .. adminPermID)
            LVL.kick(getBannedPlayerSrc,"You have been banned from this server. Your ban expires in: " .. "Never, you've been permanently banned." .. " Reason: " .. reason .. " | Banning Admin: " ..  GetPlayerName(adminsource) .. " | ID Of Admin: " .. adminPermID ) 
        end
    else 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            LVLclient.notify(adminsource,{"~g~Successfully banned Perm ID:" .. permid})
            LVL.setBanned(permid,true,banTime,reason, GetPlayerName(adminsource) .. " | ID Of Admin: " .. adminPermID)
        else 
            LVLclient.notify(adminsource,{"~g~Successfully banned Perm ID:" .. permid})
            LVL.setBanned(permid,true,"perm",reason, GetPlayerName(adminsource) .. " | ID Of Admin: " .. adminPermID)
        end
    end
end

function LVL.banConsole(permid,time,reason)
    local adminPermID = "Console Ban"
    local getBannedPlayerSrc = LVL.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            LVL.setBanned(permid,true,banTime,reason,  'Console' .. " | ID Of Admin: " .. adminPermID)
            LVL.kick(getBannedPlayerSrc,"You have been banned from this server. Your ban expires in: " .. os.date("%c", banTime) .. " Reason: " .. reason .. " | BanningAdmin: " ..  'Console' .. " | ID Of Admin: " .. adminPermID ) 
            print("~g~Successfully banned Perm ID:" .. permid)
        else 
            print("~g~Successfully banned Perm ID:" .. permid)
            LVL.setBanned(permid,true,"perm",reason,  'Console' .. " | ID Of Admin: " .. adminPermID)
            LVL.kick(getBannedPlayerSrc,"You have been banned from this server. Your ban expires in: " .. "Never, you've been permanently banned." .. " Reason: " .. reason .. " | BanningAdmin: " ..  'Console' .. " | ID Of Admin: " .. adminPermID ) 
        end
    else 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            print("~g~Successfully banned Perm ID:" .. permid)
            LVL.setBanned(permid,true,banTime,reason, 'Console' .. " | ID Of Admin: " .. adminPermID)
        else 
            print("~g~Successfully banned Perm ID:" .. permid)
            LVL.setBanned(permid,true,"perm",reason, 'Console' .. " | ID Of Admin: " .. adminPermID)
        end
    end
end

-- To use token banning you need the latest artifacts.
function LVL.StoreTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            MySQL.query("LVL/check_token", {token = token}, function(rows)
                if token and rows and #rows <= 0 then 
                    MySQL.execute("LVL/add_token", {token = token, user_id = user_id})
                end        
            end)
        end
    end
end


function LVL.CheckTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local banned = false;
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            local rows = MySQL.asyncQuery("LVL/check_token", {token = token, user_id = user_id})
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

function LVL.BanTokens(user_id, banned) 
    if GetNumPlayerTokens then 
        MySQL.query("LVL/check_token_userid", {id = user_id}, function(id)
            for i = 1, #id do 
                MySQL.execute("LVL/ban_token", {token = id[i].token, banned = banned})
            end
        end)
    end
end


function LVL.kick(source,reason)
    webhook = log_config.kicklog
    local user_id = LVL.getUserId(source)
    local playername = GetPlayerName(source)
    if webhook ~= nil then
        if webhook ~= 'none' then
            PerformHttpRequest(webhook, function(err, text, headers) end, "POST", json.encode({username = "Dunko LVL Logs", embeds = {{["color"] = "15158332", ["title"] = playername .. ' Has Been Kicked', ["description"] = 'Players Perm-ID: **' .. user_id .. '**\nReason Player Was Kicked: **' .. reason .. '**', ["footer"] = {["text"] = "Time - "..os.date("%x %X %p"),}}}}), { ["Content-Type"] = "application/json" })
        end
    end
    DropPlayer(source,reason)
end

-- tasks

function task_save_datatables()
    TriggerEvent("LVL:save")
    
    Debug.pbegin("LVL save datatables")
    for k,v in pairs(LVL.user_tables) do
        LVL.setUData(k,"LVL:datatable",json.encode(v))
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
        deferrals.update("[LVL] Checking identifiers...")
        LVL.getUserIdByIdentifiers(ids, function(user_id)
            LVL.IdentifierBanCheck(source, user_id, function(status, id)
                if status then
                    print("[LVL] User rejected for attempting to evade. Perm ID: " .. user_id .. " | (Ignore joined message, they were rejected)") 
                    deferrals.done("[LVL]: You are banned from this server, please do not try to evade your ban. If you believe this was an error quote your Perm ID which is: " .. id)
                    return 
                end
            end)
            -- if user_id ~= nil and LVL.rusers[user_id] == nil then -- check user validity and if not already connected (old way, disabled until playerDropped is sure to be called)
            if user_id ~= nil then -- check user validity 
                deferrals.update("[LVL] Fetching Tokens...")
                LVL.StoreTokens(source, user_id) 
                deferrals.update("[LVL] Checking banned...")
                LVL.isBanned(user_id, function(banned)
                    if not banned then
                        deferrals.update("[LVL] Checking whitelisted...")
                        LVL.isWhitelisted(user_id, function(whitelisted)
                            if not config.whitelist or whitelisted then
                                Debug.pbegin("playerConnecting_delayed")
                                if LVL.rusers[user_id] == nil then -- not present on the server, init
                                    if LVL.CheckTokens(source, user_id) then 
                                        deferrals.done("[LVL]: You are banned from this server, please do not try to evade your ban.")
                                    end
                                    LVL.users[ids[1]] = user_id
                                    LVL.rusers[user_id] = ids[1]
                                    LVL.user_tables[user_id] = {}
                                    LVL.user_tmp_tables[user_id] = {}
                                    LVL.user_sources[user_id] = source
                                    
                                    -- load user data table
                                    deferrals.update("[LVL] Loading datatable...")
                                    LVL.getUData(user_id, "LVL:datatable", function(sdata)
                                        local data = json.decode(sdata)
                                        if type(data) == "table" then LVL.user_tables[user_id] = data end
                                        
                                        -- init user tmp table
                                        local tmpdata = LVL.getUserTmpTable(user_id)
                                        
                                        deferrals.update("[LVL] Getting last login...")
                                        LVL.getLastLogin(user_id, function(last_login)
                                            tmpdata.last_login = last_login or ""
                                            tmpdata.spawns = 0
                                            
                                            -- set last login
                                            local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                            MySQL.execute("LVL/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                            
                                            -- trigger join
                                            print("[LVL] "..name.." joined (Perm ID: "..user_id..")")
                                            TriggerEvent("LVL:playerJoin", user_id, source, name, tmpdata.last_login)
                                            deferrals.done()
                                        end)
                                    end)
                                else -- already connected
                                    if LVL.CheckTokens(source, user_id) then 
                                        deferrals.done("[LVL]: You are banned from this server, please do not try to evade your ban.")
                                    end
                                    print("[LVL] "..name.." re-joined (Perm ID: "..user_id..")")
                                    TriggerEvent("LVL:playerRejoin", user_id, source, name)
                                    deferrals.done()
                                    
                                    -- reset first spawn
                                    local tmpdata = LVL.getUserTmpTable(user_id)
                                    tmpdata.spawns = 0
                                end
                                
                                Debug.pend()
                            else
                                print("[LVL] "..name.." rejected: not whitelisted (Perm ID: "..user_id..")")
                                deferrals.done("[LVL] Not whitelisted (Perm ID: "..user_id..").")
                            end
                        end)
                    else
                        deferrals.update("[LVL] Fetching Tokens...")
                        LVL.StoreTokens(source, user_id) 
                        LVL.fetchBanReasonTime(user_id,function(bantime, banreason, banadmin)
                            if tonumber(bantime) then 
                                local timern = os.time()
                                if timern > tonumber(bantime) then 
                                    deferrals.update('Your ban has expired. Please do not violate this server\'s rules again. You will now be automatically connected!')
                                    Wait(2000)
                                    LVL.setBanned(user_id,false)
                                    if LVL.rusers[user_id] == nil then -- not present on the server, init
                                        -- init entries
                                        LVL.users[ids[1]] = user_id
                                        LVL.rusers[user_id] = ids[1]
                                        LVL.user_tables[user_id] = {}
                                        LVL.user_tmp_tables[user_id] = {}
                                        LVL.user_sources[user_id] = source
                                        
                                        -- load user data table
                                        deferrals.update("[LVL] Loading datatable...")
                                        LVL.getUData(user_id, "LVL:datatable", function(sdata)
                                            local data = json.decode(sdata)
                                            if type(data) == "table" then LVL.user_tables[user_id] = data end
                                            
                                            -- init user tmp table
                                            local tmpdata = LVL.getUserTmpTable(user_id)
                                            
                                            deferrals.update("[LVL] Getting last login...")
                                            LVL.getLastLogin(user_id, function(last_login)
                                                tmpdata.last_login = last_login or ""
                                                tmpdata.spawns = 0
                                                
                                                -- set last login
                                                local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                                MySQL.execute("LVL/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                
                                                -- trigger join
                                                print("[LVL] "..name.." joined after his ban expired. (Perm ID: "..user_id..")")
                                                TriggerEvent("LVL:playerJoin", user_id, source, name, tmpdata.last_login)
                                                deferrals.done()
                                            end)
                                        end)
                                    else -- already connected
                                        print("[LVL] "..name.." re-joined after his ban expired. (Perm ID: "..user_id..")")
                                        TriggerEvent("LVL:playerRejoin", user_id, source, name)
                                        deferrals.done()
                                        
                                        -- reset first spawn
                                        local tmpdata = LVL.getUserTmpTable(user_id)
                                        tmpdata.spawns = 0
                                    end
                                    return 
                                end
                                print("[LVL] "..name.." rejected: banned (Perm ID: "..user_id..")")
                                deferrals.done("[LVL] You have been banned from this server.\nYour ban will expire on the: " .. os.date("%c", bantime) .. "\nReason: " .. banreason .. "\n\nBanning Admin: " .. banadmin)
                            else 
                                print("[LVL] "..name.." rejected: banned (Perm ID: "..user_id..")")
                                deferrals.done("[LVL] You have been banned from this server.\nYour ban will expire: Never, you have been permanently banned \nReason: " .. banreason .. "\n\nBanning Admin: " .. banadmin)
                            end
                        end)
                    end
                end)
            else
                print("[LVL] "..name.." rejected: identification error")
                deferrals.done("[LVL] Identification error.")
            end
        end)
    else
        print("[LVL] "..name.." rejected: missing identifiers")
        deferrals.done("[LVL] Missing identifiers.")
    end
    Debug.pend()
end)

AddEventHandler("playerDropped",function(reason)
    local source = source
    local user_id = LVL.getUserId(source)
    local playername = GetPlayerName(source)
    webhook = log_config.leavelog
    if webhook ~= nil then
        if webhook ~= 'none' then
            PerformHttpRequest(webhook, function(err, text, headers) end, "POST", json.encode({username = "Dunko LVL Logs", embeds = {{["color"] = "15158332", ["title"] = playername .. ' Has Left The Server', ["description"] = 'His Perm-ID: **' .. user_id .. '\n** His Source Id: **' .. source .. '**', ["footer"] = {["text"] = "Time - "..os.date("%x %X %p"),}}}}), { ["Content-Type"] = "application/json" })
        end
    end
    if user_id ~= nil then
        TriggerEvent("LVL:playerLeave", user_id, source)
        
        -- save user data table
        LVL.setUData(user_id,"LVL:datatable",json.encode(LVL.getUserDataTable(user_id)))
        
        print("[LVL] "..GetPlayerName(source).." disconnected (Perm ID: "..user_id..")")
        LVL.users[LVL.rusers[user_id]] = nil
        LVL.rusers[user_id] = nil
        LVL.user_tables[user_id] = nil
        LVL.user_tmp_tables[user_id] = nil
        LVL.user_sources[user_id] = nil
        print('[LVL] Saved data for: ' .. GetPlayerName(source) .. " (Perm ID: "..user_id..")")
    else 
        print('[LVL] SEVERE ERROR: Failed to save data for: ' .. GetPlayerName(source) .. ' (NIL ID)')
    end
    LVLclient.removePlayer(-1,{source})
end)

RegisterServerEvent("LVLcli:playerSpawned")
AddEventHandler("LVLcli:playerSpawned", function()
    Debug.pbegin("playerSpawned")
    -- register user sources and then set first spawn to false
    local user_id = LVL.getUserId(source)
    local player = source
    if user_id ~= nil then
        LVL.user_sources[user_id] = source
        local tmp = LVL.getUserTmpTable(user_id)
        tmp.spawns = tmp.spawns+1
        local first_spawn = (tmp.spawns == 1)
        if first_spawn then
            for k,v in pairs(LVL.user_sources) do
                LVLclient.addPlayer(source,{v})
            end
            LVLclient.addPlayer(-1,{source})
        end
        TriggerEvent("LVL:playerSpawn",user_id,player,first_spawn)
    end
    Debug.pend()
end)

RegisterServerEvent("LVL:playerDied")
