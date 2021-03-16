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
    local mA, nA = a.m, a.n
    local mB, nB = b.m, b.n
    local matrixSum

    if (mA == mB and nA == nB) then
        matrixSum = newMatrix(mA, nA)

        for i = 1, mA, 1 do
            for j = 1, nA, 1 do
                local sum = a.data[i][j] + (sign * b.data[i][j])
                matrixSum[i][j] = sum
            end
        end
    else
        error("Mismatching dimensions")
    end

    return Matrix(matrixSum)
end

function Matrix:init(matrix)
    if type(matrix) == "table" then
        self.m = #matrix
        self.n = #matrix[1]
        matrix.data = matrix
    else
        error("Argument of type table expected")
    end
end

function Matrix.__mul(a, b)
    local m, n = a.m, a.n
    local o, p = b.m, b.n
    local matrixProduct

    if (n == o) then
        matrixProduct = newMatrix(m, p)

        for i = 1, m, 1 do
            for j = 1, p, 1 do
                local sum = 0

                for k = 1, n, 1 do
                    sum = sum + a.data[i][k] * b.data[k][j]
                end

                matrixProduct[i][j] = sum
            end
        end
    else
        error("Mismatching dimensions")
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
    if type(index) == "number" then
        if type(value) == "table" and #value == self.n then
            self.data[index] = value
        else
            error("Trying to assign incompatible value")
        end
    else
        error("Type mismatch for row index, number expected")
    end
end

function Matrix:transpose()
    local matrix = newMatrix(self.n, self.m)

    for i = 1, self.m, 1 do
        for j = 1, self.n, 1 do
            matrix[j][i] = self.data[i][j]
        end
    end

    self.data = matrix
end
