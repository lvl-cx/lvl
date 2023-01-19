const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    let embed = {
        "title": "ARMA Bot Commands",
        "description": `**Public Commands:** \n${process.env.PREFIX}verify [code] \n${process.env.PREFIX}hmc [spawncode] \n${process.env.PREFIX}gco [spawncode] \n${process.env.PREFIX}status \n${process.env.PREFIX}ip \n${process.env.PREFIX}staffapp \n${process.env.PREFIX}banappeal \n${process.env.PREFIX}locklist \n${process.env.PREFIX}support \n${process.env.PREFIX}trader\n\n**Staff Commands:**\n${process.env.PREFIX}ch [permid] \n${process.env.PREFIX}d2p [@user] \n${process.env.PREFIX}p2d [permid] \n${process.env.PREFIX}checkban [permid] \n${process.env.PREFIX}sw [permid] \n${process.env.PREFIX}profile [permid] \n${process.env.PREFIX}notes [permid] \n${process.env.PREFIX}ticketlb\n\n**Support Team+ Commands:** \n${process.env.PREFIX}ban [permid] [time (hours)] [reason] \n${process.env.PREFIX}garage [permid]\n\n**Administrator+ Commands:** \n${process.env.PREFIX}unban [permid] \n${process.env.PREFIX}groups [permid]`,
        "color": settingsjson.settings.botColour,
        "footer": {
            "text": ""
        },
        "timestamp": new Date()
    }
    message.channel.send({ embed })
}

exports.conf = {
    name: "help",
    perm: 0,
    guild: "975490533344559154"
}
