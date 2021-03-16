Gate = class(Vertex)
Gate.booleanOperation = nil
Gate.output = nil

function Gate:init(identifier, booleanOperation)
    Vertex.init(self, identifier)
    self.booleanOperation = booleanOperation
    self.output = false
end

function Gate:simulate(edges)
    self.output = BooleanOperation[self.booleanOperation](edges)
end

function Gate:getOutput()
    return self.output
end

function Gate:getBooleanOperation()
    return self.booleanOperation
end

function Gate:toTable()
    return {
        identifier = self.identifier,
        booleanOperation = self.booleanOperation
    }
end
