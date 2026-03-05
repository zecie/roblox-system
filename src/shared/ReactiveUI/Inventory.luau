local UIComponents = require(script.Parent.UIComponents)

local Inventory = {}

local RARITY_COLORS = {
	Common = {border = Color3.fromRGB(120, 120, 140), glow = Color3.fromRGB(80, 80, 100)},
	Uncommon = {border = Color3.fromRGB(60, 200, 80), glow = Color3.fromRGB(40, 160, 60)},
	Rare = {border = Color3.fromRGB(60, 120, 255), glow = Color3.fromRGB(40, 80, 200)},
	Epic = {border = Color3.fromRGB(160, 60, 255), glow = Color3.fromRGB(120, 40, 200)},
	Legendary = {border = Color3.fromRGB(255, 180, 40), glow = Color3.fromRGB(200, 140, 20)},
	Mythic = {border = Color3.fromRGB(255, 60, 120), glow = Color3.fromRGB(200, 40, 80)},
}

local SAMPLE_ITEMS = {
	{name = "Dragon Blade", icon = "//>", rarity = "Legendary", stats = "+450 ATK"},
	{name = "Shadow Cloak", icon = "{}", rarity = "Epic", stats = "+280 DEF"},
	{name = "Crystal Ring", icon = "(o)", rarity = "Rare", stats = "+120 CRIT"},
	{name = "Health Potion", icon = "[+]", rarity = "Common", stats = "+200 HP", count = 12},
	{name = "Mana Elixir", icon = "[~]", rarity = "Uncommon", stats = "+150 MP", count = 8},
	{name = "Phoenix Feather", icon = "^v^", rarity = "Mythic", stats = "Revive"},
	{name = "Thunder Hammer", icon = "|T|", rarity = "Legendary", stats = "+380 ATK"},
	{name = "Frost Shield", icon = "[=]", rarity = "Epic", stats = "+320 DEF"},
	{name = "Emerald Amulet", icon = "<*>", rarity = "Rare", stats = "+90 SPD"},
	{name = "Steel Boots", icon = "|_|", rarity = "Uncommon", stats = "+60 DEF"},
	{name = "Fire Scroll", icon = "///", rarity = "Rare", stats = "AoE DMG", count = 3},
	{name = "Void Stone", icon = "(x)", rarity = "Mythic", stats = "+500 ATK"},
	{name = "Healing Herb", icon = "~Y~", rarity = "Common", stats = "+50 HP", count = 25},
	{name = "Star Fragment", icon = "-*-", rarity = "Epic", stats = "+200 ALL"},
	{name = "Ancient Tome", icon = "[#]", rarity = "Legendary", stats = "+10% EXP"},
	{name = "Iron Helm", icon = "/^\\", rarity = "Common", stats = "+40 DEF"},
}

