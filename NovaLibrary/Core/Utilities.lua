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
