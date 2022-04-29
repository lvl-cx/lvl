const Discord = require('discord.js');
var Table = require('easy-table')
const client = new Discord.Client();
client.on('ready', () => {
    console.log(`BotClient: Logged in as ${client.user.tag}! ${GetNumPlayerIndices()}`);
});

setInterval(function() {
    let totalSeconds = (client.uptime / 1000);
    totalSeconds %= 86400;
    let hours = Math.floor(totalSeconds / 3600);
    totalSeconds %= 3600;
    let minutes = Math.floor(totalSeconds / 60);
    client.user.setActivity(`Watching ATM Wrld`)
    let embed = {
        "color": 7063872,
        "timestamp": new Date(),
        "footer": {
            "text": "ATM"
        },
        "fields": [],
        "description": `\nPlayers: ${GetNumPlayerIndices()}/${GetConvarInt("sv_maxclients",120)}\nUptime: ` + `${hours} hours, ${minutes} minutes\nIP: N/A`,
        "title": "ATM Status"
    }
    client.channels.get('968286183501221948').fetchMessage('968286183501221948').then(messages => {
        messages.edit({ embed: embed })
    })
}, 30000)

function currency(val, width) {
    return Table.padLeft(val, 30)
}

function currency2(val, width) {
    return Table.padLeft(val, 15)
}

function currency3(val, width) {
    return Table.padLeft(val, 35)
}



client.awaitReply = async(msg, question, limit = 60000) => {
    const filter = m => m.author.id === msg.author.id;
    await msg.channel.send(question);
    try {
        const collected = await msg.channel.awaitMessages(filter, { max: 1, time: limit, errors: ["time"] });
        return collected.first().content;
    } catch (e) {
        return false;
    }
};

