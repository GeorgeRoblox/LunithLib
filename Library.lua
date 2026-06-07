-- LunithLib/Library.lua
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}
Library.__index = Library

Library.Theme = {
    Background = Color3.fromRGB(15, 15, 20),
    Accent = Color3.fromRGB(90, 140, 255),
    AccentDark = Color3.fromRGB(60, 90, 180),
    Text = Color3.fromRGB(235, 235, 245),
    SubText = Color3.fromRGB(150, 150, 160),
    Section = Color3.fromRGB(25, 25, 32),
    Outline = Color3.fromRGB(40, 40, 50)
}

Library.Flags = {}
Library.Windows = {}

local ComponentsFolder = script:WaitForChild("Components")

local BaseComponent = require(ComponentsFolder:WaitForChild("Base"))
local SectionComponent = require(ComponentsFolder:WaitForChild("Section"))
local ToggleComponent = require(ComponentsFolder:WaitForChild("Toggle"))
local SliderComponent = require(ComponentsFolder:WaitForChild("Slider"))
local DropdownComponent = require(ComponentsFolder:WaitForChild("Dropdown"))
local KeybindComponent = require(ComponentsFolder:WaitForChild("Keybind"))
local ButtonComponent = require(ComponentsFolder:WaitForChild("Button"))

local function CreateScreenGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = "LunithLib"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.Parent = game:GetService("CoreGui")
    return gui
end

local ScreenGui = CreateScreenGui()

function Library:CreateWindow(title)
    local Window = setmetatable({}, {})
    Window.Title = title or "LunithLib"
    Window.Tabs = {}
    Window.Library = self

    local Main = Instance.new("Frame")
    Main.Name = "Window"
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.BackgroundColor3 = self.Theme.Background
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    local UICorner = Instance.new("UICorner", Main)
    UICorner.CornerRadius = UDim.new(0, 6)

    local Outline = Instance.new("UIStroke", Main)
    Outline.Color = self.Theme.Outline
    Outline.Thickness = 1

    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 32)
    Topbar.BackgroundColor3 = self.Theme.Section
    Topbar.BorderSizePixel = 0
    Topbar.Parent = Main

    local TopCorner = Instance.new("UICorner", Topbar)
    TopCorner.CornerRadius = UDim.new(0, 6)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = Window.Title
    TitleLabel.TextSize = 14
    TitleLabel.TextColor3 = self.Theme.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Topbar

    local TabHolder = Instance.new("Frame")
    TabHolder.Name = "TabHolder"
    TabHolder.Size = UDim2.new(0, 140, 1, -32)
    TabHolder.Position = UDim2.new(0, 0, 0, 32)
    TabHolder.BackgroundColor3 = self.Theme.Background
    TabHolder.BorderSizePixel = 0
    TabHolder.Parent = Main

    local TabList = Instance.new("UIListLayout", TabHolder)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 4)

    local ContentHolder = Instance.new("Frame")
    ContentHolder.Name = "ContentHolder"
    ContentHolder.Size = UDim2.new(1, -140, 1, -32)
    ContentHolder.Position = UDim2.new(0, 140, 0, 32)
    ContentHolder.BackgroundColor3 = self.Theme.Background
    ContentHolder.BorderSizePixel = 0
    ContentHolder.Parent = Main

    Window.Instance = Main
    Window.Topbar = Topbar
    Window.TabHolder = TabHolder
    Window.ContentHolder = ContentHolder

    -- Dragging
    do
        local dragging, dragStart, startPos
        Topbar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = Main.Position
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                Main.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    function Window:AddTab(name)
        local Tab = {}
        Tab.Name = name
        Tab.Sections = {}
        Tab.Window = Window

        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "_Tab"
        TabButton.Size = UDim2.new(1, 0, 0, 26)
        TabButton.BackgroundColor3 = Library.Theme.Section
        TabButton.BorderSizePixel = 0
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = name
        TabButton.TextSize = 13
        TabButton.TextColor3 = Library.Theme.SubText
        TabButton.Parent = TabHolder

        local TabCorner = Instance.new("UICorner", TabButton)
        TabCorner.CornerRadius = UDim.new(0, 4)

        local Container = Instance.new("Frame")
        Container.Name = name .. "_Container"
        Container.Size = UDim2.new(1, 0, 1, 0)
        Container.BackgroundTransparency = 1
        Container.Visible = false
        Container.Parent = ContentHolder

        local SectionList = Instance.new("UIListLayout", Container)
        SectionList.SortOrder = Enum.SortOrder.LayoutOrder
        SectionList.Padding = UDim.new(0, 8)

        Tab.Button = TabButton
        Tab.Container = Container

        function Tab:SetActive(state)
            Container.Visible = state
            TweenService:Create(TabButton, TweenInfo.new(0.15), {
                BackgroundColor3 = state and Library.Theme.AccentDark or Library.Theme.Section,
                TextColor3 = state and Library.Theme.Text or Library.Theme.SubText
            }):Play()
        end

        TabButton.MouseButton1Click:Connect(function()
            for _, t in ipairs(Window.Tabs) do
                t:SetActive(false)
            end
            Tab:SetActive(true)
        end)

        function Tab:AddSection(title)
            local Section = SectionComponent.new(Library, Tab, title)
            table.insert(Tab.Sections, Section)
            return Section
        end

        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then
            Tab:SetActive(true)
        end

        return Tab
    end

    table.insert(self.Windows, Window)
    return Window
end

-- Expose component constructors to sections
function Library._CreateToggle(section, data)
    return ToggleComponent.new(Library, section, data)
end

function Library._CreateSlider(section, data)
    return SliderComponent.new(Library, section, data)
end

function Library._CreateDropdown(section, data)
    return DropdownComponent.new(Library, section, data)
end

function Library._CreateKeybind(section, data)
    return KeybindComponent.new(Library, section, data)
end

function Library._CreateButton(section, data)
    return ButtonComponent.new(Library, section, data)
end

return Library
