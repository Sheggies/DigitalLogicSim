EdgeSet = class(Set)

local function keyProvider(edge)
    return ("%s->%s"):format(edge:getSource():getIdentifier(), edge:getDestination():getIdentifier())
end

function EdgeSet:init()
    Set.init(self, keyProvider)
end

function EdgeSet:map(func)
    local result = EdgeSet(keyProvider)

    for _, value in self:getIterator() do
        if func(value) then
            result:add(value)
        end
    end

    return result
end

function EdgeSet:getOutgoingEdges(vertex)
    local function mapByOutgoing(edge)
        return edge:getSource() == vertex
    end

    return self:map(mapByOutgoing)
end

function EdgeSet:getIncomingEdges(vertex)
    local function mapByIncoming(edge)
        return edge:getDestination() == vertex
    end

    return self:map(mapByIncoming)
end

function EdgeSet:clone()
    local copy = EdgeSet(keyProvider)

    for _, value in self:getIterator() do
        copy:add(value)
    end

    return copy
end
