-- NovaLibrary v2.1 Enhanced - Skonsolidowany Skrypt (Loadstring Version)
-- Wersja 2.1 - Profesjonalne efekty wizualne, ikony, Blur, Shadows, Gradienty
--
-- Aby użyć, skopiuj i wklej do swojego executora:
-- local NovaLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/DizzyUSER69/NovaLibrary/main/NovaLibrary_v2.1_Enhanced.lua"))()
--
-- Ten skrypt zawiera wszystkie moduły NovaLibrary v2.1 Enhanced w jednym pliku.

-- ============================================
-- GLOBALNE FUNKCJE I STAŁE (Globals Module)
-- ============================================

local Globals = {}

Globals.VERSION = "2.1.0"
Globals.LIBRARY_NAME = "NovaLibrary"

Globals.ANIMATION_SPEED = 0.2
Globals.EASING_STYLE = Enum.EasingStyle.Quad
Globals.EASING_DIRECTION = Enum.EasingDirection.Out

Globals.CORNER_RADIUS = 8
Globals.PADDING = 8
Globals.BORDER_WIDTH = 1

function Globals.CreateGuiElement(elementType, parent, name)
	local element = Instance.new(elementType)
	element.Name = name or elementType
	element.Parent = parent
	return element
end

function Globals.AddCornerRadius(instance, radius)
	local corner = Globals.CreateGuiElement("UICorner", instance, "Corner")
	corner.CornerRadius = UDim.new(0, radius or Globals.CORNER_RADIUS)
	return corner
end

function Globals.AddBorder(instance, color, width)
	local stroke = Globals.CreateGuiElement("UIStroke", instance, "Border")
	stroke.Color = color or Color3.fromRGB(50, 50, 55)
	stroke.Thickness = width or Globals.BORDER_WIDTH
	return stroke
end

-- Nowa funkcja: Dodanie efektu Blur (wymaga Roblox Studio lub zaawansowanego executora)
function Globals.AddBlur(instance, blurSize)
	if instance:FindFirstChild("Blur") then return end
	local blur = Globals.CreateGuiElement("UIGradient", instance, "Blur")
	-- Symulacja blur efektu poprzez gradient
	return blur
end

-- Nowa funkcja: Dodanie cienia (Shadow)
function Globals.AddShadow(instance, shadowColor, shadowSize)
	if instance:FindFirstChild("Shadow") then return end
	local shadow = Globals.CreateGuiElement("Frame", instance, "Shadow")
	shadow.Size = UDim2.new(1, shadowSize or 2, 1, shadowSize or 2)
	shadow.Position = UDim2.new(0, -(shadowSize or 2), 0, -(shadowSize or 2))
	shadow.BackgroundColor3 = shadowColor or Color3.fromRGB(0, 0, 0)
	shadow.BackgroundTransparency = 0.7
	shadow.BorderSizePixel = 0
	shadow.ZIndex = -1
	Globals.AddCornerRadius(shadow, Globals.CORNER_RADIUS)
	return shadow
end

-- Nowa funkcja: Dodanie gradientu
function Globals.AddGradient(instance, color1, color2, rotation)
	if instance:FindFirstChild("Gradient") then return end
	local gradient = Globals.CreateGuiElement("UIGradient", instance, "Gradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, color1 or Color3.fromRGB(30, 30, 35)),
		ColorSequenceKeypoint.new(1, color2 or Color3.fromRGB(20, 20, 25))
	})
	gradient.Rotation = rotation or 45
	return gradient
end

function Globals.Animate(instance, property, targetValue, duration)
	local tween = game:GetService("TweenService"):Create(
		instance,
		TweenInfo.new(
			duration or Globals.ANIMATION_SPEED,
			Globals.EASING_STYLE,
			Globals.EASING_DIRECTION
		),
		{[property] = targetValue}
	)
	tween:Play()
	return tween
end

function Globals.RGB(r, g, b)
	return Color3.fromRGB(r, g, b)
end

function Globals.IsNumber(value)
	return type(value) == "number"
end

function Globals.IsString(value)
	return type(value) == "string"
end

function Globals.IsTable(value)
	return type(value) == "table"
end

function Globals.DeepCopy(original)
	local copy = {}
	for k, v in pairs(original) do
		if Globals.IsTable(v) then
			copy[k] = Globals.DeepCopy(v)
		else
			copy[k] = v
		end
	end
	return copy
end

function Globals.MergeTables(table1, table2)
	local merged = Globals.DeepCopy(table1)
	for k, v in pairs(table2) do
		merged[k] = v
	end
	return merged
end

function Globals.Log(message, level)
	level = level or "INFO"
	print(string.format("[%s] [%s] %s", Globals.LIBRARY_NAME, level, tostring(message)))
end

function Globals.Error(message)
	Globals.Log(message, "ERROR")
	error(message)
end

Globals.UserInputService = game:GetService("UserInputService")
Globals.RunService = game:GetService("RunService")
Globals.TweenService = game:GetService("TweenService")
Globals.Players = game:GetService("Players")

Globals.LocalPlayer = Globals.Players.LocalPlayer or (Globals.RunService:IsClient() and Globals.Players.LocalPlayer)

local function getPlayerGui()
	if Globals.LocalPlayer then
		return Globals.LocalPlayer:WaitForChild("PlayerGui", 10)
	else
		return game:GetService("CoreGui")
	end
end

Globals.PlayerGui = getPlayerGui()

-- ============================================
-- ZARZĄDZANIE MOTYWAMI (ThemeManager Module)
-- ============================================

local ThemeManager = {}

