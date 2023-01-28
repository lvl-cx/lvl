// const resourcePath = global.GetResourcePath ?
//     global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
// const settingsjson = require(resourcePath + '/settings.js')

// exports.runcmd = (fivemexports, client, message, params) => {
//     let embed = {
//         "title": "ARMA Trader Discord",
//         "description": `https://discord.gg/X5hV8E39Sf`,
//         "color": settingsjson.settings.botColour,
//         "footer": {
//             "text": ""
//         },
//         "timestamp": new Date()
//     }
//     message.channel.send({ embed })
// }

exports.conf = {
    name: "trader",
    perm: 0,
    guild: "975490533344559154"
}