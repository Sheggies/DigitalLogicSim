Edge = class()
Edge.source = nil
Edge.destination = nil

function Edge:init(source, destination)
    self.source = source
    self.destination = destination
end

function Edge:getSource()
    return self.source
end

function Edge:getDestination()
    return self.destination
end

function Edge:toTable()
    return {
        source = self.source:getIdentifier(),
        destination = self.destination:getIdentifier()
    }
end
