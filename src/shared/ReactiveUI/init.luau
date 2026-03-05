local Players = game:GetService("Players")
local UIComponents = require(script.UIComponents)
local HUD = require(script.HUD)
local AbilityBar = require(script.AbilityBar)
local Inventory = require(script.Inventory)
local NotificationSystem = require(script.NotificationSystem)
local SettingsPanel = require(script.SettingsPanel)
local StatsPanel = require(script.StatsPanel)
local BackgroundEffects = require(script.BackgroundEffects)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ReactiveUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

BackgroundEffects.create(screenGui)

local hudAPI = HUD.create(screenGui)
AbilityBar.create(screenGui)
local notifAPI = NotificationSystem.create(screenGui)

local panels = {}
local activePanel = nil

local sidebar = UIComponents.createGlassPanel({
	name = "Sidebar",
	size = UDim2.new(0, 52, 0, 280),
	position = UDim2.new(0, 20, 0.5, 0),
	parent = screenGui,
	anchorPoint = Vector2.new(0, 0.5),
	transparency = 0.15,
	cornerRadius = 14,
	zIndex = 8,
})

local sidebarButtons = {
	{icon = "[ ]", name = "Inventory", panel = Inventory},
	{icon = "|||", name = "Stats", panel = StatsPanel},
	{icon = ":::", name = "Settings", panel = SettingsPanel},
}

for i, btnData in sidebarButtons do
	local yPos = (i - 1) * 58 + 10

	local btn = Instance.new("TextButton")
	btn.Name = btnData.name
	btn.Text = ""
	btn.Size = UDim2.new(0, 38, 0, 38)
	btn.Position = UDim2.new(0, 7, 0, yPos)
	btn.BackgroundColor3 = UIComponents.Colors.SurfaceLight
	btn.BackgroundTransparency = 0.3
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.ZIndex = 9
	UIComponents.applyCorner(btn, 10)
	btn.Parent = sidebar

	UIComponents.createIcon({
		text = btnData.icon,
		size = UDim2.new(1, 0, 1, 0),
		parent = btn,
		textSize = 18,
		zIndex = 10,
	})

	local tooltip = UIComponents.createGlassPanel({
		name = "Tooltip",
		size = UDim2.new(0, 0, 0, 28),
		position = UDim2.new(1, 8, 0.5, 0),
		parent = btn,
		anchorPoint = Vector2.new(0, 0.5),
		transparency = 0.1,
		cornerRadius = 6,
		zIndex = 15,
	})
	tooltip.ClipsDescendants = true

	UIComponents.createLabel({
		text = btnData.name,
		size = UDim2.new(0, 80, 1, 0),
		position = UDim2.new(0, 8, 0, 0),
		parent = tooltip,
		font = UIComponents.Fonts.Body,
		textSize = 11,
		color = UIComponents.Colors.TextPrimary,
		zIndex = 16,
	})

	btn.MouseEnter:Connect(function()
		UIComponents.tween(btn, 0.2, {BackgroundTransparency = 0})
		UIComponents.tween(tooltip, 0.2, {Size = UDim2.new(0, 90, 0, 28)}, Enum.EasingStyle.Back)
	end)

	btn.MouseLeave:Connect(function()
		UIComponents.tween(btn, 0.3, {BackgroundTransparency = 0.3})
		UIComponents.tween(tooltip, 0.15, {Size = UDim2.new(0, 0, 0, 28)})
	end)

	btn.MouseButton1Click:Connect(function()
		if activePanel then
			local panelFrame = panels[activePanel]
			if panelFrame then
				UIComponents.tween(panelFrame, 0.3, {
					BackgroundTransparency = 1,
					Size = panelFrame.Size - UDim2.new(0, 20, 0, 20),
				})
				task.delay(0.3, function()
					panelFrame:Destroy()
					panels[activePanel] = nil
				end)
			end

			if activePanel == btnData.name then
				activePanel = nil
				return
			end
		end

		activePanel = btnData.name
		local panelFrame = btnData.panel.create(screenGui)
		panels[btnData.name] = panelFrame
	end)
end

