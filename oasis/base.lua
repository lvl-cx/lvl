MySQL = module("modules/MySQL")

Proxy = module("lib/Proxy")
Tunnel = module("lib/Tunnel")
Lang = module("lib/Lang")
Debug = module("lib/Debug")

local config = module("cfg/base")
local version = module("version")


local verify_card = {
    ["type"] = "AdaptiveCard",
    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
    ["version"] = "1.3",
    ["backgroundImage"] = {
        ["url"] = "https://cdn.discordapp.com/attachments/925933277854961684/1004861451099451463/bg.jpg?size=4096",
    },
    ["body"] = {
        {
            ["type"] = "TextBlock",
            ["text"] = "Welcome to OASIS, to join our server please verify your discord account by following the steps below.",
            ["wrap"] = true,
            ["weight"] = "Bolder"
        },
        {
            ["type"] = "Container",
            ["items"] = {
                {
                    ["type"] = "TextBlock",
                    ["text"] = "1. Join the OASIS discord (discord.gg/oasisv)",
                    ["wrap"] = true,
                },
                {
                    ["type"] = "TextBlock",
                    ["text"] = "2. Type the following command",
                    ["wrap"] = true,
                },
                {
                    ["type"] = "TextBlock",
                    ["color"] = "Attention",
                    ["text"] = "3. !verify NULL",
                    ["wrap"] = true,
                }
            }
        },
        {
            ["type"] = "ActionSet",
            ["actions"] = {
                {
                    ["type"] = "Action.OpenUrl",
                    ["title"] = "Join Discord",
                    ["url"] = "https://discord.gg/oasisv"
                }
            }
        },
    }
}

Debug.active = config.debug
OASIS = {}
Proxy.addInterface("OASIS",OASIS)

tOASIS = {}
Tunnel.bindInterface("OASIS",tOASIS) -- listening for client tunnel

-- load language 
local dict = module("cfg/lang/"..config.lang) or {}
OASIS.lang = Lang.new(dict)

-- init
OASISclient = Tunnel.getInterface("OASIS","OASIS") -- server -> client tunnel