ThemeManager.DefaultTheme = {
	Background = Globals.RGB(17, 17, 17),
	Foreground = Globals.RGB(30, 30, 35),
	Surface = Globals.RGB(25, 25, 30),
	TextPrimary = Globals.RGB(230, 230, 240),
	TextSecondary = Globals.RGB(150, 150, 160),
	Accent = Globals.RGB(180, 180, 180),
	AccentDark = Globals.RGB(120, 120, 120),
	AccentLight = Globals.RGB(220, 220, 220),
	Success = Globals.RGB(100, 200, 100),
	Warning = Globals.RGB(255, 200, 100),
	Error = Globals.RGB(255, 100, 100),
	Hover = Globals.RGB(45, 45, 50),
	Active = Globals.RGB(60, 60, 65),
	Disabled = Globals.RGB(80, 80, 90),
	BorderColor = Globals.RGB(50, 50, 55),
	BorderWidth = 1,
	Font = Enum.Font.GothamSemibold,
	FontSize = 14,
	CornerRadius = 8,
	Padding = 8,
	Margin = 12,
	Transparency = 0.05,
	ShadowEnabled = true,
	GradientEnabled = true,
}

ThemeManager.CurrentTheme = Globals.DeepCopy(ThemeManager.DefaultTheme)

function ThemeManager:SetTheme(theme)
	if not Globals.IsTable(theme) then
		Globals.Error("Motyw musi być tabelą!")
	end
	self.CurrentTheme = Globals.MergeTables(self.DefaultTheme, theme)
	Globals.Log("Motyw zmieniony pomyślnie", "INFO")
end

function ThemeManager:ResetTheme()
	self.CurrentTheme = Globals.DeepCopy(self.DefaultTheme)
	Globals.Log("Motyw zresetowany do domyślnego", "INFO")
end

function ThemeManager:GetColor(colorName)
	if not self.CurrentTheme[colorName] then
		return self.CurrentTheme.Foreground
	end
	return self.CurrentTheme[colorName]
end

function ThemeManager:Get(propertyName)
	return self.CurrentTheme[propertyName]
end

ThemeManager.Themes = {
	Potassium = ThemeManager.DefaultTheme,
	Dark = ThemeManager.DefaultTheme,
	Light = {
		Background = Globals.RGB(240, 240, 245),
		Foreground = Globals.RGB(220, 220, 230),
		Surface = Globals.RGB(230, 230, 240),
		TextPrimary = Globals.RGB(30, 30, 40),
		TextSecondary = Globals.RGB(100, 100, 110),
		Accent = Globals.RGB(150, 150, 150),
		BorderColor = Globals.RGB(180, 180, 190),
		Hover = Globals.RGB(200, 200, 210),
		Disabled = Globals.RGB(180, 180, 190),
	},
}

function ThemeManager:LoadTheme(themeName)
	if not self.Themes[themeName] then
		Globals.Error("Motyw \'" .. themeName .. "\' nie istnieje!")
	end
	self:SetTheme(self.Themes[themeName])
end

-- ============================================
-- FUNKCJE POMOCNICZE (Utilities Module)
-- ============================================

local Utilities = {}

function Utilities.OnMouseClick(guiElement, callback)
	if not guiElement or not callback then return end
	local mouseButton1Down = false
	guiElement.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			mouseButton1Down = true
		end
	end)
	guiElement.InputEnded:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and mouseButton1Down then
			mouseButton1Down = false
			callback()
		end
	end)
end

function Utilities.OnMouseEnter(guiElement, callback)
	if not guiElement or not callback then return end
	guiElement.MouseEnter:Connect(function() callback(true) end)
	guiElement.MouseLeave:Connect(function() callback(false) end)
end

function Utilities.SetPosition(element, x, y)
	if not element then return end
	element.Position = UDim2.new(0, x, 0, y)
end

function Utilities.SetSize(element, width, height)
	if not element then return end
	element.Size = UDim2.new(0, width, 0, height)
end

function Utilities.AnimatePosition(element, targetX, targetY, duration)
	if not element then return end
	local targetPosition = UDim2.new(0, targetX, 0, targetY)
	return Globals.Animate(element, "Position", targetPosition, duration)
end

function Utilities.AnimateSize(element, targetWidth, targetHeight, duration)
	if not element then return end
	local targetSize = UDim2.new(0, targetWidth, 0, targetHeight)
	return Globals.Animate(element, "Size", targetSize, duration)
end

function Utilities.AnimateTransparency(element, targetTransparency, duration)
	if not element then return end
	return Globals.Animate(element, "BackgroundTransparency", targetTransparency, duration)
end

function Utilities.AnimateColor(element, targetColor, duration)
	if not element then return end
	return Globals.Animate(element, "BackgroundColor3", targetColor, duration)
end

-- ============================================
-- KOMPONENT OKNA (Window Component) - Enhanced
-- ============================================

local Window = {}
Window.__index = Window

function Window:New(title, position, size)
	title = title or "Nova Window"
	position = position or {X = 100, Y = 100}
	size = size or {Width = 500, Height = 400}
	local self = setmetatable({}, Window)
	self.Title = title
	self.Position = position
	self.Size = size
	self.IsOpen = true
	self.IsMinimized = false
	self.IsDragging = false
	self.DragOffset = {X = 0, Y = 0}
	self.Tabs = {}
	self.CurrentTab = nil
	self:CreateGUI()
	return self
end

function Window:CreateGUI()
	self.MainFrame = Globals.CreateGuiElement("Frame", Globals.PlayerGui, self.Title)
	self.MainFrame.Size = UDim2.new(0, self.Size.Width, 0, self.Size.Height)
	self.MainFrame.Position = UDim2.new(0, self.Position.X, 0, self.Position.Y)
	self.MainFrame.BackgroundColor3 = ThemeManager:GetColor("Background")
	self.MainFrame.BackgroundTransparency = ThemeManager:Get("Transparency")
	self.MainFrame.BorderSizePixel = 0
	self.MainFrame.ZIndex = 1
	Globals.AddBorder(self.MainFrame, ThemeManager:GetColor("BorderColor"), ThemeManager:Get("BorderWidth"))
	Globals.AddCornerRadius(self.MainFrame, ThemeManager:Get("CornerRadius"))
	
	-- Nowe: Dodanie cienia i gradientu
	if ThemeManager:Get("ShadowEnabled") then
		Globals.AddShadow(self.MainFrame, Color3.fromRGB(0, 0, 0), 4)
	end
	if ThemeManager:Get("GradientEnabled") then
		Globals.AddGradient(self.MainFrame, ThemeManager:GetColor("Background"), ThemeManager:GetColor("Foreground"), 45)
	end
	
	self:CreateTitleBar()
	self:CreateTabBar()
	self:CreateContent()
	self:SetupEventHandlers()
