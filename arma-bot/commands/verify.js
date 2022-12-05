const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = async(fivemexports, client, message, params) => {
    message.delete()
    if (!params[0] && !parseInt(params[0])) {
        return message.reply('Invalid args! Correct term is: ' + process.env.PREFIX + 'verify [code]', delete_after=10)
    }
    fivemexports.ghmattimysql.execute("SELECT * FROM `arma_verification` WHERE code = ?", [params[0]], (code) => {
        if (code.length > 0) {
           if (code[0].discord_id === null ){
            fivemexports.ghmattimysql.execute("UPDATE `arma_verification` SET discord_id = ?, verified = 1 WHERE code = ?", [message.author.id, params[0]], (result) => {
                if (result) {
                    let embed = {
                        "title": "Verified",
                        "description": `**Code: **${params[0]}\n**Perm ID:** ${code[0].user_id}`,
                        "color": settingsjson.settings.botColour,
                        "footer": {
                            "text": ""
                        },
                        "timestamp": new Date()
                    }
                    message.channel.send({ embed })
                    try {
                        let role = message.guild.roles.find(r => r.name === '| Verified')
                        message.member.addRole(role)
                    } catch (err) {
                        console.log()
                    }
                }
            });
           }
           else{
            return message.reply('This code has already been used!', delete_after=10)
           }
        }
        else {
            message.reply('Invalid code!', delete_after=10)
        }
    })
}

exports.conf = {
    name: "verify",
    perm: 0
}