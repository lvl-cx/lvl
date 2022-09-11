let bannedPlayers = 0
let totalBans = 0
let totalKicks = 0
let totalWarns = 0
let totalACBans = 0

exports.runcmd = (fivemexports, client, message, params) => {
    fivemexports.ghmattimysql.execute("SELECT * FROM arma_users WHERE banned = 1", (bannedPlayers) => {
    fivemexports.ghmattimysql.execute("SELECT * FROM arma_warnings WHERE warning_type = 'Ban'", (totalBans) => {
    fivemexports.ghmattimysql.execute("SELECT * FROM arma_warnings WHERE warning_type = 'Kick'", (totalKicks) => {
    fivemexports.ghmattimysql.execute("SELECT * FROM arma_anticheat", (totalACBans) => {
    let embed = {
        "title": "Punishment Statistics",
        "description": `Currently Banned:\n - Anticheat Banned: **${totalACBans.length}** \n - Total Banned: **${bannedPlayers.length}**\n\nF10 Related: \n - Total Bans:** ${totalBans.length}**\n - Total Kicks:** ${totalKicks.length}**\n - Total Punishments:** ${totalBans.length+totalKicks.length}**\n\nAdmin: <@${message.author.id}>`,
        "color": 16711680,
        "footer": {
            "text": ""
        },
        "timestamp": new Date()
    }
    message.channel.send({ embed })
    }) }) }) })
}

exports.conf = {
    name: "punishments",
    perm: 6
}