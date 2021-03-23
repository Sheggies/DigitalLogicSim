--[[--
    Provides functionalities to manage lists of objects.
    @type List
]]
List = class()
List.array = nil
List.length = nil

--[[--
    Constructor
    @param size The initial size of the list
]]
function List:init(size)
    self.array = {}
    self.length = 0

    if size ~= nil and type(size) == "number" then
        for i = 1, size, 1 do
            self:add(0)
        end
    end
end

--[[--
    Checks whether the list contains the specified object.
    @param object The object to check for
    @return True if the list contains the specified object otherwise false
]]
function List:contains(object)
    return self:indexOf(object) > 0
end

--[[--
    Adds the passed object to the list.
    @param object The object to add
]]
function List:add(object)
    self:insert(nil, object)
end

--[[--
    Inserts the passed object at the specified position in the list.
    @param i The position in the list to insert the object
    @param object The object to insert
]]
function List:insert(i, object)
    if not i then
        table.insert(self.array, object)
        self.length = self.length + 1
    elseif i > 0 and i <= self:getLength() then
        table.insert(self.array, i, object)
        self.length = self.length + 1
    end
end

--[[--
    Updates the value at the given index.
    @param i The position in the list to update
    @param object The new value for the given index
]]
function List:update(i, object)
    assert(i > 0 and i <= self:getLength(), "Index out of bounds.")
    assert(object ~= nil, "Value can't be nil.")

    self.array[i] = object
end

--[[--
    Adds a range of objects to the end of the list.
    The range can be either a List object or a simple Lua table
    @param range The range to add
]]
function List:addRange(range)
    if range.getIterator and type(range.getIterator) == "function" then
        for _, v in range:getIterator() do
            self:add(v)
        end
    else
        for _, v in ipairs(range) do
            self:add(v)
        end
    end
end

--[[--
    Removes the passed object from the list.
    @param object The object to remove from the list
]]
function List:remove(object)
    local i = self:indexOf(object)

    if i > 0 then
        self:removeAt(i)
    end
end

--[[--
    Removes an object at the specified position.
    @param i The position of the object to be removed
    @raise Raises an error if the index is out of bounds
]]
function List:removeAt(i)
    assert(i > 0 and i <= self:getLength(), "Index out of bounds.")

    table.remove(self.array, i)
    self.length = self.length - 1
end

--[[--
    Removes all objects satisfying the passed matching expression.
    @param match A function which constitutes the matching expression
    @return The number of matched items that have been removed
    @raise Raises an error if no matching expression has been passed
]]
function List:removeAll(match)
    assert(match ~= nil, "Match can't be nil.")
    assert(type(match) == "function", "Argument of type function expected.")

    local removedItems = 0

    for i, v in self:getIterator() do
        if match(i, v) then
            self:removeAt(i)
            removedItems = removedItems + 1
        end
    end

    return removedItems
end

--[[--
    Clears the list from all its members and sets the length to zero.
]]
function List:clear()
    if not self:isEmpty() then
        self.array = {}
        self.length = 0
    end
end

--[[--
    Returns the length of the list.
    @return The length of the list as number
]]
function List:getLength()
    return self.length
end

--[[--
    Returns the first element of the list.
    @return The object at first position
]]
function List:getFirst()
    return self:getAt(1)
end

--[[--
    Returns the last element of the list.
    @return The object at the last position
]]
function List:getLast()
    return self:getAt(self:getLength())
end

--[[--
    Returns the object at the specified position.
    @param i The position of the object
    @return The object at the specified position
    @raise Raises an error if the index is out of bounds
]]
function List:getAt(i)
    assert(i > 0 and i <= self:getLength(), "Index out of range.")

    return self.array[i]
end

--[[--
    Looks for the passed object and returns its index if found.
    @param object The object to look for
    @return The objects position in the list or -1 if there was no match
]]
function List:indexOf(object)
    local index = -1

    for i, v in self:getIterator() do
        if object == v then
            index = i
            break
        end
    end

    return index
end

--[[--
    Creates a range of elements as List for the passed index and count.
    @param index The start position of the range
    @param count The number of elements for the range
    @return The List object containing the range
    @raise Raises an error of either the index or the count of elements are out of range
]]
function List:getRange(index, count)
    assert(index > 0 and index <= self:getLength(), "Index out of range.")
    assert(count >= 0 and index + count <= self:getLength(), "Index out of range.")

    local list = List()

    for i = index, index + (count - 1), 1 do
        list:add(self:getAt(i))
    end

    return list
end

--[[--
    Gets the iterator function for the list.
    @usage for i, v in myDictionary:getIterator() do end
    @return The iterator function
]]
function List:getIterator()
    return ipairs(self.array)
end

