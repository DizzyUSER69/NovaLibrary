-- NovaLibrary Bundled via Manus

local _modules = {}

_modules['Globals'] = (function()
-- NovaLibrary - Globals Module
-- Zawiera globalne stałe, funkcje pomocnicze i zmienne środowiskowe

local Globals = {}

-- ============================================
-- STAŁE BIBLIOTEKI
-- ============================================

Globals.VERSION = "1.0.0"
Globals.LIBRARY_NAME = "NovaLibrary"

-- Stałe animacji
Globals.ANIMATION_SPEED = 0.2
Globals.EASING_STYLE = Enum.EasingStyle.Quad
Globals.EASING_DIRECTION = Enum.EasingDirection.Out

-- Stałe dla UI
Globals.CORNER_RADIUS = 8
Globals.PADDING = 8
Globals.BORDER_WIDTH = 1

-- ============================================
-- FUNKCJE POMOCNICZE
-- ============================================

-- Funkcja do tworzenia instancji GUI z podstawowymi właściwościami
function Globals.CreateGuiElement(elementType, parent, name)
	local element = Instance.new(elementType)
	element.Name = name or elementType
	element.Parent = parent
	return element
end

-- Funkcja do ustawienia zaokrąglonych narożników
function Globals.AddCornerRadius(instance, radius)
	local corner = Globals.CreateGuiElement("UICorner", instance, "Corner")
	corner.CornerRadius = UDim.new(0, radius or Globals.CORNER_RADIUS)
	return corner
end

-- Funkcja do ustawienia obramowania
function Globals.AddBorder(instance, color, width)
	local stroke = Globals.CreateGuiElement("UIStroke", instance, "Border")
	stroke.Color = color or Color3.fromRGB(255, 255, 255)
	stroke.Thickness = width or Globals.BORDER_WIDTH
	return stroke
end

-- Funkcja do animowania właściwości
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

-- Funkcja do konwersji RGB na Color3
function Globals.RGB(r, g, b)
	return Color3.fromRGB(r, g, b)
end

-- Funkcja do sprawdzenia, czy wartość jest liczbą
function Globals.IsNumber(value)
	return type(value) == "number"
end

-- Funkcja do sprawdzenia, czy wartość jest stringiem
function Globals.IsString(value)
	return type(value) == "string"
end

-- Funkcja do sprawdzenia, czy wartość jest tabelą
function Globals.IsTable(value)
	return type(value) == "table"
end

-- Funkcja do głębokie kopii tabeli
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

-- Funkcja do łączenia dwóch tabel
function Globals.MergeTables(table1, table2)
	local merged = Globals.DeepCopy(table1)
	for k, v in pairs(table2) do
		merged[k] = v
	end
	return merged
end

-- Funkcja do logowania (debug)
function Globals.Log(message, level)
	level = level or "INFO"
	print(string.format("[%s] [%s] %s", Globals.LIBRARY_NAME, level, tostring(message)))
end

-- Funkcja do obsługi błędów
function Globals.Error(message)
	Globals.Log(message, "ERROR")
	error(message)
end

-- ============================================
-- ZMIENNE GLOBALNE
-- ============================================

-- Referencja do UserInputService
Globals.UserInputService = game:GetService("UserInputService")

-- Referencja do RunService
Globals.RunService = game:GetService("RunService")

-- Referencja do TweenService
Globals.TweenService = game:GetService("TweenService")

-- Referencja do Players
Globals.Players = game:GetService("Players")

-- Referencja do LocalPlayer
Globals.LocalPlayer = Globals.Players.LocalPlayer

-- Referencja do PlayerGui (dla umieszczania GUI)
Globals.PlayerGui = Globals.LocalPlayer:WaitForChild("PlayerGui")


return Globals
end)()

