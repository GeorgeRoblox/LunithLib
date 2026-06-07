-- LunithLib/Components/Keybind.lua
local UserInputService = game:GetService("UserInputService")
local Base = require(script.Parent:WaitForChild("Base"))

local Keybind = {}
Keybind.__index = Keybind
setmetatable(Keybind, Base)

function Keybind.new(library, section, data)
    local self = Base.new(library, section)
    setmetatable(self, Keybind)

    self.Key = data.Default or Enum.KeyCode.F
    self.Binding = false
    self:SetCallback(data.Callback)
    self:SetFlag(data.Flag)

    if self.Flag then
        library.Flags[self.Flag] = self.Key
    end

    local Frame = Instance.new("Frame")
    Frame.Name = data.Text
    Frame.Size = UDim2.new(1, -12, 0, 24)
    Frame.BackgroundTransparency = 1
    Frame.Parent = section.Frame

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0.5, -4, 1, 0)
    Label.Position = UDim2.new(0, 4, 0, 0)
    Label.Font = Enum.Font.Gotham
    Label.Text = data.Text
    Label.TextSize = 13
    Label.TextColor3 = library.Theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.5, -8, 1, 0)
    Button.Position = UDim2.new(0.5, 4, 0, 0)
    Button.BackgroundColor3 = library.Theme.Section
    Button.BorderSizePixel = 0
    Button.Font = Enum.Font.Gotham
    Button.Text = "[" .. self.Key.Name .. "]"
    Button.TextSize = 13
    Button.TextColor3 = library.Theme.SubText
    Button.TextXAlignment = Enum.TextXAlignment.Center
    Button.Parent = Frame

    local Corner = Instance.new("UICorner", Button)
    Corner.CornerRadius = UDim.new(0, 4)

    self.Frame = Frame
    self.Button = Button

    function self:Set(keycode)
        self.Key = keycode
        if self.Flag then
            library.Flags[self.Flag] = keycode
        end
        Button.Text = "[" .. keycode.Name .. "]"
    end

    Button.MouseButton1Click:Connect(function()
        self.Binding = true
        Button.Text = "[...]"
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if self.Binding then
            if input.KeyCode ~= Enum.KeyCode.Unknown then
                self:Set(input.KeyCode)
                self.Binding = false
            end
        else
            if input.KeyCode == self.Key then
                self.Callback()
            end
        end
    end)

    return self
end

return Keybind
