local UIComponents = require(script.Parent.UIComponents)

local HUD = {}

function HUD.create(screenGui: ScreenGui): {updateHealth: (number) -> (), updateMana: (number) -> (), updateXP: (number, number) -> ()}
	local hudContainer = Instance.new("Frame")
	hudContainer.Name = "HUD"
	hudContainer.Size = UDim2.new(1, 0, 1, 0)
	hudContainer.BackgroundTransparency = 1
	hudContainer.Parent = screenGui

	local topLeft = UIComponents.createGlassPanel({
		name = "PlayerStats",
		size = UDim2.new(0, 320, 0, 130),
		position = UDim2.new(0, 20, 0, 20),
		parent = hudContainer,
		transparency = 0.25,
		cornerRadius = 14,
	})

	local avatarFrame = Instance.new("Frame")
	avatarFrame.Name = "AvatarFrame"
	avatarFrame.Size = UDim2.new(0, 56, 0, 56)
	avatarFrame.Position = UDim2.new(0, 14, 0, 14)
	avatarFrame.BackgroundColor3 = UIComponents.Colors.SurfaceLight
	avatarFrame.BorderSizePixel = 0
	avatarFrame.ZIndex = 2
	UIComponents.applyCorner(avatarFrame, 28)
	UIComponents.applyStroke(avatarFrame, UIComponents.Colors.AccentPrimary, 2, 0.2)
	avatarFrame.Parent = topLeft

	local avatarGlow = Instance.new("Frame")
	avatarGlow.Name = "AvatarGlow"
	avatarGlow.Size = UDim2.new(1, 8, 1, 8)
	avatarGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
	avatarGlow.AnchorPoint = Vector2.new(0.5, 0.5)
	avatarGlow.BackgroundColor3 = UIComponents.Colors.AccentPrimary
	avatarGlow.BackgroundTransparency = 0.7
	avatarGlow.BorderSizePixel = 0
	avatarGlow.ZIndex = 1
	UIComponents.applyCorner(avatarGlow, 32)
	avatarGlow.Parent = avatarFrame

	UIComponents.tweenLoop(avatarGlow, 2, {BackgroundTransparency = 0.9})

	local avatarIcon = UIComponents.createIcon({
		text = "+",
		size = UDim2.new(1, 0, 1, 0),
		parent = avatarFrame,
		color = UIComponents.Colors.AccentPrimary,
		textSize = 28,
		zIndex = 3,
	})

	local levelBadge = Instance.new("Frame")
	levelBadge.Name = "LevelBadge"
	levelBadge.Size = UDim2.new(0, 24, 0, 24)
	levelBadge.Position = UDim2.new(1, -4, 1, -4)
	levelBadge.AnchorPoint = Vector2.new(0.5, 0.5)
	levelBadge.BackgroundColor3 = UIComponents.Colors.AccentGold
	levelBadge.BorderSizePixel = 0
	levelBadge.ZIndex = 4
	UIComponents.applyCorner(levelBadge, 12)
	levelBadge.Parent = avatarFrame

	local levelText = UIComponents.createLabel({
		text = "42",
		size = UDim2.new(1, 0, 1, 0),
		parent = levelBadge,
		font = UIComponents.Fonts.Title,
		textSize = 11,
		color = Color3.fromRGB(20, 15, 0),
		xAlignment = Enum.TextXAlignment.Center,
		zIndex = 5,
		name = "LevelText",
	})

	local playerName = UIComponents.createLabel({
		text = "SHADOWBLADE",
		size = UDim2.new(0, 200, 0, 20),
		position = UDim2.new(0, 80, 0, 14),
		parent = topLeft,
		font = UIComponents.Fonts.Title,
		textSize = 16,
		color = UIComponents.Colors.TextPrimary,
		zIndex = 3,
		name = "PlayerName",
	})

	local playerTitle = UIComponents.createLabel({
		text = "Arcane Warrior",
		size = UDim2.new(0, 200, 0, 16),
		position = UDim2.new(0, 80, 0, 34),
		parent = topLeft,
		font = UIComponents.Fonts.Light,
		textSize = 11,
		color = UIComponents.Colors.AccentGold,
		zIndex = 3,
		name = "PlayerTitle",
	})

	local healthBar = UIComponents.createProgressBar({
		name = "HealthBar",
		size = UDim2.new(0, 226, 0, 16),
		position = UDim2.new(0, 80, 0, 56),
		parent = topLeft,
		fillColor = UIComponents.Colors.HealthBar,
		fillColorEnd = UIComponents.Colors.HealthBarEnd,
		cornerRadius = 8,
		zIndex = 3,
		initialFill = 0.78,
	})

	UIComponents.createIcon({
		text = "HP",
		size = UDim2.new(0, 14, 0, 14),
		position = UDim2.new(0, 4, 0.5, 0),
		parent = healthBar.container,
		color = Color3.fromRGB(255, 255, 255),
		textSize = 10,
		anchorPoint = Vector2.new(0, 0.5),
		zIndex = 6,
	})

	local healthText = UIComponents.createLabel({
		text = "780 / 1000",
		size = UDim2.new(1, -22, 1, 0),
		position = UDim2.new(0, 20, 0, 0),
		parent = healthBar.container,
		font = UIComponents.Fonts.Mono,
		textSize = 9,
		color = Color3.fromRGB(255, 255, 255),
		xAlignment = Enum.TextXAlignment.Right,
		zIndex = 6,
		name = "HealthText",
	})

	local manaBar = UIComponents.createProgressBar({
		name = "ManaBar",
		size = UDim2.new(0, 226, 0, 12),
		position = UDim2.new(0, 80, 0, 78),
		parent = topLeft,
		fillColor = UIComponents.Colors.ManaBar,
		fillColorEnd = UIComponents.Colors.ManaBarEnd,
		cornerRadius = 6,
		zIndex = 3,
		initialFill = 0.55,
	})

	UIComponents.createIcon({
		text = "◆",
		size = UDim2.new(0, 12, 0, 12),
		position = UDim2.new(0, 3, 0.5, 0),
		parent = manaBar.container,
		color = Color3.fromRGB(255, 255, 255),
		textSize = 8,
		anchorPoint = Vector2.new(0, 0.5),
		zIndex = 6,
	})

	local manaText = UIComponents.createLabel({
		text = "550 / 1000",
		size = UDim2.new(1, -18, 1, 0),
		position = UDim2.new(0, 16, 0, 0),
		parent = manaBar.container,
		font = UIComponents.Fonts.Mono,
		textSize = 8,
		color = Color3.fromRGB(255, 255, 255),
		xAlignment = Enum.TextXAlignment.Right,
		zIndex = 6,
		name = "ManaText",
	})

	local xpContainer = Instance.new("Frame")
	xpContainer.Name = "XPContainer"
	xpContainer.Size = UDim2.new(0, 226, 0, 20)
	xpContainer.Position = UDim2.new(0, 80, 0, 98)
	xpContainer.BackgroundTransparency = 1
	xpContainer.ZIndex = 3
	xpContainer.Parent = topLeft

	local xpLabel = UIComponents.createLabel({
		text = "EXP",
		size = UDim2.new(0, 30, 0, 12),
		position = UDim2.new(0, 0, 0, 0),
		parent = xpContainer,
		font = UIComponents.Fonts.Mono,
		textSize = 9,
		color = UIComponents.Colors.TextMuted,
		zIndex = 4,
		name = "XPLabel",
	})

	local xpBar = UIComponents.createProgressBar({
		name = "XPBar",
		size = UDim2.new(0, 158, 0, 8),
		position = UDim2.new(0, 34, 0, 2),
		parent = xpContainer,
		fillColor = UIComponents.Colors.XPBar,
		fillColorEnd = UIComponents.Colors.XPBarEnd,
		cornerRadius = 4,
		zIndex = 4,
		initialFill = 0.62,
	})

	local xpText = UIComponents.createLabel({
		text = "62%",
		size = UDim2.new(0, 36, 0, 12),
		position = UDim2.new(1, -2, 0, 0),
		parent = xpContainer,
		font = UIComponents.Fonts.Mono,
		textSize = 9,
		color = UIComponents.Colors.AccentGreen,
		xAlignment = Enum.TextXAlignment.Right,
		anchorPoint = Vector2.new(1, 0),
		zIndex = 4,
		name = "XPText",
	})

	local miniStatsRow = UIComponents.createGlassPanel({
		name = "MiniStats",
		size = UDim2.new(0, 320, 0, 36),
		position = UDim2.new(0, 20, 0, 158),
		parent = hudContainer,
		transparency = 0.35,
		cornerRadius = 10,
	})

	local stats = {
		{icon = "⚔", value = "2,450", label = "ATK"},
		{icon = "🛡", value = "1,800", label = "DEF"},
		{icon = "⚡", value = "340", label = "SPD"},
		{icon = "✦", value = "99.2%", label = "CRIT"},
	}

	for i, stat in stats do
		local statX = (i - 1) * 80
		UIComponents.createIcon({
			text = stat.icon,
			size = UDim2.new(0, 16, 0, 36),
			position = UDim2.new(0, statX + 6, 0, 0),
			parent = miniStatsRow,
			color = UIComponents.Colors.AccentSecondary,
			textSize = 11,
			zIndex = 3,
		})
		UIComponents.createLabel({
			text = stat.value,
			size = UDim2.new(0, 50, 0, 20),
			position = UDim2.new(0, statX + 22, 0, 2),
			parent = miniStatsRow,
			font = UIComponents.Fonts.Mono,
			textSize = 12,
			color = UIComponents.Colors.TextPrimary,
			zIndex = 3,
			name = stat.label .. "Value",
		})
		UIComponents.createLabel({
			text = stat.label,
			size = UDim2.new(0, 50, 0, 14),
			position = UDim2.new(0, statX + 22, 0, 20),
			parent = miniStatsRow,
			font = UIComponents.Fonts.Light,
			textSize = 8,
			color = UIComponents.Colors.TextMuted,
			zIndex = 3,
			name = stat.label .. "Label",
		})
	end

	UIComponents.animateIn(topLeft, "left", 0.2)
	UIComponents.animateIn(miniStatsRow, "left", 0.4)

	local topRight = UIComponents.createGlassPanel({
		name = "TopRightInfo",
		size = UDim2.new(0, 200, 0, 80),
		position = UDim2.new(1, -20, 0, 20),
		parent = hudContainer,
		anchorPoint = Vector2.new(1, 0),
		transparency = 0.3,
		cornerRadius = 14,
	})

	local currencyItems = {
		{icon = "💎", value = "12,450", color = UIComponents.Colors.AccentSecondary, y = 10},
		{icon = "🪙", value = "847,200", color = UIComponents.Colors.AccentGold, y = 35},
		{icon = "⭐", value = "2,100", color = UIComponents.Colors.AccentTertiary, y = 55},
	}

	for _, currency in currencyItems do
		UIComponents.createIcon({
			text = currency.icon,
			size = UDim2.new(0, 20, 0, 20),
			position = UDim2.new(0, 12, 0, currency.y),
			parent = topRight,
			textSize = 14,
			zIndex = 3,
		})
		UIComponents.createLabel({
			text = currency.value,
			size = UDim2.new(0, 140, 0, 18),
			position = UDim2.new(0, 36, 0, currency.y + 1),
			parent = topRight,
			font = UIComponents.Fonts.Mono,
			textSize = 14,
			color = currency.color,
			xAlignment = Enum.TextXAlignment.Right,
			zIndex = 3,
		})
	end

	UIComponents.animateIn(topRight, "right", 0.3)

	local function updateHealth(ratio: number)
		UIComponents.tween(healthBar.fill, 0.4, {Size = UDim2.new(math.clamp(ratio, 0, 1), 0, 1, 0)})
		healthText.Text = tostring(math.floor(ratio * 1000)) .. " / 1000"
	end

	local function updateMana(ratio: number)
		UIComponents.tween(manaBar.fill, 0.4, {Size = UDim2.new(math.clamp(ratio, 0, 1), 0, 1, 0)})
		manaText.Text = tostring(math.floor(ratio * 1000)) .. " / 1000"
	end

	local function updateXP(current: number, max: number)
		local ratio = current / max
		UIComponents.tween(xpBar.fill, 0.6, {Size = UDim2.new(math.clamp(ratio, 0, 1), 0, 1, 0)})
		xpText.Text = tostring(math.floor(ratio * 100)) .. "%"
	end

	return {
		updateHealth = updateHealth,
		updateMana = updateMana,
		updateXP = updateXP,
	}
end

return HUD
