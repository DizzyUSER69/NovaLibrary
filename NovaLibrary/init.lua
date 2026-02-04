-- NovaLibrary - Main Module
-- Główny moduł biblioteki GUI dla Roblox

local Core = script:WaitForChild("Core")
local Globals = require(Core:WaitForChild("Globals"))
local ThemeManager = require(Core:WaitForChild("ThemeManager"))
local Utilities = require(Core:WaitForChild("Utilities"))

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
	local Components = script:WaitForChild("Components")
	local Window = require(Components:WaitForChild("Window"))
	return Window:New(title, position, size)
end

-- Funkcja do tworzenia przycisku
function NovaLibrary:CreateButton(text, parent, callback)
	local Components = script:WaitForChild("Components")
	local Button = require(Components:WaitForChild("Button"))
	return Button:New(text, parent, callback)
end

-- Funkcja do tworzenia przełącznika
function NovaLibrary:CreateToggle(text, parent, callback)
	local Components = script:WaitForChild("Components")
	local Toggle = require(Components:WaitForChild("Toggle"))
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
