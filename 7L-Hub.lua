local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")
local httpService = game:GetService("HttpService")
local virtualUser = game:GetService("VirtualUser")
local replicatedStorage = game:GetService("ReplicatedStorage")
local contextActionService = game:GetService("ContextActionService")
local guiService = game:GetService("GuiService")
local tweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local aimbotActive = false
local aimbotRadius = 150
local teamCheck = false
local speedEnabled = false
local currentSpeed = 16
local noclipEnabled = false
local fpsValue = 0
local espObjects = {}
local bordas = {}
local hue = 0
local aimbotPart = "Head"
local aimbotPrecision = 100
local aimbotVisibility = 50
local fovCircleEnabled = true
local fovCircleRGB = true
local removeTextures = false
local removeParticles = false
local showFPS = false
local customFOV = false
local currentFOV = 70
local externalCrosshair = false
local crosshairSize = 30
local crosshairTransparency = 0
local infiniteJump = false
local shiftLockEnabled = false
local menuColor = Color3.fromRGB(255, 34, 0)
local menuWidth = 500
local menuHeight = 500
local savedOptions = {}
local selectedPlayer = nil
local loopTeleport = false
local loopConnection = nil
local antiAFK = false
local antiAFKConnection = nil
local antiAFKTimer = 0
local godMode = false
local godModeConnection = nil
local godModeHealthConnection = nil
local godModeLastPosition = nil
local triggerBot = false
local autoClicker = false
local clickCount = 1
local autoClickerPosition = UDim2.new(0.5, -25, 0.5, -25)
local autoClickerButton = nil
local isDraggingClicker = false
local autoFarm = false
local autoFarmConnection = nil
local projectileConnection = nil
local isGodModeTeleporting = false
local isMobile = userInputService.TouchEnabled
local lastTriggerTime = 0
local shiftLockConnection = nil
local gradientRotation = 0
local gradientObjects = {}
local splashFrame = nil
local splashLogo = nil
local splashSubtitle = nil

local espSettings = {
	Boxes = false,
	Skeleton = false,
	Names = false,
	HealthBar = false,
	RGB = false
}

local PRIMARY = menuColor
local BG_COLOR = Color3.fromRGB(8, 8, 12)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "7LAG_Menu"
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

function createSplashScreen()
	if splashFrame then splashFrame:Destroy() end
	
	splashFrame = Instance.new("Frame")
	splashFrame.Size = UDim2.new(0, 400, 0, 280)
	splashFrame.Position = UDim2.new(0.5, -200, 0.5, -140)
	splashFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
	splashFrame.BackgroundTransparency = 0.15
	splashFrame.BorderSizePixel = 0
	splashFrame.Parent = screenGui
	splashFrame.ZIndex = 2000

	local splashCorner = Instance.new("UICorner")
	splashCorner.CornerRadius = UDim.new(0, 25)
	splashCorner.Parent = splashFrame

	local splashStroke = Instance.new("UIStroke")
	splashStroke.Color = Color3.fromRGB(255, 30, 30)
	splashStroke.Thickness = 3
	splashStroke.Parent = splashFrame

	local splashGradient = Instance.new("UIGradient")
	splashGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
	})
	splashGradient.Rotation = 45
	splashGradient.Parent = splashFrame

	splashLogo = Instance.new("TextLabel")
	splashLogo.Size = UDim2.new(0, 200, 0, 100)
	splashLogo.Position = UDim2.new(0.5, -100, 0.3, -30)
	splashLogo.BackgroundTransparency = 1
	splashLogo.TextColor3 = Color3.fromRGB(255, 20, 20)
	splashLogo.Text = "7L"
	splashLogo.Font = Enum.Font.GothamBlack
	splashLogo.TextSize = 80
	splashLogo.Parent = splashFrame
	splashLogo.ZIndex = 2001

	splashSubtitle = Instance.new("TextLabel")
	splashSubtitle.Size = UDim2.new(1, 0, 0, 35)
	splashSubtitle.Position = UDim2.new(0, 0, 0.65, 0)
	splashSubtitle.BackgroundTransparency = 1
	splashSubtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	splashSubtitle.Text = ""
	splashSubtitle.Font = Enum.Font.GothamBold
	splashSubtitle.TextSize = 22
	splashSubtitle.Parent = splashFrame
	splashSubtitle.ZIndex = 2001

	local progressBar = Instance.new("Frame")
	progressBar.Size = UDim2.new(0.6, 0, 0, 3)
	progressBar.Position = UDim2.new(0.2, 0, 0.85, 0)
	progressBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	progressBar.BackgroundTransparency = 0.5
	progressBar.Parent = splashFrame
	progressBar.ZIndex = 2001

	local progressCorner = Instance.new("UICorner")
	progressCorner.CornerRadius = UDim.new(1, 0)
	progressCorner.Parent = progressBar

	local progressFill = Instance.new("Frame")
	progressFill.Size = UDim2.new(0, 0, 1, 0)
	progressFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	progressFill.Parent = progressBar
	progressFill.ZIndex = 2001

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = progressFill

	local loadingText = Instance.new("TextLabel")
	loadingText.Size = UDim2.new(1, 0, 0, 20)
	loadingText.Position = UDim2.new(0, 0, 0.92, 0)
	loadingText.BackgroundTransparency = 1
	loadingText.TextColor3 = Color3.fromRGB(150, 150, 170)
	loadingText.Text = "Carregando..."
	loadingText.Font = Enum.Font.Gotham
	loadingText.TextSize = 12
	loadingText.TextXAlignment = Enum.TextXAlignment.Center
	loadingText.Parent = splashFrame
	loadingText.ZIndex = 2001

	coroutine.wrap(function()
		local rotateTween = tweenService:Create(splashLogo, TweenInfo.new(1.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = 360})
		rotateTween:Play()
		rotateTween.Completed:Wait()
		splashLogo.Rotation = 0

		local fullText = "THE BEST HUB"
		local currentText = ""
		for i = 1, #fullText do
			currentText = currentText .. fullText:sub(i, i)
			splashSubtitle.Text = currentText
			task.wait(0.1)
		end

		local progressTween = tweenService:Create(progressFill, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 1, 0)})
		progressTween:Play()
		progressTween.Completed:Wait()

		loadingText.Text = "Pronto!"
		task.wait(0.5)

		local fadeOut = tweenService:Create(splashFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 200, 0, 140)
		})
		fadeOut:Play()

		local textFade = tweenService:Create(splashLogo, TweenInfo.new(0.8), {TextTransparency = 1})
		textFade:Play()
		
		local subFade = tweenService:Create(splashSubtitle, TweenInfo.new(0.8), {TextTransparency = 1})
		subFade:Play()
		
		local loadingFade = tweenService:Create(loadingText, TweenInfo.new(0.8), {TextTransparency = 1})
		loadingFade:Play()

		fadeOut.Completed:Wait()
		splashFrame:Destroy()
		splashFrame = nil
		splashLogo = nil
		splashSubtitle = nil

		print("7L HUB v9 carregado!")
		print("Luisggpr | 7Lag")
		print("7L Hub on top")
	end)()
end

createSplashScreen()

function createAnimatedGradient(parent, rotationOffset)
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
	})
	gradient.Rotation = rotationOffset or 0
	gradient.Parent = parent

	table.insert(gradientObjects, {
		gradient = gradient,
		offset = rotationOffset or 0
	})

	return gradient
end

runService.RenderStepped:Connect(function(deltaTime)
	gradientRotation = gradientRotation + 50 * deltaTime
	if gradientRotation > 360 then gradientRotation = gradientRotation - 360 end

	for _, obj in pairs(gradientObjects) do
		if obj.gradient and obj.gradient.Parent then
			obj.gradient.Rotation = gradientRotation + obj.offset
		end
	end
end)

local function loadSavedOptions()
	local success, data = pcall(function()
		return httpService:JSONDecode(player:GetAttribute("7LAG_SaveData") or "{}")
	end)
	if success and data then
		savedOptions = data
		if savedOptions.menuColor then
			local success2, color = pcall(function() return Color3.fromHex(savedOptions.menuColor) end)
			if success2 and color then menuColor = color; PRIMARY = menuColor end
		end
		if savedOptions.menuWidth then menuWidth = savedOptions.menuWidth end
		if savedOptions.menuHeight then menuHeight = savedOptions.menuHeight end
		if savedOptions.infiniteJump ~= nil then infiniteJump = savedOptions.infiniteJump end
		if savedOptions.clickCount then clickCount = savedOptions.clickCount end
		if savedOptions.fovCircleRGB ~= nil then fovCircleRGB = savedOptions.fovCircleRGB end
		if savedOptions.shiftLockEnabled ~= nil then shiftLockEnabled = savedOptions.shiftLockEnabled end
	end
end

