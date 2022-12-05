const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

var statusLeaderboard = require(resourcePath + '/statusleaderboard.json')
let descriptionText = ''

exports.runcmd = (fivemexports, client, message, params) => {
    message.delete()
    var promoters = []
    const sortable = Object.fromEntries(
        Object.entries(statusLeaderboard['leaderboard']).sort(([,a],[,b]) => b-a)
    );
    for (i = 0; i < Object.keys(statusLeaderboard['leaderboard']).length; i++) {
        if (i < 10) {
            promoters.push(`${Object.keys(sortable)[i]} - ${Object.values(sortable)[i]} minutes promoted\n`)
        }
    }
    let embed = {
        "title": `Promotion Leaderboard`,
        "description": 'To take part in the competition for £100, place `discord.gg/armarp` in your status.'+descriptionText+'```\n'+promoters.join('').replace(',', '')+'```',
        "color": settingsjson.settings.botColour,
        "footer": {
            "text": ""
        },
        "timestamp": new Date()
    }
    message.channel.send({ embed })
}

exports.conf = {
    name: "leaderboard",
    perm: 0
}