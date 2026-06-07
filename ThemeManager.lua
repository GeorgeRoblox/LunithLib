-- LunithLib/ThemeManager.lua
local ThemeManager = {}
ThemeManager.__index = ThemeManager

function ThemeManager.new(library)
    local self = setmetatable({}, ThemeManager)
    self.Library = library
    self.Themes = {
        Default = {
            Background = Color3.fromRGB(15, 15, 20),
            Accent = Color3.fromRGB(90, 140, 255),
            AccentDark = Color3.fromRGB(60, 90, 180),
            Text = Color3.fromRGB(235, 235, 245),
            SubText = Color3.fromRGB(150, 150, 160),
            Section = Color3.fromRGB(25, 25, 32),
            Outline = Color3.fromRGB(40, 40, 50)
        },
        Red = {
            Background = Color3.fromRGB(18, 10, 10),
            Accent = Color3.fromRGB(220, 80, 80),
            AccentDark = Color3.fromRGB(160, 40, 40),
            Text = Color3.fromRGB(240, 230, 230),
            SubText = Color3.fromRGB(160, 130, 130),
            Section = Color3.fromRGB(30, 18, 18),
            Outline = Color3.fromRGB(60, 30, 30)
        }
    }
    return self
end

function ThemeManager:ApplyTheme(name)
    local theme = self.Themes[name]
    if not theme then return end
    for k, v in pairs(theme) do
        self.Library.Theme[k] = v
    end
end

return ThemeManager
