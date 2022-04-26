RegisterNetEvent("ATMNotify:default")
AddEventHandler("ATMNotify:default", function(message,position,color,textColor,timeout,progress)
    Default(message,position,color,textColor,timeout,progress)
end)

function Default(message,position,color,textColor,timeout,progress)
    SendNUIMessage({
        response = "show_default_notification",
        data = {
            message = message,
            position = position,
            color = color,
            textColor = textColor,
            timeout = timeout,
            progress = progress,
        }
    })
end

RegisterNetEvent("ATMNotify:caption")
AddEventHandler("ATMNotify:caption", function(caption,message,position,timeout,color,textColor,progress)
    Caption(caption,message,position,timeout,color,textColor,progress)
end)

function Caption(caption,message,position,timeout,color,textColor,progress)
    SendNUIMessage({
        response = "show_caption_notification",
        data = {
            caption = caption,
            message = message,
            position = position,
            color = color,
            textColor = textColor,
            timeout = timeout,
            progress = progress,
        }
    })
end

RegisterNetEvent("ATMNotify:Warning")
AddEventHandler("ATMNotify:Warning", function(caption,message,position,timeout,progress)
    Warning(caption,message,position,timeout,progress)
end)

function Warning(caption,message,position,timeout,progress)
    SendNUIMessage({
        response = "show_warning",
        data = {
            caption = caption,
            message = message,
            position = position,
            timeout = timeout,
            progress = progress,
        }
    })
end

RegisterNetEvent("ATMNotify:Success")
AddEventHandler("ATMNotify:Success", function(caption,message,position,timeout,progress)
    Success(caption,message,position,timeout,progress)
end)

function Success(caption,message,position,timeout,progress)
    SendNUIMessage({
        response = "show_success",
        data = {
            caption = caption,
            message = message,
            position = position,
            timeout = timeout,
            progress = progress,
        }
    })
end

RegisterNetEvent("ATMNotify:Info")
AddEventHandler("ATMNotify:Info", function(caption,message,position,timeout,progress)
    Info(caption,message,position,timeout,progress)
end)

function Info(caption,message,position,timeout,progress)
    SendNUIMessage({
        response = "show_info",
        data = {
            caption = caption,
            message = message,
            position = position,
            timeout = timeout,
            progress = progress,
        }
    })
end

RegisterNetEvent("ATMNotify:Negative")
AddEventHandler("ATMNotify:Negative", function(caption,message,position,timeout,progress)
    Negative(caption,message,position,timeout,progress)
end)

function Negative(caption,message,position,timeout,progress)
    SendNUIMessage({
        response = "show_negative",
        data = {
            caption = caption,
            message = message,
            position = position,
            timeout = timeout,
            progress = progress,
        }
    })
end

RegisterNetEvent("ATMNotify:captionIcon")
AddEventHandler("ATMNotify:captionIcon", function(caption,message,position,timeout,color,textColor,progress,icon)
    CaptionIcon(caption,message,position,timeout,color,textColor,progress,icon)
end)

function CaptionIcon(caption,message,position,timeout,color,textColor,progress,icon)
    SendNUIMessage({
        response = "show_icon_caption_notification",
        data = {
            caption=caption,
            message = message,
            position = position,
            color = color,
            textColor = textColor,
            timeout = timeout,
            progress = progress,
            icon = icon
        }
    })
end

RegisterNetEvent("ATMNotify:Icon")
AddEventHandler("ATMNotify:Icon", function(message,position,timeout,color,textColor,progress,icon)
    Icon(message,position,timeout,color,textColor,progress,icon)
end)

function Icon(message,position,timeout,color,textColor,progress,icon)
    SendNUIMessage({
        response = "show_icon_icon_notification",
        data = {
            message = message,
            position = position,
            color = color,
            textColor = textColor,
            timeout = timeout,
            progress = progress,
            icon = icon
        }
    })
end
