local ExperienceChat = script:FindFirstAncestor("ExperienceChat")
local ProjectRoot = ExperienceChat.Parent
local Roact = require(ProjectRoot.Roact)
local RoactRodux = require(ProjectRoot.RoactRodux)

local ControlsBubble = require(script.Parent)
local ChatSettings = require(ExperienceChat.installReducer.BubbleChat.LegacySettings)

local createStore = require(ExperienceChat.createStore)
local story = Roact.Component:extend("story")

function story:init()
	self.store = createStore()
end

function story:render()
	local props = self.props
	local controls = self.props.controls
	return Roact.createElement(RoactRodux.StoreProvider, {
		store = self.store,
	}, {
		controlsBubble = Roact.createElement(ControlsBubble, {
			chatSettings = ChatSettings,
			isInsideMaximizeDistance = true,
			isLocalPlayer = true,
			userId = props.userId,
			LayoutOrder = 1,
			getIcon = props.getIcon,
			hasCameraPermissions = controls.hasCameraPermissions,
			hasMicPermissions = controls.hasMicPermissions,
			voiceState = controls.voiceState,
			onClickedVoiceIndicator = function() end,
			onClickedCameraIndicator = function() end,
			getPermissions = function()
				return true, true
			end,
		}),
	})
end

return {
	summary = "Controls Bubble",
	story = story,
	controls = {
		hasCameraPermissions = { true, false },
		hasMicPermissions = { true, false },
		voiceState = { "Inactive", "Talking", "Connecting", "Muted", "LOCAL_MUTED", "Error", "Hidden" },
	},
	props = {
		userId = "userId",
		getIcon = function(name, folder)
			local folderStr = folder and folder .. "/" or ""
			return "rbxasset://textures/ui/VoiceChat/" .. folderStr .. name .. ".png"
		end,
	},
}
