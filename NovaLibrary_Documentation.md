# NovaLibrary - Dokumentacja

## Wprowadzenie

**NovaLibrary** to lekka, wydajna i w pełni natywna (100% UNC - User-Native Code) biblioteka GUI dla Roblox, zaprojektowana z myślą o nowoczesnej estetyce i wysokiej wydajności. Jej interfejs wizualny jest inspirowany minimalistycznym i funkcjonalnym stylem popularnego executora Potassium, oferując ciemny motyw z wyraźnymi akcentami.

Celem NovaLibrary jest dostarczenie deweloperom Roblox narzędzia do szybkiego tworzenia intuicyjnych i estetycznych interfejsów użytkownika, bez polegania na zewnętrznych zależnościach, co zapewnia maksymalną kontrolę i kompatybilność.

## 1. Architektura i Struktura Projektu

NovaLibrary została zaprojektowana z myślą o modułowości i łatwości rozbudowy. Poniżej przedstawiono strukturę katalogów i głównych modułów:

```
NovaLibrary/
├── init.lua          -- Główny moduł inicjujący bibliotekę
├── Core/             -- Rdzeń biblioteki (funkcje pomocnicze, zarządzanie stanem)
│   ├── Globals.lua
│   ├── ThemeManager.lua
│   └── Utilities.lua
├── Components/       -- Folder na poszczególne komponenty GUI
│   ├── Window.lua
│   ├── Button.lua
│   ├── Toggle.lua
│   └── ...
└── Examples/         -- Przykłady użycia komponentów
    └── BasicWindow.lua
```

### 1.1. Moduły Rdzenia (`Core`)

*   **`Globals.lua`**: Zawiera globalne stałe biblioteki (np. wersja, nazwa, stałe animacji, stałe UI) oraz podstawowe funkcje pomocnicze, takie jak `CreateGuiElement`, `AddCornerRadius`, `AddBorder`, `Animate`, `RGB`, funkcje walidacyjne i narzędzia do logowania/obsługi błędów. Umożliwia również dostęp do kluczowych usług Roblox (np. `UserInputService`, `TweenService`).

*   **`ThemeManager.lua`**: Odpowiedzialny za zarządzanie motywami wizualnymi. Definiuje domyślny motyw w stylu Potassium, a także predefiniowane motywy (Dark, Light, Green, Red). Udostępnia funkcje do ustawiania, resetowania i pobierania kolorów/wartości z aktualnego motywu, a także funkcje do stylizacji komponentów GUI zgodnie z wybranym motywem.

*   **`Utilities.lua`**: Zbiór uniwersalnych funkcji pomocniczych, które ułatwiają interakcję z elementami GUI. Obejmuje obsługę zdarzeń myszy (`OnMouseClick`, `OnMouseEnter`), manipulację elementami (pozycja, rozmiar, widoczność), animacje (pozycja, rozmiar, przezroczystość, kolor), walidację oraz funkcje do pracy z tekstem i kolorami.

### 1.2. Główny Moduł (`init.lua`)

Moduł `init.lua` jest punktem wejścia do NovaLibrary. Udostępnia publiczne API do inicjalizacji biblioteki, zarządzania motywami oraz tworzenia instancji komponentów GUI. Automatycznie inicjalizuje bibliotekę przy załadowaniu i ładuje domyślny motyw.

## 2. Instalacja i Użycie

Aby użyć NovaLibrary w swoim projekcie Roblox, masz dwie główne metody:

### 2.1. Metoda 1: Ręczna instalacja

1.  **Pobierz NovaLibrary**: Skopiuj całą strukturę katalogów `NovaLibrary` (zawierającą `init.lua`, `Core/`, `Components/` i `Examples/`) do `ServerScriptService` w swoim projekcie Roblox Studio. Upewnij się, że nazwa folderu to `NovaLibrary`.

2.  **Załaduj bibliotekę**: W dowolnym skrypcie serwerowym lub lokalnym (w zależności od tego, gdzie chcesz używać GUI), załaduj bibliotekę za pomocą `require`:

    ```lua
    local NovaLibrary = require(game.ServerScriptService:WaitForChild("NovaLibrary"))
    ```

3.  **Inicjalizacja**: Biblioteka jest automatycznie inicjalizowana przy załadowaniu, ale możesz również jawnie wywołać funkcję inicjalizującą:

    ```lua
    NovaLibrary:Init()
    ```

