# NovaLibrary

![NovaLibrary Logo](https://via.placeholder.com/150x50?text=NovaLibrary)

## Lekka i Wydajna Biblioteka GUI dla Roblox

NovaLibrary to nowoczesna, w pełni natywna (100% UNC - User-Native Code) biblioteka GUI dla Roblox, zaprojektowana z myślą o tworzeniu intuicyjnych i estetycznych interfejsów użytkownika. Jej interfejs wizualny jest inspirowany minimalistycznym i funkcjonalnym stylem popularnego executora Potassium, oferując ciemny motyw z wyraźnymi akcentami.

## Cechy

*   **Styl Potassium**: Ciemny motyw, minimalistyczny, funkcjonalny design z ostrymi krawędziami.
*   **100% UNC**: Całość biblioteki napisana w czystym Lua, bez zewnętrznych zależności.
*   **Modułowość**: Łatwo rozszerzalna architektura oparta na niezależnych komponentach.
*   **Wydajność**: Zoptymalizowana pod kątem minimalnego zużycia zasobów i płynnego działania.
*   **Responsywność**: Komponenty skalowalne i adaptujące się do różnych rozdzielczości ekranu.

## Instalacja

### Metoda 1: Ręczna instalacja

1.  Pobierz najnowszą wersję NovaLibrary z [sekcji wydań](https://github.com/TwojaNazwaUzytkownika/NovaLibrary/releases) lub sklonuj repozytorium.
2.  Skopiuj folder `NovaLibrary` (zawierający `init.lua`, `Core/`, `Components/` i `Examples/`) do `ServerScriptService` w swoim projekcie Roblox Studio.
3.  Upewnij się, że nazwa folderu to `NovaLibrary`.

### Metoda 2: Z użyciem Rojo (zalecane dla deweloperów)

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

## Użycie z Rojo

Po zsynchronizowaniu NovaLibrary z Roblox Studio za pomocą Rojo, możesz używać jej w swoich skryptach tak samo, jak w przypadku instalacji ręcznej. Ścieżka do biblioteki będzie `game.ServerScriptService.NovaLibrary`.

## Użycie

Po zainstalowaniu biblioteki, możesz ją załadować i używać w swoich skryptach:

```lua
-- W skrypcie serwerowym lub lokalnym
local NovaLibrary = require(game.ServerScriptService:WaitForChild("NovaLibrary"))

-- Inicjalizacja biblioteki (opcjonalne, biblioteka inicjalizuje się automatycznie)
NovaLibrary:Init()

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

-- Zmiana motywu
NovaLibrary:LoadTheme("Light") -- Dostępne motywy: "Dark", "Light", "Green", "Red"
```

## Komponenty

NovaLibrary oferuje następujące podstawowe komponenty:

*   **`Window`**: Podstawowy kontener z możliwością przeciągania, minimalizacji i zamknięcia.
*   **`Button`**: Interaktywny przycisk z efektami najechania i wciśnięcia.
*   **`Toggle`**: Przełącznik on/off z animowanymi efektami wizualnymi.

Szczegółowe API i przykłady użycia każdego komponentu znajdziesz w [dokumentacji](#dokumentacja).

## Dokumentacja

Pełna dokumentacja API i szczegółowe instrukcje użycia znajdują się w pliku [`NovaLibrary_Documentation.md`](NovaLibrary_Documentation.md).

## Przykład

Przykładowe użycie biblioteki znajduje się w pliku [`NovaLibrary/Examples/BasicWindow.lua`](NovaLibrary/Examples/BasicWindow.lua).

## Rozwój i Współpraca

Zachęcamy do wnoszenia wkładu w rozwój NovaLibrary! Jeśli masz pomysły na nowe komponenty, ulepszenia lub znalazłeś błędy, prosimy o zgłaszanie ich poprzez [Issues](https://github.com/TwojaNazwaUzytkownika/NovaLibrary/issues) lub tworzenie [Pull Requestów](https://github.com/TwojaNazwaUzytkownika/NovaLibrary/pulls).

## Licencja

NovaLibrary jest dostępna na licencji [MIT License](LICENSE).

## Kontakt

Masz pytania? Skontaktuj się z nami poprzez GitHub Issues.
