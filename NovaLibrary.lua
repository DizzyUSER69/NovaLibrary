-- NovaLibrary - Skonsolidowany Skrypt (Loadstring Version)
-- Wersja 1.0.0
--
-- Aby użyć, skopiuj i wklej do swojego executora:
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/DizzyUSER69/NovaLibrary/main/NovaLibrary.lua"))()
--
-- Ten skrypt zawiera wszystkie moduły NovaLibrary (Core, Components) w jednym pliku.

-- ============================================
-- GLOBALNE FUNKCJE I STAŁE (Globals Module)
-- ============================================

local Globals = {}

Globals.VERSION = "1.0.0"
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
	stroke.Color = color or Color3.fromRGB(70, 70, 85)
	stroke.Thickness = width or Globals.BORDER_WIDTH
	return stroke
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
Globals.LocalPlayer = Globals.Players.LocalPlayer or nil -- Może być nil w niektórych kontekstach executora
Globals.PlayerGui = Globals.LocalPlayer and Globals.LocalPlayer:WaitForChild("PlayerGui") or game:GetService("CoreGui") -- Fallback na CoreGui

-- ============================================
-- ZARZĄDZANIE MOTYWAMI (ThemeManager Module)
-- ============================================

local ThemeManager = {}

ThemeManager.DefaultTheme = {
	Background = Globals.RGB(20, 20, 25),
	Foreground = Globals.RGB(40, 40, 50),
	Surface = Globals.RGB(30, 30, 40),
	TextPrimary = Globals.RGB(230, 230, 240),
	TextSecondary = Globals.RGB(150, 150, 160),
	Accent = Globals.RGB(100, 200, 255),
	AccentDark = Globals.RGB(70, 150, 220),
	AccentLight = Globals.RGB(150, 220, 255),
	Success = Globals.RGB(100, 200, 100),
	Warning = Globals.RGB(255, 200, 100),
	Error = Globals.RGB(255, 100, 100),
	Hover = Globals.RGB(60, 60, 80),
	Active = Globals.RGB(100, 200, 255),
	Disabled = Globals.RGB(80, 80, 90),
	BorderColor = Globals.RGB(70, 70, 85),
	BorderWidth = 1,
	Font = Enum.Font.GothamSemibold,
	FontSize = 14,
	CornerRadius = 8,
	Padding = 8,
	Margin = 12,
	Transparency = 0.05,
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
		Globals.Log("Kolor \'" .. colorName .. "\' nie znaleziony, używam domyślnego", "WARNING")
		return self.CurrentTheme.Foreground
	end
	return self.CurrentTheme[colorName]
end

function ThemeManager:Get(propertyName)
	if not self.CurrentTheme[propertyName] then
		Globals.Log("Właściwość \'" .. propertyName .. "\' nie znaleziona", "WARNING")
		return nil
	end
	return self.CurrentTheme[propertyName]
end

function ThemeManager:StyleWindow(windowFrame)
	if not windowFrame then return end
	windowFrame.BackgroundColor3 = self:GetColor("Background")
	windowFrame.BackgroundTransparency = self:Get("Transparency")
	Globals.AddBorder(windowFrame, self:GetColor("BorderColor"), self:Get("BorderWidth"))
	Globals.AddCornerRadius(windowFrame, self:Get("CornerRadius"))
end

function ThemeManager:StyleButton(buttonFrame)
	if not buttonFrame then return end
	buttonFrame.BackgroundColor3 = self:GetColor("Foreground")
	buttonFrame.BackgroundTransparency = self:Get("Transparency")
	Globals.AddBorder(buttonFrame, self:GetColor("BorderColor"), self:Get("BorderWidth"))
	Globals.AddCornerRadius(buttonFrame, self:Get("CornerRadius"))
end

function ThemeManager:StyleTextLabel(textLabel, colorType)
	if not textLabel then return end
	colorType = colorType or "TextPrimary"
	textLabel.TextColor3 = self:GetColor(colorType)
	textLabel.Font = self:Get("Font")
	textLabel.TextSize = self:Get("FontSize")
	textLabel.BackgroundTransparency = 1
end

function ThemeManager:StyleTextBox(textBox)
	if not textBox then return end
	textBox.BackgroundColor3 = self:GetColor("Surface")
	textBox.BackgroundTransparency = self:Get("Transparency")
	textBox.TextColor3 = self:GetColor("TextPrimary")
	textBox.Font = self:Get("Font")
	textBox.TextSize = self:Get("FontSize")
	Globals.AddBorder(textBox, self:GetColor("BorderColor"), self:Get("BorderWidth"))
	Globals.AddCornerRadius(textBox, self:Get("CornerRadius"))
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
		Accent = Globals.RGB(100, 150, 255),
		BorderColor = Globals.RGB(180, 180, 190),
		Hover = Globals.RGB(200, 200, 210),
		Disabled = Globals.RGB(180, 180, 190),
	},
	Green = {
		Accent = Globals.RGB(100, 200, 100),
		AccentDark = Globals.RGB(70, 150, 70),
		AccentLight = Globals.RGB(150, 220, 150),
		Active = Globals.RGB(100, 200, 100),
	},
	Red = {
		Accent = Globals.RGB(255, 100, 100),
		AccentDark = Globals.RGB(200, 70, 70),
		AccentLight = Globals.RGB(255, 150, 150),
		Active = Globals.RGB(255, 100, 100),
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
	
	guiElement.MouseEnter:Connect(function()
		callback(true)
	end)
	
	guiElement.MouseLeave:Connect(function()
		callback(false)
	end)
end

function Utilities.SetPosition(element, x, y)
	if not element then return end
	element.Position = UDim2.new(0, x, 0, y)
end

function Utilities.SetSize(element, width, height)
	if not element then return end
	element.Size = UDim2.new(0, width, 0, height)
end

function Utilities.SetPositionAndSize(element, x, y, width, height)
	Utilities.SetPosition(element, x, y)
	Utilities.SetSize(element, width, height)
end

function Utilities.CenterElement(element)
	if not element or not element.Parent then return end
	
	local parent = element.Parent
	local elementSize = element.AbsoluteSize
	
	local x = (parent.AbsoluteSize.X - elementSize.X) / 2
	local y = (parent.AbsoluteSize.Y - elementSize.Y) / 2
	
	Utilities.SetPosition(element, x, y)
end

function Utilities.SetTransparency(element, transparency)
	if not element then return end
	element.BackgroundTransparency = transparency
end

function Utilities.SetVisible(element, visible)
	if not element then return end
	element.Visible = visible
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

function Utilities.ElementExists(element)
	return element and element.Parent ~= nil
end

function Utilities.IsElementVisible(element)
	if not element then return false end
	return element.Visible and element.BackgroundTransparency < 1
end

function Utilities.IsValidSize(width, height)
	return Globals.IsNumber(width) and Globals.IsNumber(height) and width > 0 and height > 0
end

function Utilities.IsValidPosition(x, y)
	return Globals.IsNumber(x) and Globals.IsNumber(y)
end

function Utilities.TruncateText(text, maxLength)
	if not Globals.IsString(text) then return text end
	if #text > maxLength then
		return string.sub(text, 1, maxLength - 3) .. "..."
	end
	return text
end

function Utilities.IsTextEmpty(text)
	return not text or text == "" or text:match("^%s*$") ~= nil
end

function Utilities.TrimText(text)
	if not Globals.IsString(text) then return text end
	return text:match("^%s*(.-)%s*$")
end

function Utilities.AdjustBrightness(color, factor)
	if not color then return color end
	local r = math.min(255, math.floor(color.R * 255 * factor))
	local g = math.min(255, math.floor(color.G * 255 * factor))
	local b = math.min(255, math.floor(color.B * 255 * factor))
	return Color3.fromRGB(r, g, b)
end

function Utilities.LerpColor(color1, color2, alpha)
	if not color1 or not color2 then return color1 end
	local r = color1.R + (color2.R - color1.R) * alpha
	local g = color1.G + (color2.G - color1.G) * alpha
	local b = color1.B + (color2.B - color1.B) * alpha
	return Color3.new(r, g, b)
end

function Utilities.PrintElementProperties(element)
	if not element then
		Globals.Log("Element nie istnieje!", "WARNING")
		return
	end
	Globals.Log("Właściwości elementu: " .. element.Name, "DEBUG")
	Globals.Log("  Position: " .. tostring(element.Position), "DEBUG")
	Globals.Log("  Size: " .. tostring(element.Size), "DEBUG")
	Globals.Log("  Visible: " .. tostring(element.Visible), "DEBUG")
	Globals.Log("  BackgroundColor3: " .. tostring(element.BackgroundColor3), "DEBUG")
end

function Utilities.PrintElementHierarchy(element, indent)
	indent = indent or 0
	if not element then return end
	local indentStr = string.rep("  ", indent)
	Globals.Log(indentStr .. element.Name .. " (" .. element.ClassName .. ")", "DEBUG")
	for _, child in pairs(element:GetChildren()) do
		Utilities.PrintElementHierarchy(child, indent + 1)
	end
end

-- ============================================
-- KOMPONENT OKNA (Window Component)
-- ============================================

local Window = {}
Window.__index = Window

function Window:New(title, position, size)
	title = title or "Nova Window"
	position = position or {X = 100, Y = 100}
	size = size or {Width = 400, Height = 300}
	
	local self = setmetatable({}, Window)
	
	self.Title = title
	self.Position = position
	self.Size = size
	self.IsOpen = true
	self.IsMinimized = false
	self.IsDragging = false
	self.DragOffset = {X = 0, Y = 0}
	
	self.OnClose = nil
	self.OnMinimize = nil
	
	self:CreateGUI()
	
	Globals.Log("Okno \'" .. title .. "\' zostało utworzone", "INFO")
	
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
	
	self:CreateTitleBar()
	self:CreateContent()
	self:SetupEventHandlers()
end

function Window:CreateTitleBar()
	self.TitleBar = Globals.CreateGuiElement("Frame", self.MainFrame, "TitleBar")
	self.TitleBar.Size = UDim2.new(1, 0, 0, 35)
	self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
	self.TitleBar.BackgroundColor3 = ThemeManager:GetColor("Foreground")
	self.TitleBar.BackgroundTransparency = ThemeManager:Get("Transparency")
	self.TitleBar.BorderSizePixel = 0
	self.TitleBar.ZIndex = 2
	
	local corner = Globals.AddCornerRadius(self.TitleBar, ThemeManager:Get("CornerRadius"))
	corner.CornerRadius = UDim.new(0, ThemeManager:Get("CornerRadius"))
	
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
	self.MinimizeButton.BorderSizePixel = 0
	self.MinimizeButton.ZIndex = 3
	
	Utilities.OnMouseClick(self.MinimizeButton, function()
		self:Minimize()
	end)
	
	Utilities.OnMouseEnter(self.MinimizeButton, function(hovering)
		if hovering then
			self.MinimizeButton.BackgroundColor3 = ThemeManager:GetColor("Hover")
		else
			self.MinimizeButton.BackgroundColor3 = ThemeManager:GetColor("Foreground")
		end
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
	self.CloseButton.BorderSizePixel = 0
	self.CloseButton.ZIndex = 3
	
	Utilities.OnMouseClick(self.CloseButton, function()
		self:Close()
	end)
	
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

function Window:CreateContent()
	self.ContentFrame = Globals.CreateGuiElement("Frame", self.MainFrame, "ContentFrame")
	self.ContentFrame.Size = UDim2.new(1, 0, 1, -35)
	self.ContentFrame.Position = UDim2.new(0, 0, 0, 35)
	self.ContentFrame.BackgroundColor3 = ThemeManager:GetColor("Background")
	self.ContentFrame.BackgroundTransparency = ThemeManager:Get("Transparency")
	self.ContentFrame.BorderSizePixel = 0
	self.ContentFrame.ZIndex = 2
	
	local corner = Globals.AddCornerRadius(self.ContentFrame, ThemeManager:Get("CornerRadius"))
	corner.CornerRadius = UDim.new(0, ThemeManager:Get("CornerRadius"))
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
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.IsDragging = false
		end
	end)
	
	Globals.UserInputService.InputChanged:Connect(function(input, gameProcessed)
		if self.IsDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mousePos = Globals.UserInputService:GetMouseLocation()
			local newX = mousePos.X - self.DragOffset.X
			local newY = mousePos.Y - self.DragOffset.Y
			
			self.MainFrame.Position = UDim2.new(0, newX, 0, newY)
		end
	end)
end

function Window:Close()
	if self.OnClose then
		self.OnClose()
	end
	self.IsOpen = false
	self.MainFrame:Destroy()
	Globals.Log("Okno \'" .. self.Title .. "\' zostało zamknięte", "INFO")
end

function Window:Minimize()
	self.IsMinimized = not self.IsMinimized
	
	if self.IsMinimized then
		Utilities.AnimateSize(self.MainFrame, self.Size.Width, 35, 0.3)
		self.ContentFrame.Visible = false
	else
		Utilities.AnimateSize(self.MainFrame, self.Size.Width, self.Size.Height, 0.3)
		self.ContentFrame.Visible = true
	end
	
	if self.OnMinimize then
		self.OnMinimize(self.IsMinimized)
	end
end

function Window:SetVisible(visible)
	self.MainFrame.Visible = visible
end

function Window:SetPosition(x, y)
	self.Position = {X = x, Y = y}
	self.MainFrame.Position = UDim2.new(0, x, 0, y)
end

function Window:SetSize(width, height)
	self.Size = {Width = width, Height = height}
	self.MainFrame.Size = UDim2.new(0, width, 0, height)
end

function Window:AddElement(element)
	if element and element.Parent then
		element.Parent = self.ContentFrame
	end
	return element
end

function Window:OnWindowClose(callback)
	self.OnClose = callback
end

function Window:OnWindowMinimize(callback)
	self.OnMinimize = callback
end

-- ============================================
-- KOMPONENT PRZYCISKU (Button Component)
-- ============================================

local Button = {}
Button.__index = Button

function Button:New(text, parent, callback)
	text = text or "Button"
	callback = callback or function() end
	
	local self = setmetatable({}, Button)
	
	self.Text = text
	self.Parent = parent
	self.Callback = callback
	self.IsHovering = false
	self.IsPressed = false
	self.IsEnabled = true
	
	self:CreateGUI()
	
	Globals.Log("Przycisk \'" .. text .. "\' został utworzony", "INFO")
	
	return self
end

function Button:CreateGUI()
	self.MainFrame = Globals.CreateGuiElement("TextButton", self.Parent, self.Text)
	self.MainFrame.Size = UDim2.new(1, 0, 0, 40)
	self.MainFrame.BackgroundColor3 = ThemeManager:GetColor("Foreground")
	self.MainFrame.BackgroundTransparency = ThemeManager:Get("Transparency")
	self.MainFrame.BorderSizePixel = 0
	self.MainFrame.Text = ""
	self.MainFrame.ZIndex = 1
	
	Globals.AddBorder(self.MainFrame, ThemeManager:GetColor("BorderColor"), ThemeManager:Get("BorderWidth"))
	Globals.AddCornerRadius(self.MainFrame, ThemeManager:Get("CornerRadius"))
	
	self.TextLabel = Globals.CreateGuiElement("TextLabel", self.MainFrame, "TextLabel")
	self.TextLabel.Size = UDim2.new(1, 0, 1, 0)
	self.TextLabel.BackgroundTransparency = 1
	self.TextLabel.Text = self.Text
	self.TextLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	self.TextLabel.Font = ThemeManager:Get("Font")
	self.TextLabel.TextSize = ThemeManager:Get("FontSize")
	self.TextLabel.ZIndex = 2
	
	self:SetupEventHandlers()
end

function Button:SetupEventHandlers()
	Utilities.OnMouseClick(self.MainFrame, function()
		if self.IsEnabled then
			self:OnClick()
		end
	end)
	
	Utilities.OnMouseEnter(self.MainFrame, function(hovering)
		if self.IsEnabled then
			self.IsHovering = hovering
			self:UpdateVisuals()
		end
	end)
	
	self.MainFrame.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 and self.IsEnabled then
			self.IsPressed = true
			self:UpdateVisuals()
		end
	end)
	
	self.MainFrame.InputEnded:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.IsPressed = false
			self:UpdateVisuals()
		end
	end)
