const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    fivemexports.ghmattimysql.execute("DELETE FROM `arma_staff_tickets`") 
    let embed = {
        "title": "Ticket Leaderboard Wiped",
        "description": `Admin: <@${message.author.id}>`,
        "color": settingsjson.settings.botColour,
        "footer": {
            "text": ""
        },
        "timestamp": new Date()
    }
    message.channel.send({ embed })
}

exports.conf = {
    name: "ticketreset",
    perm: 6,
    guild: "975490533344559154"
}