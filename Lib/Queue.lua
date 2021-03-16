Queue = class()
Queue.array = nil
Queue.length = nil

function Queue:init()
    self.array = {}
    self.length = 0
end

function Queue:enqueue(object)
    table.insert(self.array, object)
    self.length = self.length + 1
end

function Queue:dequeue()
    self.length = self.length - 1
    return table.remove(self.array, 1)
end

function Queue:peek()
    return self.array[1]
end

function Queue:getLength()
    return self.length
end

function Queue:isEmpty()
    return self:getLength() == 0
end

function Queue:clear()
    if not self:isEmpty() then
        self.array = {}
        self.length = 0
    end
end
