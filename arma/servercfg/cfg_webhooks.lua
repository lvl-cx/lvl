local webhooks = {}
-- THESE LOGS CAN BE TURNED OFF BY CHANGING THE VALUE TO 'NONE'
-- THESE LOGS ONLY LOG user_id + source_id




-- ADMIN LOGS
webhooks.banlog = 'none' -- when a player is kicked
webhooks.unbanlog = 'none' -- when a player is unbanned
webhooks.kicklog = 'hone' -- when an admin kicks a player


-- JOIN/LEAVE LOGS

webhooks.spawnlog = 'https://discord.com/api/webhooks/972460581246353458/F9UWs44upvXoBbmqkIgPn-sQ3GHUhfG3QpIQ032_3hElNAS6tdi9LHzGCTmUuxgJYcxO' -- when player passes queue and is spawned.
webhooks.leavelog = 'https://discord.com/api/webhooks/972460642911023184/PQ6lMII6C8w2R_Bxf1YsQjzOrErMeRGlu9oV2FLP7r33YK1tH6A8NMsCmIM3pxHCPt2V' -- when any player leaves server.




return webhooks