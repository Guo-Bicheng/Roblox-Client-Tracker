local UserLib = script:FindFirstAncestor("UserLib")

local User = require(UserLib.Models.User)

return {
	[0] = User.PresenceType.OFFLINE,
	[1] = User.PresenceType.ONLINE,
	[2] = User.PresenceType.IN_GAME,
	[3] = User.PresenceType.IN_STUDIO,
}