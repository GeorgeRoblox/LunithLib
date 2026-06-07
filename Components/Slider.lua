-- LunithLib/Components/Slider.lua
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Base = require(script.Parent:WaitForChild("Base"))

local Slider = {}
Slider.__index = Slider
setmetatable(Slider, Base)

function Slider.new(library, section, data)
    local self = Base.new(library, section)
    setmetatable(self, Slider)

    self.Min = data.Min or 0
    self.Max = data.Max or 100
    self.Value = data.Default or self.Min
    self:SetCallback(data.Callback)
    self:SetFlag(data.Flag)

    if self.Flag then
        library.Flags[self.Flag] = self.Value
    end

    local Frame = Instance.new("Frame")
    Frame.Name = data.Text
    Frame.Size = UDim2.new(1, -12, 0, 32)
    Frame.BackgroundTransparency = 1
    Frame.Parent = section.Frame

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0.5, -4, 0, 16)
    Label.Position = UDim2.new(0, 4, 0, 0)
    Label.Font = Enum.Font.Gotham
    Label.Text = data.Text
    Label.TextSize = 13
    Label.TextColor3 = library.Theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Size = UDim2.new(0.5, -4, 0, 16)
    ValueLabel.Position = UDim2.new(0.5, 0, 0, 0)
    ValueLabel.Font = Enum.Font.Gotham
    ValueLabel.Text = tostring(self.Value)
    ValueLabel.TextSize = 13
    ValueLabel.TextColor3 = library.Theme.SubText
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Frame

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, -8, 0, 6)
    Bar.Position = UDim2.new(0, 4, 0, 20)
    Bar.BackgroundColor3 = library.Theme.Section
    Bar.BorderSizePixel = 0
    Bar.Parent = Frame

    local BarCorner = Instance.new("UICorner", Bar)
    BarCorner.CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = library.Theme.Accent
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar

    local FillCorner = Instance.new("UICorner", Fill)
    FillCorner.CornerRadius = UDim.new(1, 0)

    self.Frame = Frame
    self.Bar = Bar
    self.Fill = Fill
    self.ValueLabel = ValueLabel

    local dragging = false

    local function SetFromX(x)
        local rel = math.clamp((x - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(self.Min + (self.Max - self.Min) * rel + 0.5)
        self:Set(val)
    end

    function self:Set(v)
        v = math.clamp(v, self.Min, self.Max)
        self.Value = v
        if self.Flag then
            library.Flags[self.Flag] = v
        end
        local alpha = (v - self.Min) / (self.Max - self.Min)
        TweenService:Create(Fill, TweenInfo.new(0.1), {
            Size = UDim2.new(alpha, 0, 1, 0)
        }):Play()
        ValueLabel.Text = tostring(v)
        self.Callback(v)
    end

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            SetFromX(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            SetFromX(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    self:Set(self.Value)

    return self
end

return Slider
