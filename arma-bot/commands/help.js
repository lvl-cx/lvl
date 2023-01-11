const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    if (!params[0]) {
        let embed = {
            "title": "ARMA Bot Commands",
            "description": `**Public Commands:** \n${process.env.PREFIX}verify [code] \n${process.env.PREFIX}hmc [spawncode] \n${process.env.PREFIX}gco [spawncode] \n${process.env.PREFIX}status \n${process.env.PREFIX}ip \n${process.env.PREFIX}staffapp \n${process.env.PREFIX}banappeal \n${process.env.PREFIX}locklist \n${process.env.PREFIX}support \n${process.env.PREFIX}trader\n\n**Staff Commands:**\n${process.env.PREFIX}ch [permid] \n${process.env.PREFIX}d2p [@user] \n${process.env.PREFIX}p2d [permid] \n${process.env.PREFIX}sw [permid] \n${process.env.PREFIX}profile [permid] \n${process.env.PREFIX}notes [permid]\n\n**Support Team+ Commands:** \n${process.env.PREFIX}ban [permid] [time (hours)] [reason] \n${process.env.PREFIX}garage [permid]\n\n**Administrator+ Commands:** \n${process.env.PREFIX}unban [permid] \n${process.env.PREFIX}groups [permid]`,
            "color": settingsjson.settings.botColour,
            "footer": {
                "text": ""
            },
            "timestamp": new Date()
        }
        message.channel.send({ embed })
    } 
    else if (params[0] == 'management') {
        let embed = {
            "title": "ARMA Bot Commands",
            "description": `**Management Commands:** \n${process.env.PREFIX}addcar [permid] \n${process.env.PREFIX}delcar [permid] \n${process.env.PREFIX}vote [text] \n${process.env.PREFIX}clearwarnings [permid]`,
            "color": settingsjson.settings.botColour,
            "footer": {
                "text": ""
            },
            "timestamp": new Date()
        }
        message.channel.send({ embed })
    }   
    else if (params[0] == 'dev') {
        let embed = {
            "title": "ARMA Bot Commands",
            "description": `**Developer Commands:** \n*(These commands will interact with the server database, do not run any if unsure of the outcome.)* \n${process.env.PREFIX}clearbans \n${process.env.PREFIX}punishments \n${process.env.PREFIX}clearvehicleowners [spawncode] \n${process.env.PREFIX}cleargarage [permid] \n${process.env.PREFIX}lockcar [spawncode]`,
            "color": settingsjson.settings.botColour,
            "footer": {
                "text": ""
            },
            "timestamp": new Date()
        }
        message.channel.send({ embed })
    }       
    else {
        let embed = {
            "title": "ARMA Bot Commands",
            "description": "**Error**, unknown option selected",
            "color": settingsjson.settings.botColour,
            "footer": {
                "text": ""
            },
            "timestamp": new Date()
        }
        message.channel.send({ embed })
    }
}

exports.conf = {
    name: "help",
    perm: 0
}
