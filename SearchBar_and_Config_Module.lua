-- SearchBar i Config Module dla NovaLibrary v2.0
-- Moduł zawiera funkcjonalność wyszukiwarki i automatycznego zapisywania konfiguracji

-- ============================================
-- KOMPONENT WYSZUKIWARKI (SearchBar Component)
-- ============================================

local SearchBar = {}
SearchBar.__index = SearchBar

function SearchBar:New(parent, onSearch, onClear)
	local self = setmetatable({}, SearchBar)
	self.Parent = parent
	self.OnSearch = onSearch
	self.OnClear = onClear
	self.SearchText = ""
	self:CreateGUI()
	return self
end

function SearchBar:CreateGUI()
	self.MainFrame = Instance.new("Frame", self.Parent)
	self.MainFrame.Name = "SearchBar"
	self.MainFrame.Size = UDim2.new(1, -10, 0, 40)
	self.MainFrame.BackgroundTransparency = 1
	self.MainFrame.BorderSizePixel = 0
	
	self.SearchContainer = Instance.new("Frame", self.MainFrame)
	self.SearchContainer.Name = "SearchContainer"
	self.SearchContainer.Size = UDim2.new(1, 0, 1, 0)
	self.SearchContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	self.SearchContainer.BackgroundTransparency = 0.05
	self.SearchContainer.BorderSizePixel = 0
	
	local corner = Instance.new("UICorner", self.SearchContainer)
	corner.CornerRadius = UDim.new(0, 8)
	
	local stroke = Instance.new("UIStroke", self.SearchContainer)
	stroke.Color = Color3.fromRGB(50, 50, 55)
	stroke.Thickness = 1
	
	-- Ikona wyszukiwarki (tekst zastępczy)
	self.IconLabel = Instance.new("TextLabel", self.SearchContainer)
	self.IconLabel.Name = "IconLabel"
	self.IconLabel.Size = UDim2.new(0, 30, 1, 0)
	self.IconLabel.Position = UDim2.new(0, 5, 0, 0)
	self.IconLabel.BackgroundTransparency = 1
	self.IconLabel.Text = "🔍"
	self.IconLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
	self.IconLabel.Font = Enum.Font.GothamSemibold
	self.IconLabel.TextSize = 16
	self.IconLabel.TextXAlignment = Enum.TextXAlignment.Center
	self.IconLabel.TextYAlignment = Enum.TextYAlignment.Center
	
	-- Pole tekstowe wyszukiwarki
	self.SearchInput = Instance.new("TextBox", self.SearchContainer)
	self.SearchInput.Name = "SearchInput"
	self.SearchInput.Size = UDim2.new(1, -70, 1, 0)
	self.SearchInput.Position = UDim2.new(0, 35, 0, 0)
	self.SearchInput.BackgroundTransparency = 1
	self.SearchInput.TextColor3 = Color3.fromRGB(230, 230, 240)
	self.SearchInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 160)
	self.SearchInput.PlaceholderText = "Szukaj..."
	self.SearchInput.Font = Enum.Font.GothamSemibold
	self.SearchInput.TextSize = 14
	self.SearchInput.ClearTextOnFocus = false
	
	-- Przycisk czyszczenia
	self.ClearButton = Instance.new("TextButton", self.SearchContainer)
	self.ClearButton.Name = "ClearButton"
	self.ClearButton.Size = UDim2.new(0, 35, 1, 0)
	self.ClearButton.Position = UDim2.new(1, -35, 0, 0)
	self.ClearButton.BackgroundTransparency = 1
	self.ClearButton.Text = "✕"
	self.ClearButton.TextColor3 = Color3.fromRGB(150, 150, 160)
	self.ClearButton.Font = Enum.Font.GothamSemibold
	self.ClearButton.TextSize = 16
	
	self:SetupEventHandlers()
end

function SearchBar:SetupEventHandlers()
	self.SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
		self.SearchText = self.SearchInput.Text
		if self.OnSearch then self.OnSearch(self.SearchText) end
	end)
	
	self.ClearButton.MouseButton1Click:Connect(function()
		self.SearchInput.Text = ""
		self.SearchText = ""
		if self.OnClear then self.OnClear() end
	end)
	
	self.ClearButton.MouseEnter:Connect(function()
		self.ClearButton.TextColor3 = Color3.fromRGB(255, 100, 100)
	end)
	
	self.ClearButton.MouseLeave:Connect(function()
		self.ClearButton.TextColor3 = Color3.fromRGB(150, 150, 160)
	end)
end