local function saveOptions()
	local data = {
		menuColor = menuColor:ToHex(),
		menuWidth = menuWidth,
		menuHeight = menuHeight,
		espSettings = espSettings,
		aimbotActive = aimbotActive,
		aimbotRadius = aimbotRadius,
		teamCheck = teamCheck,
		aimbotPart = aimbotPart,
		speedEnabled = speedEnabled,
		currentSpeed = currentSpeed,
		noclipEnabled = noclipEnabled,
		infiniteJump = infiniteJump,
		shiftLockEnabled = shiftLockEnabled,
		externalCrosshair = externalCrosshair,
		crosshairSize = crosshairSize,
		crosshairTransparency = crosshairTransparency,
		removeTextures = removeTextures,
		removeParticles = removeParticles,
		showFPS = showFPS,
		customFOV = customFOV,
		currentFOV = currentFOV,
		fovCircleEnabled = fovCircleEnabled,
		fovCircleRGB = fovCircleRGB,
		aimbotPrecision = aimbotPrecision,
		aimbotVisibility = aimbotVisibility,
		antiAFK = antiAFK,
		godMode = godMode,
		triggerBot = triggerBot,
		autoClicker = autoClicker,
		clickCount = clickCount,
		autoFarm = autoFarm
	}
	player:SetAttribute("7LAG_SaveData", httpService:JSONEncode(data))
end

loadSavedOptions()

local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, menuWidth, 0, menuHeight)
menuFrame.Position = UDim2.new(0.5, -menuWidth/2, 0.5, -menuHeight/2)
menuFrame.BackgroundColor3 = BG_COLOR
menuFrame.BackgroundTransparency = 0.05
menuFrame.Visible = false
menuFrame.Parent = screenGui
menuFrame.ZIndex = 10

createAnimatedGradient(menuFrame, 0)

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 10)
menuCorner.Parent = menuFrame

local border = Instance.new("UIStroke")
border.Color = PRIMARY
border.Thickness = 1.5
border.Transparency = 0.3
border.Parent = menuFrame

local mainButton = Instance.new("TextButton")
mainButton.Size = UDim2.new(0, 55, 0, 55)
mainButton.Position = UDim2.new(0.5, -27.5, 0, 15)
mainButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainButton.BackgroundTransparency = 0.1
mainButton.Text = "7L"
mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mainButton.TextSize = 20
mainButton.Font = Enum.Font.GothamBlack
mainButton.Parent = screenGui
mainButton.ZIndex = 100

createAnimatedGradient(mainButton, 90)

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(1, 0)
mainCorner.Parent = mainButton

local mainBorder = Instance.new("UIStroke")
mainBorder.Color = Color3.fromRGB(255, 0, 0)
mainBorder.Thickness = 2.5
mainBorder.Transparency = 0.3
mainBorder.Parent = mainButton

local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 4, 1, 4)
shadow.Position = UDim2.new(0, -2, 0, -2)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316046979"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(4, 4, 16, 16)
shadow.Parent = mainButton

local mainDragging = false
local mainDragStart = nil
local mainStartPos = nil

mainButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		mainDragging = true
		mainDragStart = input.Position
		mainStartPos = mainButton.Position
	end
end)

mainButton.InputChanged:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and mainDragging then
		local delta = input.Position - mainDragStart
		local newX = mainStartPos.X.Offset + delta.X
		local newY = mainStartPos.Y.Offset + delta.Y
		newX = math.clamp(newX, 0, screenGui.AbsoluteSize.X - mainButton.AbsoluteSize.X)
		newY = math.clamp(newY, 0, screenGui.AbsoluteSize.Y - mainButton.AbsoluteSize.Y)
		mainButton.Position = UDim2.new(0, newX, 0, newY)
	end
end)

mainButton.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		mainDragging = false
	end
end)

mainButton.MouseButton1Click:Connect(function()
	menuFrame.Visible = not menuFrame.Visible
end)

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
topBar.BackgroundTransparency = 0.2
topBar.Parent = menuFrame
topBar.ZIndex = 11

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 10)
topCorner.Parent = topBar

local topLogo = Instance.new("TextLabel")
topLogo.Size = UDim2.new(0, 35, 0, 35)
topLogo.Position = UDim2.new(0, 12, 0.5, -17)
topLogo.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
topLogo.BackgroundTransparency = 0.2
topLogo.TextColor3 = Color3.fromRGB(255, 255, 255)
topLogo.Text = "7L"
topLogo.Font = Enum.Font.GothamBlack
topLogo.TextSize = 18
topLogo.Parent = topBar
topLogo.ZIndex = 11

createAnimatedGradient(topLogo, 180)

local topLogoCorner = Instance.new("UICorner")
topLogoCorner.CornerRadius = UDim.new(0, 10)
topLogoCorner.Parent = topLogo

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 52, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
titleLabel.Text = "7L HUB"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 20
titleLabel.Parent = topBar
titleLabel.ZIndex = 11

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 32, 0, 32)
closeButton.Position = UDim2.new(1, -40, 0.5, -16)
closeButton.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
closeButton.BackgroundTransparency = 0.3
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Text = "✕"
closeButton.Font = Enum.Font.GothamBlack
closeButton.TextSize = 18
closeButton.Parent = topBar
closeButton.ZIndex = 11

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
	menuFrame.Visible = false
end)

local mainContainer = Instance.new("Frame")
mainContainer.Size = UDim2.new(1, 0, 1, -45)
mainContainer.Position = UDim2.new(0, 0, 0, 45)
mainContainer.BackgroundTransparency = 1
mainContainer.Parent = menuFrame
mainContainer.ZIndex = 11

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 100, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
sidebar.BackgroundTransparency = 0.3
sidebar.Parent = mainContainer
sidebar.ZIndex = 11

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 8)
sidebarCorner.Parent = sidebar

local navButtons = {}
local navNames = {"HOME", "VISUALS", "AIMBOT", "CHARACTER", "FPS", "TELEPORT", "OTHERS", "CONFIG", "CREDITS"}

for i, name in ipairs(navNames) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -8, 0, 30)
	btn.Position = UDim2.new(0, 4, 0, 4 + (i-1) * 34)
	btn.BackgroundTransparency = 1
	btn.TextColor3 = Color3.fromRGB(160, 160, 190)
	btn.Text = name
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 12
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Parent = sidebar
	btn.ZIndex = 12

	if i == 1 then btn.TextColor3 = Color3.fromRGB(255, 50, 50) end
	navButtons[name] = btn
end

local dividerLine = Instance.new("Frame")
dividerLine.Size = UDim2.new(0, 1, 0.9, 0)
dividerLine.Position = UDim2.new(1, -1, 0.05, 0)
dividerLine.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
dividerLine.BackgroundTransparency = 0.5
dividerLine.Parent = sidebar
dividerLine.ZIndex = 12

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -110, 1, -10)
contentContainer.Position = UDim2.new(0, 105, 0, 5)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainContainer
contentContainer.ZIndex = 11

function createToggle(parent, title, yPos, default, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -5, 0, 24)
	frame.Position = UDim2.new(0, 5, 0, yPos)
	frame.BackgroundTransparency = 1
	frame.Parent = parent
	frame.ZIndex = 12

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.55, 0, 1, 0)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(210, 210, 230)
	label.Text = title
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.Gotham
	label.TextSize = 11
	label.Parent = frame
	label.ZIndex = 12

	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Size = UDim2.new(0, 30, 0, 16)
	toggleBtn.Position = UDim2.new(1, -34, 0.5, -8)
	toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
	toggleBtn.Text = ""
	toggleBtn.Parent = frame
	toggleBtn.ZIndex = 12

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(1, 0)
	toggleCorner.Parent = toggleBtn

	local toggleBall = Instance.new("Frame")
	toggleBall.Size = UDim2.new(0, 10, 0, 10)
	toggleBall.Position = UDim2.new(0, 3, 0.5, -5)
	toggleBall.BackgroundColor3 = Color3.fromRGB(180, 180, 200)
	toggleBall.Parent = toggleBtn
	toggleBall.ZIndex = 13

	local ballCorner = Instance.new("UICorner")
	ballCorner.CornerRadius = UDim.new(1, 0)
	ballCorner.Parent = toggleBall

	local active = default or false

	if active then
		toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		toggleBall.Position = UDim2.new(1, -13, 0.5, -5)
		toggleBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	end

	toggleBtn.MouseButton1Click:Connect(function()
		active = not active
		if active then
			toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			toggleBall.Position = UDim2.new(1, -13, 0.5, -5)
			toggleBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		else
			toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
			toggleBall.Position = UDim2.new(0, 3, 0.5, -5)
			toggleBall.BackgroundColor3 = Color3.fromRGB(180, 180, 200)
		end
		callback(active)
		saveOptions()
	end)

	return frame
end

