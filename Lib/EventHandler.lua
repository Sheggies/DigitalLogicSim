--[[--
    Provides a simple way to define events.
    Ability to subscribe to an event and add or remove event handler functions through simple means.
    Event handlers are called in an arbitrary order. Return false if you want the propagation of the event to stop.
    @usage local eventA = Eventhandler() -- Defines a new event
    @usage local function eventHandler(sender, eventArgs) return true end -- Defines an event handler
    @usage _= eventA + eventHandler -- Adds the event handler to the event (subscribing to the event)
    @usage eventA(senderArg, { eventArg1, eventArg2 }) -- Raising the event
    @type EventHandler
]]
EventHandler = class()
EventHandler.handler = nil

--[[--
    Default constructor
]]
function EventHandler:init()
    self.handler = Dictionary()
end

--[[--
    Overloads the + operator for a simple subscription notation
    @param a A function or the EventHandler object
    @param b A function or the EventHandler object
    @return Returns the EventHandler object
    @raise Raises an error of no event handler function was passed
]]
function EventHandler.__add(a, b)
    local eventHandler

    if type(a) == "function" then
        b.handler:add(tostring(a), a)
        eventHandler = b
    elseif type(b) == "function" then
        a.handler:add(tostring(b), b)
        eventHandler = a
    else
        error("You need to provide a function")
    end

    return eventHandler
end

--[[--
    Overloads the - operator for a simple unsubscription notation
    @param a A function or the EventHandler object
    @param b A function or the EventHandler object
    @raise Raises an error of no event handler function was passed
]]
function EventHandler.__sub(a, b)
    local eventHandler

    if type(a) == "function" then
        b.handler:remove(tostring(a))
        eventHandler = b
    elseif type(b) == "function" then
        a.handler:remove(tostring(b))
        eventHandler = a
    else
        error("You need to provide a function")
    end

    return eventHandler
end

--[[--
    Raises the event with the specified sender and event arguments
    @sender The object which raised the event
    @eventArgs Event specific arguments to be passed
]]
function EventHandler:__call(sender, eventArgs)
    for k, v in self.handler:getIterator() do
        if not v(sender, eventArgs) then
            break
        end
    end
end

--[[--
    Checks whether a given event has registered subscribers
    @return Returns true if there is at least one subscirber otherwise false
]]
function EventHandler:hasSubscribers()
    return not self.handler:isEmpty()
end

--[[--
    Clears the list of all event handlers.
]]
function EventHandler:clearAll()
    self.handler:clear()
end