-- ============================================
-- SYSTEM KONFIGURACJI (Config Manager)
-- ============================================

local ConfigManager = {}
ConfigManager.__index = ConfigManager

function ConfigManager:New(configName)
	local self = setmetatable({}, ConfigManager)
	self.ConfigName = configName or "NovaLibraryConfig"
	self.ConfigPath = game:GetService("RunService"):IsStudio() and ("studio_" .. self.ConfigName) or self.ConfigName
	self.Config = {}
	self:LoadConfig()
	return self
end

function ConfigManager:SaveConfig(data)
	self.Config = data
	-- W rzeczywistym scenariuszu, tutaj byśmy zapisali do pliku lub datastore
	-- Na potrzeby tego przykładu, przechowujemy w pamięci
	print("[NovaLibrary] Konfiguracja zapisana: " .. self.ConfigName)
end

function ConfigManager:LoadConfig()
	-- W rzeczywistym scenariuszu, tutaj byśmy załadowali z pliku lub datastore
	-- Na potrzeby tego przykładu, zwracamy pustą tabelę
	self.Config = {}
	print("[NovaLibrary] Konfiguracja załadowana: " .. self.ConfigName)
end

function ConfigManager:GetValue(key, default)
	return self.Config[key] or default
end

function ConfigManager:SetValue(key, value)
	self.Config[key] = value
	self:SaveConfig(self.Config)
end

function ConfigManager:ClearConfig()
	self.Config = {}
	self:SaveConfig(self.Config)
	print("[NovaLibrary] Konfiguracja wyczyszczona: " .. self.ConfigName)
end

-- ============================================
-- KOMPONENT TOOLTIP (Tooltip Component)
-- ============================================

local Tooltip = {}
Tooltip.__index = Tooltip

function Tooltip:New(targetElement, text)
	local self = setmetatable({}, Tooltip)
	self.TargetElement = targetElement
	self.Text = text
	self.IsVisible = false
	self:SetupTooltip()
	return self
end

function Tooltip:SetupTooltip()
	self.TooltipFrame = Instance.new("Frame")
	self.TooltipFrame.Name = "Tooltip"
	self.TooltipFrame.Size = UDim2.new(0, 200, 0, 50)
	self.TooltipFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	self.TooltipFrame.BackgroundTransparency = 0.05
	self.TooltipFrame.BorderSizePixel = 0
	self.TooltipFrame.ZIndex = 1000
	self.TooltipFrame.Visible = false
	
	local corner = Instance.new("UICorner", self.TooltipFrame)
	corner.CornerRadius = UDim.new(0, 8)
	
	local stroke = Instance.new("UIStroke", self.TooltipFrame)
	stroke.Color = Color3.fromRGB(50, 50, 55)
	stroke.Thickness = 1
	
	self.TextLabel = Instance.new("TextLabel", self.TooltipFrame)
	self.TextLabel.Name = "TextLabel"
	self.TextLabel.Size = UDim2.new(1, -10, 1, -10)
	self.TextLabel.Position = UDim2.new(0, 5, 0, 5)
	self.TextLabel.BackgroundTransparency = 1
	self.TextLabel.Text = self.Text
	self.TextLabel.TextColor3 = Color3.fromRGB(230, 230, 240)
	self.TextLabel.Font = Enum.Font.GothamSemibold
	self.TextLabel.TextSize = 12
	self.TextLabel.TextWrapped = true
	self.TextLabel.TextXAlignment = Enum.TextXAlignment.Center
	self.TextLabel.TextYAlignment = Enum.TextYAlignment.Center
	
	self:SetupEventHandlers()
end

function Tooltip:SetupEventHandlers()
	self.TargetElement.MouseEnter:Connect(function()
		self:Show()
	end)
	
	self.TargetElement.MouseLeave:Connect(function()
		self:Hide()
	end)
end

function Tooltip:Show()
	if self.IsVisible then return end
	self.IsVisible = true
	self.TooltipFrame.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	
	local mousePos = game:GetService("UserInputService"):GetMouseLocation()
	self.TooltipFrame.Position = UDim2.new(0, mousePos.X + 10, 0, mousePos.Y + 10)
	self.TooltipFrame.Visible = true
end

function Tooltip:Hide()
	if not self.IsVisible then return end
	self.IsVisible = false
	self.TooltipFrame.Visible = false
end

-- ============================================
-- EKSPORT MODUŁÓW
-- ============================================

return {
	SearchBar = SearchBar,
	ConfigManager = ConfigManager,
	Tooltip = Tooltip
}
