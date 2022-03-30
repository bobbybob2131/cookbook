-- Get the factorial of a number (!x)
local function factorial(number: number): number
	local total: number = number
	while not number == 0 do
		number -= 1
		total *= number
	end
	return total
end

-- Calculate the nth root of a number
local function root(number: number, root: number): number
	return number ^ (1 / root)	
end

-- Round a number to a given precision
local function round(number: number, precision: number): number
	return math.round(number * 10^precision) * 10^-precision
end

-- Check if a number is an integer (whole number)
local function isInteger(number: number): boolean
	return number % 1 == 0
end

-- Check if a number is prime (only factors are itself and one)
local function isPrime(number: number): boolean
	if number < 1 or number % 1 ~= 0 or number > 2 and number % 2 == 0 then
		return false
	end
	
	for index: number = 2, math.sqrt(number) do
		if number % index == 0 then
			return false
		end
	end

	return true
end

-- List all prime factors of a number, in ascending order
local function primeFactors(number: number): {number}
	local primeFactors: {number} = {}
	
	while number % 2 == 0 do
		table.insert(primeFactors, 2)
		number /= 2
	end
	
	for factor: number = 3, math.sqrt(number) + 1, 2 do
		while number % factor == 0 do
			table.insert(primeFactors, factor)
			number /= factor
		end
	end
	
	if number > 2 then
		table.insert(primeFactors, number)
	end
	
	return primeFactors
end

-- Generate a copy of the fibonacci sequence of length n
local function fibonacciSequence(length: number): {number}
	local fibonacci: {number} = {0, 1}
	
	for index: number = 3, length do
		table.insert(fibonacci, fibonacci[index - 2] + fibonacci[index - 1])
	end
	
	return fibonacci
end

-- Find the square root of the product of all the inputs
local function geometricMean(...): number
	local total: number = 0
	local args: {number} = if type(...) == "table" then ... else {...}
	for index: number, value: number in ipairs(args) do
		total *= value
	end
	return math.sqrt(total)
end

-- Find the square root of the mean of the squared inputs (aka root mean square)
local function quadraticMean(...): number
	local args: {number} = if type(...) == "table" then ... else {...}
	local total: number = 0
	for index: number, value: number in ipairs(args) do
		total += value^2
	end
	return math.sqrt(total / #args)
end

-- Find the mean of a data set (average)
local function mean(...): number
	local total: number = 0
	local args: {number} = if type(...) == "table" then ... else {...}
	for index: number, value: number in ipairs(args) do
		total += value
	end
	return total / #args
end
			
-- Find the median of a data set (middle value)
local function median(...): number
	local args: {number} = if type(...) == "table" then ... else {...}
	table.sort(args)
	return if #args % 2 == 0 then (args[#args / 2] + args[#args / 2 + 1]) / 2 else args[math.ceil(#args / 2)]
end

-- Find the mode(s) of a data set (most common value)
local function mode(...): (number | {number}, number)
	local args: {number} = if type(...) == "table" then ... else {...}
	local modePass1: {number} = {}
	local modePass2: {number} = {}
	local occurrences: number = 0

	for index: number, value: number in ipairs(args) do
		modePass1[value] = if modePass1[value] then modePass1[value] + 1 else 1
	end

	for index: number, value: number in ipairs(modePass1) do
		if value > occurrences then
			occurrences = value
			modePass2 = {index}
		elseif value == occurrences then
			table.insert(modePass2, index)
		end
	end

	return if #modePass2 == 1 then modePass2[1] else modePass2, occurrences
end