_modules['ThemeManager'] = (function()
-- NovaLibrary - Theme Manager Module
-- Zarządza motywami wizualnymi i stylowaniem komponentów

local Globals = require(script.Parent:WaitForChild("Globals"))

local ThemeManager = {}

-- ============================================
-- DOMYŚLNY MOTYW (Potassium Style)
-- ============================================

ThemeManager.DefaultTheme = {
	-- Kolory podstawowe
	Background = Globals.RGB(20, 20, 25),        -- Ciemny tło
	Foreground = Globals.RGB(40, 40, 50),        -- Jaśniejszy tło dla elementów
	Surface = Globals.RGB(30, 30, 40),           -- Powierzchnia elementów
	
	-- Kolory tekstu
	TextPrimary = Globals.RGB(230, 230, 240),    -- Główny tekst (jasny)
	TextSecondary = Globals.RGB(150, 150, 160),  -- Pomocniczy tekst (szary)
	
	-- Kolory akcent
	Accent = Globals.RGB(180, 180, 180),         -- Subtelny szary akcent
	AccentDark = Globals.RGB(120, 120, 120),      -- Ciemniejszy szary akcent
	AccentLight = Globals.RGB(220, 220, 220),    -- Jaśniejszy szary akcent
	
	-- Kolory stanu
	Success = Globals.RGB(100, 200, 100),        -- Zielony (sukces)
	Warning = Globals.RGB(255, 200, 100),        -- Pomarańczowy (ostrzeżenie)
	Error = Globals.RGB(255, 100, 100),          -- Czerwony (błąd)
	
	-- Kolory interakcji
	Hover = Globals.RGB(60, 60, 80),             -- Kolor przy najechaniu
	Active = Globals.RGB(100, 100, 100),         -- Kolor aktywny (ciemniejszy szary)
	Disabled = Globals.RGB(80, 80, 90),          -- Kolor wyłączony
	
	-- Granice i obramowania
	BorderColor = Globals.RGB(70, 70, 85),       -- Kolor obramowania
	BorderWidth = 1,
	
	-- Czcionka
	Font = Enum.Font.GothamSemibold,
	FontSize = 14,
	
	-- Zaokrąglenie narożników
	CornerRadius = 8,
	
	-- Padding i marginesy
	Padding = 8,
	Margin = 12,
	
	-- Przezroczystość
	Transparency = 0.05,
}

-- ============================================
-- ZARZĄDZANIE MOTYWAMI
-- ============================================

-- Przechowywanie aktualnego motywu
ThemeManager.CurrentTheme = Globals.DeepCopy(ThemeManager.DefaultTheme)

-- Funkcja do ustawienia nowego motywu
function ThemeManager:SetTheme(theme)
	if not Globals.IsTable(theme) then
		Globals.Error("Motyw musi być tabelą!")
	end
	self.CurrentTheme = Globals.MergeTables(self.DefaultTheme, theme)
	Globals.Log("Motyw zmieniony pomyślnie", "INFO")
end

-- Funkcja do resetowania motywu do domyślnego
function ThemeManager:ResetTheme()
	self.CurrentTheme = Globals.DeepCopy(self.DefaultTheme)
	Globals.Log("Motyw zresetowany do domyślnego", "INFO")
end

-- Funkcja do pobierania koloru z motywu
function ThemeManager:GetColor(colorName)
	if not self.CurrentTheme[colorName] then
		Globals.Log("Kolor '" .. colorName .. "' nie znaleziony, używam domyślnego", "WARNING")
		return self.CurrentTheme.Foreground
	end
	return self.CurrentTheme[colorName]
end

-- Funkcja do pobierania wartości z motywu
function ThemeManager:Get(propertyName)
	if not self.CurrentTheme[propertyName] then
		Globals.Log("Właściwość '" .. propertyName .. "' nie znaleziona", "WARNING")
		return nil
	end
	return self.CurrentTheme[propertyName]
end

-- ============================================
-- APLIKOWANIE MOTYWU DO ELEMENTÓW
-- ============================================

-- Funkcja do stylizacji okna
function ThemeManager:StyleWindow(windowFrame)
	if not windowFrame then return end
	
	windowFrame.BackgroundColor3 = self:GetColor("Background")
	windowFrame.BackgroundTransparency = self:Get("Transparency")
	
	-- Dodaj obramowanie
	Globals.AddBorder(windowFrame, self:GetColor("BorderColor"), self:Get("BorderWidth"))
	
	-- Dodaj zaokrąglenie narożników
	Globals.AddCornerRadius(windowFrame, self:Get("CornerRadius"))
end

-- Funkcja do stylizacji przycisku
function ThemeManager:StyleButton(buttonFrame)
	if not buttonFrame then return end
	
	buttonFrame.BackgroundColor3 = self:GetColor("Foreground")
	buttonFrame.BackgroundTransparency = self:Get("Transparency")
	
	-- Dodaj obramowanie
	Globals.AddBorder(buttonFrame, self:GetColor("BorderColor"), self:Get("BorderWidth"))
	
	-- Dodaj zaokrąglenie narożników
	Globals.AddCornerRadius(buttonFrame, self:Get("CornerRadius"))
end

-- Funkcja do stylizacji tekstu
function ThemeManager:StyleTextLabel(textLabel, colorType)
	if not textLabel then return end
	
	colorType = colorType or "TextPrimary"
	
	textLabel.TextColor3 = self:GetColor(colorType)
	textLabel.Font = self:Get("Font")
	textLabel.TextSize = self:Get("FontSize")
	textLabel.BackgroundTransparency = 1
end

-- Funkcja do stylizacji pola tekstowego
function ThemeManager:StyleTextBox(textBox)
	if not textBox then return end
	
	textBox.BackgroundColor3 = self:GetColor("Surface")
	textBox.BackgroundTransparency = self:Get("Transparency")
	textBox.TextColor3 = self:GetColor("TextPrimary")
	textBox.Font = self:Get("Font")
	textBox.TextSize = self:Get("FontSize")
	
	-- Dodaj obramowanie
	Globals.AddBorder(textBox, self:GetColor("BorderColor"), self:Get("BorderWidth"))
	
	-- Dodaj zaokrąglenie narożników
	Globals.AddCornerRadius(textBox, self:Get("CornerRadius"))
end

-- ============================================
-- PREDEFINIOWANE MOTYWY
-- ============================================

ThemeManager.Themes = {
	Potassium = ThemeManager.DefaultTheme,
	
	-- Ciemny motyw (domyślny)
	Dark = ThemeManager.DefaultTheme,
	
	-- Jasny motyw
	Light = {
		Background = Globals.RGB(240, 240, 245),
		Foreground = Globals.RGB(220, 220, 230),
		Surface = Globals.RGB(230, 230, 240),
		TextPrimary = Globals.RGB(30, 30, 40),
		TextSecondary = Globals.RGB(100, 100, 110),
		Accent = Globals.RGB(150, 150, 150), -- Szary akcent dla jasnego motywu
		BorderColor = Globals.RGB(180, 180, 190),
		Hover = Globals.RGB(200, 200, 210),
		Disabled = Globals.RGB(180, 180, 190),
	},
	
	-- Motyw z zielonym akcentem
	Green = {
		Accent = Globals.RGB(100, 200, 100),
		AccentDark = Globals.RGB(70, 150, 70),
		AccentLight = Globals.RGB(150, 220, 150),
		Active = Globals.RGB(100, 200, 100),
	}, -- Pozostawiamy zielony jako opcję, ale domyślny będzie szary
	
	-- Motyw z czerwonym akcentem
	Red = {
		Accent = Globals.RGB(255, 100, 100),
		AccentDark = Globals.RGB(200, 70, 70),
		AccentLight = Globals.RGB(255, 150, 150),
		Active = Globals.RGB(255, 100, 100),
	}, -- Pozostawiamy czerwony jako opcję, ale domyślny będzie szary
}

-- Funkcja do załadowania predefiniowanego motywu
function ThemeManager:LoadTheme(themeName)
	if not self.Themes[themeName] then
		Globals.Error("Motyw '" .. themeName .. "' nie istnieje!")
	end
	self:SetTheme(self.Themes[themeName])
end


return ThemeManager
end)()

