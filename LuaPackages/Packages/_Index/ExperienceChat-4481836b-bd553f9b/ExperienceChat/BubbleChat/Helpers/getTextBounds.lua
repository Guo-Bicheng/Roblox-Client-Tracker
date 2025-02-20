local CoreGui = game:GetService("CoreGui")
local getTextBounds = function(text: string, chatSettings)
	local SizingGui = Instance.new("ScreenGui")
	SizingGui.Enabled = false
	SizingGui.Name = "RichTextSizingLabel"
	SizingGui.Parent = CoreGui

	local SizingLabel = Instance.new("TextLabel")
	SizingLabel.TextWrapped = true
	SizingLabel.RichText = true
	SizingLabel.Parent = SizingGui
	SizingLabel.Text = text
	SizingLabel.TextSize = chatSettings.TextSize
	SizingLabel.Font = chatSettings.Font
	SizingLabel.Size = UDim2.fromOffset(chatSettings.MaxWidth, 10000)

	local textBounds = SizingLabel.TextBounds

	-- Clean up SizingGui and SizingLabel
	SizingGui:Destroy()

	local padding = Vector2.new(chatSettings.Padding * 4, chatSettings.Padding * 2)
	return textBounds + padding
end

return getTextBounds
