-- LunithLib/Components/Dropdown.lua
local TweenService = game:GetService("TweenService")
local Base = require(script.Parent:WaitForChild("Base"))

local Dropdown = {}
Dropdown.__index = Dropdown
setmetatable(Dropdown, Base)

function Dropdown.new(library, section, data)
    local self = Base.new(library, section)
    setmetatable(self, Dropdown)

    self.Options = data.Options or {}
    self.Value = data.Default or self.Options[1]
    self.Open = false
    self:SetCallback(data.Callback)
    self:SetFlag(data.Flag)

    if self.Flag then
        library.Flags[self.Flag] = self.Value
    end

    local Frame = Instance.new("Frame")
    Frame.Name = data.Text
    Frame.Size = UDim2.new(1, -12, 0, 28)
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
    Button.Text = tostring(self.Value)
    Button.TextSize = 13
    Button.TextColor3 = library.Theme.SubText
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = Frame

    local Corner = Instance.new("UICorner", Button)
    Corner.CornerRadius = UDim.new(0, 4)

    local Arrow = Instance.new("TextLabel")
    Arrow.BackgroundTransparency = 1
    Arrow.Size = UDim2.new(0, 16, 1, 0)
    Arrow.Position = UDim2.new(1, -18, 0, 0)
    Arrow.Font = Enum.Font.GothamBold
    Arrow.Text = "▼"
    Arrow.TextSize = 12
    Arrow.TextColor3 = library.Theme.SubText
    Arrow.TextXAlignment = Enum.TextXAlignment.Center
    Arrow.Parent = Button

    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "DropdownList"
    ListFrame.Size = UDim2.new(0.5, -8, 0, 0)
    ListFrame.Position = UDim2.new(0.5, 4, 0, 28)
    ListFrame.BackgroundColor3 = library.Theme.Section
    ListFrame.BorderSizePixel = 0
    ListFrame.Visible = false
    ListFrame.ClipsDescendants = true
    ListFrame.Parent = Frame

    local ListCorner = Instance.new("UICorner", ListFrame)
    ListCorner.CornerRadius = UDim.new(0, 4)

    local UIList = Instance.new("UIListLayout", ListFrame)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 2)

    self.Frame = Frame
    self.Button = Button
    self.ListFrame = ListFrame
    self.Arrow = Arrow

    local function RefreshOptions()
        for _, child in ipairs(ListFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        for _, opt in ipairs(self.Options) do
            local OptButton = Instance.new("TextButton")
            OptButton.Size = UDim2.new(1, -4, 0, 20)
            OptButton.Position = UDim2.new(0, 2, 0, 0)
            OptButton.BackgroundColor3 = library.Theme.Background
            OptButton.BorderSizePixel = 0
            OptButton.Font = Enum.Font.Gotham
            OptButton.Text = tostring(opt)
            OptButton.TextSize = 13
            OptButton.TextColor3 = library.Theme.SubText
            OptButton.TextXAlignment = Enum.TextXAlignment.Left
            OptButton.Parent = ListFrame

            local OptCorner = Instance.new("UICorner", OptButton)
            OptCorner.CornerRadius = UDim.new(0, 3)

            OptButton.MouseButton1Click:Connect(function()
                self:Set(opt)
                self:Toggle(false)
            end)
        end

        local total = 0
        for _, child in ipairs(ListFrame:GetChildren()) do
            if child:IsA("TextButton") then
                total = total + child.AbsoluteSize.Y + 2
            end
        end
        ListFrame.Size = UDim2.new(0.5, -8, 0, total + 4)
    end

    function self:Set(value)
        self.Value = value
        if self.Flag then
            library.Flags[self.Flag] = value
        end
        Button.Text = tostring(value)
        self.Callback(value)
    end

    function self:Toggle(state)
        self.Open = state
        ListFrame.Visible = state
        Arrow.Text = state and "▲" or "▼"
    end

    Button.MouseButton1Click:Connect(function()
        self:Toggle(not self.Open)
    end)

    RefreshOptions()
    self:Set(self.Value)

    return self
end

return Dropdown