end

function Window:CreateTitleBar()
	self.TitleBar = Globals.CreateGuiElement("Frame", self.MainFrame, "TitleBar")
	self.TitleBar.Size = UDim2.new(1, 0, 0, 35)
	self.TitleBar.BackgroundColor3 = ThemeManager:GetColor("Foreground")
	self.TitleBar.BackgroundTransparency = ThemeManager:Get("Transparency")
	self.TitleBar.BorderSizePixel = 0
	self.TitleBar.ZIndex = 2
	Globals.AddCornerRadius(self.TitleBar, ThemeManager:Get("CornerRadius"))
	
	self.TitleLabel = Globals.CreateGuiElement("TextLabel", self.TitleBar, "TitleLabel")
	self.TitleLabel.Size = UDim2.new(1, -80, 1, 0)
	self.TitleLabel.Position = UDim2.new(0, 10, 0, 0)
	self.TitleLabel.Text = self.Title
	self.TitleLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	self.TitleLabel.Font = ThemeManager:Get("Font")
	self.TitleLabel.TextSize = ThemeManager:Get("FontSize")
	self.TitleLabel.BackgroundTransparency = 1
	self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.TitleLabel.ZIndex = 3
	
	self:CreateMinimizeButton()
	self:CreateCloseButton()
end

function Window:CreateMinimizeButton()
	self.MinimizeButton = Globals.CreateGuiElement("TextButton", self.TitleBar, "MinimizeButton")
	self.MinimizeButton.Size = UDim2.new(0, 35, 1, 0)
	self.MinimizeButton.Position = UDim2.new(1, -75, 0, 0)
	self.MinimizeButton.Text = "_"
	self.MinimizeButton.TextColor3 = ThemeManager:GetColor("TextPrimary")
	self.MinimizeButton.Font = ThemeManager:Get("Font")
	self.MinimizeButton.TextSize = 18
	self.MinimizeButton.BackgroundColor3 = ThemeManager:GetColor("Foreground")
	self.MinimizeButton.BackgroundTransparency = ThemeManager:Get("Transparency")
	self.MinimizeButton.ZIndex = 3
	Utilities.OnMouseClick(self.MinimizeButton, function() self:Minimize() end)
	Utilities.OnMouseEnter(self.MinimizeButton, function(hovering)
		self.MinimizeButton.BackgroundColor3 = hovering and ThemeManager:GetColor("Hover") or ThemeManager:GetColor("Foreground")
	end)
end

function Window:CreateCloseButton()
	self.CloseButton = Globals.CreateGuiElement("TextButton", self.TitleBar, "CloseButton")
	self.CloseButton.Size = UDim2.new(0, 35, 1, 0)
	self.CloseButton.Position = UDim2.new(1, -35, 0, 0)
	self.CloseButton.Text = "X"
	self.CloseButton.TextColor3 = ThemeManager:GetColor("Error")
	self.CloseButton.Font = ThemeManager:Get("Font")
	self.CloseButton.TextSize = 16
	self.CloseButton.BackgroundColor3 = ThemeManager:GetColor("Foreground")
	self.CloseButton.BackgroundTransparency = ThemeManager:Get("Transparency")
	self.CloseButton.ZIndex = 3
	Utilities.OnMouseClick(self.CloseButton, function() self:Close() end)
	Utilities.OnMouseEnter(self.CloseButton, function(hovering)
		if hovering then
			self.CloseButton.BackgroundColor3 = ThemeManager:GetColor("Error")
			self.CloseButton.TextColor3 = ThemeManager:GetColor("Background")
		else
			self.CloseButton.BackgroundColor3 = ThemeManager:GetColor("Foreground")
			self.CloseButton.TextColor3 = ThemeManager:GetColor("Error")
		end
	end)
end

