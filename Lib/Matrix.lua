Matrix = class()
Matrix.m = nil
Matrix.n = nil
Matrix.data = nil

local function newMatrix(m, n)
    local matrix = {}

    for i = 1, m, 1 do
        table.insert(matrix, i, {})

        for j = 1, n, 1 do
            table.insert(matrix[i], j, 0)
        end
    end

    return matrix
end

local function matrixEntrywiseSum(a, b, sign)
    assert((a.m == b.m) and (a.n == b.n), "Mismatching dimensions")

    local matrixSum = newMatrix(a.m, a.n)

    for i = 1, a.m, 1 do
        for j = 1, a.n, 1 do
            local sum = a.data[i][j] + (sign * b.data[i][j])
            matrixSum[i][j] = sum
        end
    end

    return Matrix(matrixSum)
end

function Matrix:init(matrix)
    assert(type(matrix) == "table", "Argument of type table expected")

    self.m = #matrix
    self.n = #matrix[1]
    self.data = matrix
end

function Matrix.__mul(a, b)
    assert(a.n == b.m, "Mismatching dimensions")

    local m, n, p = a.m, a.n, b.n
    local matrixProduct = newMatrix(m, p)

    for i = 1, m, 1 do
        for j = 1, p, 1 do
            local sum = 0

            for k = 1, n, 1 do
                sum = sum + a.data[i][k] * b.data[k][j]
            end

            matrixProduct[i][j] = sum
        end
    end

    return Matrix(matrixProduct)
end

function Matrix.__add(a, b)
    return matrixEntrywiseSum(a, b, 1)
end

function Matrix.__sub(a, b)
    return matrixEntrywiseSum(a, b, -1)
end

function Matrix:__newindex(index, value)
    assert(type(index) == "number", "Type mismatch for row index, number expected")
    assert(type(value) == "table" and #value == self.n, "Trying to assign incompatible value")

    self.data[index] = value
end

function Matrix:transpose()
    local newData = newMatrix(self.n, self.m)

    for i = 1, self.m, 1 do
        for j = 1, self.n, 1 do
            newData[j][i] = self.data[i][j]
        end
    end

    self.data = newData
end