end

function Button:UpdateVisuals()
	if not self.IsEnabled then
		self.MainFrame.BackgroundColor3 = ThemeManager:GetColor("Disabled")
		self.TextLabel.TextColor3 = ThemeManager:GetColor("TextSecondary")
		return
	end
	
	if self.IsPressed then
		self.MainFrame.BackgroundColor3 = ThemeManager:GetColor("Active")
		self.TextLabel.TextColor3 = ThemeManager:GetColor("Background")
	elseif self.IsHovering then
		self.MainFrame.BackgroundColor3 = ThemeManager:GetColor("Hover")
		self.TextLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	else
		self.MainFrame.BackgroundColor3 = ThemeManager:GetColor("Foreground")
		self.TextLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	end
end

function Button:OnClick()
	Globals.Log("Przycisk \'" .. self.Text .. "\' został kliknięty", "DEBUG")
	
	Utilities.AnimateSize(self.MainFrame, self.MainFrame.AbsoluteSize.X - 4, self.MainFrame.AbsoluteSize.Y - 4, 0.1)
	
	self.Callback()
	
	Utilities.AnimateSize(self.MainFrame, self.MainFrame.AbsoluteSize.X + 4, self.MainFrame.AbsoluteSize.Y + 4, 0.1)
end

function Button:SetText(text)
	self.Text = text
	self.TextLabel.Text = text