local sidebarDivider = Instance.new("Frame")
sidebarDivider.Size = UDim2.new(0, 28, 0, 1)
sidebarDivider.Position = UDim2.new(0.5, 0, 0, #sidebarButtons * 58 + 4)
sidebarDivider.AnchorPoint = Vector2.new(0.5, 0)
sidebarDivider.BackgroundColor3 = UIComponents.Colors.GlassEdge
sidebarDivider.BackgroundTransparency = 0.5
sidebarDivider.BorderSizePixel = 0
sidebarDivider.ZIndex = 9
sidebarDivider.Parent = sidebar

local questBtn = Instance.new("TextButton")
questBtn.Name = "Quests"
questBtn.Text = ""
questBtn.Size = UDim2.new(0, 38, 0, 38)
questBtn.Position = UDim2.new(0, 7, 0, #sidebarButtons * 58 + 14)
questBtn.BackgroundColor3 = UIComponents.Colors.AccentPrimary
questBtn.BackgroundTransparency = 0.5
questBtn.BorderSizePixel = 0
questBtn.AutoButtonColor = false
questBtn.ZIndex = 9
UIComponents.applyCorner(questBtn, 10)
questBtn.Parent = sidebar

UIComponents.createIcon({
	text = "?!",
	size = UDim2.new(1, 0, 1, 0),
	parent = questBtn,
	textSize = 18,
	zIndex = 10,
})

local questPulse = Instance.new("Frame")
questPulse.Name = "Pulse"
questPulse.Size = UDim2.new(0, 8, 0, 8)
questPulse.Position = UDim2.new(1, -4, 0, -2)
questPulse.BackgroundColor3 = UIComponents.Colors.AccentRed
questPulse.BorderSizePixel = 0
questPulse.ZIndex = 11
UIComponents.applyCorner(questPulse, 4)
questPulse.Parent = questBtn

UIComponents.tweenLoop(questPulse, 1, {
	Size = UDim2.new(0, 12, 0, 12),
	Position = UDim2.new(1, -6, 0, -4),
	BackgroundTransparency = 0.5,
})

UIComponents.animateIn(sidebar, "left", 0.6)

local minimapFrame = UIComponents.createGlassPanel({
	name = "Minimap",
	size = UDim2.new(0, 160, 0, 160),
	position = UDim2.new(1, -20, 1, -110),
	parent = screenGui,
	anchorPoint = Vector2.new(1, 1),
	transparency = 0.15,
	cornerRadius = 80,
	zIndex = 5,
})

UIComponents.applyStroke(minimapFrame, UIComponents.Colors.AccentPrimary, 2, 0.3)

local minimapInner = Instance.new("Frame")
minimapInner.Name = "MinimapInner"
minimapInner.Size = UDim2.new(1, -12, 1, -12)
minimapInner.Position = UDim2.new(0.5, 0, 0.5, 0)
minimapInner.AnchorPoint = Vector2.new(0.5, 0.5)
minimapInner.BackgroundColor3 = UIComponents.Colors.Surface
minimapInner.BackgroundTransparency = 0.3
minimapInner.BorderSizePixel = 0
minimapInner.ZIndex = 6
UIComponents.applyCorner(minimapInner, 74)
minimapInner.ClipsDescendants = true
minimapInner.Parent = minimapFrame

local compassPoints = {"N", "E", "S", "W"}
local compassAngles = {0, 90, 180, 270}
for i, point in compassPoints do
	local angle = math.rad(compassAngles[i])
	local radius = 58
	local x = math.sin(angle) * radius
	local y = -math.cos(angle) * radius

	UIComponents.createLabel({
		text = point,
		size = UDim2.new(0, 16, 0, 16),
		position = UDim2.new(0.5, x, 0.5, y),
		parent = minimapInner,
		font = UIComponents.Fonts.Mono,
		textSize = 10,
		color = point == "N" and UIComponents.Colors.AccentRed or UIComponents.Colors.TextMuted,
		xAlignment = Enum.TextXAlignment.Center,
		anchorPoint = Vector2.new(0.5, 0.5),
		zIndex = 7,
	})
end

local playerDot = Instance.new("Frame")
playerDot.Name = "PlayerDot"
playerDot.Size = UDim2.new(0, 8, 0, 8)
playerDot.Position = UDim2.new(0.5, 0, 0.5, 0)
playerDot.AnchorPoint = Vector2.new(0.5, 0.5)
playerDot.BackgroundColor3 = UIComponents.Colors.AccentSecondary
playerDot.BorderSizePixel = 0
playerDot.ZIndex = 8
UIComponents.applyCorner(playerDot, 4)
playerDot.Parent = minimapInner

UIComponents.tweenLoop(playerDot, 1.5, {
	Size = UDim2.new(0, 12, 0, 12),
	BackgroundTransparency = 0.3,
})

local playerArrow = UIComponents.createLabel({
	text = "▲",
	size = UDim2.new(0, 16, 0, 16),
	position = UDim2.new(0.5, 0, 0.5, -10),
	parent = minimapInner,
	font = UIComponents.Fonts.Body,
	textSize = 10,
	color = UIComponents.Colors.AccentSecondary,
	xAlignment = Enum.TextXAlignment.Center,
	anchorPoint = Vector2.new(0.5, 0.5),
	zIndex = 8,
})

for i = 1, 5 do
	local blipX = 0.5 + (math.random() - 0.5) * 0.6
	local blipY = 0.5 + (math.random() - 0.5) * 0.6
	local blip = Instance.new("Frame")
	blip.Name = "EnemyBlip_" .. i
	blip.Size = UDim2.new(0, 4, 0, 4)
	blip.Position = UDim2.new(blipX, 0, blipY, 0)
	blip.AnchorPoint = Vector2.new(0.5, 0.5)
	blip.BackgroundColor3 = UIComponents.Colors.AccentRed
	blip.BorderSizePixel = 0
	blip.ZIndex = 7
	UIComponents.applyCorner(blip, 2)
	blip.Parent = minimapInner

	UIComponents.tweenLoop(blip, 2 + math.random(), {BackgroundTransparency = 0.5})
end

UIComponents.animateIn(minimapFrame, "right", 0.7)

task.spawn(function()
	while true do
		task.wait(5)
		local healthVal = 0.3 + math.random() * 0.7
		hudAPI.updateHealth(healthVal)
		task.wait(0.5)
		local manaVal = 0.2 + math.random() * 0.8
		hudAPI.updateMana(manaVal)
	end
end)
