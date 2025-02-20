local TextChatService = game:GetService("TextChatService")
local ExperienceChat = script:FindFirstAncestor("ExperienceChat")
local ProjectRoot = ExperienceChat.Parent

local Roact = require(ProjectRoot.Roact)
local llama = require(ProjectRoot.llama)
local Dictionary = llama.Dictionary

local Config = require(ExperienceChat.Config)

local UI = script:FindFirstAncestor("UI")
local ScrollingView = require(UI.ScrollingView)
local TextMessageLabel = require(UI.TextMessageLabel)

local ChatWindow = Roact.Component:extend("ChatWindow")
-- @TODO: Handle default textChannelId RBXGeneral more elegantly
ChatWindow.defaultProps = {
	LayoutOrder = 1,
	size = UDim2.fromScale(1, 1),
	messages = {},
	transparencyValue = Config.ChatWindowBackgroundTransparency,
	textTransparency = 0,
	mutedUserIds = {},
	canLocalUserChat = false,
}

function ChatWindow:init()
	self.getTransparencyOrBindingValue = function(initialTransparency, bindingOrValue)
		if type(bindingOrValue) == "number" then
			return self.props.transparencyValue
		end

		return bindingOrValue:map(function(value)
			return initialTransparency + value * (1 - initialTransparency)
		end)
	end

	self.onTextMessageLabelButtonActivated = function(message)
		self.props.resetTargetChannel()
		local fromUserId = tonumber(message.userId)
		self.props.activateWhisperMode(fromUserId)
	end

	local function isSystemMessage(message): boolean
		return message.userId == nil
	end
	local function shouldShowMessage(message)
		if self.props.canLocalUserChat then
			if
				message.status == Enum.TextChatMessageStatus.Success
				or message.status == Enum.TextChatMessageStatus.Sending
			then
				-- make bubble chat messages not appear in chat window
				if message.partOrModel then
					return false
				end

				return message.visible
			end
		else
			return isSystemMessage(message)
		end

		return false
	end

	self.createChildren = function(messages)
		local children = Dictionary.map(messages, function(message, index)
			if shouldShowMessage(message) then
				return Roact.createElement(TextMessageLabel, {
					message = message,
					LayoutOrder = index,
					textTransparency = self.getTransparencyOrBindingValue(0, self.props.textTransparency),
					textStrokeTransparency = self.getTransparencyOrBindingValue(
						self.props.chatWindowSettings.TextStrokeTransparency,
						self.props.textTransparency
					),
					onTextMessageLabelButtonActivated = self.onTextMessageLabelButtonActivated,
					chatWindowSettings = self.props.chatWindowSettings,
				}),
					message.messageId
			else
				return nil
			end
		end)

		children["$layout"] = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, 4),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		return children
	end
end

function ChatWindow:render()
	local chatWindowSettings = self.props.chatWindowSettings
	return Roact.createElement("Frame", {
		BackgroundColor3 = chatWindowSettings.BackgroundColor3,
		BorderSizePixel = 0,
		LayoutOrder = self.props.LayoutOrder,
		Size = self.props.size,
		Visible = self.props.visible,
		BackgroundTransparency = self.getTransparencyOrBindingValue(
			chatWindowSettings.BackgroundTransparency,
			self.props.transparencyValue
		),
		[Roact.Event.MouseEnter] = self.props.onHovered,
		[Roact.Event.MouseLeave] = self.props.onUnhovered,
		[Roact.Change.AbsoluteSize] = function(rbx)
			local chatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")
			if chatWindowConfiguration and self.props.onAbsoluteSizeChanged then
				self.props.onAbsoluteSizeChanged(rbx, chatWindowConfiguration)
			end
		end,
		[Roact.Change.AbsolutePosition] = function(rbx)
			local chatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")
			if chatWindowConfiguration and self.props.onAbsoluteSizeChanged then
				self.props.onAbsolutePositionChanged(rbx, chatWindowConfiguration)
			end
		end,
	}, {
		uiSizeConstraint = Roact.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(Config.ChatWindowMaxWidth, Config.ChatWindowMaxHeight),
		}),
		scrollingView = Roact.createElement(ScrollingView, {
			size = self.props.size,
		}, self.createChildren(self.props.messages)),
	})
end

return ChatWindow