4.  **Użycie komponentów**: Po zainicjalizowaniu możesz tworzyć komponenty GUI:

    ```lua
    -- Tworzenie okna
    local myWindow = NovaLibrary:CreateWindow("Moje Pierwsze Okno", {X = 100, Y = 100}, {Width = 600, Height = 400})

    -- Tworzenie przycisku w oknie
    local myButton = NovaLibrary:CreateButton("Kliknij Mnie", myWindow.ContentFrame, function()
        print("Przycisk został kliknięty!")
    end)
    myButton:SetPosition(10, 10)
    myButton:SetSize(150, 40)

    -- Tworzenie przełącznika w oknie
    local myToggle = NovaLibrary:CreateToggle("Włącz Funkcję", myWindow.ContentFrame, function(state)
        print("Przełącznik jest " .. (state and "włączony" or "wyłączony"))
    end)
    myToggle:SetPosition(10, 60)
    myToggle:SetSize(150, 40)
    ```

### 2.2. Metoda 2: Użycie z Rojo (zalecane dla deweloperów)

Jeśli używasz [Rojo](https://rojo.space/), możesz łatwo zsynchronizować NovaLibrary ze swoim projektem. Poniżej znajdziesz instrukcje, jak to zrobić:

1.  **Zainstaluj Rojo**: Jeśli jeszcze tego nie zrobiłeś, zainstaluj Rojo zgodnie z instrukcjami na [oficjalnej stronie](https://rojo.space/docs/installation/).
2.  **Sklonuj repozytorium**: Sklonuj repozytorium NovaLibrary do swojego lokalnego folderu projektu:
    ```bash
    git clone https://github.com/TwojaNazwaUzytkownika/NovaLibrary.git
    cd NovaLibrary
    ```
3.  **Skonfiguruj `rojo.project.json`**: W folderze głównym NovaLibrary znajduje się plik `rojo.project.json`. Ten plik definiuje, jak NovaLibrary ma być zsynchronizowana z Roblox Studio. Domyślnie, NovaLibrary zostanie umieszczona w `ServerScriptService`.
    ```json
    {
      "name": "NovaLibrary",
      "tree": {
        "$className": "DataModel",
        "ServerScriptService": {
          "$className": "ServerScriptService",
          "NovaLibrary": {
            "$path": "NovaLibrary"
          }
        }
      }
    }
    ```
4.  **Uruchom Rojo**: Otwórz terminal w folderze głównym NovaLibrary i uruchom Rojo:
    ```bash
    rojo serve
    ```
5.  **Połącz się w Roblox Studio**: W Roblox Studio, użyj wtyczki Rojo, aby połączyć się z uruchomionym serwerem Rojo. NovaLibrary zostanie automatycznie zsynchronizowana z Twoim projektem.

Po zsynchronizowaniu NovaLibrary z Roblox Studio za pomocą Rojo, możesz używać jej w swoich skryptach tak samo, jak w przypadku instalacji ręcznej. Ścieżka do biblioteki będzie `game.ServerScriptService.NovaLibrary`.

## 3. Komponenty GUI

NovaLibrary oferuje zestaw podstawowych komponentów GUI, które można łatwo rozbudowywać i dostosowywać.

### 3.1. `Window`

Podstawowy kontener dla innych elementów GUI. Posiada pasek tytułu, przyciski minimalizacji i zamknięcia, oraz obsługę przeciągania.

**Konstruktor:**

```lua
NovaLibrary:CreateWindow(title: string, position: {X: number, Y: number}, size: {Width: number, Height: number})
```

*   `title`: Tekst wyświetlany na pasku tytułu okna.
*   `position`: Tabela z pozycją X i Y okna na ekranie.
*   `size`: Tabela z szerokością i wysokością okna.

**Metody:**

*   `Window:Close()`: Zamyka i niszczy okno.
*   `Window:Minimize()`: Minimalizuje/przywraca okno.
*   `Window:SetVisible(visible: boolean)`: Ustawia widoczność okna.
*   `Window:SetPosition(x: number, y: number)`: Ustawia pozycję okna.
*   `Window:SetSize(width: number, height: number)`: Ustawia rozmiar okna.
*   `Window:AddElement(element: Instance)`: Dodaje element GUI do ramki zawartości okna.
*   `Window:OnWindowClose(callback: function)`: Ustawia funkcję zwrotną wywoływaną przy zamknięciu okna.
*   `Window:OnWindowMinimize(callback: function)`: Ustawia funkcję zwrotną wywoływaną przy minimalizacji/przywracaniu okna.

### 3.2. `Button`

Interaktywny przycisk z efektami najechania i wciśnięcia, stylizowany zgodnie z motywem.

**Konstruktor:**

```lua
NovaLibrary:CreateButton(text: string, parent: Instance, callback: function)
```

*   `text`: Tekst wyświetlany na przycisku.
*   `parent`: Rodzic, do którego zostanie dodany przycisk (np. `Window.ContentFrame`).
*   `callback`: Funkcja wywoływana po kliknięciu przycisku.

**Metody:**

*   `Button:SetText(text: string)`: Zmienia tekst na przycisku.
*   `Button:SetCallback(callback: function)`: Zmienia funkcję wywoływaną po kliknięciu.
*   `Button:SetEnabled(enabled: boolean)`: Włącza/wyłącza przycisk.
*   `Button:IsButtonEnabled(): boolean`: Zwraca stan włączenia przycisku.
*   `Button:SetSize(width: number, height: number)`: Ustawia rozmiar przycisku.
*   `Button:SetPosition(x: number, y: number)`: Ustawia pozycję przycisku.
*   `Button:SetColor(color: Color3)`: Ustawia kolor tła przycisku.
*   `Button:SetTextColor(color: Color3)`: Ustawia kolor tekstu przycisku.
*   `Button:Destroy()`: Usuwa przycisk.

### 3.3. `Toggle`

Przełącznik typu on/off z animowanymi efektami wizualnymi.

**Konstruktor:**

```lua
NovaLibrary:CreateToggle(text: string, parent: Instance, callback: function)
```

*   `text`: Tekst opisujący przełącznik.
*   `parent`: Rodzic, do którego zostanie dodany przełącznik.
*   `callback`: Funkcja wywoływana po zmianie stanu przełącznika. Przyjmuje jeden argument `state` (boolean).

**Metody:**

*   `Toggle:SetText(text: string)`: Zmienia tekst przełącznika.
*   `Toggle:SetCallback(callback: function)`: Zmienia funkcję wywoływaną po zmianie stanu.
*   `Toggle:SetState(state: boolean)`: Ustawia stan przełącznika (true/false).
*   `Toggle:GetState(): boolean`: Zwraca aktualny stan przełącznika.
*   `Toggle:Enable()`: Włącza przełącznik.
*   `Toggle:Disable()`: Wyłącza przełącznik.
*   `Toggle:Destroy()`: Usuwa przełącznik.

## 4. Zarządzanie Motywami

NovaLibrary umożliwia łatwe zarządzanie motywami wizualnymi. Domyślnie używany jest motyw Potassium (ciemny).

*   **`NovaLibrary:SetTheme(themeTable: table)`**: Ustawia niestandardowy motyw, przekazując tabelę z definicjami kolorów i stylów.
*   **`NovaLibrary:LoadTheme(themeName: string)`**: Ładuje jeden z predefiniowanych motywów (np. `"Dark"`, `"Light"`, `"Green"`, `"Red"`).
*   **`NovaLibrary:ResetTheme()`**: Resetuje motyw do domyślnego (Potassium/Dark).
*   **`NovaLibrary:GetTheme(): table`**: Zwraca aktualnie używany motyw.

## 5. Przykład Użycia (`BasicWindow.lua`)

W folderze `Examples/` znajduje się plik `BasicWindow.lua`, który demonstruje podstawowe użycie NovaLibrary. Aby go uruchomić:

1.  Upewnij się, że cała struktura `NovaLibrary` znajduje się w `ServerScriptService`.
2.  W `ServerScriptService` utwórz nowy `Script` i wklej do niego zawartość pliku `/home/ubuntu/NovaLibrary/Examples/BasicWindow.lua`.
3.  Uruchom grę w Roblox Studio. Powinieneś zobaczyć okno GUI z przyciskiem i przełącznikiem, stylizowane w estetyce Potassium.

```lua
-- Zawartość pliku /home/ubuntu/NovaLibrary/Examples/BasicWindow.lua

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
```

## 6. Dalszy Rozwój

NovaLibrary jest zaprojektowana tak, aby była łatwo rozszerzalna. Możesz dodawać nowe komponenty do folderu `Components/` i integrować je z głównym modułem `init.lua`. Pamiętaj o utrzymaniu spójności stylu i przestrzeganiu zasad UNC.

---
