local CorePackages = game:GetService("CorePackages")

local Actions = CorePackages.AppTempCommon.LuaApp.Actions
local Requests = require(CorePackages.Workspace.Packages.Http).Requests

local UsersGetFriendCount = Requests.UsersGetFriendCount
local SetFriendCount = require(Actions.SetFriendCount)

local isNewFriendsEndpointsEnabled = require(CorePackages.Workspace.Packages.SharedFlags).isNewFriendsEndpointsEnabled

return function(networkImpl)
	return function(store)
		return UsersGetFriendCount(networkImpl):andThen(function(result)
			local data = result.responseBody

			if isNewFriendsEndpointsEnabled() then
				if data.count then
					store:dispatch(SetFriendCount(data.count))
				end
			else
				if data.success and data.count then
					store:dispatch(SetFriendCount(data.count))
				end
			end

			return data.count
		end)
	end
end
