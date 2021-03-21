This project is a Lua based digital logic simulator.
In general vertices represent single logic gates and the edges are the wires that connect the gates in a specified direction.

# How to create a circuit
A circuit is composed by vertices and edges, which are topologically sorted, so the simulation knows which vertices are to be computed first.
First you need to create new gate objects which will be the vertices in your graph. Connections are represented by an edge object.
An edge object takes two vertices, a source and a destination vertice. This is an ordered pair and also signifies the direction the edge has.

Now in order to simulate that circuit, the vertices and edges have to be added to a vertex set and edge set respectively.
Those two sets need to be passed to the topological sorter which returns a sorted solution that the a `Simulator` object will take as arguments.
From there on input values can be passed to the simulator and it returns the resulting output values.

The `Simulator` object provides a way to query the circuit's input and output pins.

The following example is a simple SR latch.

## Prerequisites
You need a Lua environment in which you will run the scripts.

Check the folder `Lib` for the core types that are being used. The folder `Graph` contains all the necessary types that are used to create a representation of the circuits graph. The simulator and all the needed types can be found in the `Simulator` folder.

## Create vertices
Vertices represent the gates of your circuits. A gate needs a unqiue identifier and needs to know which boolean operation it is supposed to compute.

Inputs pins for a circuit are also represented by gates, which simulate the boolean identity operation. Since this is an unary operation, it will only take one vertex as its input. It accepts either a `Gate` object or the first element of a vertex set. Input pins are characterised by the lack of any incoming connections.
It's possible to have input pins that have non-unary operations, but they'll behave as if there's only one input and therefore will behave the same way as the unary identity and negation operations.

Output pins are handled similarly to input gates. They can be any gate with any non-unary operation.
The `Simulator` object itself is able to identify output pins. Output pins are characterised by the lack of any outgoing connections. If there are gates whose output is irrelevant and have no further use as output pins, consider removing them.

```lua
local vertices = VertexSet()

-- Create gates
local s = Gate("S", BooleanOperationEnum.Identity)
local r = Gate("R", BooleanOperationEnum.Identity)
local v0 = Gate(0, BooleanOperationEnum.Nor)
local v1 = Gate(1, BooleanOperationEnum.Nor)
local q = Gate("Q", BooleanOperationEnum.Identity)
local notQ = Gate("~Q", BooleanOperationEnum.Identity)

-- Adding gates to the vertex set
vertices:add(s)
vertices:add(r)
vertices:add(v0)
vertices:add(v1)
vertices:add(q)
vertices:add(notQ)
```

## Create edges
Edges represent the directed connections from one gate to the next. It takes two arguments which are the source and destination vertices.

```lua
local edges = EdgeSet()

-- Adding connections to the edge set
edges:add(Edge(s, v0))
edges:add(Edge(r, v1))
edges:add(Edge(v0, v1))
edges:add(Edge(v1, v0))
edges:add(Edge(v0, q))
edges:add(Edge(v1, notQ))
```

## Sorting the vertices and initialising the simulator
A simulator needs a sorted set of the gates in order to correctly compute the resulting output for its given inputs.

The topological sorter returns a table with four objects. Three of them are `List` objects that contain the topologically sorted solution of the vertices.
These three lists are named `merged` (containing the completely sorted solution of all the vertices), `combinational` (all the vertices which are not part of any cyclic path), and `sequential` (all the vertices that are part of at least one cyclic path).
The fourth object is a modified set of all edges. Since the cycle in a circuit has to be split in order to make the graph an DAG (directed acyclic graph) and to be able to sort the vertices, the vertex that completes a cyclic path is duplicated, the cyclic edge removed and a new edge pointing from the duplicate (which is a special kind of gate of the type `FeedbackGate` with no incoming edges) to the first vertex of the cyclic path.

The `Simulator` object expects all of those four objects in order to identify all the inputs and outputs, as well as to simulate the circuit correctly.

```lua
local solutions = TopSorter.sort(vertices, edges)

-- Create the simulator
sim = sim or Simulator(solutions.merged,
                      solutions.combinational,
                      solutions.sequential,
                      solutions.edges)
```

## Using the simulator
In order to use the simulator, the input pins have to be known. The `Simulator` object provides methods to query its input and output pins.
The `simulate` method of the  simulator expects a `Dictionary` object with the input pin's identifiers as the key and the boolean value as the value part of the key value pair.

```lua
local inputValues = Dictionary()
inputValues:add("S", false)
inputValues:add("R", true)

-- Simulate and save the computed output
local outputValues = sim:simulate(inputValues)
```

You can check the values by iterating over the returned `Dictionary` object and printing the value of each output gate.
The circuit might need some simulation iterations until a stable result is available at the output pins.
