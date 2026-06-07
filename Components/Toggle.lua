-- LunithLib/Components/Toggle.lua
local TweenService = game:GetService("TweenService")
local Base = require(script.Parent:WaitForChild("Base"))

local Toggle = {}
Toggle.__index = Toggle
setmetatable(Toggle, Base)

function Toggle.new(library, section, data)
    local self = Base.new(library, section)
    setmetatable(self, Toggle)

    self.Value = data.Default or false
    self:SetCallback(data.Callback)
    self:SetFlag(data.Flag)

    if self.Flag then
        library.Flags[self.Flag] = self.Value
    end

    local Frame = Instance.new("Frame")
    Frame.Name = data.Text
    Frame.Size = UDim2.new(1, -12, 0, 22)
    Frame.BackgroundTransparency = 1
    Frame.Parent = section.Frame

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.Position = UDim2.new(0, 4, 0, 0)
    Label.Font = Enum.Font.Gotham
    Label.Text = data.Text
    Label.TextSize = 13
    Label.TextColor3 = library.Theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Button = Instance.new("TextButton")
    Button.BackgroundColor3 = library.Theme.Section
    Button.Size = UDim2.new(0, 32, 0, 16)
    Button.Position = UDim2.new(1, -36, 0.5, -8)
    Button.Text = ""
    Button.BorderSizePixel = 0
    Button.Parent = Frame

    local Corner = Instance.new("UICorner", Button)
    Corner.CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new(self.Value and 1 or 0, self.Value and -15 or 1, 0.5, -7)
    Knob.BackgroundColor3 = self.Value and library.Theme.Accent or library.Theme.SubText
    Knob.BorderSizePixel = 0
    Knob.Parent = Button

    local KnobCorner = Instance.new("UICorner", Knob)
    KnobCorner.CornerRadius = UDim.new(1, 0)

    self.Frame = Frame
    self.Button = Button
    self.Knob = Knob

    local function SetVisual(state)
        TweenService:Create(Knob, TweenInfo.new(0.15), {
            Position = UDim2.new(state and 1 or 0, state and -15 or 1, 0.5, -7),
            BackgroundColor3 = state and library.Theme.Accent or library.Theme.SubText
        }):Play()
    end

    function self:Set(value)
        self.Value = value
        if self.Flag then
            library.Flags[self.Flag] = value
        end
        SetVisual(value)
        self.Callback(value)
    end

    Button.MouseButton1Click:Connect(function()
        self:Set(not self.Value)
    end)

    SetVisual(self.Value)

    return self
end

return Toggle