_modules['Utilities'] = (function()
-- NovaLibrary - Utilities Module
-- Zawiera uniwersalne funkcje pomocnicze dla biblioteki

local Globals = require(script.Parent:WaitForChild("Globals"))

local Utilities = {}

-- ============================================
-- FUNKCJE DO OBSŁUGI ZDARZEŃ
-- ============================================

-- Funkcja do obsługi kliknięcia myszy
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

-- Funkcja do obsługi najechania myszą
function Utilities.OnMouseEnter(guiElement, callback)
	if not guiElement or not callback then return end
	
	guiElement.MouseEnter:Connect(function()
		callback(true)
	end)
	
	guiElement.MouseLeave:Connect(function()
		callback(false)
	end)
end

-- ============================================
-- FUNKCJE DO MANIPULACJI ELEMENTAMI
-- ============================================

-- Funkcja do ustawienia pozycji elementu
function Utilities.SetPosition(element, x, y)
	if not element then return end
	element.Position = UDim2.new(0, x, 0, y)
end

-- Funkcja do ustawienia rozmiaru elementu
function Utilities.SetSize(element, width, height)
	if not element then return end
	element.Size = UDim2.new(0, width, 0, height)
end

-- Funkcja do ustawienia pozycji i rozmiaru
function Utilities.SetPositionAndSize(element, x, y, width, height)
	Utilities.SetPosition(element, x, y)
	Utilities.SetSize(element, width, height)
end

-- Funkcja do centrowania elementu w stosunku do rodzica
function Utilities.CenterElement(element)
	if not element or not element.Parent then return end
	
	local parent = element.Parent
	local parentSize = parent.AbsoluteSize
	local elementSize = element.AbsoluteSize
	
	local x = (parentSize.X - elementSize.X) / 2
	local y = (parentSize.Y - elementSize.Y) / 2
	
	Utilities.SetPosition(element, x, y)
end

-- Funkcja do ustawienia przezroczystości
function Utilities.SetTransparency(element, transparency)
	if not element then return end
	element.BackgroundTransparency = transparency
end

-- Funkcja do ustawienia widoczności
function Utilities.SetVisible(element, visible)
	if not element then return end
	element.Visible = visible
end

-- ============================================
-- FUNKCJE DO ANIMACJI
-- ============================================

-- Funkcja do animacji przesunięcia
function Utilities.AnimatePosition(element, targetX, targetY, duration)
	if not element then return end
	
	local targetPosition = UDim2.new(0, targetX, 0, targetY)
	return Globals.Animate(element, "Position", targetPosition, duration)
end

-- Funkcja do animacji rozmiaru
function Utilities.AnimateSize(element, targetWidth, targetHeight, duration)
	if not element then return end
	
	local targetSize = UDim2.new(0, targetWidth, 0, targetHeight)
	return Globals.Animate(element, "Size", targetSize, duration)
end

-- Funkcja do animacji przezroczystości
function Utilities.AnimateTransparency(element, targetTransparency, duration)
	if not element then return end
	return Globals.Animate(element, "BackgroundTransparency", targetTransparency, duration)
end

-- Funkcja do animacji koloru
function Utilities.AnimateColor(element, targetColor, duration)
	if not element then return end
	return Globals.Animate(element, "BackgroundColor3", targetColor, duration)
end

-- ============================================
-- FUNKCJE DO WALIDACJI
-- ============================================

-- Funkcja do sprawdzenia, czy element istnieje
function Utilities.ElementExists(element)
	return element and element.Parent ~= nil
end

-- Funkcja do sprawdzenia, czy element jest widoczny
function Utilities.IsElementVisible(element)
	if not element then return false end
	return element.Visible and element.BackgroundTransparency < 1
end

-- Funkcja do walidacji rozmiaru
function Utilities.IsValidSize(width, height)
	return Globals.IsNumber(width) and Globals.IsNumber(height) and width > 0 and height > 0
end

-- Funkcja do walidacji pozycji
function Utilities.IsValidPosition(x, y)
	return Globals.IsNumber(x) and Globals.IsNumber(y)
end

-- ============================================
-- FUNKCJE DO PRACY Z TEKSTEM
-- ============================================

-- Funkcja do skrócenia tekstu
function Utilities.TruncateText(text, maxLength)
	if not Globals.IsString(text) then return text end
	if #text > maxLength then
		return string.sub(text, 1, maxLength - 3) .. "..."
	end
	return text
end

-- Funkcja do sprawdzenia, czy tekst jest pusty
function Utilities.IsTextEmpty(text)
	return not text or text == "" or text:match("^%s*$") ~= nil
end

-- Funkcja do czyszczenia tekstu z białych znaków
function Utilities.TrimText(text)
	if not Globals.IsString(text) then return text end
	return text:match("^%s*(.-)%s*$")
end

-- ============================================
-- FUNKCJE DO PRACY Z KOLORAMI
-- ============================================

-- Funkcja do zmiany jasności koloru
function Utilities.AdjustBrightness(color, factor)
	if not color then return color end
	
	local r = math.min(255, math.floor(color.R * 255 * factor))
	local g = math.min(255, math.floor(color.G * 255 * factor))
	local b = math.min(255, math.floor(color.B * 255 * factor))
	
	return Color3.fromRGB(r, g, b)
end

-- Funkcja do interpolacji między dwoma kolorami
function Utilities.LerpColor(color1, color2, alpha)
	if not color1 or not color2 then return color1 end
	
	local r = color1.R + (color2.R - color1.R) * alpha
	local g = color1.G + (color2.G - color1.G) * alpha
	local b = color1.B + (color2.B - color1.B) * alpha
	
	return Color3.new(r, g, b)
end

-- ============================================
-- FUNKCJE DO DEBUGOWANIA
-- ============================================

-- Funkcja do wypisania właściwości elementu
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

-- Funkcja do wypisania hierarchii elementów
function Utilities.PrintElementHierarchy(element, indent)
	indent = indent or 0
	if not element then return end
	
	local indentStr = string.rep("  ", indent)
	Globals.Log(indentStr .. element.Name .. " (" .. element.ClassName .. ")", "DEBUG")
	
	for _, child in pairs(element:GetChildren()) do
		Utilities.PrintElementHierarchy(child, indent + 1)
	end
end


return Utilities
end)()

