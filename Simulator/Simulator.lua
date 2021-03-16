Simulator = class()
Simulator.sortedGates = nil
Simulator.combinationalGates = nil
Simulator.sequentialGates = nil
Simulator.edges = nil
Simulator.edgeCache = nil
Simulator.inputs = nil
Simulator.outputs = nil
Simulator.simulatedOutput = nil

local function getInputs(sortedGates, incomingEdges)
    local inputs = Dictionary()

    for _, gate in sortedGates:getIterator() do
        if incomingEdges:get(gate):isEmpty() and gate.booleanOperation ~= BooleanOperationEnum.Feedback then
            inputs:add(gate:getIdentifier(), gate)
        end
    end

    for _, gate in inputs:getIterator() do
        sortedGates:remove(gate)
    end

    return inputs
end

local function getOutputs(sortedGates, outgoingEdges)
    local outputs = Dictionary()

    for _, gate in sortedGates:getIterator() do
        if outgoingEdges:get(gate):isEmpty() then
            outputs:add(gate:getIdentifier(), gate)
        end
    end

    for _, gate in outputs:getIterator() do
        sortedGates:remove(gate)
    end

    return outputs
end

local function getIncomingEdges(sortedGates, edges)
    local incomingEdges = Dictionary()

    for i, gate in sortedGates:getIterator() do
        incomingEdges:add(gate, edges:getIncomingEdges(gate))
    end

    return incomingEdges
end

local function getOutgoingEdges(sortedGates, edges)
    local outgoingEdges = Dictionary()

    for i, gate in sortedGates:getIterator() do
        outgoingEdges:add(gate, edges:getOutgoingEdges(gate))
    end

    return outgoingEdges
end

function Simulator:init(sortedGates, combinationalGates, sequentialGates, edges)
    self.sortedGates = sortedGates
    self.combinationalGates = combinationalGates
    self.sequentialGates = sequentialGates
    self.edges = edges
    self.edgeCache = {
        incoming = getIncomingEdges(sortedGates, edges),
        outgoing = getOutgoingEdges(sortedGates, edges)
    }
    self.inputs = getInputs(combinationalGates, self.edgeCache.incoming)
    self.outputs = getOutputs(combinationalGates, self.edgeCache.outgoing)
    self.simulatedOutput = Dictionary()

    for i, v in self.outputs:getKeys():getIterator() do
        self.simulatedOutput:add(v, false)
    end
end

function Simulator:simulate(inputValues)
    if inputValues:getLength() ~= self.inputs:getLength() then
        error("Mismatching number of inputs")
    end

    -- Simulate input gates with the passed input values
    for gateId, value in inputValues:getIterator() do
        self.inputs:get(gateId):simulate(value)
    end

    -- Simulate combinational gates
    for _, gate in self.combinationalGates:getIterator() do
        local edges = self.edgeCache.incoming:get(gate)
        gate:simulate(edges)
    end

    -- Simulate sequential gates
    for _, gate in self.sequentialGates:getIterator() do
        local edges = self.edgeCache.incoming:get(gate)
        gate:simulate(edges)
    end

    -- Simulate output gates and update the returned output
    for gateId, gate in self.outputs:getIterator() do
        local edges = self.edgeCache.incoming:get(gate)
        gate:simulate(edges)
        self.simulatedOutput:update(gateId, gate:getOutput())
    end

    return self.simulatedOutput
end

function Simulator:getInputs()
    return self.inputs
end

function Simulator:getOutputs()
    return self.outputs
end
