local CorePackages = game:GetService("CorePackages")
local ApiFetchGameIcons = require(CorePackages.AppTempCommon.LuaApp.Thunks.ApiFetchGameIcons)
local Functional = require(CorePackages.Workspace.Packages.AppCommonLib).Functional
local GamesMultigetPlaceDetails = require(CorePackages.Workspace.Packages.Http).Requests.GamesMultigetPlaceDetails
local PlaceInfoModel = require(CorePackages.AppTempCommon.LuaChat.Models.PlaceInfoModel)
local ReceivedPlacesInfos = require(CorePackages.AppTempCommon.LuaApp.Actions.ReceivedPlacesInfos)

local convertUniverseIdToString = require(CorePackages.Workspace.Packages.SharedFlags).ConvertUniverseIdToString

return function(networkImpl, placeIds)
	return function(store)
		if not placeIds or #placeIds == 0 then
			return
		end

		return GamesMultigetPlaceDetails(networkImpl, placeIds):andThen(function(result)
			local data = result.responseBody

			local thumbnailUniverseIds = {}
			local placeInfos = Functional.Map(data, function(placeInfoData)
				local placeInfo =  PlaceInfoModel.fromWeb(placeInfoData)
				local universeId = convertUniverseIdToString(placeInfo.universeId)
				table.insert(thumbnailUniverseIds, universeId)
				return placeInfo
			end)

			store:dispatch(ReceivedPlacesInfos(placeInfos))

			if #thumbnailUniverseIds > 0 then
				store:dispatch(ApiFetchGameIcons(networkImpl, thumbnailUniverseIds))
			end

			return placeInfos
		end)
	end
end