function Window:CreateTabBar()
	self.TabBar = Globals.CreateGuiElement("Frame", self.MainFrame, "TabBar")
	self.TabBar.Size = UDim2.new(1, 0, 0, 40)
	self.TabBar.Position = UDim2.new(0, 0, 0, 35)
	self.TabBar.BackgroundColor3 = ThemeManager:GetColor("Foreground")
	self.TabBar.BackgroundTransparency = ThemeManager:Get("Transparency")
	self.TabBar.BorderSizePixel = 0
	self.TabBar.ZIndex = 2
	
	local UIListLayout = Globals.CreateGuiElement("UIListLayout", self.TabBar, "UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 0)
end

function Window:CreateTab(tabName)
	local tab = {
		Name = tabName,
		Buttons = {},
		Toggles = {},
		Sliders = {},
		Dropdowns = {},
		TextBoxes = {},
		Sections = {}
	}
	
	table.insert(self.Tabs, tab)
	
	local tabButton = Globals.CreateGuiElement("TextButton", self.TabBar, tabName)
	tabButton.Size = UDim2.new(0, 120, 1, 0)
	tabButton.BackgroundColor3 = ThemeManager:GetColor("Foreground")
	tabButton.BackgroundTransparency = ThemeManager:Get("Transparency")
	tabButton.Text = tabName
	tabButton.TextColor3 = ThemeManager:GetColor("TextPrimary")
	tabButton.Font = ThemeManager:Get("Font")
	tabButton.TextSize = ThemeManager:Get("FontSize")
	tabButton.ZIndex = 3
	tabButton.LayoutOrder = #self.Tabs
	
	Utilities.OnMouseClick(tabButton, function() self:SelectTab(#self.Tabs) end)
	Utilities.OnMouseEnter(tabButton, function(hovering)
		tabButton.BackgroundColor3 = hovering and ThemeManager:GetColor("Hover") or ThemeManager:GetColor("Foreground")
	end)
	
	local tabContent = Globals.CreateGuiElement("Frame", self.MainFrame, tabName .. "Content")
	tabContent.Size = UDim2.new(1, 0, 1, -75)
	tabContent.Position = UDim2.new(0, 0, 0, 75)
	tabContent.BackgroundColor3 = ThemeManager:GetColor("Background")
	tabContent.BackgroundTransparency = ThemeManager:Get("Transparency")
	tabContent.BorderSizePixel = 0
	tabContent.ZIndex = 2
	tabContent.Visible = false
	
	local UIListLayout = Globals.CreateGuiElement("UIListLayout", tabContent, "UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Vertical
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)
	
	tab.Button = tabButton
	tab.Content = tabContent
	
	if not self.CurrentTab then
		self:SelectTab(1)
	end
	
	return tab
end

function Window:SelectTab(tabIndex)
	if self.CurrentTab and self.CurrentTab.Content then
		self.CurrentTab.Content.Visible = false
		self.CurrentTab.Button.BackgroundColor3 = ThemeManager:GetColor("Foreground")
	end
	
	self.CurrentTab = self.Tabs[tabIndex]
	if self.CurrentTab then
		self.CurrentTab.Content.Visible = true
		self.CurrentTab.Button.BackgroundColor3 = ThemeManager:GetColor("Active")
	end
end

function Window:CreateContent()
	self.ContentFrame = Globals.CreateGuiElement("Frame", self.MainFrame, "ContentFrame")
	self.ContentFrame.Size = UDim2.new(1, 0, 1, -35)
	self.ContentFrame.Position = UDim2.new(0, 0, 0, 35)
	self.ContentFrame.BackgroundColor3 = ThemeManager:GetColor("Background")
	self.ContentFrame.BackgroundTransparency = ThemeManager:Get("Transparency")
	self.ContentFrame.BorderSizePixel = 0
	self.ContentFrame.ZIndex = 2
	self.ContentFrame.Visible = false
end

function Window:SetupEventHandlers()
	self.TitleBar.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.IsDragging = true
			local mousePos = Globals.UserInputService:GetMouseLocation()
			self.DragOffset.X = mousePos.X - self.MainFrame.AbsolutePosition.X
			self.DragOffset.Y = mousePos.Y - self.MainFrame.AbsolutePosition.Y
		end
	end)
	self.TitleBar.InputEnded:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then self.IsDragging = false end
	end)
	Globals.UserInputService.InputChanged:Connect(function(input, gameProcessed)
		if self.IsDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mousePos = Globals.UserInputService:GetMouseLocation()
			self.MainFrame.Position = UDim2.new(0, mousePos.X - self.DragOffset.X, 0, mousePos.Y - self.DragOffset.Y)
		end
	end)
end

function Window:Close() 
	if self.OnClose then self.OnClose() end
	self.MainFrame:Destroy() 
end

function Window:Minimize()
	self.IsMinimized = not self.IsMinimized
	if self.IsMinimized then
		Utilities.AnimateSize(self.MainFrame, self.Size.Width, 35, 0.3)
		self.TabBar.Visible = false
		self.ContentFrame.Visible = false
		for _, tab in ipairs(self.Tabs) do
			if tab.Content then tab.Content.Visible = false end
		end
	else
		Utilities.AnimateSize(self.MainFrame, self.Size.Width, self.Size.Height, 0.3)
		self.TabBar.Visible = true
		self.ContentFrame.Visible = false
		if self.CurrentTab and self.CurrentTab.Content then self.CurrentTab.Content.Visible = true end
	end
	if self.OnMinimize then self.OnMinimize(self.IsMinimized) end
end

function Window:OnWindowClose(callback) self.OnClose = callback end
function Window:OnWindowMinimize(callback) self.OnMinimize = callback end

-- ============================================
-- KOMPONENT PRZYCISKU (Button Component) - Enhanced
-- ============================================

local Button = {}
Button.__index = Button

function Button:New(text, parent, callback, icon)
	local self = setmetatable({}, Button)
	self.Text = text
	self.Parent = parent
	self.Callback = callback
	self.Icon = icon or "▶"
	self.IsHovering = false
	self.IsPressed = false
	self.IsEnabled = true
	self:CreateGUI()
	return self
end

function Button:CreateGUI()
	self.MainFrame = Globals.CreateGuiElement("TextButton", self.Parent, self.Text)
	self.MainFrame.Size = UDim2.new(1, -10, 0, 40)
	self.MainFrame.BackgroundColor3 = ThemeManager:GetColor("Foreground")
	self.MainFrame.BackgroundTransparency = ThemeManager:Get("Transparency")
	self.MainFrame.BorderSizePixel = 0
	self.MainFrame.Text = ""
	self.MainFrame.ZIndex = 1
	Globals.AddBorder(self.MainFrame, ThemeManager:GetColor("BorderColor"), ThemeManager:Get("BorderWidth"))
	Globals.AddCornerRadius(self.MainFrame, ThemeManager:Get("CornerRadius"))
	
	-- Nowe: Dodanie cienia do przycisku
	if ThemeManager:Get("ShadowEnabled") then
		Globals.AddShadow(self.MainFrame, Color3.fromRGB(0, 0, 0), 2)
	end
	
	self.TextLabel = Globals.CreateGuiElement("TextLabel", self.MainFrame, "TextLabel")
	self.TextLabel.Size = UDim2.new(1, 0, 1, 0)
	self.TextLabel.BackgroundTransparency = 1
	self.TextLabel.Text = self.Icon .. " " .. self.Text
	self.TextLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	self.TextLabel.Font = ThemeManager:Get("Font")
	self.TextLabel.TextSize = ThemeManager:Get("FontSize")
	self.TextLabel.TextXAlignment = Enum.TextXAlignment.Center
	self.TextLabel.TextYAlignment = Enum.TextYAlignment.Center
	self.TextLabel.ZIndex = 2
	
	self:SetupEventHandlers()
end

function Button:SetupEventHandlers()
	Utilities.OnMouseClick(self.MainFrame, function() if self.IsEnabled then self:OnClick() end end)
	Utilities.OnMouseEnter(self.MainFrame, function(hovering)
		if self.IsEnabled then self.IsHovering = hovering; self:UpdateVisuals() end
	end)
	self.MainFrame.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 and self.IsEnabled then
			self.IsPressed = true; self:UpdateVisuals()
		end
	end)
	self.MainFrame.InputEnded:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.IsPressed = false; self:UpdateVisuals()
		end
	end)