end

function Button:SetCallback(callback)
	if type(callback) == "function" then
		self.Callback = callback
	end
end

function Button:SetEnabled(enabled)
	self.IsEnabled = enabled
	self:UpdateVisuals()
end

function Button:IsButtonEnabled()
	return self.IsEnabled
end

function Button:SetSize(width, height)
	self.MainFrame.Size = UDim2.new(0, width, 0, height)
end

function Button:SetPosition(x, y)
	self.MainFrame.Position = UDim2.new(0, x, 0, y)
end

function Button:SetColor(color)
	self.MainFrame.BackgroundColor3 = color
end

function Button:SetTextColor(color)
	self.TextLabel.TextColor3 = color
end

function Button:Destroy()
	self.MainFrame:Destroy()
	Globals.Log("Przycisk \'" .. self.Text .. "\' został usunięty", "INFO")
end

-- ============================================
-- KOMPONENT PRZEŁĄCZNIKA (Toggle Component)
-- ============================================

local Toggle = {}
Toggle.__index = Toggle

function Toggle:New(text, parent, callback)
	text = text or "Toggle"
	callback = callback or function() end
	
	local self = setmetatable({}, Toggle)
	
	self.Text = text
	self.Parent = parent
	self.Callback = callback
	self.IsEnabled = false
	self.IsHovering = false
	
	self:CreateGUI()
	
	Globals.Log("Przełącznik \'" .. text .. "\' został utworzony", "INFO")
	
	return self
