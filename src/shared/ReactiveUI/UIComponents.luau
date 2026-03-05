local TweenService = game:GetService("TweenService")

local UIComponents = {}

UIComponents.Colors = {
	Background = Color3.fromRGB(12, 12, 18),
	Surface = Color3.fromRGB(18, 18, 28),
	SurfaceLight = Color3.fromRGB(28, 28, 42),
	Glass = Color3.fromRGB(30, 30, 50),
	GlassEdge = Color3.fromRGB(60, 60, 90),

	AccentPrimary = Color3.fromRGB(120, 80, 255),
	AccentSecondary = Color3.fromRGB(0, 200, 255),
	AccentTertiary = Color3.fromRGB(255, 80, 180),
	AccentGold = Color3.fromRGB(255, 200, 60),
	AccentGreen = Color3.fromRGB(60, 220, 140),
	AccentRed = Color3.fromRGB(255, 70, 80),

	TextPrimary = Color3.fromRGB(240, 240, 255),
	TextSecondary = Color3.fromRGB(160, 160, 200),
	TextMuted = Color3.fromRGB(100, 100, 140),

	HealthBar = Color3.fromRGB(255, 60, 80),
	HealthBarEnd = Color3.fromRGB(255, 120, 60),
	ManaBar = Color3.fromRGB(60, 120, 255),
	ManaBarEnd = Color3.fromRGB(160, 60, 255),
	XPBar = Color3.fromRGB(60, 220, 140),
	XPBarEnd = Color3.fromRGB(0, 200, 255),
}

UIComponents.Fonts = {
	Title = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold),
	Body = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium),
	Light = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular),
	Mono = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold),
}

function UIComponents.tween(instance: Instance, duration: number, properties: {[string]: any}, style: Enum.EasingStyle?, direction: Enum.EasingDirection?)
	local tweenInfo = TweenInfo.new(
		duration,
		style or Enum.EasingStyle.Quint,
		direction or Enum.EasingDirection.Out
	)
	local tween = TweenService:Create(instance, tweenInfo, properties)
	tween:Play()
	return tween
end

function UIComponents.tweenLoop(instance: Instance, duration: number, properties: {[string]: any})
	local tweenInfo = TweenInfo.new(
		duration,
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.InOut,
		-1,
		true
	)
	local tween = TweenService:Create(instance, tweenInfo, properties)
	tween:Play()
	return tween
end

function UIComponents.applyCorner(parent: GuiObject, radius: number): UICorner
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = parent
	return corner
end

function UIComponents.applyGradient(parent: GuiObject, colorStart: Color3, colorEnd: Color3, rotation: number?): UIGradient
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, colorStart),
		ColorSequenceKeypoint.new(1, colorEnd),
	})
	gradient.Rotation = rotation or 0
	gradient.Parent = parent
	return gradient
end

function UIComponents.applyMultiGradient(parent: GuiObject, keypoints: {{position: number, color: Color3}}, rotation: number?): UIGradient
	local gradient = Instance.new("UIGradient")
	local colorKeypoints = {}
	for _, kp in keypoints do
		table.insert(colorKeypoints, ColorSequenceKeypoint.new(kp.position, kp.color))
	end
	gradient.Color = ColorSequence.new(colorKeypoints)
	gradient.Rotation = rotation or 0
	gradient.Parent = parent
	return gradient
end

function UIComponents.applyStroke(parent: GuiObject, color: Color3, thickness: number?, transparency: number?): UIStroke
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = thickness or 1
	stroke.Transparency = transparency or 0.5
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	parent.BorderSizePixel = 0
	stroke.Parent = parent
	return stroke
end

function UIComponents.applyShadow(parent: GuiObject, color: Color3?, size: number?): Frame
	local shadowSize = size or 20
	local shadow = Instance.new("Frame")
	shadow.Name = "Shadow"
	shadow.BackgroundColor3 = color or Color3.fromRGB(0, 0, 0)
	shadow.BackgroundTransparency = 0.6
	shadow.Size = UDim2.new(1, shadowSize * 2, 1, shadowSize * 2)
	shadow.Position = UDim2.new(0, -shadowSize, 0, -shadowSize)
	shadow.ZIndex = parent.ZIndex - 1
	shadow.BorderSizePixel = 0
	UIComponents.applyCorner(shadow, 16)
	shadow.Parent = parent
	return shadow
