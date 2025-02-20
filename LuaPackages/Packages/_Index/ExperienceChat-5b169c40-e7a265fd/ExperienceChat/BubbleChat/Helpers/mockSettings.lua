return {
	BubbleDuration = 15,
	MaxBubbles = 3,
	BackgroundColor3 = Color3.fromRGB(250, 250, 250),
	TextColor3 = Color3.fromRGB(57, 59, 61),
	TextSize = 16,
	Font = Enum.Font.GothamMedium,
	Transparency = 0.1,
	CornerEnabled = true,
	CornerRadius = UDim.new(0, 12),
	TailVisible = true,
	Padding = 8,
	MaxWidth = 300,
	BackgroundImage = {
		Image = "",
		ImageColor3 = Color3.new(1, 1, 1),
		ImageRectOffset = Vector2.new(),
		ImageRectSize = Vector2.new(),
		ScaleType = Enum.ScaleType.Stretch,
		SliceCenter = Rect.new(Vector2.new(), Vector2.new()),
		SliceScale = 1,
		TileSize = UDim2.fromScale(1, 1),
	},
	BackgroundGradient = {
		Enabled = false,
		Color = ColorSequence.new(Color3.fromRGB(150, 150, 150), Color3.fromRGB(250, 250, 250)),
		Offset = Vector2.new(),
		Rotation = 0,
		Transparency = NumberSequence.new(0),
	},
	SizeAnimation = {
		Enabled = true,
		SpringDampingRatio = 1,
		SpringFrequency = 2,
	},
	TransparencyAnimation = {
		Enabled = true,
		SpringDampingRatio = 1,
		SpringFrequency = 2,
	},
	VerticalStudsOffset = 0,
	LocalPlayerStudsOffset = Vector3.new(0, 0, 2),
	BubblesSpacing = 6,
	MinimizeDistance = 40,
	MaxDistance = 100,
	AdorneeName = "HumanoidRootPart",
	Voice = {
		ShowIndicator = true,
	},
	UserSpecificSettings = {},
}
