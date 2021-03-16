Vertex = class()
Vertex.identifier = nil
Vertex.visitedMark = nil

function Vertex:init(identifier)
    self.identifier = identifier
    self.visitedMark = VisitedMarkEnum.Unvisited
end

function Vertex:getIdentifier()
    return self.identifier
end

function Vertex:setVisitedMark(visitedMark)
    self.visitedMark = visitedMark
end

function Vertex:getVisitedMark()
    return self.visitedMark
end

function Vertex:toTable()
    return {
        identifier = self.identifier
    }
end