end

function UIComponents.createGlassPanel(props: {
	name: string?,
	size: UDim2,
	position: UDim2,
	parent: GuiObject,
	anchorPoint: Vector2?,
	cornerRadius: number?,
	transparency: number?,
	zIndex: number?,
	layoutOrder: number?,
}): Frame
	local panel = Instance.new("Frame")
	panel.Name = props.name or "GlassPanel"
	panel.Size = props.size
	panel.Position = props.position
	panel.AnchorPoint = props.anchorPoint or Vector2.new(0, 0)
	panel.BackgroundColor3 = UIComponents.Colors.Glass
	panel.BackgroundTransparency = props.transparency or 0.3
	panel.BorderSizePixel = 0
	panel.ZIndex = props.zIndex or 1
	panel.LayoutOrder = props.layoutOrder or 0

	UIComponents.applyCorner(panel, props.cornerRadius or 12)
	UIComponents.applyStroke(panel, UIComponents.Colors.GlassEdge, 1, 0.6)

	panel.Parent = props.parent
	return panel
end

function UIComponents.createLabel(props: {
	text: string,
	size: UDim2?,
	position: UDim2?,
	parent: GuiObject,
	font: Font?,
	textSize: number?,
	color: Color3?,
	anchorPoint: Vector2?,
	xAlignment: Enum.TextXAlignment?,
	yAlignment: Enum.TextYAlignment?,
	zIndex: number?,
	name: string?,
}): TextLabel
	local label = Instance.new("TextLabel")
	label.Name = props.name or "Label"
	label.Text = props.text
	label.Size = props.size or UDim2.new(1, 0, 1, 0)
	label.Position = props.position or UDim2.new(0, 0, 0, 0)
	label.AnchorPoint = props.anchorPoint or Vector2.new(0, 0)
	label.BackgroundTransparency = 1
	label.FontFace = props.font or UIComponents.Fonts.Body
	label.TextSize = props.textSize or 14
	label.TextColor3 = props.color or UIComponents.Colors.TextPrimary
	label.TextXAlignment = props.xAlignment or Enum.TextXAlignment.Left
	label.TextYAlignment = props.yAlignment or Enum.TextYAlignment.Center
	label.ZIndex = props.zIndex or 2
	label.Parent = props.parent
	return label
end

function UIComponents.createIcon(props: {
	text: string,
	size: UDim2?,
	position: UDim2?,
	parent: GuiObject,
	color: Color3?,
	textSize: number?,
	anchorPoint: Vector2?,
	zIndex: number?,
}): TextLabel
	local icon = Instance.new("TextLabel")
	icon.Name = "Icon"
	icon.Text = props.text
	icon.Size = props.size or UDim2.new(0, 24, 0, 24)
	icon.Position = props.position or UDim2.new(0, 0, 0, 0)
	icon.AnchorPoint = props.anchorPoint or Vector2.new(0, 0)
	icon.BackgroundTransparency = 1
	icon.FontFace = UIComponents.Fonts.Body
	icon.TextSize = props.textSize or 18
	icon.TextColor3 = props.color or UIComponents.Colors.AccentPrimary
	icon.TextXAlignment = Enum.TextXAlignment.Center
	icon.TextYAlignment = Enum.TextYAlignment.Center
	icon.ZIndex = props.zIndex or 2
	icon.Parent = props.parent
	return icon
end