_modules['Button'] = (function()
-- NovaLibrary - Button Component
-- Interaktywny przycisk z efektami wizualnymi

local Core = script.Parent.Parent:WaitForChild("Core")
local Globals = require(Core:WaitForChild("Globals"))
local ThemeManager = require(Core:WaitForChild("ThemeManager"))
local Utilities = require(Core:WaitForChild("Utilities"))

local Button = {}
Button.__index = Button

-- ============================================
-- KONSTRUKTOR
-- ============================================

function Button:New(text, parent, callback)
	text = text or "Button"
	callback = callback or function() end
	
	local self = setmetatable({}, Button)
	
	-- Właściwości przycisku
	self.Text = text
	self.Parent = parent
	self.Callback = callback
	self.IsHovering = false
	self.IsPressed = false
	self.IsEnabled = true
	
	-- Utwórz GUI
	self:CreateGUI()
	
	Globals.Log("Przycisk '" .. text .. "' został utworzony", "INFO")
	
	return self
end

-- ============================================
-- TWORZENIE GUI
-- ============================================

function Button:CreateGUI()
	-- Główny kontener przycisku
	self.MainFrame = Globals.CreateGuiElement("TextButton", self.Parent, self.Text)
	self.MainFrame.Size = UDim2.new(1, 0, 0, 40)
	self.MainFrame.BackgroundColor3 = ThemeManager:GetColor("Foreground")
	self.MainFrame.BackgroundTransparency = ThemeManager:Get("Transparency")
	self.MainFrame.BorderSizePixel = 0
	self.MainFrame.Text = ""
	self.MainFrame.ZIndex = 1
	
	-- Dodaj obramowanie
	Globals.AddBorder(self.MainFrame, ThemeManager:GetColor("BorderColor"), ThemeManager:Get("BorderWidth"))
	
	-- Dodaj zaokrąglenie narożników
	Globals.AddCornerRadius(self.MainFrame, ThemeManager:Get("CornerRadius"))
	
	-- Tekst przycisku
	self.TextLabel = Globals.CreateGuiElement("TextLabel", self.MainFrame, "TextLabel")
	self.TextLabel.Size = UDim2.new(1, 0, 1, 0)
	self.TextLabel.BackgroundTransparency = 1
	self.TextLabel.Text = self.Text
	self.TextLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	self.TextLabel.Font = ThemeManager:Get("Font")
	self.TextLabel.TextSize = ThemeManager:Get("FontSize")
	self.TextLabel.ZIndex = 2
	
	-- Obsługa zdarzeń
	self:SetupEventHandlers()
end

-- ============================================
-- OBSŁUGA ZDARZEŃ
-- ============================================

function Button:SetupEventHandlers()
	-- Obsługa kliknięcia
	Utilities.OnMouseClick(self.MainFrame, function()
		if self.IsEnabled then
			self:OnClick()
		end
	end)
	
	-- Obsługa najechania myszą
	Utilities.OnMouseEnter(self.MainFrame, function(hovering)
		if self.IsEnabled then
			self.IsHovering = hovering
			self:UpdateVisuals()
		end
	end)
	
	-- Obsługa wciśnięcia myszy
	self.MainFrame.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 and self.IsEnabled then
			self.IsPressed = true
			self:UpdateVisuals()
		end
	end)
	
	-- Obsługa zwolnienia myszy
	self.MainFrame.InputEnded:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.IsPressed = false
			self:UpdateVisuals()
		end
	end)