end

function Toggle:CreateGUI()
	self.MainFrame = Globals.CreateGuiElement("Frame", self.Parent, self.Text)
	self.MainFrame.Size = UDim2.new(1, 0, 0, 40)
	self.MainFrame.BackgroundTransparency = 1
	self.MainFrame.BorderSizePixel = 0
	self.MainFrame.ZIndex = 1
	
	self.TextLabel = Globals.CreateGuiElement("TextLabel", self.MainFrame, "TextLabel")
	self.TextLabel.Size = UDim2.new(1, -60, 1, 0)
	self.TextLabel.Position = UDim2.new(0, 0, 0, 0)
	self.TextLabel.BackgroundTransparency = 1
	self.TextLabel.Text = self.Text
	self.TextLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	self.TextLabel.Font = ThemeManager:Get("Font")
	self.TextLabel.TextSize = ThemeManager:Get("FontSize")
	self.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.TextLabel.ZIndex = 2
	
	self:CreateToggleButton()
end

function Toggle:CreateToggleButton()
	self.ToggleBackground = Globals.CreateGuiElement("Frame", self.MainFrame, "ToggleBackground")
	self.ToggleBackground.Size = UDim2.new(0, 50, 0, 24)
	self.ToggleBackground.Position = UDim2.new(1, -55, 0.5, -12)
	self.ToggleBackground.BackgroundColor3 = ThemeManager:GetColor("Foreground")
	self.ToggleBackground.BackgroundTransparency = ThemeManager:Get("Transparency")
	self.ToggleBackground.BorderSizePixel = 0
	self.ToggleBackground.ZIndex = 2
	
	Globals.AddBorder(self.ToggleBackground, ThemeManager:GetColor("BorderColor"), ThemeManager:Get("BorderWidth"))
	Globals.AddCornerRadius(self.ToggleBackground, 12)
	
	self.ToggleButton = Globals.CreateGuiElement("Frame", self.ToggleBackground, "ToggleButton")
	self.ToggleButton.Size = UDim2.new(0, 20, 0, 20)
	self.ToggleButton.Position = UDim2.new(0, 2, 0, 2)
	self.ToggleButton.BackgroundColor3 = ThemeManager:GetColor("TextSecondary")
	self.ToggleButton.BackgroundTransparency = 0
	self.ToggleButton.BorderSizePixel = 0
	self.ToggleButton.ZIndex = 3
	
	Globals.AddCornerRadius(self.ToggleButton, 10)
	
	self:SetupEventHandlers()
