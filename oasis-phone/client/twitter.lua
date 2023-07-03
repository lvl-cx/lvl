--====================================================================================
-- #Author: Jonathan D @ Gannon
--====================================================================================

RegisterNetEvent("OASIS:twitter_getTweets")
AddEventHandler("OASIS:twitter_getTweets", function(tweets)
  SendNUIMessage({event = 'twitter_tweets', tweets = tweets})
end)

RegisterNetEvent("OASIS:twitter_getFavoriteTweets")
AddEventHandler("OASIS:twitter_getFavoriteTweets", function(tweets)
  SendNUIMessage({event = 'twitter_favoritetweets', tweets = tweets})
end)

RegisterNetEvent("OASIS:twitter_newTweets")
AddEventHandler("OASIS:twitter_newTweets", function(tweet)
  SendNUIMessage({event = 'twitter_newTweet', tweet = tweet})
end)

RegisterNetEvent("OASIS:twitter_updateTweetLikes")
AddEventHandler("OASIS:twitter_updateTweetLikes", function(tweetId, likes)
  SendNUIMessage({event = 'twitter_updateTweetLikes', tweetId = tweetId, likes = likes})
end)

RegisterNetEvent("OASIS:twitter_setAccount")
AddEventHandler("OASIS:twitter_setAccount", function(username, password, avatarUrl)
  SendNUIMessage({event = 'twitter_setAccount', username = username, password = password, avatarUrl = avatarUrl})
end)

RegisterNetEvent("OASIS:twitter_createAccount")
AddEventHandler("OASIS:twitter_createAccount", function(account)
  SendNUIMessage({event = 'twitter_createAccount', account = account})
end)

RegisterNetEvent("OASIS:twitter_showError")
AddEventHandler("OASIS:twitter_showError", function(title, message)
  SendNUIMessage({event = 'twitter_showError', message = message, title = title})
end)

RegisterNetEvent("OASIS:twitter_showSuccess")
AddEventHandler("OASIS:twitter_showSuccess", function(title, message)
  SendNUIMessage({event = 'twitter_showSuccess', message = message, title = title})
end)

RegisterNetEvent("OASIS:twitter_setTweetLikes")
AddEventHandler("OASIS:twitter_setTweetLikes", function(tweetId, isLikes)
  SendNUIMessage({event = 'twitter_setTweetLikes', tweetId = tweetId, isLikes = isLikes})
end)



RegisterNUICallback('twitter_login', function(data, cb)
  TriggerServerEvent('OASIS:twitter_login', data.username, data.password)
end)

RegisterNUICallback('twitter_getTweets', function(data, cb)
  TriggerServerEvent('OASIS:twitter_getTweets')
end)

RegisterNUICallback('twitter_getFavoriteTweets', function(data, cb)
  TriggerServerEvent('OASIS:twitter_getFavoriteTweets')
end)

RegisterNUICallback('twitter_postTweet', function(data, cb)
  TriggerServerEvent('OASIS:twitter_postTweets', data.message)
end)

RegisterNUICallback('twitter_postTweetImg', function(data, cb)
  TriggerServerEvent('OASIS:twitter_postTweets', data.username or '', data.password or '', data.message)
end)

RegisterNUICallback('twitter_toggleLikeTweet', function(data, cb)
  TriggerServerEvent('OASIS:likeTweet',data.tweetId)
end)

RegisterNUICallback('twitter_setAvatarUrl', function(data, cb)
    TriggerServerEvent("OASIS:setTwitterAvatar", data.avatarUrl)
end)
