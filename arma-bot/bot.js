const Discord = require('discord.js');
const client = new Discord.Client();
const path = require('path')
const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
require('dotenv').config({ path: path.join(resourcePath, './.env') })
const fs = require('fs');
const settingsjson = require(resourcePath + '/settings.js')

client.path = resourcePath
client.ip = settingsjson.settings.ip

if (process.env.TOKEN == "" || process.env.TOKEN == "TOKEN") {
    console.log(`Error! No Token Provided you forgot to edit the .env`);
    throw new Error('Whoops!')
}

client.on('ready', () => {
    console.log(`Logged in as ${client.user.tag}! Players: ${GetNumPlayerIndices()}`);
    console.log(`Your Prefix Is ${process.env.PREFIX}`)
    init()
});

let onlinePD = 0
let onlineStaff = 0
let onlineNHS = 0
let serverStatus = ""

if (settingsjson.settings.StatusEnabled) {
    setInterval(() => {
        if (!client.guilds.get(settingsjson.settings.GuildID)) return console.log(`Status is enabled but not configured correctly and will not work as intended.`)
        let channelid = client.guilds.get(settingsjson.settings.GuildID).channels.find(r => r.name === settingsjson.settings.StatusChannel);
        if (!channelid) return console.log(`Status channel is not available / cannot be found.`)
        let settingsjsons = require(resourcePath + '/params.json')
        let totalSeconds = (client.uptime / 1000);
        totalSeconds %= 86400;
        let hours = Math.floor(totalSeconds / 3600);
        totalSeconds %= 3600;
        let minutes = Math.floor(totalSeconds / 60);
        client.user.setActivity(`${GetNumPlayerIndices()}/${GetConvarInt("sv_maxclients",60)} players`, { type: 'WATCHING' });
        exports.ghmattimysql.execute("SELECT * FROM `arma_user_moneys`", (result) => {
            playersSinceRelease = result.length
        });
        exports.arma.armabot('getUsersByPermission', ['admin.tickets'], function(result) {
            if (!result.length)
                onlineStaff = 0
            else
                onlineStaff = result.length
        })
        exports.arma.armabot('getUsersByPermission', ['police.onduty.permission'], function(result) {
            if (!result.length)
                onlinePD = 0
            else
                onlinePD = result.length
        })
        exports.arma.armabot('getUsersByPermission', ['nhs perm'], function(result) {
            if (!result.length)
                onlineNHS = 0
            else
                onlineNHS = result.length
        })
        exports.arma.getServerStatus([], function(result) {
            serverStatus = result
        })
        channelid.fetchMessage(settingsjsons.messageid).then(msg => {
            let status = {
                "color": settingsjson.settings.botColour,
                "fields": [{
                        "name": "👀 Players Online:",
                        "value": `${GetNumPlayerIndices()}/${GetConvarInt("sv_maxclients",60)}`,
                        "inline": true
                    },
                    {
                        "name": "✅ Uptime:",
                        "value": `${hours} hours, ${minutes} minutes`,
                        "inline": true
                    },                    
                    {
                        "name": "💂 Staff Online:",
                        "value": `${onlineStaff}`,
                        "inline": true
                    },                    
                    {
                        "name": "👮🏻 MET PD Online:",
                        "value": `${onlineStaff}`,
                        "inline": true
                    },                      
                    {
                        "name": "🚑 NHS Online:",
                        "value": `${onlineStaff}`,
                        "inline": true
                    },                      
                    {
                        "name": "Server Status:",
                        "value": `${serverStatus}`,
                        "inline": true
                    },
/*                     {
                        "name": "🌎 Players Since Release:",
                        "value": `${playersSinceRelease}`,
                        "inline": true
                    }, */
                    {
                        "name": "💻 How do I connect?",
                        //"value": '``F8 -> connect ARMA.city``',
                        "value": "``Search 'ARMA' on FiveM Server List``",
                        "inline": true
                    }
                ],
                "title": "ARMA Status",
                "footer": {
                    "text": "⚙️ ARMA"
                },
                "timestamp": new Date()
            }
            msg.edit({ embed: status })
        }).catch(err => {
            channelid.send('Status Page JamesUK#6793 Starting..').then(id => {
                settingsjsons.messageid = id.id
                fs.writeFile(`${resourcePath}/params.json`, JSON.stringify(settingsjsons), function(err) {});
                return
            })
        })
    }, 15000);
}