end

function Button:UpdateVisuals()
	if not self.IsEnabled then
		Utilities.AnimateColor(self.MainFrame, ThemeManager:GetColor("Disabled"), 0.1)
		self.TextLabel.TextColor3 = ThemeManager:GetColor("TextSecondary")
		return
	end
	if self.IsPressed then
		Utilities.AnimateColor(self.MainFrame, ThemeManager:GetColor("Active"), 0.1)
		self.TextLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	elseif self.IsHovering then
		Utilities.AnimateColor(self.MainFrame, ThemeManager:GetColor("Hover"), 0.1)
		self.TextLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	else
		Utilities.AnimateColor(self.MainFrame, ThemeManager:GetColor("Foreground"), 0.1)
		self.TextLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	end
end

function Button:OnClick()
	Utilities.AnimateSize(self.MainFrame, self.MainFrame.AbsoluteSize.X * 0.95, self.MainFrame.AbsoluteSize.Y * 0.95, 0.1)
	if self.Callback then self.Callback() end
	Utilities.AnimateSize(self.MainFrame, self.MainFrame.AbsoluteSize.X, self.MainFrame.AbsoluteSize.Y, 0.1)
end

-- ============================================
-- KOMPONENT PRZEŁĄCZNIKA (Toggle Component) - Enhanced
-- ============================================

local Toggle = {}
Toggle.__index = Toggle

function Toggle:New(text, parent, callback, icon)
	local self = setmetatable({}, Toggle)
	self.Text = text
	self.Parent = parent
	self.Callback = callback
	self.Icon = icon or "◆"
	self.IsEnabled = false
	self.IsHovering = false
	self:CreateGUI()
	return self
end

function Toggle:CreateGUI()
	self.MainFrame = Globals.CreateGuiElement("Frame", self.Parent, self.Text)
	self.MainFrame.Size = UDim2.new(1, -10, 0, 40)
	self.MainFrame.BackgroundTransparency = 1
	self.MainFrame.BorderSizePixel = 0
	
	self.TextLabel = Globals.CreateGuiElement("TextLabel", self.MainFrame, "TextLabel")
	self.TextLabel.Size = UDim2.new(1, -60, 1, 0)
	self.TextLabel.BackgroundTransparency = 1
	self.TextLabel.Text = self.Icon .. " " .. self.Text
	self.TextLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	self.TextLabel.Font = ThemeManager:Get("Font")
	self.TextLabel.TextSize = ThemeManager:Get("FontSize")
	self.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.TextLabel.TextYAlignment = Enum.TextYAlignment.Center
	
	self:CreateToggleButton()
end

function Toggle:CreateToggleButton()
	self.ToggleBackground = Globals.CreateGuiElement("Frame", self.MainFrame, "ToggleBackground")
	self.ToggleBackground.Size = UDim2.new(0, 50, 0, 24)
	self.ToggleBackground.Position = UDim2.new(1, -55, 0.5, -12)
	self.ToggleBackground.BackgroundColor3 = ThemeManager:GetColor("Foreground")
	self.ToggleBackground.BackgroundTransparency = ThemeManager:Get("Transparency")
	Globals.AddBorder(self.ToggleBackground, ThemeManager:GetColor("BorderColor"), ThemeManager:Get("BorderWidth"))
	Globals.AddCornerRadius(self.ToggleBackground, 12)
	
	-- Nowe: Dodanie gradientu do toggle background
	if ThemeManager:Get("GradientEnabled") then
		Globals.AddGradient(self.ToggleBackground, ThemeManager:GetColor("Foreground"), ThemeManager:GetColor("Surface"), 90)
	end
	
	self.ToggleButton = Globals.CreateGuiElement("Frame", self.ToggleBackground, "ToggleButton")
	self.ToggleButton.Size = UDim2.new(0, 20, 0, 20)
	self.ToggleButton.Position = UDim2.new(0, 2, 0, 2)
	self.ToggleButton.BackgroundColor3 = ThemeManager:GetColor("TextSecondary")
	Globals.AddCornerRadius(self.ToggleButton, 10)
	
	self:SetupEventHandlers()
end

function Toggle:SetupEventHandlers()
	Utilities.OnMouseClick(self.ToggleBackground, function() self:Toggle() end)
	Utilities.OnMouseEnter(self.ToggleBackground, function(hovering)
		self.IsHovering = hovering; self:UpdateVisuals()
	end)
end

function Toggle:UpdateVisuals()
	if self.IsEnabled then
		Utilities.AnimateColor(self.ToggleBackground, ThemeManager:GetColor("Accent"), 0.1)
		Utilities.AnimateColor(self.ToggleButton, ThemeManager:GetColor("Background"), 0.1)
		Utilities.AnimatePosition(self.ToggleButton, 28, 2, 0.2)
	else
		Utilities.AnimateColor(self.ToggleBackground, ThemeManager:GetColor("Foreground"), 0.1)
		Utilities.AnimateColor(self.ToggleButton, ThemeManager:GetColor("TextSecondary"), 0.1)
		Utilities.AnimatePosition(self.ToggleButton, 2, 2, 0.2)
	end
end

function Toggle:Toggle()
	self.IsEnabled = not self.IsEnabled
	self:UpdateVisuals()
	if self.Callback then self.Callback(self.IsEnabled) end
end

-- ============================================
-- KOMPONENT SUWAKA (Slider Component) - Enhanced
-- ============================================

local Slider = {}
Slider.__index = Slider

function Slider:New(text, parent, min, max, default, callback, icon)
	local self = setmetatable({}, Slider)
	self.Text = text
	self.Parent = parent
	self.Min = min or 0
	self.Max = max or 100
	self.Value = default or (self.Min + self.Max) / 2
	self.Callback = callback
	self.Icon = icon or "⊙"
	self:CreateGUI()
	return self