end

-- Funkcja do aktualizacji wizualizacji przycisku
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

-- Funkcja wywoływana przy kliknięciu
function Button:OnClick()
	Globals.Log("Przycisk '" .. self.Text .. "' został kliknięty", "DEBUG")
	
	-- Animacja wciśnięcia
	Utilities.AnimateSize(self.MainFrame, self.MainFrame.AbsoluteSize.X * 0.95, self.MainFrame.AbsoluteSize.Y * 0.95, 0.1)
	
	-- Wykonaj callback
	self.Callback()
	
	-- Animacja powrotu
	Utilities.AnimateSize(self.MainFrame, self.MainFrame.AbsoluteSize.X, self.MainFrame.AbsoluteSize.Y, 0.1)
end

-- ============================================
-- METODY PUBLICZNE
-- ============================================

-- Funkcja do ustawienia tekstu
function Button:SetText(text)
	self.Text = text
	self.TextLabel.Text = text
end

-- Funkcja do ustawienia callback'u
function Button:SetCallback(callback)
	if type(callback) == "function" then
		self.Callback = callback
	end
end

-- Funkcja do włączenia/wyłączenia przycisku
function Button:SetEnabled(enabled)
	self.IsEnabled = enabled
	self:UpdateVisuals()
end

-- Funkcja do sprawdzenia, czy przycisk jest włączony
function Button:IsButtonEnabled()
	return self.IsEnabled
end

-- Funkcja do ustawienia rozmiaru
function Button:SetSize(width, height)
	self.MainFrame.Size = UDim2.new(0, width, 0, height)
end

-- Funkcja do ustawienia pozycji
function Button:SetPosition(x, y)
	self.MainFrame.Position = UDim2.new(0, x, 0, y)
end

-- Funkcja do ustawienia koloru
function Button:SetColor(color)
	self.MainFrame.BackgroundColor3 = color
end

-- Funkcja do ustawienia koloru tekstu
function Button:SetTextColor(color)
	self.TextLabel.TextColor3 = color
end

-- Funkcja do usunięcia przycisku
function Button:Destroy()
	self.MainFrame:Destroy()
	Globals.Log("Przycisk '" .. self.Text .. "' został usunięty", "INFO")
end


return Button
end)()