client.commands = new Discord.Collection();

const init = async() => {
    fs.readdir(resourcePath + '/commands/', (err, files) => {
        if (err) console.error(err);
        console.log(`Loading a total of ${files.length} commands.`);
        files.forEach(f => {
            let command = require(`${resourcePath}/commands/${f}`);
            client.commands.set(command.conf.name, command);
        });
    });
}



client.getPerms = function(msg) {

    let settings = settingsjson.settings
    let lvl1 = msg.guild.roles.find(r => r.name === settings.Level1Perm);
    let lvl2 = msg.guild.roles.find(r => r.name === settings.Level2Perm);
    let lvl3 = msg.guild.roles.find(r => r.name === settings.Level3Perm);
    let lvl4 = msg.guild.roles.find(r => r.name === settings.Level4Perm);
    let lvl5 = msg.guild.roles.find(r => r.name === settings.Level5Perm);
    let lvl6 = msg.guild.roles.find(r => r.name === settings.Level6Perm);
    if (!lvl1 || !lvl2 || !lvl3 || !lvl4 || !lvl5 || !lvl6) {
        console.log(`Your permissions are not setup correctly and the bot will not function as intended.\nStatus: Level 1 Perm is: ${lvl1}, Level 2 Perm is: ${lvl2}, Level 3 Perm is ${lvl3}, Level 4 Perm is ${lvl4}, Level 5 Perm is ${lvl5}, Level 6 Perm is ${lvl6}`)
    }

    // hot fix for Discord role caching 
    const guild = client.guilds.get(msg.guild.id);
    if (guild.members.has(msg.author.id)) {
        guild.members.delete(msg.author.id);
    }
    const member = guild.members.get(msg.author.id);
    // hot fix for Discord role caching 

    let level = 0;
    if (msg.member.roles.has(lvl6.id)) {
        level = 6;
    } else if (msg.member.roles.has(lvl5.id)) {
        level = 5;
    } else if (msg.member.roles.has(lvl4.id)) {
        level = 4;
    } else if (msg.member.roles.has(lvl3.id)) {
        level = 3;
    } else if (msg.member.roles.has(lvl2.id)) {
        level = 2;
    } else if (msg.member.roles.has(lvl1.id)) {
        level = 1;
    }
    return level
}

client.on('message', (message) => {
    let client = message.client;
    if (message.author.bot) return;
    if (!message.content.startsWith(process.env.PREFIX)) return;
    let command = message.content.split(' ')[0].slice(process.env.PREFIX.length).toLowerCase();
    let params = message.content.split(' ').slice(1);
    let cmd;
    let permissions = client.getPerms(message)
    if (client.commands.has(command)) {
        cmd = client.commands.get(command);
    }
    if (cmd) {
        //if (message.channel.name.includes('bot') || cmd.conf.name == 'embed' || cmd.conf.name == 'rulechange' || cmd.conf.name == 'auction' || cmd.conf.name == 'verify' || cmd.conf.name == 'vote') {
            if (permissions < cmd.conf.perm) return;
            try {
                cmd.runcmd(exports, client, message, params, permissions);
            } catch (err) {
                let embed = {
                    "title": "Error Occured!",
                    "description": "\nAn error occured. Contact JamesUK#6793 in ARMA with the code:\n\n```" + err.message + "\n```",
                    "color": 13632027
                }
                message.channel.send({ embed })
            }
        //}
    }
});


client.login(process.env.TOKEN)
