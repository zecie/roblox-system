local UIComponents = require(script.Parent.UIComponents)

local SettingsPanel = {}

function SettingsPanel.create(screenGui: ScreenGui): Frame
	local panel = UIComponents.createGlassPanel({
		name = "SettingsPanel",
		size = UDim2.new(0, 380, 0, 500),
		position = UDim2.new(0.5, 0, 0.5, 0),
		parent = screenGui,
		anchorPoint = Vector2.new(0.5, 0.5),
		transparency = 0.1,
		cornerRadius = 18,
		zIndex = 10,
	})

	local headerBar = Instance.new("Frame")
	headerBar.Name = "HeaderBar"
	headerBar.Size = UDim2.new(1, 0, 0, 50)
	headerBar.BackgroundColor3 = UIComponents.Colors.AccentPrimary
	headerBar.BackgroundTransparency = 0.85
	headerBar.BorderSizePixel = 0
	headerBar.ZIndex = 11
	headerBar.ClipsDescendants = true
	UIComponents.applyCorner(headerBar, 18)
	UIComponents.applyGradient(headerBar, UIComponents.Colors.AccentSecondary, UIComponents.Colors.AccentPrimary, 0)
	headerBar.Parent = panel

	UIComponents.createIcon({
		text = ":::",
		size = UDim2.new(0, 24, 0, 50),
		position = UDim2.new(0, 16, 0, 0),
		parent = panel,
		color = UIComponents.Colors.TextPrimary,
		textSize = 18,
		zIndex = 12,
	})

	UIComponents.createLabel({
		text = "SETTINGS",
		size = UDim2.new(0, 200, 0, 50),
		position = UDim2.new(0, 44, 0, 0),
		parent = panel,
		font = UIComponents.Fonts.Title,
		textSize = 18,
		color = UIComponents.Colors.TextPrimary,
		zIndex = 12,
		name = "Title",
	})

	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "SettingsScroll"
	scrollFrame.Size = UDim2.new(1, -24, 1, -70)
	scrollFrame.Position = UDim2.new(0, 12, 0, 58)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 3
	scrollFrame.ScrollBarImageColor3 = UIComponents.Colors.AccentPrimary
	scrollFrame.ScrollBarImageTransparency = 0.5
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 680)
	scrollFrame.ZIndex = 11
	scrollFrame.Parent = panel

	local function createSection(title: string, yPos: number): number
		UIComponents.createLabel({
			text = title,
			size = UDim2.new(1, 0, 0, 24),
			position = UDim2.new(0, 4, 0, yPos),
			parent = scrollFrame,
			font = UIComponents.Fonts.Title,
			textSize = 13,
			color = UIComponents.Colors.AccentPrimary,
			zIndex = 12,
		})

		local line = Instance.new("Frame")
		line.Size = UDim2.new(1, -8, 0, 1)
		line.Position = UDim2.new(0, 4, 0, yPos + 24)
		line.BackgroundColor3 = UIComponents.Colors.AccentPrimary
		line.BackgroundTransparency = 0.7
		line.BorderSizePixel = 0
		line.ZIndex = 12
		line.Parent = scrollFrame

		return yPos + 32
	end

	local y = 0

	y = createSection("DISPLAY", y)

	UIComponents.createToggle({
		label = "Fullscreen Mode",
		size = UDim2.new(1, -8, 0, 30),
		position = UDim2.new(0, 4, 0, y),
		parent = scrollFrame,
		initialState = true,
		zIndex = 12,
	})
	y += 36

	UIComponents.createToggle({
		label = "VSync",
		size = UDim2.new(1, -8, 0, 30),
		position = UDim2.new(0, 4, 0, y),
		parent = scrollFrame,
		initialState = false,
		zIndex = 12,
	})
	y += 36

	UIComponents.createSlider({
		label = "Brightness",
		size = UDim2.new(1, -8, 0, 36),
		position = UDim2.new(0, 4, 0, y),
		parent = scrollFrame,
		min = 0,
		max = 100,
		initial = 75,
		zIndex = 12,
	})
	y += 44

	UIComponents.createSlider({
		label = "UI Scale",
		size = UDim2.new(1, -8, 0, 36),
		position = UDim2.new(0, 4, 0, y),
		parent = scrollFrame,
		min = 50,
		max = 150,
		initial = 100,
		zIndex = 12,
	})
	y += 52

	y = createSection("AUDIO", y)

	UIComponents.createSlider({
		label = "Master Volume",
		size = UDim2.new(1, -8, 0, 36),
		position = UDim2.new(0, 4, 0, y),
		parent = scrollFrame,
		min = 0,
		max = 100,
		initial = 80,
		zIndex = 12,
	})
	y += 44

	UIComponents.createSlider({
		label = "Music",
		size = UDim2.new(1, -8, 0, 36),
		position = UDim2.new(0, 4, 0, y),
		parent = scrollFrame,
		min = 0,
		max = 100,
		initial = 60,
		zIndex = 12,
	})
	y += 44

	UIComponents.createSlider({
		label = "Sound Effects",
		size = UDim2.new(1, -8, 0, 36),
		position = UDim2.new(0, 4, 0, y),
		parent = scrollFrame,
		min = 0,
		max = 100,
		initial = 90,
		zIndex = 12,
	})
	y += 52

	y = createSection("GAMEPLAY", y)

	UIComponents.createToggle({
		label = "Show Damage Numbers",
		size = UDim2.new(1, -8, 0, 30),
		position = UDim2.new(0, 4, 0, y),
		parent = scrollFrame,
		initialState = true,
		zIndex = 12,
	})
	y += 36

	UIComponents.createToggle({
		label = "Auto-Pickup Items",
		size = UDim2.new(1, -8, 0, 30),
		position = UDim2.new(0, 4, 0, y),
		parent = scrollFrame,
		initialState = true,
		zIndex = 12,
	})
	y += 36

	UIComponents.createToggle({
		label = "Show Player Names",
		size = UDim2.new(1, -8, 0, 30),
		position = UDim2.new(0, 4, 0, y),
		parent = scrollFrame,
		initialState = true,
		zIndex = 12,
	})
	y += 36

	UIComponents.createToggle({
		label = "Screen Shake",
		size = UDim2.new(1, -8, 0, 30),
		position = UDim2.new(0, 4, 0, y),
		parent = scrollFrame,
		initialState = false,
		zIndex = 12,
	})
	y += 44

	y = createSection("ACCESSIBILITY", y)

	UIComponents.createToggle({
		label = "Colorblind Mode",
		size = UDim2.new(1, -8, 0, 30),
		position = UDim2.new(0, 4, 0, y),
		parent = scrollFrame,
		initialState = false,
		zIndex = 12,
	})
	y += 36

	UIComponents.createSlider({
		label = "Text Size",
		size = UDim2.new(1, -8, 0, 36),
		position = UDim2.new(0, 4, 0, y),
		parent = scrollFrame,
		min = 8,
		max = 24,
		initial = 14,
		zIndex = 12,
	})
	y += 52

	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, y + 10)

	UIComponents.animateIn(panel, "bottom", 0.3)

	return panel
end

return SettingsPanel