_modules['Toggle'] = (function()
-- NovaLibrary - Toggle Component
-- Przełącznik on/off z efektami wizualnymi

local Core = script.Parent.Parent:WaitForChild("Core")
local Globals = require(Core:WaitForChild("Globals"))
local ThemeManager = require(Core:WaitForChild("ThemeManager"))
local Utilities = require(Core:WaitForChild("Utilities"))

local Toggle = {}
Toggle.__index = Toggle

-- ============================================
-- KONSTRUKTOR
-- ============================================

function Toggle:New(text, parent, callback)
	text = text or "Toggle"
	callback = callback or function() end
	
	local self = setmetatable({}, Toggle)
	
	-- Właściwości przełącznika
	self.Text = text
	self.Parent = parent
	self.Callback = callback
	self.IsEnabled = false
	self.IsHovering = false
	
	-- Utwórz GUI
	self:CreateGUI()
	
	Globals.Log("Przełącznik '" .. text .. "' został utworzony", "INFO")
	
	return self
end

-- ============================================
-- TWORZENIE GUI
-- ============================================

function Toggle:CreateGUI()
	-- Główny kontener przełącznika
	self.MainFrame = Globals.CreateGuiElement("Frame", self.Parent, self.Text)
	self.MainFrame.Size = UDim2.new(1, 0, 0, 40)
	self.MainFrame.BackgroundTransparency = 1
	self.MainFrame.BorderSizePixel = 0
	self.MainFrame.ZIndex = 1
	
	-- Etykieta tekstu
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
	
	-- Przycisk przełącznika
	self:CreateToggleButton()
end

-- Funkcja do tworzenia przycisku przełącznika
function Toggle:CreateToggleButton()
	-- Tło przełącznika
	self.ToggleBackground = Globals.CreateGuiElement("Frame", self.MainFrame, "ToggleBackground")
	self.ToggleBackground.Size = UDim2.new(0, 50, 0, 24)
	self.ToggleBackground.Position = UDim2.new(1, -55, 0.5, -12)
	self.ToggleBackground.BackgroundColor3 = ThemeManager:GetColor("Foreground")
	self.ToggleBackground.BackgroundTransparency = ThemeManager:Get("Transparency")
	self.ToggleBackground.BorderSizePixel = 0
	self.ToggleBackground.ZIndex = 2
	
	-- Dodaj obramowanie
	Globals.AddBorder(self.ToggleBackground, ThemeManager:GetColor("BorderColor"), ThemeManager:Get("BorderWidth"))
	
	-- Dodaj zaokrąglenie narożników
	Globals.AddCornerRadius(self.ToggleBackground, 12)
	
	-- Przycisk przesuwny
	self.ToggleButton = Globals.CreateGuiElement("Frame", self.ToggleBackground, "ToggleButton")
	self.ToggleButton.Size = UDim2.new(0, 20, 0, 20)
	self.ToggleButton.Position = UDim2.new(0, 2, 0, 2)
	self.ToggleButton.BackgroundColor3 = ThemeManager:GetColor("TextSecondary")
	self.ToggleButton.BackgroundTransparency = 0
	self.ToggleButton.BorderSizePixel = 0
	self.ToggleButton.ZIndex = 3
	
	-- Dodaj zaokrąglenie narożników
	Globals.AddCornerRadius(self.ToggleButton, 10)
	
	-- Obsługa zdarzeń
	self:SetupEventHandlers()
end

-- ============================================
-- OBSŁUGA ZDARZEŃ
-- ============================================

function Toggle:SetupEventHandlers()
	-- Obsługa kliknięcia
	Utilities.OnMouseClick(self.ToggleBackground, function()
		self:Toggle()
	end)
	
	-- Obsługa najechania myszą
	Utilities.OnMouseEnter(self.ToggleBackground, function(hovering)
		self.IsHovering = hovering
		self:UpdateVisuals()
	end)
end

-- Funkcja do aktualizacji wizualizacji
function Toggle:UpdateVisuals()
	if self.IsEnabled then
		-- Przełącznik włączony
		self.ToggleBackground.BackgroundColor3 = ThemeManager:GetColor("Accent")
		self.ToggleButton.BackgroundColor3 = ThemeManager:GetColor("Background")
		
		-- Animacja przesunięcia przycisku
		Utilities.AnimatePosition(self.ToggleButton, 28, 2, 0.2)
	else
		-- Przełącznik wyłączony
		self.ToggleBackground.BackgroundColor3 = ThemeManager:GetColor("Foreground")
		self.ToggleButton.BackgroundColor3 = ThemeManager:GetColor("TextSecondary")
		
		-- Animacja przesunięcia przycisku
		Utilities.AnimatePosition(self.ToggleButton, 2, 2, 0.2)
	end
	
	-- Efekt najechania
	if self.IsHovering then
		Utilities.AnimateTransparency(self.ToggleBackground, ThemeManager:Get("Transparency") - 0.1, 0.1)
	else
		Utilities.AnimateTransparency(self.ToggleBackground, ThemeManager:Get("Transparency"), 0.1)
	end
end

-- Funkcja do przełączenia stanu
function Toggle:Toggle()
	self.IsEnabled = not self.IsEnabled
	self:UpdateVisuals()
	
	Globals.Log("Przełącznik '" .. self.Text .. "' zmienił stan na: " .. tostring(self.IsEnabled), "DEBUG")
	
	-- Wykonaj callback
	self.Callback(self.IsEnabled)
end

-- ============================================
-- METODY PUBLICZNE
-- ============================================

-- Funkcja do ustawienia tekstu
function Toggle:SetText(text)
	self.Text = text
	self.TextLabel.Text = text
end

-- Funkcja do ustawienia callback'u
function Toggle:SetCallback(callback)
	if type(callback) == "function" then
		self.Callback = callback
	end
end

-- Funkcja do ustawienia stanu
function Toggle:SetState(state)
	if state ~= self.IsEnabled then
		self:Toggle()
	end
end

-- Funkcja do pobierania stanu
function Toggle:GetState()
	return self.IsEnabled
end

-- Funkcja do włączenia przełącznika
function Toggle:Enable()
	if not self.IsEnabled then
		self:Toggle()
	end
end

-- Funkcja do wyłączenia przełącznika
function Toggle:Disable()
	if self.IsEnabled then
		self:Toggle()
	end
end

-- Funkcja do usunięcia przełącznika
function Toggle:Destroy()
	self.MainFrame:Destroy()
	Globals.Log("Przełącznik '" .. self.Text .. "' został usunięty", "INFO")
end


return Toggle
end)()

