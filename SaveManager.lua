-- LunithLib/SaveManager.lua
local HttpService = game:GetService("HttpService")

local SaveManager = {}
SaveManager.__index = SaveManager

function SaveManager.new(library)
    local self = setmetatable({}, SaveManager)
    self.Library = library
    self.Saves = {}
    return self
end

function SaveManager:Export()
    local data = {}
    for flag, value in pairs(self.Library.Flags) do
        data[flag] = value
    end
    return HttpService:JSONEncode(data)
end

function SaveManager:Import(json)
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(json)
    end)
    if not ok or type(decoded) ~= "table" then return end

    for flag, value in pairs(decoded) do
        self.Library.Flags[flag] = value
    end
end

return SaveManager
