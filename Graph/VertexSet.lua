VertexSet = class(Set)

local function keyProvider(vertex)
    return ("[%s]"):format(vertex:getIdentifier())
end

function VertexSet:init()
    Set.init(self, keyProvider)
end

function VertexSet:map(func)
    local result = VertexSet(keyProvider)

    for _, value in self:getIterator() do
        if func(value) then
            result:add(value)
        end
    end

    return result
end

function VertexSet:getVertexById(vertexId)
    local uniqueKey = ("[%s]"):format(vertexId)

    return self.array[uniqueKey]
end

function VertexSet:clone()
    local copy = VertexSet(keyProvider)

    for _, value in self:getIterator() do
        copy:add(value)
    end

    return copy
end