function createSlider(parent, title, yPos, min, max, default, callback, suffix)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -5, 0, 38)
	frame.Position = UDim2.new(0, 5, 0, yPos)
	frame.BackgroundTransparency = 1
	frame.Parent = parent
	frame.ZIndex = 12

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.5, 0, 0, 16)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(210, 210, 230)
	label.Text = title
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.Gotham
	label.TextSize = 11
	label.Parent = frame
	label.ZIndex = 12

	local valueBg = Instance.new("Frame")
	valueBg.Size = UDim2.new(0, 40, 0, 16)
	valueBg.Position = UDim2.new(1, -45, 0, 0)
	valueBg.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	valueBg.BackgroundTransparency = 0.3
	valueBg.Parent = frame
	valueBg.ZIndex = 12

	local valueCorner = Instance.new("UICorner")
	valueCorner.CornerRadius = UDim.new(0, 4)
	valueCorner.Parent = valueBg

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.new(1, 0, 1, 0)
	valueLabel.BackgroundTransparency = 1
	valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	valueLabel.Text = tostring(default) .. (suffix or "")
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextSize = 10
	valueLabel.Parent = valueBg
	valueLabel.ZIndex = 12

	local sliderBg = Instance.new("Frame")
	sliderBg.Size = UDim2.new(1, -50, 0, 3)
	sliderBg.Position = UDim2.new(0, 0, 0, 24)
	sliderBg.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
	sliderBg.Parent = frame
	sliderBg.ZIndex = 12

	local sliderCorner = Instance.new("UICorner")
	sliderCorner.CornerRadius = UDim.new(1, 0)
	sliderCorner.Parent = sliderBg

	local sliderFill = Instance.new("Frame")
	local initialPercent = (default - min) / (max - min)
	sliderFill.Size = UDim2.new(initialPercent, 0, 1, 0)
	sliderFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	sliderFill.Parent = sliderBg
	sliderFill.ZIndex = 12

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = sliderFill

	local sliderBtn = Instance.new("TextButton")
	sliderBtn.Size = UDim2.new(0, 10, 0, 10)
	sliderBtn.Position = UDim2.new(initialPercent, -5, 0.5, -5)
	sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sliderBtn.Text = ""
	sliderBtn.Parent = sliderBg
	sliderBtn.ZIndex = 13

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(1, 0)
	btnCorner.Parent = sliderBtn

	local value = default
	local isDragging = false
	local moveConnection = nil
	local upConnection = nil

	local function updateSlider(inputPosition)
		local x = math.clamp((inputPosition.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
		value = math.floor(min + (max - min) * x + 0.5)
		value = math.clamp(value, min, max)
		sliderFill.Size = UDim2.new(x, 0, 1, 0)
		sliderBtn.Position = UDim2.new(x, -5, 0.5, -5)
		valueLabel.Text = tostring(value) .. (suffix or "")
		callback(value)
		saveOptions()
	end

	local function startDragging()
		isDragging = true

		if moveConnection then moveConnection:Disconnect() end
		if upConnection then upConnection:Disconnect() end

		moveConnection = userInputService.InputChanged:Connect(function(input)
			if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				updateSlider(input.Position)
			end
		end)

		upConnection = userInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				isDragging = false
				if moveConnection then 
					moveConnection:Disconnect()
					moveConnection = nil
				end
				if upConnection then
					upConnection:Disconnect()
					upConnection = nil
				end
			end
		end)
	end

	sliderBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			startDragging()
		end
	end)

	sliderBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			updateSlider(input.Position)
			startDragging()
		end
	end)

	return frame
end

function createSectionTitle(parent, title, yPos)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0, 20)
	label.Position = UDim2.new(0, 5, 0, yPos)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 50, 50)
	label.Text = title
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.GothamBold
	label.TextSize = 14
	label.Parent = parent
	label.ZIndex = 12
	return label
end

function createDivider(parent, yPos)
	local dividerFrame = Instance.new("Frame")
	dividerFrame.Size = UDim2.new(1, -10, 0, 1)
	dividerFrame.Position = UDim2.new(0, 5, 0, yPos)
	dividerFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	dividerFrame.BackgroundTransparency = 0.5
	dividerFrame.Parent = parent
	dividerFrame.ZIndex = 12
	return dividerFrame
end

function createPlayerSelector(parent, title, yPos, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -5, 0, 28)
	frame.Position = UDim2.new(0, 5, 0, yPos)
	frame.BackgroundTransparency = 1
	frame.Parent = parent
	frame.ZIndex = 12

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.35, 0, 1, 0)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(210, 210, 230)
	label.Text = title
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.Gotham
	label.TextSize = 11
	label.Parent = frame
	label.ZIndex = 12

	local dropdown = Instance.new("TextButton")
	dropdown.Size = UDim2.new(0.55, -5, 1, -4)
	dropdown.Position = UDim2.new(0.45, 5, 0, 2)
	dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
	dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
	dropdown.Text = "Select Player"
	dropdown.Font = Enum.Font.Gotham
	dropdown.TextSize = 11
	dropdown.Parent = frame
	dropdown.ZIndex = 12

	local dropCorner = Instance.new("UICorner")
	dropCorner.CornerRadius = UDim.new(0, 4)
	dropCorner.Parent = dropdown

	local listFrame = nil

	local function updatePlayerList()
		local playerList = {}
		for _, plr in pairs(players:GetPlayers()) do
			if plr ~= player then
				table.insert(playerList, plr.Name)
			end
		end
		return playerList
	end

	dropdown.MouseButton1Click:Connect(function()
		if listFrame then
			listFrame:Destroy()
			listFrame = nil
			return
		end

		local options = updatePlayerList()
		if #options == 0 then options = {"No players"} end

		listFrame = Instance.new("Frame")
		listFrame.Size = UDim2.new(0.55, -5, 0, #options * 22 + 4)
		listFrame.Position = UDim2.new(0.45, 5, 0, 28)
		listFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
		listFrame.Parent = frame
		listFrame.ZIndex = 20

		local listCorner = Instance.new("UICorner")
		listCorner.CornerRadius = UDim.new(0, 4)
		listCorner.Parent = listFrame

		for i, opt in ipairs(options) do
			local optBtn = Instance.new("TextButton")
			optBtn.Size = UDim2.new(1, 0, 0, 22)
			optBtn.Position = UDim2.new(0, 0, 0, 2 + (i-1) * 22)
			optBtn.BackgroundTransparency = 1
			optBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
			optBtn.Text = opt
			optBtn.Font = Enum.Font.Gotham
			optBtn.TextSize = 11
			optBtn.Parent = listFrame
			optBtn.ZIndex = 21

			optBtn.MouseButton1Click:Connect(function()
				dropdown.Text = opt
				callback(opt)
				if listFrame then listFrame:Destroy(); listFrame = nil end
			end)
		end
	end)

	return frame
end

local homeTab = Instance.new("ScrollingFrame")
homeTab.Size = UDim2.new(1, 0, 1, 0)
homeTab.BackgroundTransparency = 1
homeTab.ScrollBarThickness = 0
homeTab.CanvasSize = UDim2.new(0, 0, 0, 0)
homeTab.Parent = contentContainer
homeTab.ZIndex = 11

local homeY = 10

local avatarFrame = Instance.new("Frame")
avatarFrame.Size = UDim2.new(0, 90, 0, 90)
avatarFrame.Position = UDim2.new(0.5, -45, 0, homeY)
avatarFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
avatarFrame.BackgroundTransparency = 0.2
avatarFrame.Parent = homeTab
avatarFrame.ZIndex = 12

local avatarCornerFrame = Instance.new("UICorner")
avatarCornerFrame.CornerRadius = UDim.new(0, 45)
avatarCornerFrame.Parent = avatarFrame

local avatarStroke = Instance.new("UIStroke")
avatarStroke.Color = Color3.fromRGB(255, 0, 0)
avatarStroke.Thickness = 2
avatarStroke.Transparency = 0.5
avatarStroke.Parent = avatarFrame

local avatarImage = Instance.new("ImageLabel")
avatarImage.Size = UDim2.new(1, -8, 1, -8)
avatarImage.Position = UDim2.new(0, 4, 0, 4)
avatarImage.BackgroundTransparency = 1
local success, thumbnail = pcall(function()
	return players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
end)
if success and thumbnail then
	avatarImage.Image = thumbnail
else
	avatarImage.Image = "rbxassetid://0"
end
avatarImage.Parent = avatarFrame
avatarImage.ZIndex = 13

local avatarImageCorner = Instance.new("UICorner")
avatarImageCorner.CornerRadius = UDim.new(0, 41)
avatarImageCorner.Parent = avatarImage

homeY = homeY + 100

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, -10, 0, 28)
nameLabel.Position = UDim2.new(0, 5, 0, homeY)
nameLabel.BackgroundTransparency = 1
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.Text = player.Name
nameLabel.Font = Enum.Font.GothamBlack
nameLabel.TextSize = 20
nameLabel.TextXAlignment = Enum.TextXAlignment.Center
nameLabel.Parent = homeTab
nameLabel.ZIndex = 12
homeY = homeY + 35

local infoFrame = Instance.new("Frame")
infoFrame.Size = UDim2.new(1, -10, 0, 90)
infoFrame.Position = UDim2.new(0, 5, 0, homeY)
infoFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
infoFrame.BackgroundTransparency = 0.2
infoFrame.Parent = homeTab
infoFrame.ZIndex = 12

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoFrame

local infoBorder = Instance.new("UIStroke")
infoBorder.Color = Color3.fromRGB(255, 0, 0)
infoBorder.Thickness = 1
infoBorder.Transparency = 0.5
infoBorder.Parent = infoFrame

local infoY = 8
local userId = player.UserId
local profileLink = "https://www.roblox.com/users/" .. userId .. "/profile"
local accountAge = player.AccountAge
local displayName = player.DisplayName