end

function Toggle:SetupEventHandlers()
	Utilities.OnMouseClick(self.ToggleBackground, function()
		self:Toggle()
	end)
	
	Utilities.OnMouseEnter(self.ToggleBackground, function(hovering)
		self.IsHovering = hovering
		self:UpdateVisuals()
	end)
end

function Toggle:UpdateVisuals()
	if self.IsEnabled then
		self.ToggleBackground.BackgroundColor3 = ThemeManager:GetColor("Active")
		self.ToggleButton.BackgroundColor3 = ThemeManager:GetColor("TextPrimary")
		
		Utilities.AnimatePosition(self.ToggleButton, 28, 2, 0.2)
	else
		self.ToggleBackground.BackgroundColor3 = ThemeManager:GetColor("Foreground")
		self.ToggleButton.BackgroundColor3 = ThemeManager:GetColor("TextSecondary")
		
		Utilities.AnimatePosition(self.ToggleButton, 2, 2, 0.2)
	end
	
	if self.IsHovering then
		Utilities.AnimateTransparency(self.ToggleBackground, ThemeManager:Get("Transparency") - 0.1, 0.1)
	else
		Utilities.AnimateTransparency(self.ToggleBackground, ThemeManager:Get("Transparency"), 0.1)
	end
end

function Toggle:Toggle()
	self.IsEnabled = not self.IsEnabled
	self:UpdateVisuals()
	
	Globals.Log("Przełącznik \'" .. self.Text .. "\' zmienił stan na: " .. tostring(self.IsEnabled), "DEBUG")
	
	self.Callback(self.IsEnabled)
