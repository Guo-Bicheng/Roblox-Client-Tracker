--[[
	This Roact component contains 3 buttons that deal with enabling/disabling
	permissions.

	- Device Microphone
	- Device Camera
	- Mute All
]]
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local FaceAnimatorService = game:GetService("FaceAnimatorService")
local StarterGui = game:GetService("StarterGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Roact = require(CorePackages.Roact)
local UIBlox = require(CorePackages.UIBlox)
local t = require(CorePackages.Packages.t)

local toggleSelfViewSignal = require(RobloxGui.Modules.SelfView.toggleSelfViewSignal)
local selfViewVisibilityUpdatedSignal = require(RobloxGui.Modules.SelfView.selfViewVisibilityUpdatedSignal)
local selfViewCloseButtonSignal = require(RobloxGui.Modules.SelfView.selfViewCloseButtonSignal)
local getCamMicPermissions = require(RobloxGui.Modules.Settings.getCamMicPermissions)
local SelfViewAPI = require(RobloxGui.Modules.SelfView.publicApi)

local ExternalEventConnection = UIBlox.Utility.ExternalEventConnection
local Images = UIBlox.App.ImageSet.Images

local Modules = CoreGui.RobloxGui.Modules
local PermissionButton = require(Modules.Settings.Components.PermissionButton)
local VoiceChatServiceManager = require(Modules.VoiceChat.VoiceChatServiceManager).default

local FFlagSelfViewFixes = require(RobloxGui.Modules.Flags.FFlagSelfViewFixes)
local FFlagSelfViewFixesTwo = require(RobloxGui.Modules.Flags.FFlagSelfViewFixesTwo)

local PermissionsButtons = Roact.PureComponent:extend("PermissionsButtons")

local PADDING_SIZE = 24
local DIVIDER_HEIGHT = 24
local Y_HEIGHT = 38

local VIDEO_IMAGE = Images["icons/controls/video"]
local VIDEO_OFF_IMAGE = Images["icons/controls/videoOff"]
local MIC_IMAGE = Images["icons/controls/microphone"]
local MIC_OFF_IMAGE = Images["icons/controls/microphoneMute"]
local SELF_VIEW_IMAGE = Images["icons/controls/selfie"]
local SELF_VIEW_OFF_IMAGE = Images["icons/controls/selfieOff"]
local MUTE_ALL_IMAGE = Images["icons/controls/headphone"]
local UNMUTE_ALL_IMAGE = Images["icons/controls/headphoneDeafen"]

PermissionsButtons.validateProps = t.strictInterface({
	isPortrait = t.boolean,
	isSmallTouchScreen = t.boolean,
	isTenFootInterface = t.boolean,
	ZIndex = t.number,
	LayoutOrder = t.number,
	shouldFillScreen = t.boolean,
	selfViewOpen = t.boolean,
})

local function createDivider(layoutOrder)
	return Roact.createElement("Frame", {
		LayoutOrder = layoutOrder,
		Size = UDim2.new(0, 2, 0, DIVIDER_HEIGHT),
		BorderSizePixel = 0,
		BackgroundTransparency = 0.2,
	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0.5, 0),
		})
	})
end

function PermissionsButtons:init()
	self:setState({
		allPlayersMuted = false,
		microphoneEnabled = not VoiceChatServiceManager.localMuted or false,
		cameraEnabled = if FaceAnimatorService then FaceAnimatorService.VideoAnimationEnabled else false,
		selfViewOpen = self.props.selfViewOpen,
		showSelfView = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.SelfView),
		hasCameraPermissions = false,
		hasMicPermissions = false,
	})

	if not FFlagSelfViewFixes then
		self.selfViewCloseButtonSignal = selfViewCloseButtonSignal:connect(function()
			self:setState({
				selfViewOpen = not self.state.selfViewOpen,
			})
		end)
	end

	if FFlagSelfViewFixesTwo then
		self.selfViewVisibilityUpdatedSignal = selfViewVisibilityUpdatedSignal:connect(function()
			self:setState({
				selfViewOpen = SelfViewAPI.getSelfViewIsOpenAndVisible()
			})
		end)
	end

	-- Mute all players in the lobby
	self.toggleMuteAll = function()
		local newAllPlayersMuted = not self.state.allPlayersMuted
		VoiceChatServiceManager:MuteAll(newAllPlayersMuted)
		self:setState({
			allPlayersMuted = newAllPlayersMuted,
		})
	end

	-- toggle mic permissions
	self.toggleMic = function()
		VoiceChatServiceManager:ToggleMic()
		-- this.SecondButton.Image = pollImage() TODO Update Icon

		local didDisableMic = not VoiceChatServiceManager.localMuted
		-- Camera is tied to the microphone being enabled.
		if didDisableMic and FaceAnimatorService.VideoAnimationEnabled then
			FaceAnimatorService.VideoAnimationEnabled = false
		end

		self:setState({
			cameraEnabled = FaceAnimatorService.VideoAnimationEnabled,
			microphoneEnabled = not VoiceChatServiceManager.localMuted,
		})
	end

	-- toggle video permissions
	self.toggleVideo = function()
		if not FaceAnimatorService then
			return
		end

		FaceAnimatorService.VideoAnimationEnabled = not FaceAnimatorService.VideoAnimationEnabled

		self:setState({
			cameraEnabled = FaceAnimatorService.VideoAnimationEnabled
		})
	end

	-- toggle self view visibility
	self.toggleSelfView = function()
		toggleSelfViewSignal:fire()
		self:setState({
			selfViewOpen = not self.state.selfViewOpen,
		})
	end

	self.muteChangedEvent = function(muted)
		-- Video is tied to audio being enabled.
		if muted and FaceAnimatorService.VideoAnimationEnabled then
			FaceAnimatorService.VideoAnimationEnabled = false
		end

		self:setState({
			cameraEnabled = FaceAnimatorService.VideoAnimationEnabled,
			microphoneEnabled = not muted
		})
	end

	self.onSelfViewVisibilityUpdated = function()
		self:setState({
			selfViewOpen = SelfViewAPI.getSelfViewIsOpenAndVisible()
		})
	end

	self.onCoreGuiChanged = function()
		local coreGuiState = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.SelfView)
		if self.state.showSelfView ~= coreGuiState then
			self:setState({
				showSelfView = coreGuiState
			})
		end
	end
