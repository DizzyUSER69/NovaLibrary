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
	Accent = Globals.RGB(100, 200, 255),         -- Niebieski akcent (Potassium style)
	AccentDark = Globals.RGB(70, 150, 220),      -- Ciemniejszy akcent
	AccentLight = Globals.RGB(150, 220, 255),    -- Jaśniejszy akcent
	
	-- Kolory stanu
	Success = Globals.RGB(100, 200, 100),        -- Zielony (sukces)
	Warning = Globals.RGB(255, 200, 100),        -- Pomarańczowy (ostrzeżenie)
	Error = Globals.RGB(255, 100, 100),          -- Czerwony (błąd)
	
	-- Kolory interakcji
	Hover = Globals.RGB(60, 60, 80),             -- Kolor przy najechaniu
	Active = Globals.RGB(100, 200, 255),         -- Kolor aktywny
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
		Accent = Globals.RGB(100, 150, 255),
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
	},
	
	-- Motyw z czerwonym akcentem
	Red = {
		Accent = Globals.RGB(255, 100, 100),
		AccentDark = Globals.RGB(200, 70, 70),
		AccentLight = Globals.RGB(255, 150, 150),
		Active = Globals.RGB(255, 100, 100),
	},
}

-- Funkcja do załadowania predefiniowanego motywu
function ThemeManager:LoadTheme(themeName)
	if not self.Themes[themeName] then
		Globals.Error("Motyw '" .. themeName .. "' nie istnieje!")
	end
	self:SetTheme(self.Themes[themeName])
end

return ThemeManager