end

function Toggle:SetText(text)
	self.Text = text
	self.TextLabel.Text = text
end

function Toggle:SetCallback(callback)
	if type(callback) == "function" then
		self.Callback = callback
	end
end

function Toggle:SetState(state)
	if state ~= self.IsEnabled then
		self:Toggle()
	end
end

function Toggle:GetState()
	return self.IsEnabled
end

function Toggle:Enable()
	if not self.IsEnabled then
		self:Toggle()
	end
end

function Toggle:Disable()
	if self.IsEnabled then
		self:Toggle()
	end
end

function Toggle:Destroy()
	self.MainFrame:Destroy()
	Globals.Log("Przełącznik \'" .. self.Text .. "\' został usunięty", "INFO")
end

-- ============================================
-- GŁÓWNY MODUŁ BIBLIOTEKI (init.lua logic)
-- ============================================

local NovaLibrary = {}

NovaLibrary.Version = Globals.VERSION
NovaLibrary.Name = Globals.LIBRARY_NAME

NovaLibrary.Globals = Globals
NovaLibrary.ThemeManager = ThemeManager
NovaLibrary.Utilities = Utilities

local isInitialized = false

function NovaLibrary:Init()
	if isInitialized then
		Globals.Log("Biblioteka jest już zainicjalizowana!", "WARNING")
		return
	end
	
	Globals.Log("Inicjalizacja biblioteki " .. self.Name .. " v" .. self.Version, "INFO")
	
	ThemeManager:ResetTheme()
	
	isInitialized = true
	Globals.Log("Biblioteka zainicjalizowana pomyślnie!", "INFO")
end

function NovaLibrary:IsInitialized()
	return isInitialized
end

function NovaLibrary:SetTheme(theme)
	ThemeManager:SetTheme(theme)
end

function NovaLibrary:LoadTheme(themeName)
	ThemeManager:LoadTheme(themeName)
end

function NovaLibrary:ResetTheme()
	ThemeManager:ResetTheme()
end

function NovaLibrary:GetTheme()
	return ThemeManager.CurrentTheme
end

function NovaLibrary:CreateWindow(title, position, size)
	return Window:New(title, position, size)
end

function NovaLibrary:CreateButton(text, parent, callback)
	return Button:New(text, parent, callback)