local infoItems = {
	"Display Name: " .. displayName,
	"User ID: " .. userId,
	"Account Age: " .. math.floor(accountAge) .. " dias",
	"Profile: " .. profileLink
}

for _, item in ipairs(infoItems) do
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -16, 0, 20)
	label.Position = UDim2.new(0, 8, 0, infoY)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(200, 200, 220)
	label.Text = item
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = infoFrame
	label.ZIndex = 12
	infoY = infoY + 22
end

homeY = homeY + 100
homeTab.CanvasSize = UDim2.new(0, 0, 0, homeY + 10)

local visualsTab = Instance.new("ScrollingFrame")
visualsTab.Size = UDim2.new(1, 0, 1, 0)
visualsTab.BackgroundTransparency = 1
visualsTab.ScrollBarThickness = 0
visualsTab.CanvasSize = UDim2.new(0, 0, 0, 0)
visualsTab.Visible = false
visualsTab.Parent = contentContainer
visualsTab.ZIndex = 11

local visY = 5
createToggle(visualsTab, "Team Check", visY, false, function(active) teamCheck = active; updateESP() end)
visY = visY + 28
createDivider(visualsTab, visY); visY = visY + 10
createToggle(visualsTab, "Boxes", visY, false, function(active) espSettings.Boxes = active; updateESP() end)
visY = visY + 28
createToggle(visualsTab, "Skeleton", visY, false, function(active) espSettings.Skeleton = active; updateESP() end)
visY = visY + 28
createToggle(visualsTab, "Names", visY, false, function(active) espSettings.Names = active; updateESP() end)
visY = visY + 28
createToggle(visualsTab, "Health Bar", visY, false, function(active) espSettings.HealthBar = active; updateESP() end)
visY = visY + 28
createToggle(visualsTab, "RGB Mode", visY, false, function(active) espSettings.RGB = active; updateESP() end)
visY = visY + 28
visualsTab.CanvasSize = UDim2.new(0, 0, 0, visY + 10)

local aimbotTab = Instance.new("ScrollingFrame")
aimbotTab.Size = UDim2.new(1, 0, 1, 0)
aimbotTab.BackgroundTransparency = 1
aimbotTab.ScrollBarThickness = 0
aimbotTab.CanvasSize = UDim2.new(0, 0, 0, 0)
aimbotTab.Visible = false
aimbotTab.Parent = contentContainer
aimbotTab.ZIndex = 11

local aimY = 5
createSectionTitle(aimbotTab, "AIMBOT", aimY); aimY = aimY + 24
createToggle(aimbotTab, "Enable Aimbot", aimY, false, function(active) aimbotActive = active; if active then criarCirculo() else removerCirculo() end end)
aimY = aimY + 28
createToggle(aimbotTab, "Team Check", aimY, false, function(active) teamCheck = active end)
aimY = aimY + 28
createSlider(aimbotTab, "FOV Radius", aimY, 50, 500, 150, function(value) aimbotRadius = value; if aimbotActive then atualizarCirculo() end end)
aimY = aimY + 42
createSlider(aimbotTab, "Precision", aimY, 0, 100, 100, function(value) aimbotPrecision = value end, "%")
aimY = aimY + 42
createToggle(aimbotTab, "Disable FOV Circle", aimY, false, function(active) fovCircleEnabled = not active; if active then removerCirculo() else if aimbotActive then criarCirculo() end end end)
aimY = aimY + 28
createToggle(aimbotTab, "FOV Circle RGB", aimY, fovCircleRGB, function(active) fovCircleRGB = active; saveOptions() end)
aimY = aimY + 28
createDivider(aimbotTab, aimY); aimY = aimY + 10
createSectionTitle(aimbotTab, "CROSSHAIR", aimY); aimY = aimY + 24
createToggle(aimbotTab, "Enable Crosshair", aimY, false, function(active) externalCrosshair = active; updateCrosshair(); if active then startProjectileRedirect() else stopProjectileRedirect() end end)
aimY = aimY + 28
createSlider(aimbotTab, "Crosshair Size", aimY, 10, 80, 30, function(value) crosshairSize = value; updateCrosshair() end)
aimY = aimY + 42
createSlider(aimbotTab, "Transparency", aimY, 0, 100, 0, function(value) crosshairTransparency = value / 100; updateCrosshair() end, "%")
aimY = aimY + 42
aimbotTab.CanvasSize = UDim2.new(0, 0, 0, aimY + 10)

local charTab = Instance.new("ScrollingFrame")
charTab.Size = UDim2.new(1, 0, 1, 0)
charTab.BackgroundTransparency = 1
charTab.ScrollBarThickness = 0
charTab.CanvasSize = UDim2.new(0, 0, 0, 0)
charTab.Visible = false
charTab.Parent = contentContainer
charTab.ZIndex = 11

local charY = 5
createSectionTitle(charTab, "MOVEMENT", charY); charY = charY + 24
createToggle(charTab, "Speed Hack", charY, false, function(active) speedEnabled = active; if active then setSpeed(currentSpeed) else setSpeed(16) end end)
charY = charY + 28
createSlider(charTab, "Speed Value", charY, 16, 200, 16, function(value) currentSpeed = value; if speedEnabled then setSpeed(value) end end)
charY = charY + 42
createDivider(charTab, charY); charY = charY + 10
createSectionTitle(charTab, "JUMP", charY); charY = charY + 24
createToggle(charTab, "Infinite Jump", charY, false, function(active) infiniteJump = active; if active then startInfiniteJump() else stopInfiniteJump() end; saveOptions() end)
charY = charY + 28
createDivider(charTab, charY); charY = charY + 10
createToggle(charTab, "Noclip", charY, false, function(active) noclipEnabled = active; if active then enableNoclip() else disableNoclip() end end)
charY = charY + 28
charTab.CanvasSize = UDim2.new(0, 0, 0, charY + 10)

local fpsTab = Instance.new("ScrollingFrame")
fpsTab.Size = UDim2.new(1, 0, 1, 0)
fpsTab.BackgroundTransparency = 1
fpsTab.ScrollBarThickness = 0
fpsTab.CanvasSize = UDim2.new(0, 0, 0, 0)
fpsTab.Visible = false
fpsTab.Parent = contentContainer
fpsTab.ZIndex = 11

local fpsY = 5
createSectionTitle(fpsTab, "DISPLAY", fpsY); fpsY = fpsY + 24
createToggle(fpsTab, "Remove Textures", fpsY, false, function(active) removeTextures = active; updateTextures() end)
fpsY = fpsY + 28
createToggle(fpsTab, "Remove Particles", fpsY, false, function(active) removeParticles = active; updateParticles() end)
fpsY = fpsY + 28
createToggle(fpsTab, "Show FPS", fpsY, false, function(active) showFPS = active; updateFPSDisplay() end)
fpsY = fpsY + 28
createDivider(fpsTab, fpsY); fpsY = fpsY + 10
createSectionTitle(fpsTab, "CAMERA", fpsY); fpsY = fpsY + 24
createToggle(fpsTab, "Custom FOV", fpsY, false, function(active) customFOV = active; if active then camera.FieldOfView = currentFOV else camera.FieldOfView = 70 end end)
fpsY = fpsY + 28
createSlider(fpsTab, "FOV Value", fpsY, 1, 120, 70, function(value) currentFOV = value; if customFOV then camera.FieldOfView = value end end)
fpsY = fpsY + 42

local resetFOVBtn = Instance.new("TextButton")
resetFOVBtn.Size = UDim2.new(0.35, 0, 0, 28)
resetFOVBtn.Position = UDim2.new(0.05, 0, 0, fpsY)
resetFOVBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
resetFOVBtn.BackgroundTransparency = 0.2
resetFOVBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetFOVBtn.Text = "Reset FOV"
resetFOVBtn.Font = Enum.Font.GothamBold
resetFOVBtn.TextSize = 12
resetFOVBtn.Parent = fpsTab
resetFOVBtn.ZIndex = 12
local resetCorner = Instance.new("UICorner"); resetCorner.CornerRadius = UDim.new(0, 6); resetCorner.Parent = resetFOVBtn
resetFOVBtn.MouseButton1Click:Connect(function() camera.FieldOfView = 70; currentFOV = 70; saveOptions() end)
fpsY = fpsY + 38
fpsTab.CanvasSize = UDim2.new(0, 0, 0, fpsY + 10)

local tpTab = Instance.new("ScrollingFrame")
tpTab.Size = UDim2.new(1, 0, 1, 0)
tpTab.BackgroundTransparency = 1
tpTab.ScrollBarThickness = 0
tpTab.CanvasSize = UDim2.new(0, 0, 0, 0)
tpTab.Visible = false
tpTab.Parent = contentContainer
tpTab.ZIndex = 11

local tpY = 5
createSectionTitle(tpTab, "TELEPORT", tpY); tpY = tpY + 24