end

function Slider:CreateGUI()
	self.MainFrame = Globals.CreateGuiElement("Frame", self.Parent, self.Text)
	self.MainFrame.Size = UDim2.new(1, -10, 0, 60)
	self.MainFrame.BackgroundTransparency = 1
	self.MainFrame.BorderSizePixel = 0
	
	self.TextLabel = Globals.CreateGuiElement("TextLabel", self.MainFrame, "TextLabel")
	self.TextLabel.Size = UDim2.new(1, 0, 0, 20)
	self.TextLabel.BackgroundTransparency = 1
	self.TextLabel.Text = self.Icon .. " " .. self.Text .. ": " .. tostring(math.floor(self.Value))
	self.TextLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	self.TextLabel.Font = ThemeManager:Get("Font")
	self.TextLabel.TextSize = ThemeManager:Get("FontSize")
	self.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	self.SliderBackground = Globals.CreateGuiElement("Frame", self.MainFrame, "SliderBackground")
	self.SliderBackground.Size = UDim2.new(1, 0, 0, 8)
	self.SliderBackground.Position = UDim2.new(0, 0, 0, 30)
	self.SliderBackground.BackgroundColor3 = ThemeManager:GetColor("Foreground")
	self.SliderBackground.BackgroundTransparency = ThemeManager:Get("Transparency")
	Globals.AddBorder(self.SliderBackground, ThemeManager:GetColor("BorderColor"), 1)
	Globals.AddCornerRadius(self.SliderBackground, 4)
	
	self.SliderFill = Globals.CreateGuiElement("Frame", self.SliderBackground, "SliderFill")
	self.SliderFill.Size = UDim2.new((self.Value - self.Min) / (self.Max - self.Min), 0, 1, 0)
	self.SliderFill.BackgroundColor3 = ThemeManager:GetColor("Accent")
	self.SliderFill.BackgroundTransparency = ThemeManager:Get("Transparency")
	self.SliderFill.BorderSizePixel = 0
	Globals.AddCornerRadius(self.SliderFill, 4)
	
	-- Nowe: Dodanie gradientu do suwaka
	if ThemeManager:Get("GradientEnabled") then
		Globals.AddGradient(self.SliderFill, ThemeManager:GetColor("Accent"), ThemeManager:GetColor("AccentDark"), 90)
	end
	
	self:SetupEventHandlers()
end

function Slider:SetupEventHandlers()
	self.SliderBackground.InputBegan:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:UpdateSliderValue()
		end
	end)
	Globals.UserInputService.InputChanged:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			if self.SliderBackground:FindFirstChild("Dragging") then
				self:UpdateSliderValue()
			end
		end
	end)
end

function Slider:UpdateSliderValue()
	local mousePos = Globals.UserInputService:GetMouseLocation()
	local sliderPos = self.SliderBackground.AbsolutePosition.X
	local sliderSize = self.SliderBackground.AbsoluteSize.X
	local relativePos = math.clamp(mousePos.X - sliderPos, 0, sliderSize)
	local percentage = relativePos / sliderSize
	self.Value = self.Min + (self.Max - self.Min) * percentage
	self.SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
	self.TextLabel.Text = self.Icon .. " " .. self.Text .. ": " .. tostring(math.floor(self.Value))
	if self.Callback then self.Callback(self.Value) end
end

-- ============================================
-- KOMPONENT LISTY ROZWIJANE (Dropdown Component) - Enhanced
-- ============================================

local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown:New(text, parent, options, callback, icon)
	local self = setmetatable({}, Dropdown)
	self.Text = text
	self.Parent = parent
	self.Options = options or {}
	self.Callback = callback
	self.Icon = icon or "▼"
	self.IsOpen = false
	self.Selected = self.Options[1] or "None"
	self:CreateGUI()
	return self
end

