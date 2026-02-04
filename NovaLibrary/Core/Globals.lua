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