local tpToBtn = Instance.new("TextButton")
tpToBtn.Size = UDim2.new(0.45, 0, 0, 28)
tpToBtn.Position = UDim2.new(0.05, 0, 0, tpY)
tpToBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
tpToBtn.BackgroundTransparency = 0.2
tpToBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpToBtn.Text = "TP To Player"
tpToBtn.Font = Enum.Font.GothamBold
tpToBtn.TextSize = 12
tpToBtn.Parent = tpTab
tpToBtn.ZIndex = 12
local tpCorner = Instance.new("UICorner"); tpCorner.CornerRadius = UDim.new(0, 6); tpCorner.Parent = tpToBtn
tpToBtn.MouseButton1Click:Connect(function()
	if selectedPlayer then
		local target = players:FindFirstChild(selectedPlayer)
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if root then root.CFrame = target.Character.HumanoidRootPart.CFrame end
		end
	end
end)
tpY = tpY + 34

local tpFromBtn = Instance.new("TextButton")
tpFromBtn.Size = UDim2.new(0.45, 0, 0, 28)
tpFromBtn.Position = UDim2.new(0.52, 0, 0, tpY - 34)
tpFromBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
tpFromBtn.BackgroundTransparency = 0.2
tpFromBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpFromBtn.Text = "TP Player To Me"
tpFromBtn.Font = Enum.Font.GothamBold
tpFromBtn.TextSize = 12
tpFromBtn.Parent = tpTab
tpFromBtn.ZIndex = 12
local tpFromCorner = Instance.new("UICorner"); tpFromCorner.CornerRadius = UDim.new(0, 6); tpFromCorner.Parent = tpFromBtn
tpFromBtn.MouseButton1Click:Connect(function()
	if selectedPlayer then
		local target = players:FindFirstChild(selectedPlayer)
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if root then
				target.Character.HumanoidRootPart.CFrame = root.CFrame + Vector3.new(0, 0, -5)
				local hum = target.Character:FindFirstChild("Humanoid")
				if hum then hum.PlatformStand = true end
			end
		end
	end
end)
tpY = tpY + 34
createPlayerSelector(tpTab, "Select Player", tpY, function(value) selectedPlayer = value end)
tpY = tpY + 34
createDivider(tpTab, tpY); tpY = tpY + 10
createSectionTitle(tpTab, "LOOP", tpY); tpY = tpY + 24

local loopBtn = Instance.new("TextButton")
loopBtn.Size = UDim2.new(0.4, 0, 0, 28)
loopBtn.Position = UDim2.new(0.05, 0, 0, tpY)
loopBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
loopBtn.BackgroundTransparency = 0.2
loopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loopBtn.Text = "Loop TP"
loopBtn.Font = Enum.Font.GothamBold
loopBtn.TextSize = 12
loopBtn.Parent = tpTab
loopBtn.ZIndex = 12
local loopCorner = Instance.new("UICorner"); loopCorner.CornerRadius = UDim.new(0, 6); loopCorner.Parent = loopBtn
loopBtn.MouseButton1Click:Connect(function()
	loopTeleport = not loopTeleport
	if loopTeleport then
		loopBtn.Text = "Stop Loop"
		loopBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		startLoopTeleport()
	else
		loopBtn.Text = "Loop TP"
		loopBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		loopBtn.BackgroundTransparency = 0.2
		stopLoopTeleport()
	end
end)
tpY = tpY + 34
tpTab.CanvasSize = UDim2.new(0, 0, 0, tpY + 10)

local othersTab = Instance.new("ScrollingFrame")
othersTab.Size = UDim2.new(1, 0, 1, 0)
othersTab.BackgroundTransparency = 1
othersTab.ScrollBarThickness = 0
othersTab.CanvasSize = UDim2.new(0, 0, 0, 0)
othersTab.Visible = false
othersTab.Parent = contentContainer
othersTab.ZIndex = 11

local otherY = 5
createSectionTitle(othersTab, "OTHERS", otherY); otherY = otherY + 24
createToggle(othersTab, "Shiftlock", otherY, shiftLockEnabled, function(active)
	shiftLockEnabled = active
	if active then enableShiftLock() else disableShiftLock() end
	saveOptions()
end)
otherY = otherY + 28
createToggle(othersTab, "Anti AFK", otherY, false, function(active) antiAFK = active; if active then startAntiAFK() else stopAntiAFK() end end)
otherY = otherY + 28
createToggle(othersTab, "God Mode", otherY, false, function(active) godMode = active; if active then enableGodMode() else disableGodMode() end end)
otherY = otherY + 28
createToggle(othersTab, "Trigger Bot", otherY, false, function(active) triggerBot = active end)
otherY = otherY + 28
createDivider(othersTab, otherY); otherY = otherY + 10
createSectionTitle(othersTab, "AUTO CLICKER", otherY); otherY = otherY + 24
createToggle(othersTab, "Enable Auto Clicker", otherY, false, function(active) 
	autoClicker = active
	if active then createAutoClickerButton(); startAutoClicker()
	else if autoClickerButton then autoClickerButton:Destroy(); autoClickerButton = nil end; stopAutoClicker() end
end)
otherY = otherY + 28
createSlider(othersTab, "Clicks per second", otherY, 1, 700, clickCount, function(value) 
	clickCount = value; saveOptions()
	if autoClicker then stopAutoClicker(); startAutoClicker() end
end)
otherY = otherY + 42
createDivider(othersTab, otherY); otherY = otherY + 10
createSectionTitle(othersTab, "AUTO FARM", otherY); otherY = otherY + 24
createToggle(othersTab, "Auto Farm", otherY, false, function(active) autoFarm = active; if active then startAutoFarm() else stopAutoFarm() end end)
otherY = otherY + 28
othersTab.CanvasSize = UDim2.new(0, 0, 0, otherY + 10)

local configTab = Instance.new("ScrollingFrame")
configTab.Size = UDim2.new(1, 0, 1, 0)
configTab.BackgroundTransparency = 1
configTab.ScrollBarThickness = 0
configTab.CanvasSize = UDim2.new(0, 0, 0, 0)
configTab.Visible = false
configTab.Parent = contentContainer
configTab.ZIndex = 11

local configY = 5
createSectionTitle(configTab, "MENU COLOR", configY); configY = configY + 24

local colorInput = Instance.new("TextBox")
colorInput.Size = UDim2.new(0.4, 0, 0, 28)
colorInput.Position = UDim2.new(0.05, 0, 0, configY)
colorInput.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
colorInput.TextColor3 = Color3.fromRGB(255, 255, 255)
colorInput.Text = "#" .. menuColor:ToHex()
colorInput.Font = Enum.Font.Gotham
colorInput.TextSize = 12
colorInput.Parent = configTab
colorInput.ClearTextOnFocus = false
colorInput.ZIndex = 12
local colorCorner = Instance.new("UICorner"); colorCorner.CornerRadius = UDim.new(0, 4); colorCorner.Parent = colorInput

local colorBox = Instance.new("Frame")
colorBox.Size = UDim2.new(0, 28, 0, 28)
colorBox.Position = UDim2.new(0.48, 0, 0, configY)
colorBox.BackgroundColor3 = menuColor
colorBox.Parent = configTab
colorBox.ZIndex = 12
local colorBoxCorner = Instance.new("UICorner"); colorBoxCorner.CornerRadius = UDim.new(0, 4); colorBoxCorner.Parent = colorBox

colorInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local success, color = pcall(function() return Color3.fromHex(colorInput.Text:gsub("#", "")) end)
		if success and color then
			menuColor = color; PRIMARY = color
			colorBox.BackgroundColor3 = color
			border.Color = color
			mainBorder.Color = color
			titleLabel.TextColor3 = color
			saveOptions()
		end
	end
end)
configY = configY + 38
createSectionTitle(configTab, "REDIMENSIONAR MENU", configY); configY = configY + 24
createSlider(configTab, "Largura (X)", configY, 400, 900, menuWidth, function(value) 
	menuWidth = value
	menuFrame.Size = UDim2.new(0, value, 0, menuHeight)
	menuFrame.Position = UDim2.new(0.5, -value/2, 0.5, -menuHeight/2)
	saveOptions()
end)
configY = configY + 42
createSlider(configTab, "Altura (Y)", configY, 400, 900, menuHeight, function(value) 
	menuHeight = value
	menuFrame.Size = UDim2.new(0, menuWidth, 0, value)
	menuFrame.Position = UDim2.new(0.5, -menuWidth/2, 0.5, -value/2)
	saveOptions()
end)
configY = configY + 42
createDivider(configTab, configY); configY = configY + 10
createSectionTitle(configTab, "SAVE", configY); configY = configY + 24

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.35, 0, 0, 30)
saveBtn.Position = UDim2.new(0.05, 0, 0, configY)
saveBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
saveBtn.BackgroundTransparency = 0.2
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.Text = "Save Options"
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 12
saveBtn.Parent = configTab
saveBtn.ZIndex = 12
local saveCorner = Instance.new("UICorner"); saveCorner.CornerRadius = UDim.new(0, 6); saveCorner.Parent = saveBtn
saveBtn.MouseButton1Click:Connect(function()
	saveOptions()
	local notification = Instance.new("TextLabel")
	notification.Size = UDim2.new(0.2, 0, 0, 28)
	notification.Position = UDim2.new(0.45, 0, 0, configY)
	notification.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	notification.BackgroundTransparency = 0.3
	notification.TextColor3 = Color3.fromRGB(255, 255, 255)
	notification.Text = "Saved!"
	notification.Font = Enum.Font.GothamBold
	notification.TextSize = 14
	notification.Parent = configTab
	notification.ZIndex = 12
	local notCorner = Instance.new("UICorner"); notCorner.CornerRadius = UDim.new(0, 4); notCorner.Parent = notification
	game:GetService("Debris"):AddItem(notification, 2)
end)
configY = configY + 40
configTab.CanvasSize = UDim2.new(0, 0, 0, configY + 10)