--[[--
    Converts all it's members to simple Lua tables and returns an array of them.
    @return The generated array
]]
function List:toTable()
    local t = {}

    for _, v in self:getIterator() do
        if v.toTable ~= nil and type(v.toTable) == "function" then
            table.insert(t, v:toTable())
        else
            table.insert(t, v)
        end
    end

    return t
end

--[[--
    Reverses the order of the list.
]]
function List:reverse()
    local stack = Stack()

    for _, v in self:getIterator() do
        stack:push(v)
    end

    for i, _ in self:getIterator() do
        self.array[i] = stack:pop()
    end
end

--[[--
    Clones the whole list and returns a copy.
    This is a shallow copy, the elements of the list are not copied, only their references are.
    @return A copy of the List object
]]
function List:clone()
    return self:getRange(1, self:getLength())
end

--[[--
    Checks whether the list is empty.
    @return True if the list is empty otherwise false
]]
function List:isEmpty()
    return self:getLength() == 0
end

--[[--
    Creates a List of the objects satisfying the passed match expression.
    @local
    @param self The List object to look into
    @param match The matching expression function
    @param returnOnFirstOccurrence Whether to stop the search at the first occurrence
    @return A List object with the matching objects
    @raise Raises an error when no match expression has been passed
]]
local function find(self, match, returnOnFirstOccurrence)
    assert(match ~= nil, "Match can't be nil.")
    assert(type(match) == "function", "Argument of type function expected.")

    local result = List()

    for _, v in self:getIterator() do
        if match(_, v) then
            result:add(v)

            if returnOnFirstOccurrence then
                break
            end
        end
    end

    return result
end

--[[--
    Search for the first occurrence of an object satisfying the match expression.
    @param match The match expression function
    @return The first element satisfying the match expression
]]
function List:find(match)
    return find(self, match, true):getFirst()
end

--[[--
    Search for the last occurrence of an object satisfying the match expression.
    @param match The match expression function
    @return The last element satisfying the match expression
]]
function List:findLast(match)
    return self:findAll(match):getLast()
end

--[[--
    Search for all objects satisfying the match expression.
    @param match The match expression function
    @return The list of all matching objects
]]
function List:findAll(match)
    return find(self, match, false)
end

--[[--
    Search for an object satisfying the match expression and return its index
    @param startIndex The position to start the search from
    @param endIndex The last position to search up to
    @param match The match expression function
    @param returnOnFirstOccurrence Whether to stop the search at the first occurrence
    @return The index of the matched object or -1 if not found
    @raise Raises an error when no match expression has been passed
]]
local function findIndexInRange(self, startIndex, endIndex, match, returnOnFirstOccurrence)
    assert(match ~= nil, "Match can't be nil.")
    assert(type(match) == "function", "Argument of type function expected.")

    local index = -1

    for i = startIndex, endIndex, 1 do
        if match(i, self:getAt(i)) then
            index = self:indexOf(self:getAt(i))

            if returnOnFirstOccurrence then
                break
            end
        end
    end

    return index
end

--[[--
    Searches and returns the index of the first occuronce of an object satisfying the match expression.
    @param match The match expression function
    @return The index of the matched object or -1 if not found
    @raise @see findIndexInRange
]]
function List:findIndex(match)
    return self:findIndexInRange(1, self:getLength(), match)
end

--[[--
    Searches and returns the index of the last occuronce of an object satisfying the match expression.
    @param match The match expression function
    @return The index of the matched object or -1 if not found
    @raise @see findIndexInRange
]]
function List:findLastIndex(match)
    return findIndexInRange(1, self:getLength(), match, false)
end

--[[--
    Searches from the specified position and returns the index of the first occuronce of an object satisfying the match expression.
    @param index The position to start from
    @param match The match expression function
    @return The index of the matched object or -1 if not found
    @raise Raises an error when the index is out of bounds
]]
function List:findIndexAfter(index, match)
    assert(index > 0 and index <= self:getLength(), "Index out of range.")

    return self:findIndexInRange(index, self:getLength(), match)
end

--[[--
    Searches and returns the index of the first occuronce of an object satisfying the match expression in the specified range.
    @param index The position to start from
    @param endIndex The final position including the last element
    @param match The match expression function
    @return The index of the matched object or -1 if not found
    @raise Raises an error when the range is out of bounds
]]
function List:findIndexInRange(index, endIndex, match)
    assert(index > 0 and index <= self:getLength(), "Index out of range.")

    return findIndexInRange(index, endIndex, match, true)
end

--[[--
    Checks whether the list contains an object satisfying the match expression.
    @param match THe match expression function
    @return True on the first occurrence otherwise false
]]
function List:exists(match)
    return self:find(match) ~= nil
end
