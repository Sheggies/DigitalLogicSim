Set = class()
Set.keyProvider = nil
Set.array = nil
Set.length = nil

local function defaultKeyProvider(value)
    local uniqueKey

    if type(value) == "table" then
        uniqueKey = tostring(value)
    else
        uniqueKey = value
    end

    return uniqueKey
end

function Set:init(keyProvider)
    self.keyProvider = keyProvider or defaultKeyProvider
    self.array = {}
    self.length = 0
end

function Set:add(value)
    local uniqueKey = self.keyProvider(value)
    local isPresent = self.array[uniqueKey] ~= nil

    if not isPresent then
        self.array[uniqueKey] = value
        self.length = self.length + 1
    end

    return not isPresent
end

function Set:remove(value)
    local uniqueKey = self.keyProvider(value)
    local isPresent = self.array[uniqueKey] ~= nil

    if isPresent then
        self.array[uniqueKey] = nil
        self.length = self.length - 1
    end

    return isPresent
end

function Set:map(func)
    local result = Set()

    for _, value in self:getIterator() do
        if func(value) then
            result:add(value)
        end
    end

    return result
end

function Set:contains(value)
    local uniqueKey = self.keyProvider(value)

    return self.array[uniqueKey] ~= nil
end

function Set:getLength()
    return self.length
end

function Set:isEmpty()
    return self.length == 0
end

function Set:getIterator()
    return pairs(self.array)
end

function Set:clone()
    local copy = Set()

    for _, value in self:getIterator() do
        copy:add(value)
    end

    return copy
end

function Set:toTable()
    local t = {}

    for _, value in self:getIterator() do
        table.insert(t, value)
    end

    return t
end