local creditsTab = Instance.new("ScrollingFrame")
creditsTab.Size = UDim2.new(1, 0, 1, 0)
creditsTab.BackgroundTransparency = 1
creditsTab.ScrollBarThickness = 0
creditsTab.CanvasSize = UDim2.new(0, 0, 0, 0)
creditsTab.Visible = false
creditsTab.Parent = contentContainer
creditsTab.ZIndex = 11

local credY = 15

local creditTitle = Instance.new("TextLabel")
creditTitle.Size = UDim2.new(1, -10, 0, 45)
creditTitle.Position = UDim2.new(0, 5, 0, credY)
creditTitle.BackgroundTransparency = 1
creditTitle.TextColor3 = Color3.fromRGB(255, 50, 50)
creditTitle.Text = "CREDITS"
creditTitle.Font = Enum.Font.GothamBlack
creditTitle.TextSize = 28
creditTitle.TextXAlignment = Enum.TextXAlignment.Center
creditTitle.Parent = creditsTab
creditTitle.ZIndex = 12
credY = credY + 55

local creditDivider = Instance.new("Frame")
creditDivider.Size = UDim2.new(0.8, 0, 0, 2)
creditDivider.Position = UDim2.new(0.1, 0, 0, credY)
creditDivider.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
creditDivider.Parent = creditsTab
creditDivider.ZIndex = 12
credY = credY + 25

local creditInfo = {
	{"Programador", "Luisggpr"},
	{"Designer", "Luisggpr"},
	{"Gui Maker", "Luisggpr"},
	{"Discord", "Indisponivel"},
	{"", ""},
	{"", ""},
	{"Agradecimentos", "Todos os usuarios do 7L HUB"},
	{"", "Obrigado por usar nosso script!"},
	{"", ""},
	{"", "7L HUB ON TOP"}
}

for _, info in ipairs(creditInfo) do
	if info[1] ~= "" then
		local labelTitle = Instance.new("TextLabel")
		labelTitle.Size = UDim2.new(1, -20, 0, 24)
		labelTitle.Position = UDim2.new(0, 10, 0, credY)
		labelTitle.BackgroundTransparency = 1
		labelTitle.TextColor3 = Color3.fromRGB(255, 120, 120)
		labelTitle.Text = info[1]
		labelTitle.Font = Enum.Font.GothamBold
		labelTitle.TextSize = 15
		labelTitle.TextXAlignment = Enum.TextXAlignment.Left
		labelTitle.Parent = creditsTab
		labelTitle.ZIndex = 12
		credY = credY + 26

		local labelValue = Instance.new("TextLabel")
		labelValue.Size = UDim2.new(1, -20, 0, 24)
		labelValue.Position = UDim2.new(0, 10, 0, credY)
		labelValue.BackgroundTransparency = 1
		labelValue.TextColor3 = Color3.fromRGB(200, 200, 220)
		labelValue.Text = info[2]
		labelValue.Font = Enum.Font.Gotham
		labelValue.TextSize = 14
		labelValue.TextXAlignment = Enum.TextXAlignment.Left
		labelValue.Parent = creditsTab
		labelValue.ZIndex = 12
		credY = credY + 30
	else
		credY = credY + 30
		local labelValue = Instance.new("TextLabel")
		labelValue.Size = UDim2.new(1, -20, 0, 35)
		labelValue.Position = UDim2.new(0, 10, 0, credY)
		labelValue.BackgroundTransparency = 1
		labelValue.TextColor3 = Color3.fromRGB(255, 50, 50)
		labelValue.Text = info[2]
		labelValue.Font = Enum.Font.GothamBlack
		labelValue.TextSize = 20
		labelValue.TextXAlignment = Enum.TextXAlignment.Center
		labelValue.Parent = creditsTab
		labelValue.ZIndex = 12
		credY = credY + 40
	end
end

creditsTab.CanvasSize = UDim2.new(0, 0, 0, credY + 20)

function updateESP()
	for _, obj in pairs(espObjects) do pcall(function() obj:Destroy() end) end
	espObjects = {}; bordas = {}
	local anyActive = false
	for _, active in pairs(espSettings) do if active then anyActive = true end end
	for _, plr in pairs(game.Players:GetPlayers()) do
		if plr ~= player then
			pcall(function()
				if plr.Character then
					local espFolder = plr.Character:FindFirstChild("7LAG_ESP")
					if espFolder then espFolder:Destroy() end
				end
			end)
		end
	end
	if not anyActive then return end
	for _, plr in pairs(game.Players:GetPlayers()) do
		if plr ~= player and plr.Character then createESPForPlayer(plr) end
	end
end

function createESPForPlayer(plr)
	if not plr.Character then return end
	local char = plr.Character; local root = char:FindFirstChild("HumanoidRootPart")
	local humanoid = char:FindFirstChild("Humanoid"); local head = char:FindFirstChild("Head")
	if not root or not humanoid or not head then return end
	if teamCheck and plr.Team == player.Team then return end

	pcall(function()
		local oldESP = char:FindFirstChild("7LAG_ESP")
		if oldESP then oldESP:Destroy() end
	end)

	local espGroup = Instance.new("Folder"); espGroup.Name = "7LAG_ESP"; espGroup.Parent = char

	local function getRGB()
		if espSettings.RGB then return Color3.fromHSV(hue, 1, 1) end
		return Color3.fromRGB(255, 0, 0)
	end
	local cor = getRGB()

	if espSettings.Boxes then
		local bbg = Instance.new("BillboardGui"); bbg.AlwaysOnTop = true
		bbg.Size = UDim2.new(4, 0, 4, 0); bbg.Adornee = root; bbg.Parent = espGroup
		local moldura = Instance.new("Frame"); moldura.Size = UDim2.new(1, 0, 1, 0)
		moldura.BackgroundTransparency = 1; moldura.Parent = bbg
		local borda = Instance.new("UIStroke"); borda.Thickness = 2.5; borda.Color = cor; borda.Parent = moldura
		table.insert(bordas, borda); table.insert(espObjects, bbg)
	end

	if espSettings.Skeleton then
		local highlight = Instance.new("Highlight"); highlight.FillTransparency = 1
		highlight.OutlineColor = cor; highlight.OutlineTransparency = 0
		highlight.Adornee = char; highlight.Parent = espGroup
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		table.insert(espObjects, highlight)
	end

	if espSettings.HealthBar then
		local healthGui = Instance.new("BillboardGui"); healthGui.Size = UDim2.new(1.5, 0, 8, 0)
		healthGui.StudsOffset = Vector3.new(-3.5, 0, 0); healthGui.Adornee = root
		healthGui.AlwaysOnTop = true; healthGui.Parent = espGroup
		local bg = Instance.new("Frame"); bg.Size = UDim2.new(0.5, 0, 1, 0)
		bg.Position = UDim2.new(0.25, 0, 0, 0); bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		bg.BackgroundTransparency = 0.3; bg.Parent = healthGui
		local fill = Instance.new("Frame"); local ratio = humanoid.Health / humanoid.MaxHealth
		fill.Size = UDim2.new(1, 0, ratio, 0); fill.Position = UDim2.new(0, 0, 1 - ratio, 0)
		fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0); fill.Parent = bg
		humanoid.HealthChanged:Connect(function(health)
			local healthRatio = health / humanoid.MaxHealth
			fill.Size = UDim2.new(1, 0, healthRatio, 0)
			fill.Position = UDim2.new(0, 0, 1 - healthRatio, 0)
			if healthRatio > 0.5 then fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
			elseif healthRatio > 0.25 then fill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
			else fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0) end
		end)
		table.insert(espObjects, healthGui)
	end

	if espSettings.Names then
		local nameGui = Instance.new("BillboardGui"); nameGui.Size = UDim2.new(15, 0, 3, 0)
		nameGui.StudsOffset = Vector3.new(0, 3.5, 0); nameGui.Adornee = head
		nameGui.AlwaysOnTop = true; nameGui.Parent = espGroup
		local nameLabel = Instance.new("TextLabel"); nameLabel.Size = UDim2.new(1, 0, 1, 0)
		nameLabel.BackgroundTransparency = 1; nameLabel.TextColor3 = cor
		nameLabel.Text = plr.Name; nameLabel.TextScaled = true
		nameLabel.Font = Enum.Font.GothamBold; nameLabel.TextStrokeTransparency = 0.1
		nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); nameLabel.Parent = nameGui
		table.insert(espObjects, nameGui)
	end
end

local aimbotCircle = nil; local aimbotStroke = nil; local circleConnection = nil

