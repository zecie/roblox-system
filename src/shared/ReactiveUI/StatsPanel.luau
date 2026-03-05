local UIComponents = require(script.Parent.UIComponents)

local StatsPanel = {}

function StatsPanel.create(screenGui: ScreenGui): Frame
	local panel = UIComponents.createGlassPanel({
		name = "StatsPanel",
		size = UDim2.new(0, 420, 0, 480),
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
	UIComponents.applyGradient(headerBar, UIComponents.Colors.AccentTertiary, UIComponents.Colors.AccentPrimary, 0)
	headerBar.Parent = panel

	UIComponents.createIcon({
		text = "|||",
		size = UDim2.new(0, 24, 0, 50),
		position = UDim2.new(0, 16, 0, 0),
		parent = panel,
		textSize = 18,
		zIndex = 12,
	})

	UIComponents.createLabel({
		text = "CHARACTER STATS",
		size = UDim2.new(0, 200, 0, 50),
		position = UDim2.new(0, 44, 0, 0),
		parent = panel,
		font = UIComponents.Fonts.Title,
		textSize = 18,
		color = UIComponents.Colors.TextPrimary,
		zIndex = 12,
		name = "Title",
	})

	local statsData = {
		{label = "Strength", value = 245, max = 500, color = UIComponents.Colors.AccentRed, icon = ">>"},
		{label = "Agility", value = 180, max = 500, color = UIComponents.Colors.AccentGreen, icon = "~>"},
		{label = "Intelligence", value = 320, max = 500, color = UIComponents.Colors.AccentSecondary, icon = "::"},
		{label = "Vitality", value = 200, max = 500, color = UIComponents.Colors.HealthBar, icon = "+"},
		{label = "Wisdom", value = 275, max = 500, color = UIComponents.Colors.AccentPrimary, icon = "**"},
		{label = "Luck", value = 150, max = 500, color = UIComponents.Colors.AccentGold, icon = "%%"},
	}

	for i, stat in statsData do
		local yPos = 60 + (i - 1) * 52

		local row = Instance.new("Frame")
		row.Name = stat.label
		row.Size = UDim2.new(1, -30, 0, 44)
		row.Position = UDim2.new(0, 15, 0, yPos)
		row.BackgroundColor3 = UIComponents.Colors.Surface
		row.BackgroundTransparency = 0.5
		row.BorderSizePixel = 0
		row.ZIndex = 11
		UIComponents.applyCorner(row, 8)
		row.Parent = panel

		UIComponents.createIcon({
			text = stat.icon,
			size = UDim2.new(0, 20, 0, 44),
			position = UDim2.new(0, 10, 0, 0),
			parent = row,
			textSize = 14,
			zIndex = 12,
		})

		UIComponents.createLabel({
			text = stat.label,
			size = UDim2.new(0, 100, 0, 20),
			position = UDim2.new(0, 34, 0, 4),
			parent = row,
			font = UIComponents.Fonts.Body,
			textSize = 12,
			color = UIComponents.Colors.TextPrimary,
			zIndex = 12,
		})

		UIComponents.createLabel({
			text = tostring(stat.value) .. " / " .. tostring(stat.max),
			size = UDim2.new(0, 80, 0, 20),
			position = UDim2.new(1, -10, 0, 4),
			parent = row,
			font = UIComponents.Fonts.Mono,
			textSize = 11,
			color = stat.color,
			xAlignment = Enum.TextXAlignment.Right,
			anchorPoint = Vector2.new(1, 0),
			zIndex = 12,
		})

		local bar = UIComponents.createProgressBar({
			size = UDim2.new(1, -46, 0, 8),
			position = UDim2.new(0, 34, 0, 28),
			parent = row,
			fillColor = stat.color,
			cornerRadius = 4,
			zIndex = 12,
			initialFill = 0,
		})

		task.delay(0.3 + i * 0.1, function()
			UIComponents.tween(bar.fill, 0.8, {
				Size = UDim2.new(stat.value / stat.max, 0, 1, 0),
			}, Enum.EasingStyle.Back)
		end)
	end

	UIComponents.createDivider({
		position = UDim2.new(0.5, 0, 0, 378),
		parent = panel,
		zIndex = 11,
	})

	UIComponents.createLabel({
		text = "COMBAT RATING",
		size = UDim2.new(1, -30, 0, 20),
		position = UDim2.new(0, 15, 0, 388),
		parent = panel,
		font = UIComponents.Fonts.Title,
		textSize = 11,
		color = UIComponents.Colors.TextMuted,
		xAlignment = Enum.TextXAlignment.Center,
		zIndex = 12,
	})

	local ratingDisplay = Instance.new("Frame")
	ratingDisplay.Name = "RatingDisplay"
	ratingDisplay.Size = UDim2.new(0, 120, 0, 50)
	ratingDisplay.Position = UDim2.new(0.5, 0, 0, 410)
	ratingDisplay.AnchorPoint = Vector2.new(0.5, 0)
	ratingDisplay.BackgroundTransparency = 1
	ratingDisplay.ZIndex = 11
	ratingDisplay.Parent = panel

	local ratingLabel = UIComponents.createLabel({
		text = "8,450",
		size = UDim2.new(1, 0, 0, 36),
		position = UDim2.new(0, 0, 0, 0),
		parent = ratingDisplay,
		font = UIComponents.Fonts.Title,
		textSize = 32,
		color = UIComponents.Colors.AccentGold,
		xAlignment = Enum.TextXAlignment.Center,
		zIndex = 12,
		name = "RatingValue",
	})

	UIComponents.applyGradient(ratingLabel, UIComponents.Colors.AccentGold, UIComponents.Colors.AccentTertiary, 0)

	UIComponents.createLabel({
		text = "TOP 5% OF ALL PLAYERS",
		size = UDim2.new(1, 0, 0, 14),
		position = UDim2.new(0, 0, 0, 36),
		parent = ratingDisplay,
		font = UIComponents.Fonts.Mono,
		textSize = 9,
		color = UIComponents.Colors.AccentGreen,
		xAlignment = Enum.TextXAlignment.Center,
		zIndex = 12,
	})

	UIComponents.animateIn(panel, "bottom", 0.3)

	return panel
end

return StatsPanel
