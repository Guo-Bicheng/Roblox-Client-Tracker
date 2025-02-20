local NetworkingVirtualEvents = script:FindFirstAncestor("NetworkingVirtualEvents")

local types = require(NetworkingVirtualEvents.types)

local function createMockVirtualEventResponse(virtualEventId: string): types.VirtualEventResponse
	return {
		id = virtualEventId,
		title = "Event Title",
		description = "Event description...",
		host = {
			hostType = "user",
			hostId = 1,
			hostName = "Roblox",
			hasVerifiedBadge = false,
		},
		eventTime = {
			startUtc = DateTime.fromLocalTime(2022, 1, 1):ToIsoDate(),
			endUtc = DateTime.fromLocalTime(2022, 1, 7):ToIsoDate(),
		},
		universeId = 1,
		eventStatus = "active",
		createdUtc = DateTime.fromLocalTime(2022, 1, 1):ToIsoDate(),
		updatedUtc = DateTime.fromLocalTime(2022, 1, 1):ToIsoDate(),
		userRsvpStatus = "none",
	}
end

return createMockVirtualEventResponse
