-- LunithLib/Components/Button.lua
local TweenService = game:GetService("TweenService")
local Base = require(script.Parent:WaitForChild("Base"))

local Button = {}
Button.__index = Button
setmetatable(Button, Base)

function Button.new(library, section, data)
    local self = Base.new(library, section)
    setmetatable(self, Button)

    self:SetCallback(data.Callback)

    local Frame = Instance.new("Frame")
    Frame.Name = data.Text
    Frame.Size = UDim2.new(1, -12, 0, 24)
    Frame.BackgroundTransparency = 1
    Frame.Parent = section.Frame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -8, 1, 0)
    Btn.Position = UDim2.new(0, 4, 0, 0)
    Btn.BackgroundColor3 = library.Theme.Section
    Btn.BorderSizePixel = 0
    Btn.Font = Enum.Font.Gotham
    Btn.Text = data.Text
    Btn.TextSize = 13
    Btn.TextColor3 = library.Theme.Text
    Btn.Parent = Frame

    local Corner = Instance.new("UICorner", Btn)
    Corner.CornerRadius = UDim.new(0, 4)

    self.Frame = Frame
    self.Button = Btn

    Btn.MouseButton1Click:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.1), {
            BackgroundColor3 = library.Theme.AccentDark
        }):Play()
        self.Callback()
        task.delay(0.1, function()
            TweenService:Create(Btn, TweenInfo.new(0.1), {
                BackgroundColor3 = library.Theme.Section
            }):Play()
        end)
    end)

    return self
end

return Button