_modules['Window'] = (function()
-- NovaLibrary - Window Component
-- Podstawowe okno z możliwością przeciągania, zamykania i minimalizowania

local Core = script.Parent.Parent:WaitForChild("Core")
local Globals = require(Core:WaitForChild("Globals"))
local ThemeManager = require(Core:WaitForChild("ThemeManager"))
local Utilities = require(Core:WaitForChild("Utilities"))

local Window = {}
Window.__index = Window

-- ============================================
-- KONSTRUKTOR
-- ============================================

function Window:New(title, position, size)
	title = title or "Nova Window"
	position = position or {X = 100, Y = 100}
	size = size or {Width = 400, Height = 300}
	
	local self = setmetatable({}, Window)
	
	-- Właściwości okna
	self.Title = title
	self.Position = position
	self.Size = size
	self.IsOpen = true
	self.IsMinimized = false
	self.IsDragging = false
	self.DragOffset = {X = 0, Y = 0}
	
	-- Callbacks
	self.OnClose = nil
	self.OnMinimize = nil
	
	-- Utwórz GUI
	self:CreateGUI()
	
	Globals.Log("Okno '" .. title .. "' zostało utworzone", "INFO")
	
	return self
end

-- ============================================
-- TWORZENIE GUI
-- ============================================

function Window:CreateGUI()
	-- Główny kontener okna
	self.MainFrame = Globals.CreateGuiElement("Frame", Globals.PlayerGui, self.Title)
	self.MainFrame.Size = UDim2.new(0, self.Size.Width, 0, self.Size.Height)
	self.MainFrame.Position = UDim2.new(0, self.Position.X, 0, self.Position.Y)
	self.MainFrame.BackgroundColor3 = ThemeManager:GetColor("Background")
	self.MainFrame.BackgroundTransparency = ThemeManager:Get("Transparency")
	self.MainFrame.BorderSizePixel = 0
	self.MainFrame.ZIndex = 1
	
	-- Dodaj obramowanie
	Globals.AddBorder(self.MainFrame, ThemeManager:GetColor("BorderColor"), ThemeManager:Get("BorderWidth"))
	
	-- Dodaj zaokrąglenie narożników
	Globals.AddCornerRadius(self.MainFrame, ThemeManager:Get("CornerRadius"))
	
	-- Pasek tytułu
	self:CreateTitleBar()
	
	-- Zawartość okna
	self:CreateContent()
	
	-- Obsługa zdarzeń
	self:SetupEventHandlers()
end

-- Funkcja do tworzenia paska tytułu
function Window:CreateTitleBar()
	self.TitleBar = Globals.CreateGuiElement("Frame", self.MainFrame, "TitleBar")
	self.TitleBar.Size = UDim2.new(1, 0, 0, 35)
	self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
	self.TitleBar.BackgroundColor3 = ThemeManager:GetColor("Foreground")
	self.TitleBar.BackgroundTransparency = ThemeManager:Get("Transparency")
	self.TitleBar.BorderSizePixel = 0
	self.TitleBar.ZIndex = 2
	
	-- Dodaj zaokrąglenie narożników (górne)
	local corner = Globals.AddCornerRadius(self.TitleBar, ThemeManager:Get("CornerRadius"))
	corner.CornerRadius = UDim.new(0, ThemeManager:Get("CornerRadius"))
	
	-- Tekst tytułu
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
	
	-- Przycisk minimalizacji
	self:CreateMinimizeButton()
	
	-- Przycisk zamknięcia
	self:CreateCloseButton()
end

-- Funkcja do tworzenia przycisku minimalizacji
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
	
	-- Obsługa kliknięcia
	Utilities.OnMouseClick(self.MinimizeButton, function()
		self:Minimize()
	end)
	
	-- Efekt najechania
	Utilities.OnMouseEnter(self.MinimizeButton, function(hovering)
		if hovering then
			self.MinimizeButton.BackgroundColor3 = ThemeManager:GetColor("Hover")
		else
			self.MinimizeButton.BackgroundColor3 = ThemeManager:GetColor("Foreground")
		end
	end)
end

-- Funkcja do tworzenia przycisku zamknięcia
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
	
	-- Obsługa kliknięcia
	Utilities.OnMouseClick(self.CloseButton, function()
		self:Close()
	end)
	
	-- Efekt najechania
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

-- Funkcja do tworzenia zawartości okna
function Window:CreateContent()
	self.ContentFrame = Globals.CreateGuiElement("Frame", self.MainFrame, "ContentFrame")
	self.ContentFrame.Size = UDim2.new(1, 0, 1, -35)
	self.ContentFrame.Position = UDim2.new(0, 0, 0, 35)
	self.ContentFrame.BackgroundColor3 = ThemeManager:GetColor("Background")
	self.ContentFrame.BackgroundTransparency = ThemeManager:Get("Transparency")
	self.ContentFrame.BorderSizePixel = 0
	self.ContentFrame.ZIndex = 2
	
	-- Dodaj zaokrąglenie narożników (dolne)
	local corner = Globals.AddCornerRadius(self.ContentFrame, ThemeManager:Get("CornerRadius"))
	corner.CornerRadius = UDim.new(0, ThemeManager:Get("CornerRadius"))
end

-- ============================================
-- OBSŁUGA ZDARZEŃ
-- ============================================

function Window:SetupEventHandlers()
	-- Obsługa przeciągania okna
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
	
	-- Obsługa ruchu myszy podczas przeciągania
	Globals.UserInputService.InputChanged:Connect(function(input, gameProcessed)
		if self.IsDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mousePos = Globals.UserInputService:GetMouseLocation()
			local newX = mousePos.X - self.DragOffset.X
			local newY = mousePos.Y - self.DragOffset.Y
			
			self.MainFrame.Position = UDim2.new(0, newX, 0, newY)
		end
	end)
end

-- ============================================
-- METODY PUBLICZNE
-- ============================================

-- Funkcja do zamknięcia okna
function Window:Close()
	if self.OnClose then
		self.OnClose()
	end
	self.IsOpen = false
	self.MainFrame:Destroy()
	Globals.Log("Okno '" .. self.Title .. "' zostało zamknięte", "INFO")
end

-- Funkcja do minimalizacji okna
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

-- Funkcja do ustawienia widoczności
function Window:SetVisible(visible)
	self.MainFrame.Visible = visible
end

-- Funkcja do ustawienia pozycji
function Window:SetPosition(x, y)
	self.Position = {X = x, Y = y}
	self.MainFrame.Position = UDim2.new(0, x, 0, y)
end

-- Funkcja do ustawienia rozmiaru
function Window:SetSize(width, height)
	self.Size = {Width = width, Height = height}
	self.MainFrame.Size = UDim2.new(0, width, 0, height)
end

-- Funkcja do dodania elementu do okna
function Window:AddElement(element)
	if element and element.Parent then
		element.Parent = self.ContentFrame
	end
	return element
end

-- Funkcja do ustawienia callback'u przy zamknięciu
function Window:OnWindowClose(callback)
	self.OnClose = callback
end

-- Funkcja do ustawienia callback'u przy minimalizacji
function Window:OnWindowMinimize(callback)
	self.OnMinimize = callback
end


return Window
end)()

