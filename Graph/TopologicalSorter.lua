TopSorter = class()
local startVertices, depthTrace, sequentialGatesLookup, feedbackGatesLookup
local solution, combinationalSolution, sequentialSolution, modifiedEdges

-- Used to determine all vertices involved in a cyclic path
local function backtrackCyclicPath(startVertex)
    local currentVertex

    for position = depthTrace:getLength(), 1, -1 do
        currentVertex = depthTrace:getAt(position)

        if sequentialGatesLookup:add(currentVertex) then
            sequentialSolution:add(currentVertex)
        end

        if currentVertex == startVertex then
            break
        end
    end
end

local function scanRecursive(vertex, edges)
    if vertex:getVisitedMark() ~= VisitedMarkEnum.Unvisited then
        return
    end

    vertex:setVisitedMark(VisitedMarkEnum.InProcess)
    depthTrace:add(vertex)

    -- Iterate over all successors of the current vertex
    for _, edge in edges:getOutgoingEdges(vertex):getIterator() do
        local destinationVertex = edge:getDestination()

        -- If destination vertex is currently being processed, create feedback vertex
        -- and connect it to the destination vertex, otherwise continue recursive scanning
        if destinationVertex:getVisitedMark() == VisitedMarkEnum.InProcess then
            backtrackCyclicPath(destinationVertex)
            local fbgIdentifier = ("fb:%s"):format(vertex:getIdentifier())
            local fbGate = feedbackGatesLookup:getVertexById(fbgIdentifier)

            if fbGate == nil then
                fbGate = FeedbackGate(fbgIdentifier, vertex)
                feedbackGatesLookup:add(fbGate)
                startVertices:add(fbGate)
            end

            local newEdge = Edge(fbGate, edge:getDestination())
            edges:remove(edge)
            edges:add(newEdge)
        else
            scanRecursive(destinationVertex, edges)
            modifiedEdges:add(edge)
        end
    end

    if not sequentialGatesLookup:contains(vertex) then
        combinationalSolution:add(vertex)
    end

    solution:add(vertex)
    vertex:setVisitedMark(VisitedMarkEnum.Visited)
    depthTrace:removeAt(depthTrace:getLength())
end

function TopSorter.sort(vertices, edges)
    startVertices = List()
    depthTrace = List()
    sequentialGatesLookup = VertexSet()
    feedbackGatesLookup = VertexSet()
    solution = List()
    combinationalSolution = List()
    sequentialSolution = List()
    modifiedEdges = EdgeSet()

    -- Find starting vertices
    for _, vertex in vertices:getIterator() do
        if edges:getIncomingEdges(vertex):isEmpty() then
            startVertices:add(vertex)
        end
    end

    -- Sort vertices recursively
    if not startVertices:isEmpty() then
        while not startVertices:isEmpty() do
            local vertex = startVertices:getLast()
            startVertices:remove(vertex)
            scanRecursive(vertex, edges)
        end

        -- Sorted solutions have been constructed in reversed order
        -- Reverse to get the correctly ordered solutions
        solution:reverse()
        combinationalSolution:reverse()
        sequentialSolution:reverse()
    else
        error("No start vertices found.")
    end

    return {
        merged = solution,
        combinational = combinationalSolution,
        sequential = sequentialSolution,
        edges = modifiedEdges
    }
end
