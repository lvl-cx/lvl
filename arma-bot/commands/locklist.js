const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    let embed = {
        "title": "ARMA Lock List",
        "description": `https://docs.google.com/spreadsheets/d/1qAtkhyNzyBusQx4q2w-qFL6pEBUCTbMA7wljAvzFb40/edit?usp=sharing`,
        "color": settingsjson.settings.botColour,
        "footer": {
            "text": ""
        },
        "timestamp": new Date()
    }
    message.channel.send({ embed })
}

exports.conf = {
    name: "locklist",
    perm: 0,
    guild: "975490533344559154"
}