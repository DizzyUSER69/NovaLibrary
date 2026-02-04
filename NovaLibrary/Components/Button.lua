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
	Utilities.AnimateSize(self.MainFrame, self.MainFrame.AbsoluteSize.X - 4, self.MainFrame.AbsoluteSize.Y - 4, 0.1)
	
	-- Wykonaj callback
	self.Callback()
	
	-- Animacja powrotu
	Utilities.AnimateSize(self.MainFrame, self.MainFrame.AbsoluteSize.X + 4, self.MainFrame.AbsoluteSize.Y + 4, 0.1)
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
