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