function UIComponents.createProgressBar(props: {
	name: string?,
	size: UDim2,
	position: UDim2,
	parent: GuiObject,
	fillColor: Color3?,
	fillColorEnd: Color3?,
	backgroundColor: Color3?,
	cornerRadius: number?,
	anchorPoint: Vector2?,
	zIndex: number?,
	initialFill: number?,
}): {container: Frame, fill: Frame, gradient: UIGradient?}
	local container = Instance.new("Frame")
	container.Name = props.name or "ProgressBar"
	container.Size = props.size
	container.Position = props.position
	container.AnchorPoint = props.anchorPoint or Vector2.new(0, 0)
	container.BackgroundColor3 = props.backgroundColor or Color3.fromRGB(20, 20, 35)
	container.BackgroundTransparency = 0.3
	container.BorderSizePixel = 0
	container.ZIndex = props.zIndex or 2
	container.ClipsDescendants = true

	local radius = props.cornerRadius or 6
	UIComponents.applyCorner(container, radius)

	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.new(props.initialFill or 1, 0, 1, 0)
	fill.Position = UDim2.new(0, 0, 0, 0)
	fill.BackgroundColor3 = props.fillColor or UIComponents.Colors.AccentPrimary
	fill.BorderSizePixel = 0
	fill.ZIndex = (props.zIndex or 2) + 1
	UIComponents.applyCorner(fill, radius)
	fill.Parent = container

	local gradient = nil
	if props.fillColorEnd then
		gradient = UIComponents.applyGradient(fill, props.fillColor or UIComponents.Colors.AccentPrimary, props.fillColorEnd, 0)
	end

	local shimmer = Instance.new("Frame")
	shimmer.Name = "Shimmer"
	shimmer.Size = UDim2.new(0.3, 0, 1, 0)
	shimmer.Position = UDim2.new(-0.3, 0, 0, 0)
	shimmer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	shimmer.BackgroundTransparency = 0.85
	shimmer.BorderSizePixel = 0
	shimmer.ZIndex = (props.zIndex or 2) + 2
	shimmer.Parent = fill

	local shimmerGradient = Instance.new("UIGradient")
	shimmerGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.5, 0),
		NumberSequenceKeypoint.new(1, 1),
	})
	shimmerGradient.Parent = shimmer

	task.spawn(function()
		while shimmer.Parent do
			shimmer.Position = UDim2.new(-0.3, 0, 0, 0)
			UIComponents.tween(shimmer, 2, {Position = UDim2.new(1, 0, 0, 0)}, Enum.EasingStyle.Linear)
			task.wait(3)
		end
	end)

	container.Parent = props.parent
	return {container = container, fill = fill, gradient = gradient}
end

function UIComponents.createButton(props: {
	text: string,
	size: UDim2,
	position: UDim2,
	parent: GuiObject,
	color: Color3?,
	textColor: Color3?,
	cornerRadius: number?,
	anchorPoint: Vector2?,
	zIndex: number?,
	onClick: (() -> ())?,
	icon: string?,
}): TextButton
	local button = Instance.new("TextButton")
	button.Name = props.text
	button.Text = ""
	button.Size = props.size
	button.Position = props.position
	button.AnchorPoint = props.anchorPoint or Vector2.new(0, 0)
	button.BackgroundColor3 = props.color or UIComponents.Colors.AccentPrimary
	button.BackgroundTransparency = 0.1
	button.BorderSizePixel = 0
	button.ZIndex = props.zIndex or 2
	button.AutoButtonColor = false

	UIComponents.applyCorner(button, props.cornerRadius or 8)
	UIComponents.applyStroke(button, props.color or UIComponents.Colors.AccentPrimary, 1, 0.3)

	local innerGlow = Instance.new("UIGradient")
	innerGlow.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.3),
		NumberSequenceKeypoint.new(0.5, 0.6),
		NumberSequenceKeypoint.new(1, 0.3),
	})
	innerGlow.Rotation = 90
	innerGlow.Parent = button

	if props.icon then
		UIComponents.createIcon({
			text = props.icon,
			size = UDim2.new(0, 20, 0, 20),
			position = UDim2.new(0, 10, 0.5, 0),
			parent = button,
			color = props.textColor or UIComponents.Colors.TextPrimary,
			anchorPoint = Vector2.new(0, 0.5),
			zIndex = (props.zIndex or 2) + 1,
		})
	end

	UIComponents.createLabel({
		text = props.text,
		size = UDim2.new(1, props.icon and -35 or 0, 1, 0),
		position = UDim2.new(0, props.icon and 35 or 0, 0, 0),
		parent = button,
		font = UIComponents.Fonts.Body,
		textSize = 13,
		color = props.textColor or UIComponents.Colors.TextPrimary,
		xAlignment = Enum.TextXAlignment.Center,
		zIndex = (props.zIndex or 2) + 1,
	})

	button.MouseEnter:Connect(function()
		UIComponents.tween(button, 0.2, {BackgroundTransparency = 0})
	end)

	button.MouseLeave:Connect(function()
		UIComponents.tween(button, 0.3, {BackgroundTransparency = 0.1})
	end)

	button.MouseButton1Down:Connect(function()
		UIComponents.tween(button, 0.1, {Size = props.size - UDim2.new(0, 4, 0, 4)})
	end)

	button.MouseButton1Up:Connect(function()
		UIComponents.tween(button, 0.2, {Size = props.size})
	end)

	if props.onClick then
		button.MouseButton1Click:Connect(props.onClick)
	end

	button.Parent = props.parent
	return button