var prefix = "."
client.on('message', async message => {
    if (message.author.bot) return;
    var input = message.content.toLowerCase().split(" ")[0];
    if (!input.includes(prefix)) return;
    input = input.slice(prefix.length);
    var args = message.content.split(" ").slice(1);
    var joinargs = args.join(" ");
    let internet = joinargs.replace(/ /g, "+");

    if (input == "locklist") {
        message.reply('Here Is a list of all the locked and non importable vehicles: Coming soon')
    }

    if (input == "police") {
        message.reply('Here is the police discord: https://discord.gg/6eaQPVsPck')
    }

    if (input == "carreport") {
        message.reply('Any Issues With Your Cars Please Contact a Car Dev Through Coming soon')
    }

    if (input == "warnings") {
        if (!message.member.roles.has('968286159874703471')) {
            return
        }
        if (args[0] && parseInt(args[0])) {
            var text = ""
            exports.ghmattimysql.execute("SELECT * FROM `atm_warnings` WHERE user_id = ?", [args[0]], (result) => {
                console.log(JSON.stringify(result), result.length);
                var i;
                for (i = 0; i < result.length; i++) {
                    var date = new Date(+result[i].warning_date)
                    text += `${result[i].duration}      ${result[i].user_id}     ${result[i].warning_type}             ${result[i].reason}   ${result[i].admin}    ${date.toDateString()}` + "\n";
                }
                var t = new Table
                result.forEach(function(col) {
                    var date = new Date(+col.warning_date)
                    t.cell('User ID', col.user_id)
                    t.cell('Warning Type', col.warning_type)
                    t.cell('Duration: ', col.duration, currency2)
                    t.cell('Reason: ', col.reason, currency)
                    t.cell('Admin: ', col.admin, currency2)
                    t.cell('Date: ', date.toDateString(), currency3)
                    t.newRow()
                })
                message.channel.send(t.toString())
                message.reply('They have: ' + result.length + ' Warning/s')
            });
        } else {
            message.reply('Please specify an PermID! E.G:  .warnings [permid]')
        }
    }

    if (input == "d2p") {
        if (!message.member.roles.has('968286159874703471')) {
            return
        }
        if (message.mentions.members.first()) {
            let user = message.mentions.members.first()
            exports.ghmattimysql.execute("SELECT * FROM `atm_user_ids` WHERE identifier = ?", ["discord:" + user.id], (result) => {
                if (result.length > 0) {
                    message.reply('PermID of this user is: ' + result[0].user_id)
                } else {
                    message.reply('No account linked for this user.')
                }
            });
        } else {
            message.reply('You need to mention someone!')
        }
    }
    if (input == "p2d") {
        if (!message.member.roles.has('968286159874703471')) {
            return
        }
        if (args[0] && parseInt(args[0])) {
            exports.ghmattimysql.execute("SELECT * FROM `atm_user_ids` WHERE user_id = ?", [args[0]], (result) => {
                if (result.length > 0) {
                    console.log(JSON.stringify(result))
                    var i;
                    var text = ""
                    for (i = 0; i < result.length; i++) {
                        if (result[i].identifier.includes('discord')) {
                            message.reply('Discord of this user is: ' + "<@" + result[0].identifier.split(":")[1] + ">")
                        }
                    }
                } else {
                    message.reply('No account linked for this user.')
                }
            });
        } else {
            message.reply('You need to enter a valid PermID!')
        }
    }
    if (input == "gg") {
        if (!message.member.roles.has('968286159874703471')) {
            return
        }
        if (args[0] && parseInt(args[0])) {
            exports.ghmattimysql.execute("SELECT * FROM `atm_user_data` WHERE user_id = ?", [args[0]], (result) => {
                if (result.length > 0) {
                    var i;
                    for (i = 0; i < result.length; i++) {
                        let embed = {
                            "color": 4886754,
                            "title": "Groups for: " + args[0],
                            "description": "```" + JSON.stringify(JSON.parse(result[i].dvalue).groups) + " ```"
                        }
                        message.reply({ embed: embed })
                    }
                } else {
                    message.reply('No groups for this user.')
                }
            });
        } else {
            message.reply('You need to enter a valid PermID!')
        }
    }
    if (input == "addcar") {
        if (!message.member.roles.has('968286161191714866')) {
            return
        }
        if (args[0] && parseInt(args[0]) && args[1]) {
            exports.ghmattimysql.execute("INSERT INTO atm_user_vehicles (user_id, vehicle) VALUES(?, ?)", [args[0], args[1]], (result) => {
                if (result) {
                    message.reply('Vehicle added.')
                } else {
                    message.reply('Error! This likely is already owned by the player.')
                }
            })
        } else {
            message.reply('You need to enter a valid PermID! Example: .addcar [permid] [car]')
        }
    }
    if (input == "delcar") {
        if (!message.member.roles.has('968286161191714866')) {
            return
        }
        if (args[0] && parseInt(args[0]) && args[1]) {
            exports.ghmattimysql.execute("DELETE FROM atm_user_vehicles WHERE user_id = ? AND vehicle = ?", [args[0], args[1]], (result) => {
                if (result) {
                    message.reply('Vehicle removed.')
                } else {
                    message.reply('Error! This likely is already removed from the player.')
                }
            })
        } else {
            message.reply('You need to enter a valid PermID! Example: .addcar [permid] [car]')
        }
    }
    if (input == "topbal") {
        if (!message.member.roles.has('968286155911086170')) {
            return
        }
        exports.ghmattimysql.execute("SELECT * FROM atm_user_moneys ORDER BY bank DESC", [args[0], args[1]], (result) => {
            if (result) {
                message.reply(`Highest amount of banked money is by PermID: ${result[0].user_id}, Bank: £${result[0].bank}`)
            }
        })
    }
    if (input == "getowners") {
        if (!message.member.roles.has('968286155911086170')) {
            return
        }
        if (args[0]) {
            let string = ""
            exports.ghmattimysql.execute("SELECT * FROM atm_user_vehicles WHERE vehicle = ?", [args[0].toLowerCase()], (result) => {
                if (result) {
                    for (i = 0; i < result.length; i++) {
                        string = string + `${result[i].user_id}, `
                    }
                    let embed = {
                        "color": 4886754,
                        "title": "Owners for: " + args[0],
                        "description": "```" + string + " ```"
                    }
                    message.reply({ embed: embed })
                }
            })
        }
    }

    if (input == "hmc") {
        if (!message.member.roles.has('968286159874703471')) {
            return
        }
        if (args[0]) {
            exports.ghmattimysql.execute("SELECT * FROM atm_user_vehicles WHERE vehicle = ?", [args[0].toLowerCase()], (result) => {
                if (result) {
                    message.reply(`There are: ${result.length} ${args[0]}'s in the city.`)
                }
            })
        } else {
            message.reply('Incorrect command usage! .hmc [spawncode]')
        }
    }

    if (input == "ban") {
        if (!message.member.roles.has('968286161191714866')) {
            return
        }
        async function func() {
            let UserID = await client.awaitReply(message, 'What is the UserID you want to ban?');
            let Reason = await client.awaitReply(message, 'What is the reason for the ban?');
            let Time = await client.awaitReply(message, 'What is the time in hours for the ban?');
            let embed = {
                "color": 13573662,
                "title": "Bot Log",
                "description": `\n\n${message.author.tag} Banned user ${UserID}!`
            }
            client.channels.get('827894506481385523').send({ embed: embed })
            exports.atm.ban(parseInt(UserID), true, parseInt(Time), Reason + ' | Banned by ' + message.author.tag + " | " + message.author.id)
            message.reply('Banned User!')
        }
        func()
    }

    if (input == "unban") {
        if (!message.member.roles.has('968286161191714866')) {
            return
        }
        async function func() {
            let UserID = await client.awaitReply(message, 'What is the UserID you want to unban?');
            exports.atm.unban(parseInt(UserID))
            message.reply('Un-Banned User!')
            let embed = {
                "color": 13573662,
                "title": "Bot Log",
                "description": `\n\n${message.author.tag} Unbanned user ${UserID}!`
            }
            client.channels.get('827894506481385523').send({ embed: embed })
        }
        func()
    }

    if (input == "addgroup") {
        if (!message.member.roles.has('968286161191714866')) {
            return
        }
        if (args[0] && args[1]) {
            exports.atm.addgroup(args[0], args[1])
            message.reply('Success! Added Group.')
            let embed = {
                "color": 13573662,
                "title": "Bot Log",
                "description": `\n\n${message.author.tag} Added group ${args[1]}!`
            }
            message.reply({ embed: embed })
        } else {
            message.reply('Invalid usage! .addgroup [permid] [group]')
        }
    }
    if (input == "removegroup") {
        if (!message.member.roles.has('968286161191714866')) {
            return
        }
        if (args[0] && args[1]) {
            exports.atm.removegroup(args[0], args[1])
            message.reply('Success! Removed Group.')
            let embed = {
                "color": 13573662,
                "title": "Bot Log",
                "description": `\n\n${message.author.tag} Removed group ${args[1]}!`
            }
            message.reply({ embed: embed })
        } else {
            message.reply('Invalid usage! .removegroup [permid] [group]')
        }
    }

    if (input == "cbank") {
        if (!message.member.roles.has('968286161191714866')) {
            return
        }
        if (args[0]) {
            exports.ghmattimysql.execute("SELECT * FROM atm_user_moneys WHERE user_id = ?", [args[0]], (result) => {
                if (result) {
                    message.reply(`Amount of banked money, Bank: £${result[0].bank}`)
                }
            })
        } else {
            message.reply('Invalid usage! .cbal [permid]')
        }
    }
    if (input == "cwallet") {
        if (!message.member.roles.has('968286161191714866')) {
            return;
        }
        if (args[0]) {
            exports.ghmattimysql.execute("SELECT * FROM atm_user_moneys WHERE user_id = ?", [args[0]], (result) => {
                if (result) {
                    message.reply(`Amount of wallet money, Bank: £${result[0].wallet}`)
                }
            })
        } else {
            message.reply('Invalid usage! .cwallet [permid]')
        }
    }

    if (input == "addm") {
        if (!message.member.roles.has('968286114219720714')) {
            return
        }
        if (args[0] && args[1]) {
            exports.ghmattimysql.execute("SELECT * FROM atm_user_moneys WHERE user_id = ?", [args[0]], (result) => {
                if (result) {
                    result[0].bank = result[0].bank + parseInt(args[1])
                    message.reply(`Added: £${args[1]}, Bal now: £${result[0].bank}`)
                    exports.ghmattimysql.execute("UPDATE atm_user_moneys SET bank = ? WHERE user_id = ?", [result[0].bank, args[0]])
                    let embed = {
                        "color": 13573662,
                        "title": "Bot Log",
                        "description": `\n\n${message.author.tag} Added ${args[1]} to bank`
                    }
                    client.channels.get('827894506481385523').send({ embed: embed })
                }
            })
        } else {
            message.reply('Invalid usage! .addm [permid] [amount]')
        }
    }

    if (input == "removem") {
        if (!message.member.roles.has('968286114219720714')) {
            return
        }
        if (args[0] && args[1]) {
            exports.ghmattimysql.execute("SELECT * FROM atm_user_moneys WHERE user_id = ?", [args[0]], (result) => {
                if (result) {
                    result[0].bank = result[0].bank - parseInt(args[1])
                    message.reply(`Removed: £${args[1]}, Bal now: £${result[0].bank}`)
                    exports.ghmattimysql.execute("UPDATE atm_user_moneys SET bank = ? WHERE user_id = ?", [result[0].bank, args[0]])
                    let embed = {
                        "color": 13573662,
                        "title": "Bot Log",
                        "description": `\n\n${message.author.tag} Removed ${args[1]} from bank`
                    }
                    client.channels.get('827894506481385523').send({ embed: embed })
                }
            })
        } else {
            message.reply('Invalid usage! .removem [permid] [amount]')
        }
    }

    if (input == "changeid") {
        if (!message.member.roles.has('968286161191714866')) {
            return
        }
        if (parseInt(args[0]) && parseInt(args[1])) {
            exports.ghmattimysql.execute("SELECT * FROM atm_user_ids WHERE user_id = ?", [parseInt(args[0])], (change) => {
                exports.ghmattimysql.execute("SELECT * FROM atm_user_ids WHERE user_id = ?", [parseInt(args[1])], (changeto) => {
                    for (i = 0; i < change.length; i++) {
                        exports.ghmattimysql.execute('UPDATE atm_user_ids SET user_id = ? WHERE identifier = ?', [parseInt(args[1]), change[i].identifier])
                    }
                    for (i = 0; i < changeto.length; i++) {
                        exports.ghmattimysql.execute('UPDATE atm_user_ids SET user_id = ? WHERE identifier = ?', [parseInt(args[0]), changeto[i].identifier])
                    }
                    exports.ghmattimysql.execute("SELECT * FROM atm_user_data WHERE user_id = ?", [parseInt(args[0])], async(change) => {
                        exports.ghmattimysql.execute("SELECT * FROM atm_user_data WHERE user_id = ?", [parseInt(args[1])], async(changeto) => {
                            // Change USER DATA
                            await exports.ghmattimysql.execute("DELETE FROM atm_user_data WHERE user_id = ?", [parseInt(args[0])])
                            await exports.ghmattimysql.execute("DELETE FROM atm_user_data WHERE user_id = ?", [parseInt(args[1])])
                            for (i = 0; i < change.length; i++) {
                                exports.ghmattimysql.execute('INSERT INTO atm_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(args[1]), "ATM:datatable", change[i].dvalue])
                            }
                            for (i = 0; i < changeto.length; i++) {
                                exports.ghmattimysql.execute('INSERT INTO atm_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(args[0]), "ATM:datatable", changeto[i].dvalue])
                            }
                        })
                    })
                    exports.ghmattimysql.execute("SELECT * FROM atm_user_data WHERE user_id = ?", [parseInt(args[0])], (change) => {
                        exports.ghmattimysql.execute("SELECT * FROM atm_user_data WHERE user_id = ?", [parseInt(args[1])], (changeto) => {
                            // Change USER DATA
                            exports.ghmattimysql.execute("DELETE FROM atm_user_data WHERE user_id = ?", [parseInt(args[0])])
                            exports.ghmattimysql.execute("DELETE FROM atm_user_data WHERE user_id = ?", [parseInt(args[1])])
                            setTimeout(() => {

                                for (i = 0; i < change.length; i++) {
                                    exports.ghmattimysql.execute('INSERT INTO atm_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(args[1]), "ATM:datatable", change[i].dvalue])
                                }
                                for (i = 0; i < changeto.length; i++) {
                                    exports.ghmattimysql.execute('INSERT INTO atm_user_data (user_id, dkey, dvalue) VALUES(?,?,?)', [parseInt(args[0]), "ATM:datatable", changeto[i].dvalue])
                                }
                            }, 500);
                        })
                    })
                    exports.ghmattimysql.execute("SELECT * FROM atm_user_moneys WHERE user_id = ?", [parseInt(args[0])], (change) => {
                        exports.ghmattimysql.execute("SELECT * FROM atm_user_moneys WHERE user_id = ?", [parseInt(args[1])], (changeto) => {
                            for (i = 0; i < change.length; i++) {
                                exports.ghmattimysql.execute('UPDATE atm_user_vehicles SET user_id = ? WHERE vehicle = ?', [parseInt(args[1]), change[i].vehicle])
                            }
                            for (i = 0; i < changeto.length; i++) {
                                exports.ghmattimysql.execute('UPDATE atm_user_vehicles SET user_id = ? WHERE vehicle = ?', [parseInt(args[0]), changeto[i].vehicle])
                            }
                        })
                    })
                    exports.ghmattimysql.execute("SELECT * FROM atm_user_vehicles WHERE user_id = ?", [parseInt(args[0])], (change) => {
                        exports.ghmattimysql.execute("SELECT * FROM atm_user_vehicles WHERE user_id = ?", [parseInt(args[1])], (changeto) => {
                            for (i = 0; i < change.length; i++) {
                                setInterval(() => {
                                    exports.ghmattimysql.execute('UPDATE atm_user_vehicles SET user_id = ? WHERE vehicle = ?', [parseInt(args[1]), change[i].vehicle])
                                }, 2000);
                            }
                            for (i = 0; i < changeto.length; i++) {
                                setInterval(() => {
                                    exports.ghmattimysql.execute('UPDATE atm_user_vehicles SET user_id = ? WHERE vehicle = ?', [parseInt(args[0]), changeto[i].vehicle])
                                }, 2000);
                            }

                        })
                    })
                    exports.ghmattimysql.execute("SELECT * FROM atm_user_homes WHERE user_id = ?", [parseInt(args[0])], (change) => {
                        exports.ghmattimysql.execute("SELECT * FROM atm_user_homes WHERE user_id = ?", [parseInt(args[1])], (changeto) => {
                            for (i = 0; i < change.length; i++) {
                                exports.ghmattimysql.execute('UPDATE atm_user_homes SET user_id = ? WHERE home = ?', [parseInt(args[1]), change[i].home])
                            }
                            for (i = 0; i < changeto.length; i++) {
                                exports.ghmattimysql.execute('UPDATE atm_user_homes SET user_id = ? WHERE home = ?', [parseInt(args[0]), changeto[i].home])
                            }
                        })
                    })
                    message.reply('ID successfully changed. Changed: ' + args[0] + " to " + args[1])
                    let embed = {
                        "color": 13573662,
                        "title": "Bot Log",
                        "description": `\n\n${message.author.tag} ID successfully changed. Changed: ${args[0]} to ${args[1]}`
                    }
                    client.channels.get('827894506481385523').send({ embed: embed })
                })
            })
        } else {
            message.reply('Invalid usage! .changeid [currentpermid] [permidtochangeto] - DOESNT WORK DO NOT DO THIS')
        }
    }

});



client.login("OTY4ODkwNTc1NTM1Mzc0MzM2.Ymlbqg.hSd7jLZxBAEohbgbR3iLZfuMb5k");