function criarCirculo()
	if aimbotCircle then return end; if not fovCircleEnabled then return end
	local circleFrame = Instance.new("Frame"); circleFrame.Name = "AimbotCircle"
	circleFrame.Size = UDim2.new(0, aimbotRadius * 2, 0, aimbotRadius * 2)
	circleFrame.AnchorPoint = Vector2.new(0.5, 0.5); circleFrame.BackgroundTransparency = 1
	circleFrame.Position = UDim2.new(0.5, 0, 0.5, 0); circleFrame.ZIndex = 999; circleFrame.Parent = screenGui
	local circleCorner = Instance.new("UICorner"); circleCorner.CornerRadius = UDim.new(1, 0); circleCorner.Parent = circleFrame
	aimbotStroke = Instance.new("UIStroke"); aimbotStroke.Thickness = 3
	aimbotStroke.Color = Color3.fromRGB(255, 0, 0); aimbotStroke.Parent = circleFrame
	aimbotCircle = circleFrame
	circleConnection = runService.RenderStepped:Connect(function()
		if aimbotCircle and aimbotActive and aimbotStroke then
			if fovCircleRGB then aimbotStroke.Color = Color3.fromHSV(hue, 1, 1)
			else aimbotStroke.Color = Color3.fromRGB(255, 0, 0) end
		end
	end)
end

function atualizarCirculo()
	if aimbotCircle then aimbotCircle.Size = UDim2.new(0, aimbotRadius * 2, 0, aimbotRadius * 2) end
end

function removerCirculo()
	if circleConnection then circleConnection:Disconnect(); circleConnection = nil end
	if aimbotCircle then aimbotCircle:Destroy(); aimbotCircle = nil; aimbotStroke = nil end
end

runService.RenderStepped:Connect(function()
	if not aimbotActive then return end
	local target = findTarget()
	if target then
		local precisionFactor = aimbotPrecision / 100; local offset = (1 - precisionFactor) * 0.5
		local randomOffset = Vector3.new((math.random() - 0.5) * offset * 2, (math.random() - 0.5) * offset * 2, (math.random() - 0.5) * offset * 2)
		local targetPos = target.Position + randomOffset
		camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
	end
end)

function findTarget()
	local closest = nil; local closestDist = aimbotRadius
	for _, plr in pairs(game.Players:GetPlayers()) do
		if plr ~= player and plr.Character then
			local root = plr.Character:FindFirstChild("HumanoidRootPart")
			if root then
				if teamCheck and plr.Team == player.Team then continue end
				local targetPart = root
				if aimbotPart == "Head" then targetPart = plr.Character:FindFirstChild("Head") or root
				elseif aimbotPart == "Torso" then targetPart = plr.Character:FindFirstChild("UpperTorso") or root end
				if targetPart then
					local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
					if onScreen then
						local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
						local pos = Vector2.new(screenPos.X, screenPos.Y)
						local dist = (pos - center).Magnitude
						if dist < closestDist then closestDist = dist; closest = targetPart end
					end
				end
			end
		end
	end
	return closest
end

local crosshairContainer = nil; local projectileRedirectConnection = nil

function updateCrosshair()
	if crosshairContainer then crosshairContainer:Destroy(); crosshairContainer = nil end
	if not externalCrosshair then return end
	crosshairContainer = Instance.new("Frame"); crosshairContainer.Name = "CustomCrosshair"
	crosshairContainer.Size = UDim2.new(0, crosshairSize, 0, crosshairSize)
	crosshairContainer.AnchorPoint = Vector2.new(0.5, 0.5)
	crosshairContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
	crosshairContainer.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	crosshairContainer.BackgroundTransparency = crosshairTransparency
	crosshairContainer.ZIndex = 999; crosshairContainer.Parent = screenGui
	local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(1, 0); corner.Parent = crosshairContainer
end

function startProjectileRedirect()
	if projectileRedirectConnection then return end
	projectileRedirectConnection = runService.Heartbeat:Connect(function()
		if not externalCrosshair then return end
		local crosshairPos = Vector3.new()
		local ray = camera:ScreenPointToRay(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
		crosshairPos = ray.Origin + ray.Direction * 100
		local projectileKeywords = {"bullet", "bala", "tiro", "fire", "projetil", "projectile", "shot", "shoot", "ammo", "shell", "casing", "tracer", "laser", "beam", "ray", "missile", "rocket", "grenade"}
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") and obj.Velocity and obj.Velocity.Magnitude > 10 then
				local name = obj.Name:lower(); local isProjectile = false
				for _, keyword in ipairs(projectileKeywords) do
					if name:find(keyword) then isProjectile = true; break end
				end
				if not isProjectile and obj:GetAttribute("Projectile") then isProjectile = true end
				if isProjectile then
					local direction = (crosshairPos - obj.Position).Unit
					obj.Velocity = direction * obj.Velocity.Magnitude
					pcall(function() obj.CFrame = CFrame.lookAt(obj.Position, obj.Position + direction) end)
				end
			end
		end
	end)
end

function stopProjectileRedirect()
	if projectileRedirectConnection then projectileRedirectConnection:Disconnect(); projectileRedirectConnection = nil end
end

local infiniteJumpConnection = nil

function startInfiniteJump()
	stopInfiniteJump()
	infiniteJumpConnection = userInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.Space and infiniteJump then
			local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
			if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
		end
	end)
end

function stopInfiniteJump()
	if infiniteJumpConnection then infiniteJumpConnection:Disconnect(); infiniteJumpConnection = nil end
end

function enableGodMode()
	if godModeConnection then godModeConnection:Disconnect() end
	if godModeHealthConnection then godModeHealthConnection:Disconnect() end
	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	if humanoid then
		local root = player.Character:FindFirstChild("HumanoidRootPart")
		if root then godModeLastPosition = root.CFrame end
		godModeHealthConnection = humanoid.HealthChanged:Connect(function(health)
			if godMode and humanoid and humanoid.Parent then
				local root = player.Character:FindFirstChild("HumanoidRootPart")
				if root and not isGodModeTeleporting then
					if health < humanoid.MaxHealth and health > 0 then
						isGodModeTeleporting = true
						godModeLastPosition = root.CFrame
						root.CFrame = godModeLastPosition + Vector3.new(0, 100, 0)
						task.wait(3)
						if godMode and root and root.Parent then root.CFrame = godModeLastPosition end
						isGodModeTeleporting = false
					end
					humanoid.Health = humanoid.MaxHealth
				end
			end
		end)
		godModeConnection = runService.Heartbeat:Connect(function()
			if godMode and humanoid and humanoid.Parent then
				humanoid.Health = humanoid.MaxHealth
				humanoid.BreakJointsOnDeath = false
			end
		end)
	end
end

function disableGodMode()
	if godModeConnection then godModeConnection:Disconnect(); godModeConnection = nil end
	if godModeHealthConnection then godModeHealthConnection:Disconnect(); godModeHealthConnection = nil end
	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	if humanoid then humanoid.MaxHealth = 100; humanoid.Health = 100; humanoid.BreakJointsOnDeath = true end
	isGodModeTeleporting = false
end

function enableShiftLock()
	pcall(function()
		UserGameSettings.RotationType = Enum.RotationType.CameraRelative
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		player.DevEnableMouseLock = true
		player.CameraMode = Enum.CameraMode.Classic
		
		if shiftLockConnection then shiftLockConnection:Disconnect() end
		shiftLockConnection = runService.RenderStepped:Connect(function()
			if shiftLockEnabled then
				pcall(function()
					UserGameSettings.RotationType = Enum.RotationType.CameraRelative
					UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
					player.DevEnableMouseLock = true
					player.CameraMode = Enum.CameraMode.Classic
				end)
			end
		end)
	end)
end

function disableShiftLock()
	if shiftLockConnection then 
		shiftLockConnection:Disconnect()
		shiftLockConnection = nil 
	end
	pcall(function()
		UserGameSettings.RotationType = Enum.RotationType.MovementRelative
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		player.DevEnableMouseLock = false
		player.CameraMode = Enum.CameraMode.Default
	end)
end

userInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.M and shiftLockEnabled then
		if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		else
			UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		end
	end
end)

function startAntiAFK()
	if antiAFKConnection then return end
	antiAFKConnection = runService.Heartbeat:Connect(function()
		if antiAFK then
			antiAFKTimer = antiAFKTimer + 1
			if antiAFKTimer >= 40 then
				antiAFKTimer = 0
				local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
				if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
				pcall(function() virtualUser:CaptureController(); virtualUser:ClickButton2(Vector2.new()) end)
			end
		end
	end)
end

function stopAntiAFK()
	if antiAFKConnection then antiAFKConnection:Disconnect(); antiAFKConnection = nil; antiAFKTimer = 0 end
end

runService.RenderStepped:Connect(function()
	if not triggerBot then return end
	local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
	if not tool then return end
	local target = findTarget()
	if target then
		local currentTime = tick()
		if currentTime - lastTriggerTime > 0.1 then
			lastTriggerTime = currentTime
			pcall(function()
				if tool:FindFirstChild("Activate") then tool:Activate() end
				mouse.Button1Down:Fire(); mouse.Button1Up:Fire()
			end)
		end
	end
end)

