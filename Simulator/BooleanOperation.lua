local bOp = BooleanOperationEnum

BooleanOperation = {
    [bOp.And] = function (edges)
        local output = true
        local v

        for _, edge in edges:getIterator() do
            v = edge:getSource():getOutput()

            if not v then
                output = false
                break
            end
        end

        return output
    end,

    [bOp.Or] = function (edges)
        local output = false
        local v

        for _, edge in edges:getIterator() do
            v = edge:getSource():getOutput()

            if v then
                output = true
                break
            end
        end

        return output
    end,

    [bOp.Xor] = function (edges)
        local trueInputs = 0
        local v

        for _, edge in edges:getIterator() do
            v = edge:getSource():getOutput()

            if v then
                trueInputs = trueInputs + 1
            end
        end

        return trueInputs % 2 == 1
    end,

    [bOp.Nand] = function (edges)
        return not BooleanOperation[bOp.And](edges)
    end,

    [bOp.Nor] = function (edges)
        return not BooleanOperation[bOp.Or](edges)
    end,

    [bOp.Xnor] = function (edges)
        return not BooleanOperation[bOp.Xor](edges)
    end,

    [bOp.Identity] = function (input)
        local output

        if type(input) == "table" then
            for _, edge in input:getIterator() do
                output = edge:getSource():getOutput()
            end
        elseif type(input) == "boolean" then
            output = input
        end

        return output
    end,

    [bOp.Negation] = function (input)
        local output

        if type(input) == "table" then
            for _, edge in input:getIterator() do
                output = edge:getSource():getOutput()
            end
        elseif type(input) == "boolean" then
            output = input
        end

        return not output
    end,

    [bOp.Feedback] = function (feedbackSource)
        return feedbackSource:getOutput()
    end
}
