Stack = class()
Stack.array = nil
Stack.length = nil

function Stack:init()
    self.array = {}
    self.length = 0
end

function Stack:push(object)
    table.insert(self.array, object)
    self.length = self.length + 1
end

function Stack:pop()
    self.length = self.length - 1
    return table.remove(self.array)
end

function Stack:getLength()
    return self.length
end

function Stack:peek()
    return self.array[self:getLength()]
end

function Stack:isEmpty()
    return self:getLength() == 0
end

function Stack:contains(object)
    local contains = false

    for i, v in ipairs(self.array) do
        contains = object == v

        if contains then
            break
        end
    end

    return contains
end

function Stack:clear()
    if not self:isEmpty() then
        self.array = {}
        self.length = 0
    end
end