OASIS.users = {} -- will store logged users (id) by first identifier
OASIS.rusers = {} -- store the opposite of users
OASIS.user_tables = {} -- user data tables (logger storage, saved to database)
OASIS.user_tmp_tables = {} -- user tmp data tables (logger storage, not saved)
OASIS.user_sources = {} -- user sources 
-- queries
Citizen.CreateThread(function()
    Wait(1000) -- Wait for GHMatti to Initialize
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_users(
    id INTEGER AUTO_INCREMENT,
    last_login VARCHAR(100),
    username VARCHAR(100),
    whitelisted BOOLEAN,
    banned BOOLEAN,
    bantime VARCHAR(100) NOT NULL DEFAULT "",
    banreason VARCHAR(1000) NOT NULL DEFAULT "",
    banadmin VARCHAR(100) NOT NULL DEFAULT "",
    baninfo VARCHAR(2000) NOT NULL DEFAULT "",
    CONSTRAINT pk_user PRIMARY KEY(id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_user_ids (
    identifier VARCHAR(100) NOT NULL,
    user_id INTEGER,
    banned BOOLEAN,
    CONSTRAINT pk_user_ids PRIMARY KEY(identifier)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_user_tokens (
    token VARCHAR(200),
    user_id INTEGER,
    banned BOOLEAN  NOT NULL DEFAULT 0,
    CONSTRAINT pk_user_tokens PRIMARY KEY(token)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_user_data(
    user_id INTEGER,
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_user_data PRIMARY KEY(user_id,dkey),
    CONSTRAINT fk_user_data_users FOREIGN KEY(user_id) REFERENCES oasis_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_user_moneys(
    user_id INTEGER,
    wallet bigint,
    bank bigint,
    CONSTRAINT pk_user_moneys PRIMARY KEY(user_id),
    CONSTRAINT fk_user_moneys_users FOREIGN KEY(user_id) REFERENCES oasis_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_srv_data(
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_srv_data PRIMARY KEY(dkey)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_user_vehicles(
    user_id INTEGER,
    vehicle VARCHAR(100),
    vehicle_plate varchar(255) NOT NULL,
    rented BOOLEAN NOT NULL DEFAULT 0,
    rentedid varchar(200) NOT NULL DEFAULT '',
    rentedtime varchar(2048) NOT NULL DEFAULT '',
    locked BOOLEAN NOT NULL DEFAULT 0,
    fuel_level FLOAT NOT NULL DEFAULT 100,
    impounded BOOLEAN NOT NULL DEFAULT 0,
    impound_info varchar(2048) NOT NULL DEFAULT '',
    impound_time VARCHAR(100) NOT NULL DEFAULT '',
    CONSTRAINT pk_user_vehicles PRIMARY KEY(user_id,vehicle),
    CONSTRAINT fk_user_vehicles_users FOREIGN KEY(user_id) REFERENCES oasis_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_user_identities(
    user_id INTEGER,
    registration VARCHAR(100),
    phone VARCHAR(100),
    firstname VARCHAR(100),
    name VARCHAR(100),
    age INTEGER,
    CONSTRAINT pk_user_identities PRIMARY KEY(user_id),
    CONSTRAINT fk_user_identities_users FOREIGN KEY(user_id) REFERENCES oasis_users(id) ON DELETE CASCADE,
    INDEX(registration),
    INDEX(phone)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_warnings (
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
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_gangs (
    gangname VARCHAR(255) NULL DEFAULT NULL,
    gangmembers VARCHAR(3000) NULL DEFAULT NULL,
    funds BIGINT NULL DEFAULT NULL,
    logs VARCHAR(3000) NULL DEFAULT NULL,
    PRIMARY KEY (gangname)
    )
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_user_notes (
    user_id INT,
    info VARCHAR(500) NULL DEFAULT NULL,
    PRIMARY KEY (user_id)
    )
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_user_homes(
    user_id INTEGER,
    home VARCHAR(100),
    number INTEGER,
    rented BOOLEAN NOT NULL DEFAULT 0,
    rentedid varchar(200) NOT NULL DEFAULT '',
    rentedtime varchar(2048) NOT NULL DEFAULT '',
    CONSTRAINT pk_user_homes PRIMARY KEY(home),
    CONSTRAINT fk_user_homes_users FOREIGN KEY(user_id) REFERENCES oasis_users(id) ON DELETE CASCADE,
    UNIQUE(home,number)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_bans_offenses(
    UserID INTEGER AUTO_INCREMENT,
    Rules TEXT NULL DEFAULT NULL,
    points INT(10) NOT NULL DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY(UserID)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_dvsa(
    user_id INT(11),
    licence VARCHAR(100) NULL DEFAULT NULL,
    testsaves VARCHAR(1000) NULL DEFAULT NULL,
    points VARCHAR(500) NULL DEFAULT NULL,
    id VARCHAR(500) NULL DEFAULT NULL,
    datelicence VARCHAR(500) NULL DEFAULT NULL,
    penalties VARCHAR(500) NULL DEFAULT NULL,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_subscriptions(
    user_id INT(11),
    plathours FLOAT(10) NULL DEFAULT NULL,
    plushours FLOAT(10) NULL DEFAULT NULL,
    last_used VARCHAR(100) NOT NULL DEFAULT "",
    CONSTRAINT pk_user PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_casino_chips(
    user_id INT(11),
    chips bigint NOT NULL DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_verification(
    user_id INT(11),
    code VARCHAR(100) NULL DEFAULT NULL,
    discord_id VARCHAR(100) NULL DEFAULT NULL,
    verified TINYINT NULL DEFAULT NULL,
    CONSTRAINT pk_user PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_users_contacts (
    id int(11) NOT NULL AUTO_INCREMENT,
    identifier varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
    number varchar(10) CHARACTER SET utf8mb4 DEFAULT NULL,
    display varchar(64) CHARACTER SET utf8mb4 NOT NULL DEFAULT '-1',
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_messages (
    id int(11) NOT NULL AUTO_INCREMENT,
    transmitter varchar(10) NOT NULL,
    receiver varchar(10) NOT NULL,
    message varchar(255) NOT NULL DEFAULT '0',
    time timestamp NOT NULL DEFAULT current_timestamp(),
    isRead int(11) NOT NULL DEFAULT 0,
    owner int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_calls (
    id int(11) NOT NULL AUTO_INCREMENT,
    owner varchar(10) NOT NULL COMMENT 'Num such owner',
    num varchar(10) NOT NULL COMMENT 'Reference number of the contact',
    incoming int(11) NOT NULL COMMENT 'Defined if we are at the origin of the calls',
    time timestamp NOT NULL DEFAULT current_timestamp(),
    accepts int(11) NOT NULL COMMENT 'Calls accept or not',
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_app_chat (
    id int(11) NOT NULL AUTO_INCREMENT,
    channel varchar(20) NOT NULL,
    message varchar(255) NOT NULL,
    time timestamp NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS twitter_tweets (
    id int(11) NOT NULL AUTO_INCREMENT,
    authorId int(11) NOT NULL,
    realUser varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    message varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
    time timestamp NOT NULL DEFAULT current_timestamp(),
    likes int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    KEY FK_twitter_tweets_twitter_accounts (authorId),
    CONSTRAINT FK_twitter_tweets_twitter_accounts FOREIGN KEY (authorId) REFERENCES twitter_accounts (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS twitter_likes (
    id int(11) NOT NULL AUTO_INCREMENT,
    authorId int(11) DEFAULT NULL,
    tweetId int(11) DEFAULT NULL,
    PRIMARY KEY (id),
    KEY FK_twitter_likes_twitter_accounts (authorId),
    KEY FK_twitter_likes_twitter_tweets (tweetId),
    CONSTRAINT FK_twitter_likes_twitter_accounts FOREIGN KEY (authorId) REFERENCES twitter_accounts (id),
    CONSTRAINT FK_twitter_likes_twitter_tweets FOREIGN KEY (tweetId) REFERENCES twitter_tweets (id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS twitter_accounts (
    id int(11) NOT NULL AUTO_INCREMENT,
    username varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '0',
    password varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
    avatar_url varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY username (username)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_community_pot (
    oasis VARCHAR(65) NOT NULL,
    value BIGINT(11) NOT NULL,
    PRIMARY KEY (oasis)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_quests (
    user_id INT(11),
    quests_completed INT(11) NOT NULL DEFAULT 0,
    reward_claimed BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_weapon_whitelists (
    user_id INT(11),
    weapon_info varchar(2048) DEFAULT '{}',
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_weapon_codes (
    user_id INT(11),
    spawncode varchar(2048) NOT NULL DEFAULT '',
    weapon_code int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (weapon_code)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_prison (
    user_id INT(11),
    prison_time INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_staff_tickets (
    user_id INT(11),
    ticket_count INT(11) NOT NULL DEFAULT 0,
    username VARCHAR(100) NOT NULL,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_daily_rewards (
    user_id INT(11),
    last_reward INT(11) NOT NULL DEFAULT 0,
    streak INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS oasis_police_hours (
    user_id INT(11),
    weekly_hours FLOAT(10) NOT NULL DEFAULT 0,
    total_hours FLOAT(10) NOT NULL DEFAULT 0,
    username VARCHAR(100) NOT NULL,
    last_clocked_date VARCHAR(100) NOT NULL,
    last_clocked_rank VARCHAR(100) NOT NULL,
    total_players_fined INT(11) NOT NULL DEFAULT 0,
    total_players_jailed INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery("ALTER TABLE oasis_users ADD IF NOT EXISTS bantime varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE oasis_users ADD IF NOT EXISTS banreason varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE oasis_users ADD IF NOT EXISTS banadmin varchar(100) NOT NULL DEFAULT ''; ")
    MySQL.SingleQuery("ALTER TABLE oasis_user_vehicles ADD IF NOT EXISTS rented BOOLEAN NOT NULL DEFAULT 0;")
    MySQL.SingleQuery("ALTER TABLE oasis_user_vehicles ADD IF NOT EXISTS rentedid varchar(200) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE oasis_user_vehicles ADD IF NOT EXISTS rentedtime varchar(2048) NOT NULL DEFAULT '';")
    MySQL.createCommand("OASISls/create_modifications_column", "alter table oasis_user_vehicles add if not exists modifications text not null")
	MySQL.createCommand("OASISls/update_vehicle_modifications", "update oasis_user_vehicles set modifications = @modifications where user_id = @user_id and vehicle = @vehicle")
	MySQL.createCommand("OASISls/get_vehicle_modifications", "select modifications, vehicle_plate from oasis_user_vehicles where user_id = @user_id and vehicle = @vehicle")
	MySQL.execute("OASISls/create_modifications_column")
    print("[OASIS] ^2Base tables initialised.^0")
end)

MySQL.createCommand("OASIS/create_user","INSERT INTO oasis_users(whitelisted,banned) VALUES(false,false)")
MySQL.createCommand("OASIS/add_identifier","INSERT INTO oasis_user_ids(identifier,user_id) VALUES(@identifier,@user_id)")
MySQL.createCommand("OASIS/userid_byidentifier","SELECT user_id FROM oasis_user_ids WHERE identifier = @identifier")
MySQL.createCommand("OASIS/identifier_all","SELECT * FROM oasis_user_ids WHERE identifier = @identifier")
MySQL.createCommand("OASIS/select_identifier_byid_all","SELECT * FROM oasis_user_ids WHERE user_id = @id")

MySQL.createCommand("OASIS/set_userdata","REPLACE INTO oasis_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
MySQL.createCommand("OASIS/get_userdata","SELECT dvalue FROM oasis_user_data WHERE user_id = @user_id AND dkey = @key")

MySQL.createCommand("OASIS/set_srvdata","REPLACE INTO OASIS_srv_data(dkey,dvalue) VALUES(@key,@value)")
MySQL.createCommand("OASIS/get_srvdata","SELECT dvalue FROM OASIS_srv_data WHERE dkey = @key")

MySQL.createCommand("OASIS/get_banned","SELECT banned FROM oasis_users WHERE id = @user_id")
MySQL.createCommand("OASIS/set_banned","UPDATE oasis_users SET banned = @banned, bantime = @bantime,  banreason = @banreason,  banadmin = @banadmin, baninfo = @baninfo WHERE id = @user_id")
MySQL.createCommand("OASIS/set_identifierbanned","UPDATE oasis_user_ids SET banned = @banned WHERE identifier = @iden")
MySQL.createCommand("OASIS/getbanreasontime", "SELECT * FROM oasis_users WHERE id = @user_id")

MySQL.createCommand("OASIS/get_whitelisted","SELECT whitelisted FROM oasis_users WHERE id = @user_id")
MySQL.createCommand("OASIS/set_whitelisted","UPDATE oasis_users SET whitelisted = @whitelisted WHERE id = @user_id")
MySQL.createCommand("OASIS/set_last_login","UPDATE oasis_users SET last_login = @last_login WHERE id = @user_id")
MySQL.createCommand("OASIS/get_last_login","SELECT last_login FROM oasis_users WHERE id = @user_id")

--Token Banning 
MySQL.createCommand("OASIS/add_token","INSERT INTO oasis_user_tokens(token,user_id) VALUES(@token,@user_id)")
MySQL.createCommand("OASIS/check_token","SELECT user_id, banned FROM oasis_user_tokens WHERE token = @token")
MySQL.createCommand("OASIS/check_token_userid","SELECT token FROM oasis_user_tokens WHERE user_id = @id")
MySQL.createCommand("OASIS/ban_token","UPDATE oasis_user_tokens SET banned = @banned WHERE token = @token")
--Token Banning

-- removing anticheat ban entry
MySQL.createCommand("ac/delete_ban","DELETE FROM oasis_anticheat WHERE @user_id = user_id")


-- init tables


-- identification system

function OASIS.getUserIdByIdentifiers(ids, cbr)
    local task = Task(cbr)
    if ids ~= nil and #ids then
        local i = 0
        local function search()
            i = i+1
            if i <= #ids then
                if not config.ignore_ip_identifier or (string.find(ids[i], "ip:") == nil) then  -- ignore ip identifier
                    MySQL.query("OASIS/userid_byidentifier", {identifier = ids[i]}, function(rows, affected)
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
                MySQL.query("OASIS/create_user", {}, function(rows, affected)
                    if rows.affectedRows > 0 then
                        local user_id = rows.insertId
                        -- add identifiers
                        for l,w in pairs(ids) do
                            if not config.ignore_ip_identifier or (string.find(w, "ip:") == nil) then  -- ignore ip identifier
                                MySQL.execute("OASIS/add_identifier", {user_id = user_id, identifier = w})
                            end
                        end
                        for k,v in pairs(OASIS.getUsers()) do
                            OASISclient.notify(v, {'~g~You have received £10,000 as someone new has joined the server.'})
                            OASIS.giveBankMoney(k, 10000)
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

-- return identification string for the source (used for non OASIS identifications, for rejected players)
function OASIS.getSourceIdKey(source)
    local ids = GetPlayerIdentifiers(source)
    local idk = "idk_"
    for k,v in pairs(ids) do
        idk = idk..v
    end
    return idk
end

function OASIS.getPlayerIP(player)
    return GetPlayerEP(player) or "0.0.0.0"
end

function OASIS.getPlayerName(player)
    return GetPlayerName(player) or "unknown"
end

--- sql

function OASIS.ReLoadChar(source)
    local name = GetPlayerName(source)
    local ids = GetPlayerIdentifiers(source)
    OASIS.getUserIdByIdentifiers(ids, function(user_id)
        if user_id ~= nil then  
            OASIS.StoreTokens(source, user_id) 
            if OASIS.rusers[user_id] == nil then -- not present on the server, init
                OASIS.users[ids[1]] = user_id
                OASIS.rusers[user_id] = ids[1]
                OASIS.user_tables[user_id] = {}
                OASIS.user_tmp_tables[user_id] = {}
                OASIS.user_sources[user_id] = source
                OASIS.getUData(user_id, "OASIS:datatable", function(sdata)
                    local data = json.decode(sdata)
                    if type(data) == "table" then OASIS.user_tables[user_id] = data end
                    local tmpdata = OASIS.getUserTmpTable(user_id)
                    OASIS.getLastLogin(user_id, function(last_login)
                        tmpdata.last_login = last_login or ""
                        tmpdata.spawns = 0
                        local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                        MySQL.execute("OASIS/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                        print("[OASIS] "..name.." ("..GetPlayerName(source)..") joined (Perm ID = "..user_id..")")
                        TriggerEvent("OASIS:playerJoin", user_id, source, name, tmpdata.last_login)
                        TriggerClientEvent("OASIS:CheckIdRegister", source)
                    end)
                end)
            else -- already connected
                print("[OASIS] "..name.." ("..GetPlayerName(source)..") re-joined (Perm ID = "..user_id..")")
                TriggerEvent("OASIS:playerRejoin", user_id, source, name)
                TriggerClientEvent("OASIS:CheckIdRegister", source)
                local tmpdata = OASIS.getUserTmpTable(user_id)
                tmpdata.spawns = 0
            end
        end
    end)
end

exports("oasisbot", function(method_name, params, cb)
    if cb then 
        cb(OASIS[method_name](table.unpack(params)))
    else 
        return OASIS[method_name](table.unpack(params))
    end
end)

RegisterNetEvent("OASIS:CheckID")
AddEventHandler("OASIS:CheckID", function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if not user_id then
        OASIS.ReLoadChar(source)
    end
end)

function OASIS.isBanned(user_id, cbr)
    local task = Task(cbr, {false})
    MySQL.query("OASIS/get_banned", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].banned})
        else
            task()
        end
    end)
end

function OASIS.isWhitelisted(user_id, cbr)
    local task = Task(cbr, {false})
    MySQL.query("OASIS/get_whitelisted", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].whitelisted})
        else
            task()
        end
    end)
end

function OASIS.setWhitelisted(user_id,whitelisted)
    MySQL.execute("OASIS/set_whitelisted", {user_id = user_id, whitelisted = whitelisted})
end

function OASIS.getLastLogin(user_id, cbr)
    local task = Task(cbr,{""})
    MySQL.query("OASIS/get_last_login", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].last_login})
        else
            task()
        end
    end)
end

function OASIS.fetchBanReasonTime(user_id,cbr)
    MySQL.query("OASIS/getbanreasontime", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then 
            cbr(rows[1].bantime, rows[1].banreason, rows[1].banadmin)
        end
    end)
end

function OASIS.setUData(user_id,key,value)
    MySQL.execute("OASIS/set_userdata", {user_id = user_id, key = key, value = value})
end

function OASIS.getUData(user_id,key,cbr)
    local task = Task(cbr,{""})
    MySQL.query("OASIS/get_userdata", {user_id = user_id, key = key}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

function OASIS.setSData(key,value)
    MySQL.execute("OASIS/set_srvdata", {key = key, value = value})
end

function OASIS.getSData(key, cbr)
    local task = Task(cbr,{""})
    MySQL.query("OASIS/get_srvdata", {key = key}, function(rows, affected)
        if rows and #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

-- return user data table for OASIS internal persistant connected user storage
function OASIS.getUserDataTable(user_id)
    return OASIS.user_tables[user_id]
end

function OASIS.getUserTmpTable(user_id)
    return OASIS.user_tmp_tables[user_id]
end

function OASIS.isConnected(user_id)
    return OASIS.rusers[user_id] ~= nil
end

function OASIS.isFirstSpawn(user_id)
    local tmp = OASIS.getUserTmpTable(user_id)
    return tmp and tmp.spawns == 1
end

function OASIS.getUserId(source)
    if source ~= nil then
        local ids = GetPlayerIdentifiers(source)
        if ids ~= nil and #ids > 0 then
            return OASIS.users[ids[1]]
        end
    end
    return nil
end

-- return map of user_id -> player source
function OASIS.getUsers()
    local users = {}
    for k,v in pairs(OASIS.user_sources) do
        users[k] = v
    end
    return users
end

-- return source or nil
function OASIS.getUserSource(user_id)
    return OASIS.user_sources[user_id]
end

function OASIS.IdentifierBanCheck(source,user_id,cb)
    for i,v in pairs(GetPlayerIdentifiers(source)) do 
        MySQL.query('OASIS/identifier_all', {identifier = v}, function(rows)
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

function OASIS.BanIdentifiers(user_id, value)
    MySQL.query('OASIS/select_identifier_byid_all', {id = user_id}, function(rows)
        for i = 1, #rows do 
            MySQL.execute("OASIS/set_identifierbanned", {banned = value, iden = rows[i].identifier })
        end
    end)
end

function calculateTimeRemaining(expireTime)
    local datetime = ''
    local expiry = os.date("%d/%m/%Y at %H:%M", tonumber(expireTime))
    local hoursLeft = ((tonumber(expireTime)-os.time()))/3600
    local minutesLeft = nil
    if hoursLeft < 1 then
        minutesLeft = hoursLeft * 60
        minutesLeft = string.format("%." .. (0) .. "f", minutesLeft)
        datetime = minutesLeft .. " mins" 
        return datetime
    else
        hoursLeft = string.format("%." .. (0) .. "f", hoursLeft)
        datetime = hoursLeft .. " hours" 
        return datetime
    end
    return datetime
end

function OASIS.setBanned(user_id,banned,time,reason,admin,baninfo)
    if banned then 
        MySQL.execute("OASIS/set_banned", {user_id = user_id, banned = banned, bantime = time, banreason = reason, banadmin = admin, baninfo = baninfo})
        OASIS.BanIdentifiers(user_id, true)
        OASIS.BanTokens(user_id, true) 
    else 
        MySQL.execute("OASIS/set_banned", {user_id = user_id, banned = banned, bantime = "", banreason =  "", banadmin =  "", baninfo = ""})
        OASIS.BanIdentifiers(user_id, false)
        OASIS.BanTokens(user_id, false) 
        MySQL.execute("ac/delete_ban", {user_id = user_id})
    end 
end

function OASIS.ban(adminsource,permid,time,reason,baninfo)
    local adminPermID = OASIS.getUserId(adminsource)
    local getBannedPlayerSrc = OASIS.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then
            OASIS.setBanned(permid,true,time,reason,GetPlayerName(adminsource),baninfo)
            OASIS.kick(getBannedPlayerSrc,"[OASIS] Ban expires in: "..calculateTimeRemaining(time).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/oasisv") 
        else
            OASIS.setBanned(permid,true,"perm",reason,GetPlayerName(adminsource),baninfo)
            OASIS.kick(getBannedPlayerSrc,"[OASIS] Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/oasisv") 
        end
        OASISclient.notify(adminsource,{"~g~Success banned! User PermID: " .. permid})
    else 
        if tonumber(time) then 
            OASIS.setBanned(permid,true,time,reason,GetPlayerName(adminsource),baninfo)
        else 
            OASIS.setBanned(permid,true,"perm",reason,GetPlayerName(adminsource),baninfo)
        end
        OASISclient.notify(adminsource,{"~g~Success banned! User PermID: " .. permid})
    end
end

function OASIS.banConsole(permid,time,reason)
    local adminPermID = "OASIS"
    local getBannedPlayerSrc = OASIS.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            OASIS.setBanned(permid,true,banTime,reason, adminPermID)
            OASIS.kick(getBannedPlayerSrc,"[OASIS] Ban expires in "..calculateTimeRemaining(banTime).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by OASIS \nAppeal @ discord.gg/oasisv") 
        else 
            OASIS.setBanned(permid,true,"perm",reason, adminPermID)
            OASIS.kick(getBannedPlayerSrc,"[OASIS] Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by OASIS \nAppeal @ discord.gg/oasisv") 
        end
        print("Successfully banned Perm ID: " .. permid)
    else 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            OASIS.setBanned(permid,true,banTime,reason, adminPermID)
        else 
            OASIS.setBanned(permid,true,"perm",reason, adminPermID)
        end
        print("Successfully banned Perm ID: " .. permid)
    end
end

function OASIS.banDiscord(permid,time,reason,adminPermID)
    local getBannedPlayerSrc = OASIS.getUserSource(tonumber(permid))
    if tonumber(time) then 
        local banTime = os.time()
        banTime = banTime  + (60 * 60 * tonumber(time))  
        OASIS.setBanned(permid,true,banTime,reason, adminPermID)
        if getBannedPlayerSrc then 
            OASIS.kick(getBannedPlayerSrc,"[OASIS] Ban expires in "..calculateTimeRemaining(banTime).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/oasisv") 
        end
    else 
        OASIS.setBanned(permid,true,"perm",reason,  adminPermID)
        if getBannedPlayerSrc then 
            OASIS.kick(getBannedPlayerSrc,"[OASIS] Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/oasisv") 
        end
    end
end

-- To use token banning you need the latest artifacts.
function OASIS.StoreTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            MySQL.query("OASIS/check_token", {token = token}, function(rows)
                if token and rows and #rows <= 0 then 
                    MySQL.execute("OASIS/add_token", {token = token, user_id = user_id})
                end        
            end)
        end
    end
end


function OASIS.CheckTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local banned = false;
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            local rows = MySQL.asyncQuery("OASIS/check_token", {token = token, user_id = user_id})
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

function OASIS.BanTokens(user_id, banned) 
    if GetNumPlayerTokens then 
        MySQL.query("OASIS/check_token_userid", {id = user_id}, function(id)
            for i = 1, #id do 
                MySQL.execute("OASIS/ban_token", {token = id[i].token, banned = banned})
            end
        end)
    end
end


function OASIS.kick(source,reason)
    DropPlayer(source,reason)
end

-- tasks

function task_save_datatables()
    TriggerEvent("OASIS:save")
    Debug.pbegin("OASIS save datatables")
    for k,v in pairs(OASIS.user_tables) do
        OASIS.setUData(k,"OASIS:datatable",json.encode(v))
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
        deferrals.update("[OASIS] Checking identifiers...")
        OASIS.getUserIdByIdentifiers(ids, function(user_id)
            local numtokens = GetNumPlayerTokens(source)
            if numtokens == 0 then
                deferrals.done("[OASIS]: You are banned from this server, please do not try to evade your ban. If you believe this was an error quote your ID which is: " .. user_id)
                tOASIS.sendWebhook('ban-evaders', 'OASIS Ban Evade Logs', "> Player Name: **"..name.."**\n> Player Current Perm ID: **"..user_id.."**\n> Player Token Amount: **"..numtokens.."**")
                return 
            end
            OASIS.IdentifierBanCheck(source, user_id, function(status, id, bannedIdentifier)
                if status then
                    deferrals.done("[OASIS]: You are banned from this server, please do not try to evade your ban. If you believe this was an error quote your ID which is: " .. id)
                    tOASIS.sendWebhook('ban-evaders', 'OASIS Ban Evade Logs', "> Player Name: **"..name.."**\n> Player Current Perm ID: **"..user_id.."**\n> Player Banned PermID: **"..id.."**\n> Player Banned Identifier: **"..bannedIdentifier.."**")
                    return 
                end
            end)
            if user_id ~= nil then -- check user validity 
                deferrals.update("[OASIS] Fetching Tokens...")
                OASIS.StoreTokens(source, user_id) 
                deferrals.update("[OASIS] Checking banned...")
                OASIS.isBanned(user_id, function(banned)
                    if not banned then
                        deferrals.update("[OASIS] Checking whitelisted...")
                        OASIS.isWhitelisted(user_id, function(whitelisted)
                            if not config.whitelist or whitelisted then
                                Debug.pbegin("playerConnecting_delayed")
                                if OASIS.rusers[user_id] == nil then -- not present on the server, init
                                    ::try_verify::
                                    local verified = exports["ghmattimysql"]:executeSync("SELECT * FROM oasis_verification WHERE user_id = @user_id", {user_id = user_id})
                                    if #verified > 0 then 
                                        if verified[1]["verified"] == 0 then
                                            local code = nil
                                            local data_code = exports["ghmattimysql"]:executeSync("SELECT * FROM oasis_verification WHERE user_id = @user_id", {user_id = user_id})
                                            code = data_code[1]["code"]
                                            if code == nil then
                                                code = math.random(100000, 999999)
                                            end
                                            ::regen_code::
                                            local checkCode = exports["ghmattimysql"]:executeSync("SELECT * FROM oasis_verification WHERE code = @code", {code = code})
                                            if checkCode ~= nil then
                                                if #checkCode > 0 then
                                                    code = math.random(100000, 999999)
                                                    goto regen_code
                                                end
                                            end
                                            exports["ghmattimysql"]:executeSync("UPDATE oasis_verification SET code = @code WHERE user_id = @user_id", {user_id = user_id, code = code})
                                            local function show_auth_card(code, deferrals, callback)
                                                verify_card["body"][2]["items"][3]["text"] = "3. !verify "..code
                                                deferrals.presentCard(verify_card, callback)
                                            end
                                            local function check_verified()
                                                local data_verified = exports["ghmattimysql"]:executeSync("SELECT * FROM oasis_verification WHERE user_id = @user_id", {user_id = user_id})
                                                local verified_code = data_verified[1]["verified"]
                                                if verified_code == true then
                                                    if OASIS.CheckTokens(source, user_id) then 
                                                        deferrals.done("[OASIS]: You are banned from this server, please do not try to evade your ban.")
                                                    end
                                                    OASIS.users[ids[1]] = user_id
                                                    OASIS.rusers[user_id] = ids[1]
                                                    OASIS.user_tables[user_id] = {}
                                                    OASIS.user_tmp_tables[user_id] = {}
                                                    OASIS.user_sources[user_id] = source
                                                    OASIS.getUData(user_id, "OASIS:datatable", function(sdata)
                                                        local data = json.decode(sdata)
                                                        if type(data) == "table" then OASIS.user_tables[user_id] = data end
                                                        local tmpdata = OASIS.getUserTmpTable(user_id)
                                                        OASIS.getLastLogin(user_id, function(last_login)
                                                            tmpdata.last_login = last_login or ""
                                                            tmpdata.spawns = 0
                                                            local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                                            MySQL.execute("OASIS/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                            print("[OASIS] "..name.." Joined | PermID: "..user_id..")")
                                                            TriggerEvent("OASIS:playerJoin", user_id, source, name, tmpdata.last_login)
                                                            Wait(500)
                                                            deferrals.done()
                                                        end)
                                                    end)
                                                else
                                                    show_auth_card(code, deferrals, check_verified)
                                                end
                                            end
                                            show_auth_card(code, deferrals, check_verified)
                                        else
                                            deferrals.update("[OASIS] Checking discord verification...")
                                            if not tOASIS.checkForRole(user_id, '975490533344559161') then
                                                deferrals.done("[OASIS]: You are required to be verified within discord.gg/oasisv to join the server. If you previously were verified, please contact management.")
                                            end
                                            if OASIS.CheckTokens(source, user_id) then 
                                                deferrals.done("[OASIS]: You are banned from this server, please do not try to evade your ban. If you believe this was an error quote your ID which is: " .. user_id)
                                            end
                                            OASIS.users[ids[1]] = user_id
                                            OASIS.rusers[user_id] = ids[1]
                                            OASIS.user_tables[user_id] = {}
                                            OASIS.user_tmp_tables[user_id] = {}
                                            OASIS.user_sources[user_id] = source
                                            OASIS.getUData(user_id, "OASIS:datatable", function(sdata)
                                                local data = json.decode(sdata)
                                                if type(data) == "table" then OASIS.user_tables[user_id] = data end
                                                local tmpdata = OASIS.getUserTmpTable(user_id)
                                                OASIS.getLastLogin(user_id, function(last_login)
                                                    tmpdata.last_login = last_login or ""
                                                    tmpdata.spawns = 0
                                                    local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                                    MySQL.execute("OASIS/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                    print("[OASIS] "..name.." Joined | PermID: "..user_id..")")
                                                    TriggerEvent("OASIS:playerJoin", user_id, source, name, tmpdata.last_login)
                                                    Wait(500)
                                                    deferrals.done()
                                                end)
                                            end)
                                        end
                                    else
                                        exports["ghmattimysql"]:executeSync("INSERT IGNORE INTO oasis_verification(user_id,verified) VALUES(@user_id,false)", {user_id = user_id})
                                        goto try_verify
                                    end
                                else -- already connected
                                    if OASIS.CheckTokens(source, user_id) then 
                                        deferrals.done("[OASIS]: You are banned from this server, please do not try to evade your ban. If you believe this was an error quote your ID which is: " .. user_id)
                                    end
                                    print("[OASIS] "..name.." Reconnected | PermID: "..user_id)
                                    TriggerEvent("OASIS:playerRejoin", user_id, source, name)
                                    Wait(500)
                                    deferrals.done()
                                    
                                    -- reset first spawn
                                    local tmpdata = OASIS.getUserTmpTable(user_id)
                                    tmpdata.spawns = 0
                                end
                                Debug.pend()
                            else
                                print("[OASIS] "..name.." ("..GetPlayerName(source)..") rejected: not whitelisted (Perm ID = "..user_id..")")
                                deferrals.done("[OASIS] Not whitelisted (Perm ID = "..user_id..").")
                            end
                        end)
                    else
                        deferrals.update("[OASIS] Fetching Tokens...")
                        OASIS.StoreTokens(source, user_id) 
                        OASIS.fetchBanReasonTime(user_id,function(bantime, banreason, banadmin)
                            if tonumber(bantime) then 
                                local timern = os.time()
                                if timern > tonumber(bantime) then 
                                    OASIS.setBanned(user_id,false)
                                    if OASIS.rusers[user_id] == nil then -- not present on the server, init
                                        OASIS.users[ids[1]] = user_id
                                        OASIS.rusers[user_id] = ids[1]
                                        OASIS.user_tables[user_id] = {}
                                        OASIS.user_tmp_tables[user_id] = {}
                                        OASIS.user_sources[user_id] = source
                                        deferrals.update("[OASIS] Loading datatable...")
                                        OASIS.getUData(user_id, "OASIS:datatable", function(sdata)
                                            local data = json.decode(sdata)
                                            if type(data) == "table" then OASIS.user_tables[user_id] = data end
                                            local tmpdata = OASIS.getUserTmpTable(user_id)
                                            deferrals.update("[OASIS] Getting last login...")
                                            OASIS.getLastLogin(user_id, function(last_login)
                                                tmpdata.last_login = last_login or ""
                                                tmpdata.spawns = 0
                                                local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                                MySQL.execute("OASIS/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                print("[OASIS] "..name.." ("..GetPlayerName(source)..") joined after his ban expired. (Perm ID = "..user_id..")")
                                                TriggerEvent("OASIS:playerJoin", user_id, source, name, tmpdata.last_login)
                                                deferrals.done()
                                            end)
                                        end)
                                    else -- already connected
                                        print("[OASIS] "..name.." ("..GetPlayerName(source)..") re-joined after his ban expired.  (Perm ID = "..user_id..")")
                                        TriggerEvent("OASIS:playerRejoin", user_id, source, name)
                                        deferrals.done()
                                        local tmpdata = OASIS.getUserTmpTable(user_id)
                                        tmpdata.spawns = 0
                                    end
                                    return 
                                end
                                print("[OASIS] "..name.." ("..GetPlayerName(source)..") rejected: banned (Perm ID = "..user_id..")")
                                deferrals.done("\n[OASIS] Ban expires in "..calculateTimeRemaining(bantime).."\nYour ID: "..user_id.."\nReason: "..banreason.."\nAppeal @ discord.gg/oasisv")
                            else 
                                print("[OASIS] "..name.." ("..GetPlayerName(source)..") rejected: banned (Perm ID = "..user_id..")")
                                deferrals.done("\n[OASIS] Permanent Ban\nYour ID: "..user_id.."\nReason: "..banreason.."\nAppeal @ discord.gg/oasisv")
                            end
                        end)
                    end
                end)
            else
                print("[OASIS] "..name.." ("..GetPlayerName(source)..") rejected: identification error")
                deferrals.done("[OASIS] Identification error.")
            end
        end)
    else
        print("[OASIS] "..name.." ("..GetPlayerName(source)..") rejected: missing identifiers")
        deferrals.done("[OASIS] Missing identifiers.")
    end
    Debug.pend()
end)

AddEventHandler("playerDropped",function(reason)
    local source = source
    local user_id = OASIS.getUserId(source)
    if user_id ~= nil then
        TriggerEvent("OASIS:playerLeave", user_id, source)
        -- save user data table
        OASIS.setUData(user_id,"OASIS:datatable",json.encode(OASIS.getUserDataTable(user_id)))
        print("[OASIS] "..GetPlayerName(source).." disconnected (Perm ID = "..user_id..")")
        OASIS.users[OASIS.rusers[user_id]] = nil
        OASIS.rusers[user_id] = nil
        OASIS.user_tables[user_id] = nil
        OASIS.user_tmp_tables[user_id] = nil
        OASIS.user_sources[user_id] = nil
        print('[OASIS] Player Leaving Save:  Saved data for: ' .. GetPlayerName(source))
        tOASIS.sendWebhook('leave', GetPlayerName(source).." PermID: "..user_id.." Temp ID: "..source.." disconnected", reason)
    else 
        print('[OASIS] SEVERE ERROR: Failed to save data for: ' .. GetPlayerName(source) .. ' Rollback expected!')
    end
    OASISclient.removeBasePlayer(-1,{source})
    OASISclient.removePlayer(-1,{source})
end)

MySQL.createCommand("OASIS/setusername","UPDATE oasis_users SET username = @username WHERE id = @user_id")

RegisterServerEvent("OASIScli:playerSpawned")
AddEventHandler("OASIScli:playerSpawned", function()
    Debug.pbegin("playerSpawned")
    -- register user sources and then set first spawn to false
    local source = source
    local user_id = OASIS.getUserId(source)
    local player = source
    OASISclient.addBasePlayer(-1, {player, user_id})
    if user_id ~= nil then
        OASIS.user_sources[user_id] = source
        local tmp = OASIS.getUserTmpTable(user_id)
        tmp.spawns = tmp.spawns+1
        local first_spawn = (tmp.spawns == 1)
        tOASIS.sendWebhook('join', GetPlayerName(source).." TempID: "..source.." PermID: "..user_id.." connected", "")
        if first_spawn then
            for k,v in pairs(OASIS.user_sources) do
                OASISclient.addPlayer(source,{v})
            end
            OASISclient.addPlayer(-1,{source})
            MySQL.execute("OASIS/setusername", {user_id = user_id, username = GetPlayerName(source)})
        end
        TriggerEvent("OASIS:playerSpawn",user_id,player,first_spawn)
        TriggerClientEvent("OASIS:onClientSpawn",player,user_id,first_spawn)
    end
    Debug.pend()
end)

RegisterServerEvent("OASIS:playerRespawned")
AddEventHandler("OASIS:playerRespawned", function()
    local source = source
    TriggerClientEvent('OASIS:onClientSpawn', source)
end)


exports("getServerStatus", function(params, cb)
    if staffWhitelist then
        cb("🛑 Whitelisted")
    else
        cb("✅ Online")
    end
end)

exports("getConnected", function(params, cb)
    if OASIS.getUserSource(params[1]) then
        cb('connected')
    else
        cb('not connected')
    end
end)