end

function UIComponents.createToggle(props: {
	label: string,
	size: UDim2,
	position: UDim2,
	parent: GuiObject,
	initialState: boolean?,
	onToggle: ((boolean) -> ())?,
	zIndex: number?,
}): {container: Frame, state: boolean}
	local state = props.initialState or false
	local container = Instance.new("Frame")
	container.Name = props.label .. "Toggle"
	container.Size = props.size
	container.Position = props.position
	container.BackgroundTransparency = 1
	container.ZIndex = props.zIndex or 2
	container.Parent = props.parent

	UIComponents.createLabel({
		text = props.label,
		size = UDim2.new(1, -60, 1, 0),
		position = UDim2.new(0, 0, 0, 0),
		parent = container,
		font = UIComponents.Fonts.Light,
		textSize = 13,
		color = UIComponents.Colors.TextSecondary,
		zIndex = (props.zIndex or 2) + 1,
	})

	local track = Instance.new("TextButton")
	track.Name = "Track"
	track.Text = ""
	track.Size = UDim2.new(0, 44, 0, 24)
	track.Position = UDim2.new(1, -44, 0.5, 0)
	track.AnchorPoint = Vector2.new(0, 0.5)
	track.BackgroundColor3 = state and UIComponents.Colors.AccentGreen or UIComponents.Colors.SurfaceLight
	track.BorderSizePixel = 0
	track.AutoButtonColor = false
	track.ZIndex = (props.zIndex or 2) + 1
	UIComponents.applyCorner(track, 12)
	track.Parent = container

	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.Size = UDim2.new(0, 18, 0, 18)
	knob.Position = state and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
	knob.AnchorPoint = Vector2.new(0, 0.5)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	knob.ZIndex = (props.zIndex or 2) + 2
	UIComponents.applyCorner(knob, 9)
	knob.Parent = track

	track.MouseButton1Click:Connect(function()
		state = not state
		UIComponents.tween(track, 0.25, {
			BackgroundColor3 = state and UIComponents.Colors.AccentGreen or UIComponents.Colors.SurfaceLight,
		})
		UIComponents.tween(knob, 0.25, {
			Position = state and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
		}, Enum.EasingStyle.Back)

		if props.onToggle then
			props.onToggle(state)
		end
	end)

	return {container = container, state = state}
end

