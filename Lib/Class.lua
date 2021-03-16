--[[--
    Creates a prototype that can be used like a class
    @usage local myType = class()
    @usage function myType:init() end
    @usage myType(arg1, arg2, arg3)
]]
function class(superType)
    local newType = {}

    if superType then
        for memberName, member in pairs(superType) do
            newType[memberName] = member
        end
    end

    local function createInstance(self, ...)
        local instance = setmetatable({}, self)

        if self.init then
            instance:init(...)
        end

        return instance
    end

    setmetatable(newType, {__call = createInstance})
    newType.__index = newType

    return newType
end
