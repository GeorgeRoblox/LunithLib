-- LunithLib/Components/Base.lua
local Base = {}
Base.__index = Base

function Base.new(library, section)
    local self = setmetatable({}, Base)
    self.Library = library
    self.Section = section
    self.Flag = nil
    self.Callback = function() end
    return self
end

function Base:SetFlag(flag)
    self.Flag = flag
    if flag then
        self.Library.Flags[flag] = self.Library.Flags[flag] or nil
    end
end

function Base:SetCallback(cb)
    if type(cb) == "function" then
        self.Callback = cb
    end
end

return Base
