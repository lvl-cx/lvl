const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    fivemexports.ghmattimysql.execute("SELECT user_id FROM `arma_verification` WHERE discord_id = ?", [message.author.id], (verification) => {
        if (verification.length > 0) {
            let permid = verification[0].user_id
            fivemexports.ghmattimysql.execute("SELECT * FROM `arma_user_data` WHERE user_id = ?", [permid], (result) => {
                if (result.length > 0) {
                    let dvalue = JSON.parse(result[0].dvalue)
                    let groups = dvalue.groups
                    groups['Supporter'] = true;
                    fivemexports.ghmattimysql.execute("UPDATE `arma_user_data` SET dvalue = ? WHERE user_id = ?", [JSON.stringify(dvalue), params[0]])
                    message.reply('You have received Supporter rank for BETA only. After beta to access VIP garages it will be a required purchase on the store.')
                }
            })
        } else {
            message.reply('You are required to have a Perm ID connected to your discord.')
        }
    });
}

exports.conf = {
    name: "beta",
    perm: 0,
    guild: "975490533344559154"
}