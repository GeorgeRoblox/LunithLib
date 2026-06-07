-- LunithLib/Components/Section.lua
local Section = {}
Section.__index = Section

function Section.new(library, tab, title)
    local self = setmetatable({}, Section)
    self.Library = library
    self.Tab = tab
    self.Title = title or "Section"
    self.Elements = {}

    local Frame = Instance.new("Frame")
    Frame.Name = self.Title
    Frame.Size = UDim2.new(1, -10, 0, 40)
    Frame.BackgroundColor3 = library.Theme.Section
    Frame.BorderSizePixel = 0
    Frame.Parent = tab.Container

    local Corner = Instance.new("UICorner", Frame)
    Corner.CornerRadius = UDim.new(0, 4)

    local UIList = Instance.new("UIListLayout", Frame)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 4)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -10, 0, 18)
    TitleLabel.Position = UDim2.new(0, 6, 0, 4)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = self.Title
    TitleLabel.TextSize = 13
    TitleLabel.TextColor3 = library.Theme.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Frame

    self.Frame = Frame
    self.TitleLabel = TitleLabel

    function self:Resize()
        local total = 8
        for _, child in ipairs(Frame:GetChildren()) do
            if child:IsA("Frame") and child ~= Frame then
                total = total + child.AbsoluteSize.Y + 4
            end
        end
        Frame.Size = UDim2.new(1, -10, 0, math.max(total, 40))
    end

    function self:AddToggle(text, default, callback, flag)
        local data = {
            Text = text,
            Default = default,
            Callback = callback,
            Flag = flag
        }
        local Toggle = self.Library._CreateToggle(self, data)
        table.insert(self.Elements, Toggle)
        self:Resize()
        return Toggle
    end

    function self:AddSlider(text, min, max, default, callback, flag)
        local data = {
            Text = text,
            Min = min,
            Max = max,
            Default = default,
            Callback = callback,
            Flag = flag
        }
        local Slider = self.Library._CreateSlider(self, data)
        table.insert(self.Elements, Slider)
        self:Resize()
        return Slider
    end

    function self:AddDropdown(text, options, default, callback, flag)
        local data = {
            Text = text,
            Options = options,
            Default = default,
            Callback = callback,
            Flag = flag
        }
        local Dropdown = self.Library._CreateDropdown(self, data)
        table.insert(self.Elements, Dropdown)
        self:Resize()
        return Dropdown
    end

    function self:AddKeybind(text, defaultKey, callback, flag)
        local data = {
            Text = text,
            Default = defaultKey,
            Callback = callback,
            Flag = flag
        }
        local Keybind = self.Library._CreateKeybind(self, data)
        table.insert(self.Elements, Keybind)
        self:Resize()
        return Keybind
    end

    function self:AddButton(text, callback)
        local data = {
            Text = text,
            Callback = callback
        }
        local Button = self.Library._CreateButton(self, data)
        table.insert(self.Elements, Button)
        self:Resize()
        return Button
    end

    return self
end

return Section
