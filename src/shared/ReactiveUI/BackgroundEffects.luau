local UIComponents = require(script.Parent.UIComponents)

local BackgroundEffects = {}

function BackgroundEffects.create(screenGui: ScreenGui)
	local effectsLayer = Instance.new("Frame")
	effectsLayer.Name = "BackgroundEffects"
	effectsLayer.Size = UDim2.new(1, 0, 1, 0)
	effectsLayer.BackgroundTransparency = 1
	effectsLayer.ZIndex = 0
	effectsLayer.ClipsDescendants = true
	effectsLayer.Parent = screenGui

	local cornerGlow1 = Instance.new("Frame")
	cornerGlow1.Name = "CornerGlow1"
	cornerGlow1.Size = UDim2.new(0, 400, 0, 400)
	cornerGlow1.Position = UDim2.new(0, -100, 0, -100)
	cornerGlow1.BackgroundColor3 = UIComponents.Colors.AccentPrimary
	cornerGlow1.BackgroundTransparency = 0.92
	cornerGlow1.BorderSizePixel = 0
	cornerGlow1.ZIndex = 0
	UIComponents.applyCorner(cornerGlow1, 200)
	cornerGlow1.Parent = effectsLayer

	UIComponents.tweenLoop(cornerGlow1, 4, {
		BackgroundTransparency = 0.96,
		Size = UDim2.new(0, 420, 0, 420),
	})

	local cornerGlow2 = Instance.new("Frame")
	cornerGlow2.Name = "CornerGlow2"
	cornerGlow2.Size = UDim2.new(0, 350, 0, 350)
	cornerGlow2.Position = UDim2.new(1, -150, 1, -150)
	cornerGlow2.AnchorPoint = Vector2.new(0.5, 0.5)
	cornerGlow2.BackgroundColor3 = UIComponents.Colors.AccentTertiary
	cornerGlow2.BackgroundTransparency = 0.93
	cornerGlow2.BorderSizePixel = 0
	cornerGlow2.ZIndex = 0
	UIComponents.applyCorner(cornerGlow2, 175)
	cornerGlow2.Parent = effectsLayer

	UIComponents.tweenLoop(cornerGlow2, 5, {
		BackgroundTransparency = 0.97,
		Size = UDim2.new(0, 380, 0, 380),
	})

	local cornerGlow3 = Instance.new("Frame")
	cornerGlow3.Name = "CornerGlow3"
	cornerGlow3.Size = UDim2.new(0, 300, 0, 300)
	cornerGlow3.Position = UDim2.new(1, -100, 0, -80)
	cornerGlow3.AnchorPoint = Vector2.new(0.5, 0.5)
	cornerGlow3.BackgroundColor3 = UIComponents.Colors.AccentSecondary
	cornerGlow3.BackgroundTransparency = 0.94
	cornerGlow3.BorderSizePixel = 0
	cornerGlow3.ZIndex = 0
	UIComponents.applyCorner(cornerGlow3, 150)
	cornerGlow3.Parent = effectsLayer

	UIComponents.tweenLoop(cornerGlow3, 6, {
		BackgroundTransparency = 0.97,
		Position = UDim2.new(1, -120, 0, -60),
	})

	local particleCount = 20
	for i = 1, particleCount do
		task.spawn(function()
			task.wait(math.random() * 3)

			local particle = Instance.new("Frame")
			particle.Name = "Particle_" .. i
			particle.BackgroundColor3 = ({
				UIComponents.Colors.AccentPrimary,
				UIComponents.Colors.AccentSecondary,
				UIComponents.Colors.AccentTertiary,
				UIComponents.Colors.AccentGold,
			})[math.random(1, 4)]
			particle.BackgroundTransparency = 0.7 + math.random() * 0.2
			particle.BorderSizePixel = 0
			particle.ZIndex = 0

			local size = math.random(2, 6)
			particle.Size = UDim2.new(0, size, 0, size)
			UIComponents.applyCorner(particle, size)
			particle.Parent = effectsLayer

			while particle.Parent do
				local startX = math.random(0, 100) / 100
				local duration = 8 + math.random() * 12

				particle.Position = UDim2.new(startX, 0, 1, 10)
				particle.BackgroundTransparency = 0.7 + math.random() * 0.2

				local drift = (math.random() - 0.5) * 0.2
				UIComponents.tween(particle, duration, {
					Position = UDim2.new(startX + drift, 0, -0.05, 0),
					BackgroundTransparency = 1,
				}, Enum.EasingStyle.Linear)

				task.wait(duration + math.random() * 2)
			end
		end)
	end

	local scanLine = Instance.new("Frame")
	scanLine.Name = "ScanLine"
	scanLine.Size = UDim2.new(1, 0, 0, 1)
	scanLine.Position = UDim2.new(0, 0, -0.01, 0)
	scanLine.BackgroundColor3 = UIComponents.Colors.AccentSecondary
	scanLine.BackgroundTransparency = 0.9
	scanLine.BorderSizePixel = 0
	scanLine.ZIndex = 0
	scanLine.Parent = effectsLayer

	task.spawn(function()
		while scanLine.Parent do
			scanLine.Position = UDim2.new(0, 0, -0.01, 0)
			scanLine.BackgroundTransparency = 0.9
			UIComponents.tween(scanLine, 8, {
				Position = UDim2.new(0, 0, 1.01, 0),
			}, Enum.EasingStyle.Linear)
			task.wait(12)
		end
	end)

	local vignette = Instance.new("Frame")
	vignette.Name = "Vignette"
	vignette.Size = UDim2.new(1, 0, 1, 0)
	vignette.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	vignette.BackgroundTransparency = 1
	vignette.BorderSizePixel = 0
	vignette.ZIndex = 0
	vignette.Parent = effectsLayer

	local vignetteGradient = Instance.new("UIGradient")
	vignetteGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.3),
		NumberSequenceKeypoint.new(0.4, 1),
		NumberSequenceKeypoint.new(0.6, 1),
		NumberSequenceKeypoint.new(1, 0.3),
	})
	vignetteGradient.Parent = vignette

	return effectsLayer
end

return BackgroundEffects
