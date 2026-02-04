-- NovaLibrary - Basic Window Example
-- Przykład użycia biblioteki NovaLibrary z podstawowymi komponentami

-- Załaduj bibliotekę
local NovaLibrary = require(game.ServerScriptService:WaitForChild("NovaLibrary"))

-- Inicjalizuj bibliotekę
NovaLibrary:Init()

-- Wyświetl informacje o bibliotece
NovaLibrary:PrintInfo()

-- ============================================
-- TWORZENIE OKNA
-- ============================================

-- Utwórz główne okno
local mainWindow = NovaLibrary:CreateWindow("NovaLibrary Demo", {X = 50, Y = 50}, {Width = 500, Height = 400})

-- ============================================
-- DODAWANIE KOMPONENTÓW
-- ============================================

-- Utwórz kontener na przyciski
local buttonContainer = NovaLibrary.Globals.CreateGuiElement("Frame", mainWindow.ContentFrame, "ButtonContainer")
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

-- ============================================
-- DODAWANIE PRZEŁĄCZNIKA
-- ============================================

-- Utwórz kontener na przełącznik
local toggleContainer = NovaLibrary.Globals.CreateGuiElement("Frame", mainWindow.ContentFrame, "ToggleContainer")
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

-- ============================================
-- DODAWANIE ETYKIET TEKSTOWYCH
-- ============================================

-- Utwórz etykietę
local infoLabel = NovaLibrary.Globals.CreateGuiElement("TextLabel", mainWindow.ContentFrame, "InfoLabel")
infoLabel.Size = UDim2.new(1, -20, 0, 100)
infoLabel.Position = UDim2.new(0, 10, 0, 130)
infoLabel.BackgroundColor3 = NovaLibrary.ThemeManager:GetColor("Foreground")
infoLabel.BackgroundTransparency = NovaLibrary.ThemeManager:Get("Transparency")
infoLabel.TextColor3 = NovaLibrary.ThemeManager:GetColor("TextPrimary")
infoLabel.Font = NovaLibrary.ThemeManager:Get("Font")
infoLabel.TextSize = 12
infoLabel.Text = "Witaj w NovaLibrary!\n\nTo jest przykład użycia biblioteki GUI dla Roblox.\nBiblioteka oferuje nowoczesne komponenty z efektami wizualnymi."
infoLabel.TextWrapped = true
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Padding = UDim.new(0, 10)

-- Dodaj obramowanie
NovaLibrary.Globals.AddBorder(infoLabel, NovaLibrary.ThemeManager:GetColor("BorderColor"))

-- Dodaj zaokrąglenie narożników
NovaLibrary.Globals.AddCornerRadius(infoLabel, NovaLibrary.ThemeManager:Get("CornerRadius"))

-- ============================================
-- OBSŁUGA ZDARZEŃ OKNA
-- ============================================

-- Ustaw callback przy zamknięciu okna
mainWindow:OnWindowClose(function()
	NovaLibrary:Log("Okno zostało zamknięte", "INFO")
end)

-- Ustaw callback przy minimalizacji okna
mainWindow:OnWindowMinimize(function(isMinimized)
	if isMinimized then
		NovaLibrary:Log("Okno zostało zminimalizowane", "INFO")
	else
		NovaLibrary:Log("Okno zostało przywrócone", "INFO")
	end
end)

-- ============================================
-- DODATKOWE FUNKCJE
-- ============================================

-- Funkcja do zmiany motywu
local function ChangeTheme(themeName)
	NovaLibrary:LoadTheme(themeName)
	NovaLibrary:Log("Motyw zmieniony na: " .. themeName, "INFO")
end

-- Funkcja do wyświetlenia informacji
local function PrintLibraryInfo()
	NovaLibrary:PrintInfo()
end

-- ============================================
-- KONIEC PRZYKŁADU
-- ============================================

NovaLibrary:Log("Przykład został załadowany pomyślnie!", "INFO")
print("NovaLibrary Demo załadowana!")
