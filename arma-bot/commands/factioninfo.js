const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    if (!params[0]) {
        return message.reply('Invalid args! Correct term is: ' + process.env.PREFIX + 'info [permid]')
    }
    fivemexports.ghmattimysql.execute("SELECT * FROM `arma_police_hours` WHERE user_id = ?", [params[0]], (result) => {
        let embed = {
            "title": `**Info**`,
            "description": `Police Hour Information regarding Perm ID: **${params[0]}**`,
            "color": settingsjson.settings.botColour,
            "fields": [
                {
                    name: '**Perm ID:**',
                    value: `${result[0].user_id}`,
                    inline: true,
                },
                {
                    name: '**Hours this week:**',
                    value: `${result[0].weekly_hours}`,
                    inline: true,
                },
                {
                    name: '**Total hours:**',
                    value: `${result[0].total_hours}`,
                    inline: true,
                },
            ],
            "footer": {
                "text": `Requested by ${message.author.username}`
            },
            "timestamp": new Date()
        }
        message.channel.send({ embed })
    })
}

exports.conf = {
    name: "info",
    perm: 0,
    guild: "991799285681233930"
}