end

function NovaLibrary:CreateToggle(text, parent, callback)
	return Toggle:New(text, parent, callback)
end

function NovaLibrary:Log(message, level)
	Globals.Log(message, level)
end

function NovaLibrary:PrintInfo()
	Globals.Log("=== " .. self.Name .. " ===", "INFO")
	Globals.Log("Wersja: " .. self.Version, "INFO")
	Globals.Log("Status: " .. (isInitialized and "Zainicjalizowana" or "Niezainicjalizowana"), "INFO")
	Globals.Log("Motyw: " .. "Potassium (Dark)", "INFO")
	Globals.Log("=========================", "INFO")
end

-- Automatyczna inicjalizacja
NovaLibrary:Init()

-- ============================================
-- PRZYKŁAD UŻYCIA (BasicWindow.lua logic)
-- ============================================

-- Utwórz główne okno
local mainWindow = NovaLibrary:CreateWindow("NovaLibrary Demo", {X = 50, Y = 50}, {Width = 500, Height = 400})

-- Utwórz kontener na przyciski
local buttonContainer = Globals.CreateGuiElement("Frame", mainWindow.ContentFrame, "ButtonContainer")
buttonContainer.Size = UDim2.new(1, -20, 0, 50)
buttonContainer.Position = UDim2.new(0, 10, 0, 10)
buttonContainer.BackgroundTransparency = 1
buttonContainer.BorderSizePixel = 0

-- Utwórz przycisk "Kliknij mnie"
local clickButton = NovaLibrary:CreateButton("Kliknij mnie!", buttonContainer, function()
	NovaLibrary:Log("Przycisk został kliknięty!", "INFO")
	print("Przycisk został kliknięty!")
end)
clickButton.MainFrame.Size = UDim2.new(1, 0, 1, 0)

-- Utwórz kontener na przełącznik
local toggleContainer = Globals.CreateGuiElement("Frame", mainWindow.ContentFrame, "ToggleContainer")
toggleContainer.Size = UDim2.new(1, -20, 0, 50)
toggleContainer.Position = UDim2.new(0, 10, 0, 70)
toggleContainer.BackgroundTransparency = 1
toggleContainer.BorderSizePixel = 0

-- Utwórz przełącznik
local toggle = NovaLibrary:CreateToggle("Włącz tryb ciemny", toggleContainer, function(state)
	NovaLibrary:Log("Przełącznik zmienił stan na: " .. tostring(state), "INFO")
	
	if state then
		NovaLibrary:LoadTheme("Dark")
	else
		NovaLibrary:LoadTheme("Light")
	end
end)
toggle.MainFrame.Size = UDim2.new(1, 0, 1, 0)

-- Utwórz etykietę
local infoLabel = Globals.CreateGuiElement("TextLabel", mainWindow.ContentFrame, "InfoLabel")
infoLabel.Size = UDim2.new(1, -20, 0, 100)
infoLabel.Position = UDim2.new(0, 10, 0, 130)
infoLabel.BackgroundColor3 = ThemeManager:GetColor("Foreground")
infoLabel.BackgroundTransparency = ThemeManager:Get("Transparency")
infoLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
infoLabel.Font = ThemeManager:Get("Font")
infoLabel.TextSize = 12
infoLabel.Text = "Witaj w NovaLibrary!\n\nTo jest przykład użycia biblioteki GUI dla Roblox.\nBiblioteka oferuje nowoczesne komponenty z efektami wizualnymi."
infoLabel.TextWrapped = true
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Padding = UDim.new(0, 10)

Globals.AddBorder(infoLabel, ThemeManager:GetColor("BorderColor"))
Globals.AddCornerRadius(infoLabel, ThemeManager:Get("CornerRadius"))

mainWindow:OnWindowClose(function()
	NovaLibrary:Log("Okno zostało zamknięte", "INFO")
end)

mainWindow:OnWindowMinimize(function(isMinimized)
	if isMinimized then
		NovaLibrary:Log("Okno zostało zminimalizowane", "INFO")
	else
		NovaLibrary:Log("Okno zostało przywrócone", "INFO")
	end
end)

NovaLibrary:Log("Przykład został załadowany pomyślnie!", "INFO")
print("NovaLibrary Demo załadowana!")

return NovaLibrary
