--[[--
    Provides functionalities to map keys to values
    @type Dictionary
]]
Dictionary = class()
Dictionary.array = nil
Dictionary.length = nil

--[[--
    Default constructor.
]]
function Dictionary:init()
    self.array = {}
    self.length = 0
end

--[[--
    Adds an object at with the specified key.
    @param key The entry's key
    @param value The object to be associated with the key
    @raise Raises an error when a key is already in use
]]
function Dictionary:add(key, value)
    assert(not self:containsKey(key), "Key is already in use.")

    self.array[key] = value
    self.length = self.length + 1
end

--[[--
    Tries adding an object with the specified key.
    @param key The entry's key
    @param value The object to be associated with the key
    @return Returns whether the key value pair was successfully added
]]
function Dictionary:tryAdd(key, value)
    local kvPairAdded = false

    if not self:containsKey(key) then
        self.array[key] = value
        self.length = self.length + 1
        kvPairAdded = true
    end

    return kvPairAdded
end

--[[--
    Gets the object associated with the key.
    @param key The key to look for
    @return The object associated with the key
    @raise Raises an error if there is no entry with the specified key
]]
function Dictionary:get(key)
    assert(self:containsKey(key), "Key not found.")

    return self.array[key]
end

--[[--
    Tries to get the object associated with the key.
    @param key The associated key to look for
    @return Returns a tuple. The first value signifies whether the key exists, the second contains the value or nil if the key was not found
]]
function Dictionary:tryGet(key)
    return self:containsKey(key), self.array[key]
end

--[[--
    Sets the value where key points at
    @param key The entry's key
    @param value The value to set
    @raise Raises an error if there is no entry with the specified key
]]
function Dictionary:update(key, value)
    assert(self:containsKey(key), "Key not found.")

    self.array[key] = value
end

--[[--
    Removes the object associated with the key.
    @param key The associated key to look for
    @return Returns true if sucessfully removed otherwise false
]]
function Dictionary:remove(key)
    local removed = false

    if self:containsKey(key) then
        self.array[key] = nil
        self.length = self.length - 1
        removed = true
    end

    return removed
end

--[[--
    Gets the iterator function for the dictionary.
    @usage for k, v in myDictionary:getIterator() do end
    @return The iterator function
]]
function Dictionary:getIterator()
    return pairs(self.array)
end

--[[--
    Returns the length of the dictionary.
    @return The length of the dictionary as number
]]
function Dictionary:getLength()
    return self.length
end

--[[--
    Checks whether the dictionary is empty.
    @return True if the dictionary is empty otherwise false
]]
function Dictionary:isEmpty()
    return self:getLength() == 0
end

--[[--
    Clones the whole dictionary and returns a copy.
    This is a shallow copy, the elements of the dictionary are not copied, only their references are.
    @return A copy of the Dictionary object
]]
function Dictionary:clone()
    local dict = Dictionary()

    for k, v in self:getIterator() do
        dict:add(k, v)
    end

    return dict
end

--[[--
    Clears the dictionary from all its members and sets the length to zero.
]]
function Dictionary:clear()
    if not self:isEmpty() then
        self.array = {}
        self.length = 0
    end
end

--[[--
    Checks for the existence of the specified key.
    @param key The key to check for
    @return Returns true if there is an entry for the specified key otherwise false
]]
function Dictionary:containsKey(key)
    assert(key ~= nil, "Key can't be nil.")

    return self.array[key] ~= nil
end

--[[--
    Checks for the existence of the specified object.
    @param value The object to check for
    @return Returns true if there is an entry for the specified object otherwise false
]]
function Dictionary:containsValue(value)
    local contains = false

    for k, v in self:getIterator() do
        contains = v == value

        if contains then
            break
        end
    end

    return contains
end

--[[--
    Generates a List with a copy of all the keys in the dictionary.
    @return The List of all current keys
]]
function Dictionary:getKeys()
    local keys = List()

    for k, v in self:getIterator() do
        keys:add(k)
    end

    return keys
end


--[[--
    Generates a List with a copy of all the objects in the dictionary.
    @return The List of all current objects
]]
function Dictionary:getValues()
    local values = List()

    for k, v in self:getIterator() do
        values:add(v)
    end

    return values
end

--[[--
    Converts all it's members to simple Lua tables and returns a associative array of them.
    @return The generated associative array
]]
function Dictionary:toTable()
    local t = {}

    for k, v in self:getIterator() do
        if v.toTable ~= nil and type(v.toTable) == "function" then
            t[k] = v:toTable()
        else
            t[k] = v
        end
    end

    return t
end
