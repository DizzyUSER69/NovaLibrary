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
