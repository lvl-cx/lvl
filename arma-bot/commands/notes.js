
exports.runcmd = (fivemexports, client, message, params) => {
    if (!params[0]) {
        return message.reply('Invalid args! Correct term is: ' + process.env.PREFIX + 'notes [permid]')
    }
    fivemexports.ghmattimysql.execute("SELECT * FROM `arma_user_notes` WHERE user_id = ?", [params[0]], (result) => {
        let notes = ''
        if (result.length > 0) {
            for (i = 0; i < result.length; i++) { 
                notes = notes + `\n[ID: ${result[i].note_id}] - ${result[i].text} [Admin: ${result[i].admin_name}(${result[i].admin_id})]`
            }
            let embed = {
                "title": `**Player Notes**`,
                "description": `**Success**! Notes have been fetched for User ID: ***${params[0]}***`,
                "color": settingsjson.settings.botColour,
                "fields": [
                    {
                        name: '**Perm ID:**',
                        value: `${params[0]}`,
                    },
                    {
                        name: '**Notes:**',
                        value: notes,
                    }
                ],
                "footer": {
                    "text": ""
                },
                "timestamp": new Date()
            }
            message.channel.send({ embed })
        } else {
            message.reply('User has no notes.')
        }
    });
}

exports.conf = {
    name: "notes",
    perm: 1
}