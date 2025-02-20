local Url = require(script.Parent.Parent.Url)

return function(requestImpl, placeIds)
	local argTable = {
		placeIds = placeIds,
	}

	-- construct the url
	local args = Url:makeQueryString(argTable)
	local url = string.format("%s/v1/games/multiget-place-details?%s",
		Url.GAME_URL, args
	)

	return requestImpl(url, "GET")
end