function Inventory.create(screenGui: ScreenGui): Frame
	local panel = UIComponents.createGlassPanel({
		name = "InventoryPanel",
		size = UDim2.new(0, 480, 0, 520),
		position = UDim2.new(0.5, 0, 0.5, 0),
		parent = screenGui,
		anchorPoint = Vector2.new(0.5, 0.5),
		transparency = 0.15,
		cornerRadius = 18,
		zIndex = 10,
	})

	local headerGlow = Instance.new("Frame")
	headerGlow.Name = "HeaderGlow"
	headerGlow.Size = UDim2.new(1, 0, 0, 50)
	headerGlow.BackgroundColor3 = UIComponents.Colors.AccentPrimary
	headerGlow.BackgroundTransparency = 0.85
	headerGlow.BorderSizePixel = 0
	headerGlow.ZIndex = 11
	headerGlow.ClipsDescendants = true
	headerGlow.Parent = panel

	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 18)
	headerCorner.Parent = headerGlow

	UIComponents.applyGradient(headerGlow, UIComponents.Colors.AccentPrimary, UIComponents.Colors.AccentTertiary, 0)

	UIComponents.createLabel({
		text = "INVENTORY",
		size = UDim2.new(0, 200, 0, 50),
		position = UDim2.new(0, 20, 0, 0),
		parent = panel,
		font = UIComponents.Fonts.Title,
		textSize = 18,
		color = UIComponents.Colors.TextPrimary,
		zIndex = 12,
		name = "Title",
	})

	UIComponents.createLabel({
		text = "16 / 40",
		size = UDim2.new(0, 100, 0, 50),
		position = UDim2.new(1, -20, 0, 0),
		parent = panel,
		font = UIComponents.Fonts.Mono,
		textSize = 13,
		color = UIComponents.Colors.TextMuted,
		xAlignment = Enum.TextXAlignment.Right,
		anchorPoint = Vector2.new(1, 0),
		zIndex = 12,
		name = "SlotCount",
	})

	local tabs = {"All", "Weapons", "Armor", "Consumables"}
	local tabContainer = Instance.new("Frame")
	tabContainer.Name = "TabContainer"
	tabContainer.Size = UDim2.new(1, -30, 0, 30)
	tabContainer.Position = UDim2.new(0, 15, 0, 58)
	tabContainer.BackgroundTransparency = 1
	tabContainer.ZIndex = 11
	tabContainer.Parent = panel

	for i, tabName in tabs do
		local tabBtn = Instance.new("TextButton")
		tabBtn.Name = tabName
		tabBtn.Text = tabName
		tabBtn.Size = UDim2.new(0, 100, 0, 28)
		tabBtn.Position = UDim2.new(0, (i - 1) * 108, 0, 0)
		tabBtn.BackgroundColor3 = i == 1 and UIComponents.Colors.AccentPrimary or UIComponents.Colors.SurfaceLight
		tabBtn.BackgroundTransparency = i == 1 and 0.3 or 0.5
		tabBtn.BorderSizePixel = 0
		tabBtn.FontFace = UIComponents.Fonts.Body
		tabBtn.TextSize = 12
		tabBtn.TextColor3 = i == 1 and UIComponents.Colors.TextPrimary or UIComponents.Colors.TextMuted
		tabBtn.AutoButtonColor = false
		tabBtn.ZIndex = 12
		UIComponents.applyCorner(tabBtn, 8)
		tabBtn.Parent = tabContainer

		tabBtn.MouseEnter:Connect(function()
			UIComponents.tween(tabBtn, 0.2, {BackgroundTransparency = 0.2})
		end)
		tabBtn.MouseLeave:Connect(function()
			UIComponents.tween(tabBtn, 0.2, {BackgroundTransparency = 0.4})
		end)
	end

	UIComponents.createDivider({
		position = UDim2.new(0.5, 0, 0, 94),
		parent = panel,
		zIndex = 11,
	})

	local gridScroll = Instance.new("ScrollingFrame")
	gridScroll.Name = "ItemGrid"
	gridScroll.Size = UDim2.new(1, -24, 1, -160)
	gridScroll.Position = UDim2.new(0, 12, 0, 100)
	gridScroll.BackgroundTransparency = 1
	gridScroll.BorderSizePixel = 0
	gridScroll.ScrollBarThickness = 3
	gridScroll.ScrollBarImageColor3 = UIComponents.Colors.AccentPrimary
	gridScroll.ScrollBarImageTransparency = 0.5
	gridScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	gridScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	gridScroll.ZIndex = 11
	gridScroll.Parent = panel

	local gridLayout = Instance.new("UIGridLayout")
	gridLayout.CellSize = UDim2.new(0, 68, 0, 85)
	gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
	gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	gridLayout.Parent = gridScroll

	local gridPadding = Instance.new("UIPadding")
	gridPadding.PaddingTop = UDim.new(0, 4)
	gridPadding.PaddingLeft = UDim.new(0, 4)
	gridPadding.Parent = gridScroll

	local selectedSlot = nil

	for i, item in SAMPLE_ITEMS do
		local rarityData = RARITY_COLORS[item.rarity]
		local slot = Instance.new("TextButton")
		slot.Name = item.name
		slot.Text = ""
		slot.Size = UDim2.new(0, 68, 0, 85)
		slot.BackgroundColor3 = UIComponents.Colors.Surface
		slot.BackgroundTransparency = 0.2
		slot.BorderSizePixel = 0
		slot.AutoButtonColor = false
		slot.LayoutOrder = i
		slot.ZIndex = 12
		UIComponents.applyCorner(slot, 10)

		local borderStroke = UIComponents.applyStroke(slot, rarityData.border, 1.5, 0.3)

		local rarityGlow = Instance.new("Frame")
		rarityGlow.Name = "RarityGlow"
		rarityGlow.Size = UDim2.new(1, 0, 0, 3)
		rarityGlow.Position = UDim2.new(0, 0, 1, -3)
		rarityGlow.BackgroundColor3 = rarityData.border
		rarityGlow.BackgroundTransparency = 0.3
		rarityGlow.BorderSizePixel = 0
		rarityGlow.ZIndex = 13
		UIComponents.applyCorner(rarityGlow, 2)
		rarityGlow.Parent = slot

		UIComponents.createIcon({
			text = item.icon,
			size = UDim2.new(1, 0, 0, 40),
			position = UDim2.new(0, 0, 0, 4),
			parent = slot,
			textSize = 26,
			zIndex = 13,
		})

		UIComponents.createLabel({
			text = item.name,
			size = UDim2.new(1, -6, 0, 14),
			position = UDim2.new(0, 3, 0, 44),
			parent = slot,
			font = UIComponents.Fonts.Body,
			textSize = 8,
			color = rarityData.border,
			xAlignment = Enum.TextXAlignment.Center,
			zIndex = 13,
		})

		UIComponents.createLabel({
			text = item.stats,
			size = UDim2.new(1, -6, 0, 12),
			position = UDim2.new(0, 3, 0, 58),
			parent = slot,
			font = UIComponents.Fonts.Mono,
			textSize = 8,
			color = UIComponents.Colors.TextMuted,
			xAlignment = Enum.TextXAlignment.Center,
			zIndex = 13,
		})

		if item.count then
			local countBadge = Instance.new("Frame")
			countBadge.Name = "Count"
			countBadge.Size = UDim2.new(0, 20, 0, 14)
			countBadge.Position = UDim2.new(1, -2, 0, 2)
			countBadge.AnchorPoint = Vector2.new(1, 0)
			countBadge.BackgroundColor3 = UIComponents.Colors.AccentPrimary
			countBadge.BackgroundTransparency = 0.3
			countBadge.BorderSizePixel = 0
			countBadge.ZIndex = 14
			UIComponents.applyCorner(countBadge, 4)
			countBadge.Parent = slot

			UIComponents.createLabel({
				text = tostring(item.count),
				size = UDim2.new(1, 0, 1, 0),
				parent = countBadge,
				font = UIComponents.Fonts.Mono,
				textSize = 9,
				color = Color3.fromRGB(255, 255, 255),
				xAlignment = Enum.TextXAlignment.Center,
				zIndex = 15,
			})
		end

		slot.MouseEnter:Connect(function()
			UIComponents.tween(slot, 0.15, {BackgroundTransparency = 0})
			UIComponents.tween(borderStroke, 0.15, {Transparency = 0, Thickness = 2})
		end)

		slot.MouseLeave:Connect(function()
			if selectedSlot ~= slot then
				UIComponents.tween(slot, 0.2, {BackgroundTransparency = 0.2})
				UIComponents.tween(borderStroke, 0.2, {Transparency = 0.3, Thickness = 1.5})
			end
		end)

		slot.MouseButton1Click:Connect(function()
			if selectedSlot then
				local oldStroke = selectedSlot:FindFirstChildOfClass("UIStroke")
				if oldStroke then
					UIComponents.tween(selectedSlot, 0.2, {BackgroundTransparency = 0.2})
					UIComponents.tween(oldStroke, 0.2, {Transparency = 0.3, Thickness = 1.5})
				end
			end
			selectedSlot = slot
			UIComponents.tween(borderStroke, 0.1, {Transparency = 0, Thickness = 2.5})
		end)

		slot.Parent = gridScroll
	end

	for i = #SAMPLE_ITEMS + 1, 40 do
		local emptySlot = Instance.new("Frame")
		emptySlot.Name = "Empty_" .. i
		emptySlot.Size = UDim2.new(0, 68, 0, 85)
		emptySlot.BackgroundColor3 = UIComponents.Colors.Surface
		emptySlot.BackgroundTransparency = 0.6
		emptySlot.BorderSizePixel = 0
		emptySlot.LayoutOrder = i
		emptySlot.ZIndex = 12
		UIComponents.applyCorner(emptySlot, 10)
		UIComponents.applyStroke(emptySlot, UIComponents.Colors.SurfaceLight, 1, 0.7)
		emptySlot.Parent = gridScroll
	end

	local bottomBar = Instance.new("Frame")
	bottomBar.Name = "BottomBar"
	bottomBar.Size = UDim2.new(1, -24, 0, 40)
	bottomBar.Position = UDim2.new(0, 12, 1, -50)
	bottomBar.BackgroundTransparency = 1
	bottomBar.ZIndex = 11
	bottomBar.Parent = panel

	UIComponents.createButton({
		text = "Equip",
		size = UDim2.new(0, 90, 0, 34),
		position = UDim2.new(0, 0, 0, 0),
		parent = bottomBar,
		color = UIComponents.Colors.AccentGreen,
		cornerRadius = 8,
		zIndex = 12,
		icon = ">>",
	})

	UIComponents.createButton({
		text = "Sell",
		size = UDim2.new(0, 80, 0, 34),
		position = UDim2.new(0, 100, 0, 0),
		parent = bottomBar,
		color = UIComponents.Colors.AccentGold,
		cornerRadius = 8,
		zIndex = 12,
		icon = "$",
	})

	UIComponents.createButton({
		text = "Discard",
		size = UDim2.new(0, 90, 0, 34),
		position = UDim2.new(0, 190, 0, 0),
		parent = bottomBar,
		color = UIComponents.Colors.AccentRed,
		cornerRadius = 8,
		zIndex = 12,
		icon = "x",
	})

	UIComponents.animateIn(panel, "bottom", 0.3)

	return panel
end

return Inventory