function Dropdown:CreateGUI()
	self.MainFrame = Globals.CreateGuiElement("Frame", self.Parent, self.Text)
	self.MainFrame.Size = UDim2.new(1, -10, 0, 40)
	self.MainFrame.BackgroundTransparency = 1
	self.MainFrame.BorderSizePixel = 0
	
	self.DropdownButton = Globals.CreateGuiElement("TextButton", self.MainFrame, "DropdownButton")
	self.DropdownButton.Size = UDim2.new(1, 0, 1, 0)
	self.DropdownButton.BackgroundColor3 = ThemeManager:GetColor("Foreground")
	self.DropdownButton.BackgroundTransparency = ThemeManager:Get("Transparency")
	self.DropdownButton.Text = self.Icon .. " " .. self.Text .. ": " .. self.Selected
	self.DropdownButton.TextColor3 = ThemeManager:GetColor("TextPrimary")
	self.DropdownButton.Font = ThemeManager:Get("Font")
	self.DropdownButton.TextSize = ThemeManager:Get("FontSize")
	self.DropdownButton.ZIndex = 2
	Globals.AddBorder(self.DropdownButton, ThemeManager:GetColor("BorderColor"), 1)
	Globals.AddCornerRadius(self.DropdownButton, ThemeManager:Get("CornerRadius"))
	
	Utilities.OnMouseClick(self.DropdownButton, function() self:Toggle() end)
	
	self.DropdownList = Globals.CreateGuiElement("Frame", self.MainFrame, "DropdownList")
	self.DropdownList.Size = UDim2.new(1, 0, 0, #self.Options * 30)
	self.DropdownList.Position = UDim2.new(0, 0, 1, 5)
	self.DropdownList.BackgroundColor3 = ThemeManager:GetColor("Foreground")
	self.DropdownList.BackgroundTransparency = ThemeManager:Get("Transparency")
	self.DropdownList.BorderSizePixel = 0
	self.DropdownList.ZIndex = 3
	self.DropdownList.Visible = false
	Globals.AddBorder(self.DropdownList, ThemeManager:GetColor("BorderColor"), 1)
	Globals.AddCornerRadius(self.DropdownList, ThemeManager:Get("CornerRadius"))
	
	local UIListLayout = Globals.CreateGuiElement("UIListLayout", self.DropdownList, "UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Vertical
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	
	for i, option in ipairs(self.Options) do
		local optionButton = Globals.CreateGuiElement("TextButton", self.DropdownList, option)
		optionButton.Size = UDim2.new(1, 0, 0, 30)
		optionButton.BackgroundColor3 = ThemeManager:GetColor("Foreground")
		optionButton.BackgroundTransparency = ThemeManager:Get("Transparency")
		optionButton.Text = option
		optionButton.TextColor3 = ThemeManager:GetColor("TextPrimary")
		optionButton.Font = ThemeManager:Get("Font")
		optionButton.TextSize = ThemeManager:Get("FontSize")
		optionButton.ZIndex = 4
		optionButton.LayoutOrder = i
		
		Utilities.OnMouseClick(optionButton, function()
			self:Select(option)
		end)
		Utilities.OnMouseEnter(optionButton, function(hovering)
			optionButton.BackgroundColor3 = hovering and ThemeManager:GetColor("Hover") or ThemeManager:GetColor("Foreground")
		end)
	end
end

function Dropdown:Toggle()
	self.IsOpen = not self.IsOpen
	self.DropdownList.Visible = self.IsOpen
end

function Dropdown:Select(option)
	self.Selected = option
	self.DropdownButton.Text = self.Icon .. " " .. self.Text .. ": " .. self.Selected
	self.IsOpen = false
	self.DropdownList.Visible = false
	if self.Callback then self.Callback(option) end
end

-- ============================================
-- KOMPONENT POLA TEKSTOWEGO (TextBox Component) - Enhanced
-- ============================================

local TextBox = {}
TextBox.__index = TextBox

function TextBox:New(text, parent, placeholder, callback, icon)
	local self = setmetatable({}, TextBox)
	self.Text = text
	self.Parent = parent
	self.Placeholder = placeholder or "Enter text..."
	self.Callback = callback
	self.Icon = icon or "✎"
	self.Value = ""
	self:CreateGUI()
	return self
end

function TextBox:CreateGUI()
	self.MainFrame = Globals.CreateGuiElement("Frame", self.Parent, self.Text)
	self.MainFrame.Size = UDim2.new(1, -10, 0, 50)
	self.MainFrame.BackgroundTransparency = 1
	self.MainFrame.BorderSizePixel = 0
	
	self.TextLabel = Globals.CreateGuiElement("TextLabel", self.MainFrame, "TextLabel")
	self.TextLabel.Size = UDim2.new(1, 0, 0, 20)
	self.TextLabel.BackgroundTransparency = 1
	self.TextLabel.Text = self.Icon .. " " .. self.Text
	self.TextLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	self.TextLabel.Font = ThemeManager:Get("Font")
	self.TextLabel.TextSize = ThemeManager:Get("FontSize")
	self.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	self.TextInputBox = Globals.CreateGuiElement("TextBox", self.MainFrame, "TextInputBox")
	self.TextInputBox.Size = UDim2.new(1, 0, 0, 25)
	self.TextInputBox.Position = UDim2.new(0, 0, 0, 22)
	self.TextInputBox.BackgroundColor3 = ThemeManager:GetColor("Surface")
	self.TextInputBox.BackgroundTransparency = ThemeManager:Get("Transparency")
	self.TextInputBox.TextColor3 = ThemeManager:GetColor("TextPrimary")
	self.TextInputBox.PlaceholderColor3 = ThemeManager:GetColor("TextSecondary")
	self.TextInputBox.PlaceholderText = self.Placeholder
	self.TextInputBox.Font = ThemeManager:Get("Font")
	self.TextInputBox.TextSize = ThemeManager:Get("FontSize")
	self.TextInputBox.ClearTextOnFocus = false
	Globals.AddBorder(self.TextInputBox, ThemeManager:GetColor("BorderColor"), 1)
	Globals.AddCornerRadius(self.TextInputBox, ThemeManager:Get("CornerRadius"))
	
	self.TextInputBox:GetPropertyChangedSignal("Text"):Connect(function()
		self.Value = self.TextInputBox.Text
		if self.Callback then self.Callback(self.Value) end
	end)
end

-- ============================================
-- KOMPONENT POWIADOMIEŃ (Notification Component) - Enhanced
-- ============================================

local Notification = {}
Notification.__index = Notification

function Notification:New(title, message, duration, icon)
	local self = setmetatable({}, Notification)
	self.Title = title
	self.Message = message
	self.Duration = duration or 3
	self.Icon = icon or "ℹ"
	self:CreateGUI()
	return self
end

function Notification:CreateGUI()
	self.MainFrame = Globals.CreateGuiElement("Frame", Globals.PlayerGui, "Notification")
	self.MainFrame.Size = UDim2.new(0, 300, 0, 80)
	self.MainFrame.Position = UDim2.new(1, -320, 1, -100)
	self.MainFrame.BackgroundColor3 = ThemeManager:GetColor("Foreground")
	self.MainFrame.BackgroundTransparency = ThemeManager:Get("Transparency")
	self.MainFrame.BorderSizePixel = 0
	self.MainFrame.ZIndex = 100
	Globals.AddBorder(self.MainFrame, ThemeManager:GetColor("BorderColor"), 1)
	Globals.AddCornerRadius(self.MainFrame, ThemeManager:Get("CornerRadius"))
	
	-- Nowe: Dodanie cienia do powiadomienia
	if ThemeManager:Get("ShadowEnabled") then
		Globals.AddShadow(self.MainFrame, Color3.fromRGB(0, 0, 0), 3)
	end
	
	self.TitleLabel = Globals.CreateGuiElement("TextLabel", self.MainFrame, "TitleLabel")
	self.TitleLabel.Size = UDim2.new(1, -10, 0, 30)
	self.TitleLabel.Position = UDim2.new(0, 5, 0, 5)
	self.TitleLabel.BackgroundTransparency = 1
	self.TitleLabel.Text = self.Icon .. " " .. self.Title
	self.TitleLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	self.TitleLabel.Font = ThemeManager:Get("Font")
	self.TitleLabel.TextSize = ThemeManager:Get("FontSize")
	self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	self.MessageLabel = Globals.CreateGuiElement("TextLabel", self.MainFrame, "MessageLabel")
	self.MessageLabel.Size = UDim2.new(1, -10, 0, 40)
	self.MessageLabel.Position = UDim2.new(0, 5, 0, 35)
	self.MessageLabel.BackgroundTransparency = 1
	self.MessageLabel.Text = self.Message
	self.MessageLabel.TextColor3 = ThemeManager:GetColor("TextSecondary")
	self.MessageLabel.Font = ThemeManager:Get("Font")
	self.MessageLabel.TextSize = 12
	self.MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.MessageLabel.TextWrapped = true
	
	game:GetService("Debris"):AddItem(self.MainFrame, self.Duration)
end

-- ============================================
-- GŁÓWNY MODUŁ BIBLIOTEKI
-- ============================================

local NovaLibrary = {}
NovaLibrary.Globals = Globals
NovaLibrary.ThemeManager = ThemeManager
NovaLibrary.Utilities = Utilities

function NovaLibrary:Init() ThemeManager:ResetTheme() end
function NovaLibrary:CreateWindow(title, pos, size) return Window:New(title, pos, size) end
function NovaLibrary:CreateButton(text, parent, callback, icon) return Button:New(text, parent, callback, icon) end
function NovaLibrary:CreateToggle(text, parent, callback, icon) return Toggle:New(text, parent, callback, icon) end
function NovaLibrary:CreateSlider(text, parent, min, max, default, callback, icon) return Slider:New(text, parent, min, max, default, callback, icon) end
function NovaLibrary:CreateDropdown(text, parent, options, callback, icon) return Dropdown:New(text, parent, options, callback, icon) end
function NovaLibrary:CreateTextBox(text, parent, placeholder, callback, icon) return TextBox:New(text, parent, placeholder, callback, icon) end
function NovaLibrary:CreateNotification(title, message, duration, icon) return Notification:New(title, message, duration, icon) end
function NovaLibrary:LoadTheme(name) ThemeManager:LoadTheme(name) end
function NovaLibrary:Log(msg, level) Globals.Log(msg, level) end

NovaLibrary:Init()

-- ============================================
-- SZABLON DEWELOPERSKI - EDYTUJ PONIŻEJ
-- ============================================

local mainWindow = NovaLibrary:CreateWindow("Nova Script v2.1", {X = 50, Y = 50}, {Width = 600, Height = 500})

-- KATEGORIA: COMBAT
local tabCombat = mainWindow:CreateTab("Combat")
NovaLibrary:CreateButton("Przykład Przycisk", tabCombat.Content, function()
	NovaLibrary:CreateNotification("Combat", "Przycisk wciśnięty!", 2, "✓")
end, "⚔")
NovaLibrary:CreateToggle("Przykład Toggle", tabCombat.Content, function(state)
	NovaLibrary:Log("Toggle: " .. tostring(state), "INFO")
end, "◆")
NovaLibrary:CreateSlider("Przykład Slider", tabCombat.Content, 0, 100, 50, function(value)
	NovaLibrary:Log("Wartość: " .. tostring(math.floor(value)), "INFO")
end, "⊙")

-- KATEGORIA: VISUALS
local tabVisuals = mainWindow:CreateTab("Visuals")
NovaLibrary:CreateButton("Przykład Przycisk", tabVisuals.Content, function()
	NovaLibrary:CreateNotification("Visuals", "Przycisk wciśnięty!", 2, "✓")
end, "👁")
NovaLibrary:CreateToggle("Przykład Toggle", tabVisuals.Content, function(state)
	NovaLibrary:Log("Toggle: " .. tostring(state), "INFO")
end, "◆")
NovaLibrary:CreateDropdown("Przykład Dropdown", tabVisuals.Content, {"Opcja 1", "Opcja 2", "Opcja 3"}, function(selected)
	NovaLibrary:Log("Wybrano: " .. selected, "INFO")
end, "▼")

-- KATEGORIA: MISC
local tabMisc = mainWindow:CreateTab("Misc")
NovaLibrary:CreateButton("Przykład Przycisk", tabMisc.Content, function()
	NovaLibrary:CreateNotification("Misc", "Przycisk wciśnięty!", 2, "✓")
end, "⚙")
NovaLibrary:CreateTextBox("Przykład TextBox", tabMisc.Content, "Wpisz tekst...", function(text)
	NovaLibrary:Log("Tekst: " .. text, "INFO")
end, "✎")
NovaLibrary:CreateToggle("Przykład Toggle", tabMisc.Content, function(state)
	NovaLibrary:Log("Toggle: " .. tostring(state), "INFO")
end, "◆")

-- KATEGORIA: SETTINGS
local tabSettings = mainWindow:CreateTab("Settings")
NovaLibrary:CreateButton("Przykład Przycisk", tabSettings.Content, function()
	NovaLibrary:CreateNotification("Settings", "Przycisk wciśnięty!", 2, "✓")
end, "⚙")
NovaLibrary:CreateToggle("Przykład Toggle", tabSettings.Content, function(state)
	NovaLibrary:Log("Toggle: " .. tostring(state), "INFO")
end, "◆")
NovaLibrary:CreateSlider("Przykład Slider", tabSettings.Content, 0, 100, 50, function(value)
	NovaLibrary:Log("Wartość: " .. tostring(math.floor(value)), "INFO")
end, "⊙")

mainWindow:OnWindowClose(function()
	NovaLibrary:Log("Skrypt zamknięty", "INFO")
end)

mainWindow:OnWindowMinimize(function(isMinimized)
	if isMinimized then
		NovaLibrary:Log("Skrypt zminimalizowany", "INFO")
	else
		NovaLibrary:Log("Skrypt przywrócony", "INFO")
	end
end)

NovaLibrary:Log("NovaLibrary v2.1 Enhanced załadowana pomyślnie!", "INFO")
print("NovaLibrary v2.1 Enhanced załadowana!")

return NovaLibrary
