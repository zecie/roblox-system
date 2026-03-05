local UIComponents = require(script.Parent.UIComponents)
local TweenService = game:GetService("TweenService")

local AbilityBar = {}

local ABILITY_DATA = {
	{name = "Flame Strike", icon = "🔥", key = "Q", cooldown = 8, color = Color3.fromRGB(255, 80, 40)},
	{name = "Ice Shard", icon = "❄", key = "W", cooldown = 5, color = Color3.fromRGB(80, 180, 255)},
	{name = "Thunder", icon = "⚡", key = "E", cooldown = 12, color = Color3.fromRGB(255, 220, 60)},
	{name = "Shadow Step", icon = "🌑", key = "R", cooldown = 15, color = Color3.fromRGB(160, 60, 255)},
	{name = "Heal", icon = "✦", key = "F", cooldown = 20, color = Color3.fromRGB(60, 220, 140)},
	{name = "Ultimate", icon = "💠", key = "X", cooldown = 45, color = Color3.fromRGB(255, 80, 180)},
}

function AbilityBar.create(screenGui: ScreenGui)
	local barWidth = #ABILITY_DATA * 68 + 20
	local barContainer = UIComponents.createGlassPanel({
		name = "AbilityBar",
		size = UDim2.new(0, barWidth, 0, 80),
		position = UDim2.new(0.5, 0, 1, -20),
		parent = screenGui,
		anchorPoint = Vector2.new(0.5, 1),
		transparency = 0.2,
		cornerRadius = 16,
	})

	local topGlow = Instance.new("Frame")
	topGlow.Name = "TopGlow"
	topGlow.Size = UDim2.new(1, 0, 0, 2)
	topGlow.Position = UDim2.new(0, 0, 0, 0)
	topGlow.BackgroundColor3 = UIComponents.Colors.AccentPrimary
	topGlow.BackgroundTransparency = 0.3
	topGlow.BorderSizePixel = 0
	topGlow.ZIndex = 3
	topGlow.Parent = barContainer

	UIComponents.applyGradient(topGlow, UIComponents.Colors.AccentSecondary, UIComponents.Colors.AccentTertiary, 0)

	local abilitySlots = {}

	for i, ability in ABILITY_DATA do
		local slotX = (i - 1) * 68 + 10

		local slot = Instance.new("TextButton")
		slot.Name = ability.name
		slot.Text = ""
		slot.Size = UDim2.new(0, 58, 0, 58)
		slot.Position = UDim2.new(0, slotX, 0, 8)
		slot.BackgroundColor3 = UIComponents.Colors.Surface
		slot.BackgroundTransparency = 0.2
		slot.BorderSizePixel = 0
		slot.AutoButtonColor = false
		slot.ZIndex = 3
		UIComponents.applyCorner(slot, 12)
		slot.Parent = barContainer

		local glowBorder = UIComponents.applyStroke(slot, ability.color, 1.5, 0.4)

		local iconLabel = UIComponents.createIcon({
			text = ability.icon,
			size = UDim2.new(1, 0, 0, 30),
			position = UDim2.new(0, 0, 0, 4),
			parent = slot,
			textSize = 22,
			zIndex = 4,
		})

		local keyBadge = Instance.new("Frame")
		keyBadge.Name = "KeyBadge"
		keyBadge.Size = UDim2.new(0, 20, 0, 14)
		keyBadge.Position = UDim2.new(0.5, 0, 1, -18)
		keyBadge.AnchorPoint = Vector2.new(0.5, 0)
		keyBadge.BackgroundColor3 = ability.color
		keyBadge.BackgroundTransparency = 0.5
		keyBadge.BorderSizePixel = 0
		keyBadge.ZIndex = 4
		UIComponents.applyCorner(keyBadge, 4)
		keyBadge.Parent = slot

		UIComponents.createLabel({
			text = ability.key,
			size = UDim2.new(1, 0, 1, 0),
			parent = keyBadge,
			font = UIComponents.Fonts.Title,
			textSize = 9,
			color = UIComponents.Colors.TextPrimary,
			xAlignment = Enum.TextXAlignment.Center,
			zIndex = 5,
		})

		local cooldownOverlay = Instance.new("Frame")
		cooldownOverlay.Name = "CooldownOverlay"
		cooldownOverlay.Size = UDim2.new(1, 0, 0, 0)
		cooldownOverlay.Position = UDim2.new(0, 0, 1, 0)
		cooldownOverlay.AnchorPoint = Vector2.new(0, 1)
		cooldownOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		cooldownOverlay.BackgroundTransparency = 0.4
		cooldownOverlay.BorderSizePixel = 0
		cooldownOverlay.ZIndex = 5
		cooldownOverlay.ClipsDescendants = true
		UIComponents.applyCorner(cooldownOverlay, 12)
		cooldownOverlay.Parent = slot

		local cooldownText = UIComponents.createLabel({
			text = "",
			size = UDim2.new(1, 0, 1, 0),
			parent = cooldownOverlay,
			font = UIComponents.Fonts.Title,
			textSize = 18,
			color = Color3.fromRGB(255, 255, 255),
			xAlignment = Enum.TextXAlignment.Center,
			yAlignment = Enum.TextYAlignment.Center,
			zIndex = 6,
			name = "CooldownText",
		})

		slot.MouseEnter:Connect(function()
			UIComponents.tween(slot, 0.2, {BackgroundTransparency = 0})
			UIComponents.tween(glowBorder, 0.2, {Transparency = 0, Thickness = 2})
		end)

		slot.MouseLeave:Connect(function()
			UIComponents.tween(slot, 0.3, {BackgroundTransparency = 0.2})
			UIComponents.tween(glowBorder, 0.3, {Transparency = 0.4, Thickness = 1.5})
		end)

		local onCooldown = false
		slot.MouseButton1Click:Connect(function()
			if onCooldown then return end
			onCooldown = true

			UIComponents.tween(slot, 0.05, {Size = UDim2.new(0, 52, 0, 52), Position = UDim2.new(0, slotX + 3, 0, 11)})
			task.delay(0.05, function()
				UIComponents.tween(slot, 0.15, {Size = UDim2.new(0, 58, 0, 58), Position = UDim2.new(0, slotX, 0, 8)})
			end)

			local flashFrame = Instance.new("Frame")
			flashFrame.Size = UDim2.new(1, 0, 1, 0)
			flashFrame.BackgroundColor3 = ability.color
			flashFrame.BackgroundTransparency = 0.3
			flashFrame.BorderSizePixel = 0
			flashFrame.ZIndex = 7
			UIComponents.applyCorner(flashFrame, 12)
			flashFrame.Parent = slot
			UIComponents.tween(flashFrame, 0.3, {BackgroundTransparency = 1})
			task.delay(0.3, function()
				flashFrame:Destroy()
			end)

			cooldownOverlay.Size = UDim2.new(1, 0, 1, 0)
			local remaining = ability.cooldown

			task.spawn(function()
				while remaining > 0 do
					cooldownText.Text = tostring(math.ceil(remaining))
					local ratio = remaining / ability.cooldown
					cooldownOverlay.Size = UDim2.new(1, 0, ratio, 0)
					remaining -= 0.1
					task.wait(0.1)
				end
				cooldownOverlay.Size = UDim2.new(1, 0, 0, 0)
				cooldownText.Text = ""
				onCooldown = false

				local readyFlash = Instance.new("Frame")
				readyFlash.Size = UDim2.new(1, 0, 1, 0)
				readyFlash.BackgroundColor3 = ability.color
				readyFlash.BackgroundTransparency = 0.5
				readyFlash.BorderSizePixel = 0
				readyFlash.ZIndex = 7
				UIComponents.applyCorner(readyFlash, 12)
				readyFlash.Parent = slot
				UIComponents.tween(readyFlash, 0.5, {BackgroundTransparency = 1})
				task.delay(0.5, function()
					readyFlash:Destroy()
				end)
			end)
		end)

		table.insert(abilitySlots, {slot = slot, ability = ability})
	end

	UIComponents.animateIn(barContainer, "bottom", 0.5)

	return barContainer
end

return AbilityBar