-- NovaLibrary - Main Module
-- Główny moduł biblioteki GUI dla Roblox


local Globals = _modules["Globals"]
local ThemeManager = _modules["ThemeManager"]
local Utilities = _modules["Utilities"]

local NovaLibrary = {}

-- ============================================
-- METADANE BIBLIOTEKI
-- ============================================

NovaLibrary.Version = Globals.VERSION
NovaLibrary.Name = Globals.LIBRARY_NAME

-- ============================================
-- PUBLICZNE MODUŁY
-- ============================================

NovaLibrary.Globals = Globals
NovaLibrary.ThemeManager = ThemeManager
NovaLibrary.Utilities = Utilities

-- ============================================
-- INICJALIZACJA
-- ============================================

-- Flaga inicjalizacji
local isInitialized = false

-- Funkcja do inicjalizacji biblioteki
function NovaLibrary:Init()
	if isInitialized then
		Globals.Log("Biblioteka jest już zainicjalizowana!", "WARNING")
		return
	end
	
	Globals.Log("Inicjalizacja biblioteki " .. self.Name .. " v" .. self.Version, "INFO")
	
	-- Załaduj domyślny motyw
	ThemeManager:ResetTheme()
	
	isInitialized = true
	Globals.Log("Biblioteka zainicjalizowana pomyślnie!", "INFO")
end

-- Funkcja do sprawdzenia, czy biblioteka jest zainicjalizowana
function NovaLibrary:IsInitialized()
	return isInitialized
end

-- ============================================
-- FUNKCJE DO ZARZĄDZANIA MOTYWAMI
-- ============================================

-- Funkcja do ustawienia motywu
function NovaLibrary:SetTheme(theme)
	ThemeManager:SetTheme(theme)
end

-- Funkcja do załadowania predefiniowanego motywu
function NovaLibrary:LoadTheme(themeName)
	ThemeManager:LoadTheme(themeName)
end

-- Funkcja do resetowania motywu
function NovaLibrary:ResetTheme()
	ThemeManager:ResetTheme()
end

-- Funkcja do pobierania aktualnego motywu
function NovaLibrary:GetTheme()
	return ThemeManager.CurrentTheme
end

-- ============================================
-- FUNKCJE DO TWORZENIA KOMPONENTÓW
-- ============================================

-- Funkcja do tworzenia okna
function NovaLibrary:CreateWindow(title, position, size)
	
	local Window = _modules["Window"]
	return Window:New(title, position, size)
end

-- Funkcja do tworzenia przycisku
function NovaLibrary:CreateButton(text, parent, callback)
	
	local Button = _modules["Button"]
	return Button:New(text, parent, callback)
end

-- Funkcja do tworzenia przełącznika
function NovaLibrary:CreateToggle(text, parent, callback)
	
	local Toggle = _modules["Toggle"]
	return Toggle:New(text, parent, callback)
end

-- ============================================
-- FUNKCJE POMOCNICZE
-- ============================================

-- Funkcja do logowania
function NovaLibrary:Log(message, level)
	Globals.Log(message, level)
end

-- Funkcja do wyświetlenia informacji o bibliotece
function NovaLibrary:PrintInfo()
	Globals.Log("=== " .. self.Name .. " ===", "INFO")
	Globals.Log("Wersja: " .. self.Version, "INFO")
	Globals.Log("Status: " .. (isInitialized and "Zainicjalizowana" or "Niezainicjalizowana"), "INFO")
	Globals.Log("Motyw: " .. "Potassium (Dark)", "INFO")
	Globals.Log("=========================", "INFO")
end

-- ============================================
-- AUTOMATYCZNA INICJALIZACJA
-- ============================================

-- Inicjalizuj bibliotekę automatycznie przy załadowaniu
NovaLibrary:Init()

return NovaLibrary
