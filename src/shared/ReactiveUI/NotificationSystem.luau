local UIComponents = require(script.Parent.UIComponents)

local NotificationSystem = {}

local NOTIFICATION_TYPES = {
	info = {icon = "i", color = UIComponents.Colors.AccentSecondary},
	success = {icon = "+", color = UIComponents.Colors.AccentGreen},
	warning = {icon = "!", color = UIComponents.Colors.AccentGold},
	error = {icon = "x", color = UIComponents.Colors.AccentRed},
	loot = {icon = "*", color = UIComponents.Colors.AccentTertiary},
	achievement = {icon = "#", color = UIComponents.Colors.AccentGold},
	levelup = {icon = "^", color = UIComponents.Colors.AccentPrimary},
}

function NotificationSystem.create(screenGui: ScreenGui)
	local notifContainer = Instance.new("Frame")
	notifContainer.Name = "NotificationContainer"
	notifContainer.Size = UDim2.new(0, 340, 1, -40)
	notifContainer.Position = UDim2.new(1, -20, 0, 120)
	notifContainer.AnchorPoint = Vector2.new(1, 0)
	notifContainer.BackgroundTransparency = 1
	notifContainer.ZIndex = 20
	notifContainer.ClipsDescendants = true
	notifContainer.Parent = screenGui

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 8)
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
	layout.Parent = notifContainer

	local notifCount = 0

	local function pushNotification(notifType: string, title: string, message: string, duration: number?)
		local typeData = NOTIFICATION_TYPES[notifType] or NOTIFICATION_TYPES.info
		notifCount += 1
		local dur = duration or 4

		local notif = UIComponents.createGlassPanel({
			name = "Notif_" .. notifCount,
			size = UDim2.new(1, 0, 0, 72),
			position = UDim2.new(1, 40, 0, 0),
			parent = notifContainer,
			transparency = 0.1,
			cornerRadius = 12,
			zIndex = 21,
			layoutOrder = notifCount,
		})

		local accentBar = Instance.new("Frame")
		accentBar.Name = "AccentBar"
		accentBar.Size = UDim2.new(0, 3, 1, -12)
		accentBar.Position = UDim2.new(0, 6, 0, 6)
		accentBar.BackgroundColor3 = typeData.color
		accentBar.BorderSizePixel = 0
		accentBar.ZIndex = 22
		UIComponents.applyCorner(accentBar, 2)
		accentBar.Parent = notif

		UIComponents.createIcon({
			text = typeData.icon,
			size = UDim2.new(0, 24, 0, 24),
			position = UDim2.new(0, 18, 0, 10),
			parent = notif,
			color = typeData.color,
			textSize = 16,
			zIndex = 22,
		})

		UIComponents.createLabel({
			text = title,
			size = UDim2.new(1, -56, 0, 20),
			position = UDim2.new(0, 46, 0, 10),
			parent = notif,
			font = UIComponents.Fonts.Title,
			textSize = 13,
			color = UIComponents.Colors.TextPrimary,
			zIndex = 22,
			name = "Title",
		})

		UIComponents.createLabel({
			text = message,
			size = UDim2.new(1, -56, 0, 30),
			position = UDim2.new(0, 46, 0, 30),
			parent = notif,
			font = UIComponents.Fonts.Light,
			textSize = 11,
			color = UIComponents.Colors.TextSecondary,
			zIndex = 22,
			yAlignment = Enum.TextYAlignment.Top,
			name = "Message",
		})

		local progressBar = Instance.new("Frame")
		progressBar.Name = "TimerBar"
		progressBar.Size = UDim2.new(1, -16, 0, 2)
		progressBar.Position = UDim2.new(0, 8, 1, -6)
		progressBar.BackgroundColor3 = typeData.color
		progressBar.BackgroundTransparency = 0.3
		progressBar.BorderSizePixel = 0
		progressBar.ZIndex = 22
		UIComponents.applyCorner(progressBar, 1)
		progressBar.Parent = notif

		UIComponents.tween(notif, 0.4, {Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Back)

		UIComponents.tween(progressBar, dur, {Size = UDim2.new(0, 0, 0, 2)}, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

		task.delay(dur, function()
			UIComponents.tween(notif, 0.3, {
				Position = UDim2.new(1, 40, 0, 0),
				BackgroundTransparency = 1,
			})
			task.delay(0.35, function()
				notif:Destroy()
			end)
		end)
	end

	local function pushCenterAlert(title: string, subtitle: string?)
		local centerAlert = Instance.new("Frame")
		centerAlert.Name = "CenterAlert"
		centerAlert.Size = UDim2.new(0, 500, 0, 80)
		centerAlert.Position = UDim2.new(0.5, 0, 0.35, 0)
		centerAlert.AnchorPoint = Vector2.new(0.5, 0.5)
		centerAlert.BackgroundTransparency = 1
		centerAlert.ZIndex = 30
		centerAlert.Parent = screenGui

		local titleLabel = UIComponents.createLabel({
			text = title,
			size = UDim2.new(1, 0, 0, 40),
			position = UDim2.new(0, 0, 0, 0),
			parent = centerAlert,
			font = UIComponents.Fonts.Title,
			textSize = 32,
			color = UIComponents.Colors.AccentGold,
			xAlignment = Enum.TextXAlignment.Center,
			zIndex = 31,
			name = "Title",
		})

		local titleGradient = UIComponents.applyGradient(
			titleLabel,
			UIComponents.Colors.AccentGold,
			UIComponents.Colors.AccentTertiary,
			0
		)

		if subtitle then
			UIComponents.createLabel({
				text = subtitle,
				size = UDim2.new(1, 0, 0, 24),
				position = UDim2.new(0, 0, 0, 42),
				parent = centerAlert,
				font = UIComponents.Fonts.Light,
				textSize = 16,
				color = UIComponents.Colors.TextSecondary,
				xAlignment = Enum.TextXAlignment.Center,
				zIndex = 31,
				name = "Subtitle",
			})
		end

		centerAlert.Size = UDim2.new(0, 0, 0, 80)
		UIComponents.tween(centerAlert, 0.5, {Size = UDim2.new(0, 500, 0, 80)}, Enum.EasingStyle.Back)

		task.delay(3, function()
			UIComponents.tween(centerAlert, 0.4, {Size = UDim2.new(0, 0, 0, 80)})
			task.delay(0.5, function()
				centerAlert:Destroy()
			end)
		end)
	end

	task.spawn(function()
		task.wait(1)
		pushNotification("success", "Welcome Back!", "Your daily rewards are ready to claim.")
		task.wait(2)
		pushNotification("loot", "Legendary Drop!", "Dragon Blade has been added to your inventory.")
		task.wait(1.5)
		pushNotification("achievement", "Achievement Unlocked", "First Blood - Defeat your first enemy.")
		task.wait(3)
		pushCenterAlert("LEVEL UP!", "You reached Level 43")
		task.wait(0.5)
		pushNotification("levelup", "Level Up!", "You are now Level 43. New abilities unlocked!")
		task.wait(2)
		pushNotification("warning", "Low Health", "Your health is below 25%. Use a potion!")
	end)

	return {
		push = pushNotification,
		centerAlert = pushCenterAlert,
	}
end

return NotificationSystem