end

--[[
	Check if Roblox has permissions for camera/mic access.
]]
function PermissionsButtons:getPermissions()
	local callback = function(response)
		self:setState({
			hasCameraPermissions = response.hasCameraPermissions,
			hasMicPermissions = response.hasMicPermissions,
		})
	end
	getCamMicPermissions(callback)
end

function PermissionsButtons:didMount()
	self:getPermissions()
end

function PermissionsButtons:render()
	local shouldShowMicButtons = self.state.hasMicPermissions
	local shouldShowCameraButtons = self.state.hasCameraPermissions
	local isTopCloseButton = not self.props.isPortrait and not self.props.isTenFootInterface and not self.props.isSmallTouchScreen

	return Roact.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.XY,
		ZIndex = self.props.ZIndex,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(self.props.shouldFillScreen and 1 or 0, 0, 0, 0),
		AnchorPoint = if isTopCloseButton then Vector2.new(0, 0) else Vector2.new(0.5, 0.5),
		LayoutOrder = self.props.LayoutOrder,
		Visible = not self.props.isTenFootInterface, -- Not Visible on Xbox
	}, {
		UIPaddingPermissionsContainer = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 74), -- Close Button location
			PaddingTop = UDim.new(0, 4), -- Top Padding from button to edge of screen
		}),
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, PADDING_SIZE),
		}),
		Divider1 = createDivider(1),
		Container = Roact.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, Y_HEIGHT),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			LayoutOrder = 2,
		}, {
			UIListLayoutPermissionsContainer = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, PADDING_SIZE),
			}),
			MuteAllButton = shouldShowMicButtons and Roact.createElement(PermissionButton, {
				LayoutOrder = 1,
				image = if self.state.allPlayersMuted then MUTE_ALL_IMAGE else UNMUTE_ALL_IMAGE,
				callback = self.toggleMuteAll,
			}),
			ToggleMicButton = shouldShowMicButtons and Roact.createElement(PermissionButton, {
				LayoutOrder = 2,
				image = if self.state.microphoneEnabled then MIC_IMAGE else MIC_OFF_IMAGE,
				callback = self.toggleMic,
			}),
			EnableVideoButton = shouldShowCameraButtons and Roact.createElement(PermissionButton, {
				LayoutOrder = 3,
				image = if self.state.cameraEnabled then VIDEO_IMAGE else VIDEO_OFF_IMAGE,
				callback = self.toggleVideo,
			}),
			EnableSelfViewButton = self.state.showSelfView and Roact.createElement(PermissionButton, {
				LayoutOrder = 4,
				image = if self.state.selfViewOpen then SELF_VIEW_IMAGE else SELF_VIEW_OFF_IMAGE,
				callback = self.toggleSelfView,
			}),
		}),
		Divider2 = createDivider(3),
		MuteChangedEvent = Roact.createElement(ExternalEventConnection, {
			event = VoiceChatServiceManager.muteChanged.Event,
			callback = self.muteChangedEvent,
		}),
		SelfViewChangedEvent = Roact.createElement(ExternalEventConnection, {
			event = StarterGui.CoreGuiChangedSignal,
			callback = self.onCoreGuiChanged,
		}),
		SelfViewVisbilityChangedEvent = FFlagSelfViewFixes and not FFlagSelfViewFixesTwo and Roact.createElement(ExternalEventConnection, {
			event = selfViewVisibilityUpdatedSignal,
			callback = self.onSelfViewVisibilityUpdated,
		}) or nil,
	})
end

function PermissionsButtons:willUnmount()
	if not FFlagSelfViewFixes and self.selfViewCloseButtonSignal then
		self.selfViewCloseButtonSignal:disconnect()
	end

	if FFlagSelfViewFixesTwo and self.selfViewVisibilityUpdatedSignal then
		self.selfViewVisibilityUpdatedSignal:disconnect()
		self.selfViewVisibilityUpdatedSignal = nil
	end
end

return PermissionsButtons