function UIComponents.createSlider(props: {
	label: string,
	size: UDim2,
	position: UDim2,
	parent: GuiObject,
	min: number?,
	max: number?,
	initial: number?,
	zIndex: number?,
	onChange: ((number) -> ())?,
}): Frame
	local min = props.min or 0
	local max = props.max or 100
	local value = props.initial or 50
	local dragging = false

	local container = Instance.new("Frame")
	container.Name = props.label .. "Slider"
	container.Size = props.size
	container.Position = props.position
	container.BackgroundTransparency = 1
	container.ZIndex = props.zIndex or 2
	container.Parent = props.parent

	UIComponents.createLabel({
		text = props.label,
		size = UDim2.new(0.6, 0, 0, 16),
		position = UDim2.new(0, 0, 0, 0),
		parent = container,
		font = UIComponents.Fonts.Light,
		textSize = 12,
		color = UIComponents.Colors.TextSecondary,
		zIndex = (props.zIndex or 2) + 1,
	})

	local valueLabel = UIComponents.createLabel({
		text = tostring(math.floor(value)),
		size = UDim2.new(0.4, 0, 0, 16),
		position = UDim2.new(0.6, 0, 0, 0),
		parent = container,
		font = UIComponents.Fonts.Mono,
		textSize = 12,
		color = UIComponents.Colors.AccentSecondary,
		xAlignment = Enum.TextXAlignment.Right,
		zIndex = (props.zIndex or 2) + 1,
		name = "Value",
	})

	local track = Instance.new("Frame")
	track.Name = "Track"
	track.Size = UDim2.new(1, 0, 0, 6)
	track.Position = UDim2.new(0, 0, 1, -10)
	track.BackgroundColor3 = UIComponents.Colors.SurfaceLight
	track.BorderSizePixel = 0
	track.ZIndex = (props.zIndex or 2) + 1
	track.ClipsDescendants = true
	UIComponents.applyCorner(track, 3)
	track.Parent = container

	local fillRatio = (value - min) / (max - min)
	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.new(fillRatio, 0, 1, 0)
	fill.BackgroundColor3 = UIComponents.Colors.AccentPrimary
	fill.BorderSizePixel = 0
	fill.ZIndex = (props.zIndex or 2) + 2
	UIComponents.applyCorner(fill, 3)
	UIComponents.applyGradient(fill, UIComponents.Colors.AccentSecondary, UIComponents.Colors.AccentPrimary, 0)
	fill.Parent = track

	local handle = Instance.new("TextButton")
	handle.Name = "Handle"
	handle.Text = ""
	handle.Size = UDim2.new(0, 16, 0, 16)
	handle.Position = UDim2.new(fillRatio, 0, 0.5, 0)
	handle.AnchorPoint = Vector2.new(0.5, 0.5)
	handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	handle.BorderSizePixel = 0
	handle.AutoButtonColor = false
	handle.ZIndex = (props.zIndex or 2) + 3
	UIComponents.applyCorner(handle, 8)
	UIComponents.applyShadow(handle, UIComponents.Colors.AccentPrimary, 6)
	handle.Parent = track

	local inputConn
	local releaseConn

	handle.MouseButton1Down:Connect(function()
		dragging = true
	end)

	local UserInputService = game:GetService("UserInputService")

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local trackAbsPos = track.AbsolutePosition.X
			local trackAbsSize = track.AbsoluteSize.X
			local mouseX = input.Position.X
			local ratio = math.clamp((mouseX - trackAbsPos) / trackAbsSize, 0, 1)
			value = min + (max - min) * ratio

			fill.Size = UDim2.new(ratio, 0, 1, 0)
			handle.Position = UDim2.new(ratio, 0, 0.5, 0)
			valueLabel.Text = tostring(math.floor(value))

			if props.onChange then
				props.onChange(value)
			end
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	return container
end

function UIComponents.createDivider(props: {
	position: UDim2,
	parent: GuiObject,
	width: UDim2?,
	zIndex: number?,
}): Frame
	local divider = Instance.new("Frame")
	divider.Name = "Divider"
	divider.Size = props.width or UDim2.new(1, -20, 0, 1)
	divider.Position = props.position
	divider.AnchorPoint = Vector2.new(0.5, 0)
	divider.BackgroundColor3 = UIComponents.Colors.GlassEdge
	divider.BackgroundTransparency = 0.5
	divider.BorderSizePixel = 0
	divider.ZIndex = props.zIndex or 2
	divider.Parent = props.parent

	UIComponents.applyGradient(divider, Color3.fromRGB(0, 0, 0), UIComponents.Colors.GlassEdge, 0)

	return divider
end

function UIComponents.animateIn(element: GuiObject, direction: string?, delay: number?)
	local dir = direction or "bottom"
	local originalPos = element.Position
	local originalTransparency = element.BackgroundTransparency

	if dir == "bottom" then
		element.Position = originalPos + UDim2.new(0, 0, 0, 30)
	elseif dir == "top" then
		element.Position = originalPos - UDim2.new(0, 0, 0, 30)
	elseif dir == "left" then
		element.Position = originalPos - UDim2.new(0, 30, 0, 0)
	elseif dir == "right" then
		element.Position = originalPos + UDim2.new(0, 30, 0, 0)
	end
	element.BackgroundTransparency = 1

	task.delay(delay or 0, function()
		UIComponents.tween(element, 0.5, {
			Position = originalPos,
			BackgroundTransparency = originalTransparency,
		}, Enum.EasingStyle.Back)
	end)
end

return UIComponents