local autoClickerConnection = nil

function startAutoClicker()
	if autoClickerConnection then return end
	autoClickerConnection = runService.Heartbeat:Connect(function()
		if autoClicker then
			for i = 1, math.min(clickCount, 20) do
				pcall(function()
					mouse.Button1Down:Fire(); task.wait(0.001); mouse.Button1Up:Fire()
					if userInputService.TouchEnabled then virtualUser:ClickButton1(mouse.Position) end
				end)
			end
		end
	end)
end

function stopAutoClicker()
	if autoClickerConnection then autoClickerConnection:Disconnect(); autoClickerConnection = nil end
end

function createAutoClickerButton()
	if autoClickerButton then autoClickerButton:Destroy(); autoClickerButton = nil end
	autoClickerButton = Instance.new("ImageButton")
	autoClickerButton.Size = UDim2.new(0, 50, 0, 50)
	autoClickerButton.Position = autoClickerPosition
	autoClickerButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	autoClickerButton.BackgroundTransparency = 0.3
	autoClickerButton.ZIndex = 1000; autoClickerButton.Parent = screenGui
	local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(1, 0); corner.Parent = autoClickerButton
	local label = Instance.new("TextLabel"); label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Text = "Click"; label.Font = Enum.Font.GothamBold; label.TextSize = 12
	label.Parent = autoClickerButton; label.ZIndex = 1001

	local dragging = false; local dragStart = nil; local startPos = nil
	autoClickerButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true; dragStart = input.Position; startPos = autoClickerButton.Position
		end
	end)
	autoClickerButton.InputChanged:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
			local delta = input.Position - dragStart
			autoClickerButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			autoClickerPosition = autoClickerButton.Position
		end
	end)
	autoClickerButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	autoClickerButton.MouseButton1Click:Connect(function()
		autoClicker = not autoClicker
		if autoClicker then
			autoClickerButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0); label.Text = "ON"; startAutoClicker()
		else
			autoClickerButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0); label.Text = "Click"; stopAutoClicker()
		end
		saveOptions()
	end)
end

function startAutoFarm()
	if autoFarmConnection then return end
	autoFarmConnection = runService.Heartbeat:Connect(function()
		if autoFarm and player.Character then
			local root = player.Character:FindFirstChild("HumanoidRootPart")
			if not root then return end
			local nearestItem = nil; local nearestDist = 100
			local itemKeywords = {"part", "item", "pickup", "coin", "gem", "crystal", "orb", "sphere", "cube", "crate", "chest", "loot", "reward", "drop", "collectible", "diamond", "gold", "silver", "bronze", "stone", "wood", "ore", "ingot", "bar", "ring", "necklace", "amulet", "sword", "shield", "helmet", "armor", "boots"}
			for _, obj in pairs(workspace:GetDescendants()) do
				if obj:IsA("BasePart") and obj.Parent and not obj.Parent:IsA("Character") then
					local name = obj.Name:lower(); local isValid = false
					for _, keyword in ipairs(itemKeywords) do
						if name:find(keyword) then isValid = true; break end
					end
					if not isValid and obj:GetAttribute("Item") then isValid = true end
					if isValid then
						local dist = (obj.Position - root.Position).Magnitude
						if dist < nearestDist then nearestDist = dist; nearestItem = obj end
					end
				end
			end
			if nearestItem then
				local direction = (nearestItem.Position - root.Position).Unit
				root.Velocity = direction * 20
				if nearestDist < 5 then
					pcall(function() mouse.Button1Down:Fire(); task.wait(0.01); mouse.Button1Up:Fire() end)
				end
			else
				if math.random() < 0.01 then root.Velocity = Vector3.new(math.random(-10, 10), 0, math.random(-10, 10)) end
			end
		end
	end)
end

function stopAutoFarm()
	if autoFarmConnection then autoFarmConnection:Disconnect(); autoFarmConnection = nil end
	if player.Character then
		local root = player.Character:FindFirstChild("HumanoidRootPart")
		if root then root.Velocity = Vector3.new(0, 0, 0) end
	end
end

function setSpeed(speed)
	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	if humanoid then humanoid.WalkSpeed = speed end
end

local noclipConnection = nil

function enableNoclip()
	if noclipConnection then return end
	noclipConnection = runService.Stepped:Connect(function()
		if noclipEnabled and player.Character then
			for _, part in pairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
		end
	end)
end

function disableNoclip()
	if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
	if player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = true end
		end
	end
end

function updateTextures()
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and removeTextures then obj.Material = Enum.Material.Plastic end
	end
end

function updateParticles()
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("ParticleEmitter") and removeParticles then obj.Enabled = false end
	end
end

local fpsDisplay = nil

function updateFPSDisplay()
	if fpsDisplay then fpsDisplay:Destroy(); fpsDisplay = nil end
	if not showFPS then return end
	fpsDisplay = Instance.new("TextLabel")
	fpsDisplay.Size = UDim2.new(0, 80, 0, 26)
	fpsDisplay.Position = UDim2.new(0.02, 0, 0.02, 0)
	fpsDisplay.BackgroundTransparency = 0.5
	fpsDisplay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	fpsDisplay.TextColor3 = Color3.fromRGB(0, 255, 0)
	fpsDisplay.Text = "FPS: 0"
	fpsDisplay.Font = Enum.Font.GothamBold; fpsDisplay.TextSize = 14
	fpsDisplay.Parent = screenGui; fpsDisplay.ZIndex = 999
	local fpsCorner = Instance.new("UICorner"); fpsCorner.CornerRadius = UDim.new(0, 4); fpsCorner.Parent = fpsDisplay
end

function startLoopTeleport()
	if loopConnection then return end
	loopConnection = runService.Heartbeat:Connect(function()
		if loopTeleport and selectedPlayer then
			local target = players:FindFirstChild(selectedPlayer)
			if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
				local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				if root then root.CFrame = target.Character.HumanoidRootPart.CFrame end
			end
		end
	end)
end

function stopLoopTeleport()
	if loopConnection then loopConnection:Disconnect(); loopConnection = nil end
end

local lastTime = tick()
runService.RenderStepped:Connect(function()
	local delta = tick() - lastTime; lastTime = tick()
	if delta > 0 then
		fpsValue = math.floor(1 / delta)
		if fpsDisplay and showFPS then fpsDisplay.Text = "FPS: " .. tostring(fpsValue) end
	end
end)

runService.RenderStepped:Connect(function()
	hue = hue + 0.005; if hue > 1 then hue = 0 end
	if espSettings.RGB then
		local corRGB = Color3.fromHSV(hue, 1, 1)
		for _, borda in ipairs(bordas) do
			pcall(function() if borda and borda.Parent then borda.Color = corRGB end end)
		end
		for _, obj in pairs(espObjects) do
			pcall(function()
				if obj:IsA("Highlight") then obj.OutlineColor = corRGB
				elseif obj:IsA("BillboardGui") and obj.Name == "NameESP" then
					local label = obj:FindFirstChildOfClass("TextLabel")
					if label then label.TextColor3 = corRGB end
				end
			end)
		end
	end
end)

local function makeDraggable(frame)
	local drag = false; local dragStart = nil; local startPos = nil
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			drag = true; dragStart = input.Position; startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then drag = false end
			end)
		end
	end)
	frame.InputChanged:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and drag then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

makeDraggable(menuFrame)

for name, btn in pairs(navButtons) do
	btn.MouseButton1Click:Connect(function()
		for _, b in pairs(navButtons) do b.TextColor3 = Color3.fromRGB(160, 160, 190) end
		btn.TextColor3 = Color3.fromRGB(255, 50, 50)
		homeTab.Visible = (name == "HOME")
		visualsTab.Visible = (name == "VISUALS")
		aimbotTab.Visible = (name == "AIMBOT")
		charTab.Visible = (name == "CHARACTER")
		fpsTab.Visible = (name == "FPS")
		tpTab.Visible = (name == "TELEPORT")
		othersTab.Visible = (name == "OTHERS")
		configTab.Visible = (name == "CONFIG")
		creditsTab.Visible = (name == "CREDITS")
	end)
end

game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		task.wait(1)
		if anyESPActive() and plr ~= player then createESPForPlayer(plr) end
	end)
end)

function anyESPActive()
	for _, active in pairs(espSettings) do if active then return true end end
	return false
end

player.CharacterAdded:Connect(function(char)
	task.wait(1)
	if speedEnabled then setSpeed(currentSpeed) end
	if noclipEnabled then enableNoclip() end
	if godMode then enableGodMode() end
	if infiniteJump then startInfiniteJump() end
	if shiftLockEnabled then enableShiftLock() end
	updateESP()
end)

updateESP()
updateFPSDisplay()
updateCrosshair()
if antiAFK then startAntiAFK() end
if infiniteJump then startInfiniteJump() end
if shiftLockEnabled then enableShiftLock() end
if autoClicker then createAutoClickerButton(); startAutoClicker() end
if autoFarm then startAutoFarm() end
if externalCrosshair then startProjectileRedirect() end
