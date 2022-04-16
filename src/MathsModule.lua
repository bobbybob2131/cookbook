--!strict
-- Author(s): bobbybob2131 
-- Last edited: 16 April 2022
-- Description: 6 variables and 27 functions for mathematics

--[[
Constants are rationalised to be accurate to 12 decimal places (if applicable).

variable mathsModule.eulersNumber: number Eulers number (e)
variable mathsModule.eulersConstant: number Eulers constant (mathematical constant)
variable mathsModule.tau: number Tau (mathematical constant)
variable mathsModule.belphegorsPrime: number Belphegors prime (palindromic prime number with 666 in the middle)
variable mathsModule.avogadrosNumber: number Avogadro's number (particles per mole)
variable mathsModule.feigenbaumConstant: number Rate of change in width of bifurcations on functions (e.g. logistic map) as you change period

function mathsModule.factorial(number: number): number Get the factorial of a number (!x)
function mathsModule.root(number: number, root: number): number Calculate the nth root of a number
function mathsModule.round(number: number, precision: number): number Round a number to a given precision
function mathsModule.isInteger(number: number): boolean Check if a number is an integer (whole number)
function mathsModule.isPrime(number: number): boolean Check if a number is prime (only factors are itself and one)
function mathsModule.primeFactors(number: number): {number} List all prime factors of a number, in ascending order
function mathsModule.isCoprime(number1: number, number2: number): boolean Check if a pair of numbers are coprime (no common prime factors)
function mathsModule.fibonacciSequence(length: number): {number} Generate a copy of the fibonacci sequence of length n
function mathsModule.nthFibonacci(number: number): number Get the nth term of the fibonacci sequence
function mathsModule.geometricMean(...): number Find the square root of the product of all the inputs
function mathsModule.quadraticMean(...): number Find the square root of the mean of the squared inputs (aka root mean square)
function mathsModule.mean(...): number Find the mean of a data set (average)
function mathsModule.median(...): number Find the median of a data set (middle value)
function mathsModule.mode(...): (number | {number}, number) Find the mode(s) of a data set (most common value)
function mathsModule.range(...): number Find the range of a data set (difference between largest and smallest)
function mathsModule.midRange(...): number Find the mid range (average of largest and smallest)
function mathsModule.lowerQuartile(...): number Find the first quartile (middle of smallest and median)
function mathsModule.upperQuartile(...): number Find the third quartile (middle of median and largest)
function mathsModule.interquartileRange(...): number Find the interquartile range (difference between first and third quartiles)
function mathsModule.standardDeviation(...): number Find the standard deviation (spread from mean average)
function mathsModule.getPercentageChange(old: number, new: number): number Calculate difference as a percentage
function mathsModule.angleBetween(vectorA: Vector3, vectorB: Vector3): number Find the angle between two vectors
function mathsModule.lerp(number1: number, number2: number, alpha: number?) Linearly interpolate between two values, alpha defaults to 0.5
function mathsModule.isFinite(number: number): boolean Check if a number is not infinite
function mathsModule.isNaN(number: number): boolean Check if a number is NaN (not a number)
function mathsModule.isReal(number: number): boolean Check if a number is not imaginary (i)
function mathsModule.isNatural(number: number, includeZero: boolean?): boolean Check if a number is a natural number
]]

local mathsModule = {}

-- Eulers number (e, the base of the natural logarithm)
mathsModule.eulersNumber = math.exp(1)

-- Eulers constant (mathematical constant)
mathsModule.eulersConstant = 0.577215664901

-- Tau (2pi)
mathsModule.tau = math.pi * 2

-- Belphegors prime (palindromic prime number with 666 in the middle)
mathsModule.belphegorsPrime = 10^30 + 666 * 10^14 + 1

-- Avogadro's number (particles per mole)
mathsModule.avogadrosNumber = 6.02214076 * 10^23

-- Rate of change in width of bifurcations on functions (e.g. logistic map) as you change period
mathsModule.feigenbaumConstant = 4.669201609102

-- Get the factorial of a number (!x)
function mathsModule.factorial(number: number): number
	local total: number = number
	while not number == 0 do
		number -= 1
		total *= number
	end
	return total
end

-- Calculate the nth root of a number
function mathsModule.root(number: number, root: number): number
	return number ^ (1 / root)	
end

-- Round a number to a given precision
function mathsModule.round(number: number, precision: number, precisionIsDecimals: boolean?): number
	if precisionIsDecimals then
		return math.round(number * 10^precision) * 10^-precision
	else 
		return math.round(number * precision) / precision
	end
end

-- Check if a number is an integer (whole number)
function mathsModule.isInteger(number: number): boolean
	return number % 1 == 0
end

-- Check if a number is prime (only factors are itself and one)
function mathsModule.isPrime(number: number): boolean
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
function mathsModule.primeFactors(number: number): {number}
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

-- Check if a pair of numbers are coprime (no common prime factors)
function mathsModule.isCoprime(number1: number, number2: number): boolean
	local primeFactors1: {number} = mathsModule.primeFactors(number1)
	local primeFactors2: {number} = mathsModule.primeFactors(number2)
	
	for index: number, factor: number in ipairs(primeFactors1) do
		if table.find(primeFactors2, factor) then
			return false
		end
	end
	
	return true
end

-- Generate a copy of the fibonacci sequence of length n
function mathsModule.fibonacciSequence(length: number): {number}
	local fibonacci: {number} = {0, 1}
	
	for index: number = 3, length do
		table.insert(fibonacci, fibonacci[index - 2] + fibonacci[index - 1])
	end
	
	return fibonacci
end

-- Get the nth term of the fibonacci sequence
function mathsModule.nthFibonacci(number: number): number
	local secondLast: number = 0
	local last: number = 1

	if number == 0 then
		return secondLast

	elseif number == 2 then
		return last

	else
		for index: number = 2, number + 1 do
			local sum: number = secondLast + last
			secondLast = last
			last = sum
		end
		return last
	end
end

-- Find the square root of the product of all the inputs
function mathsModule.geometricMean(...): number
	local total: number = 0
	local args: {number} = if type(...) == "table" then ... else table.pack(...)
	for index: number, value: number in ipairs(args) do
		total *= value
	end
	return math.sqrt(total)
end

-- Find the square root of the mean of the squared inputs (aka root mean square)
function mathsModule.quadraticMean(...): number
	local args: {number} = if type(...) == "table" then ... else table.pack(...)
	local total: number = 0
	for index: number, value: number in ipairs(args) do
		total += value^2
	end
	return math.sqrt(total / #args)
end

-- Find the mean of a data set (average)
function mathsModule.mean(...): number
	local total: number = 0
	local args: {number} = if type(...) == "table" then ... else table.pack(...)
	for index: number, value: number in ipairs(args) do
		total += value
	end
	return total / #args
end

-- Find the median of a data set (middle value)
function mathsModule.median(...): number
	local args: {number} = if type(...) == "table" then ... else table.pack(...)
	table.sort(args)
	return if #args % 2 == 0 then (args[#args / 2] + args[#args / 2 + 1]) / 2 else args[math.ceil(#args / 2)]
end

-- Find the mode(s) of a data set (most common value)
function mathsModule.mode(...): (number | {number}, number)
	local args: {number} = if type(...) == "table" then ... else table.pack(...)
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

-- Find the range of a data set (difference between largest and smallest)
function mathsModule.range(...): number
	local args: {number} = if type(...) == "table" then ... else table.pack(...)
	table.sort(args)
	return args[#args] - args[1]
end

-- Find the mid range (average of largest and smallest)
function mathsModule.midRange(...): number
	local args: {number} = if type(...) == "table" then ... else table.pack(...)
	table.sort(args)
	return (args[#args] - args[1]) / 2
end

-- Find the first quartile (middle of smallest and median)
function mathsModule.lowerQuartile(...): number
	local args: {number} = if type(...) == "table" then ... else table.pack(...)
	table.sort(args)
	
	for Index: number = 1, ((#args - #args % 2) / 2) + (#args % 2), 1 do
		table.remove(args, #args)
	end
	
	return #args % 2 == 0 and (args[#args / 2] + args[#args / 2 + 1]) / 2 or args[math.ceil(#args / 2)]
end

-- Find the third quartile (middle of median and largest)
function mathsModule.upperQuartile(...): number
	local args: {number} = if type(...) == "table" then ... else table.pack(...)
	table.sort(args)

	for Index: number = 1, ((#args - #args % 2) / 2) + (#args % 2), 1 do
		table.remove(args, 1)
	end

	return #args % 2 == 0 and (args[#args / 2] + args[#args / 2 + 1]) / 2 or args[math.ceil(#args / 2)]
end

-- Find the interquartile range (difference between first and third quartiles)
function mathsModule.interquartileRange(...): number
	local args: {number} = if type(...) == "table" then ... else table.pack(...) -- Prevent work being done twice
	table.sort(args)
	return mathsModule.upperQuartile(args) - mathsModule.lowerQuartile(args)
end

-- Find the standard deviation (spread from mean average)
function mathsModule.standardDeviation(...): number
	local args: {number} = if type(...) == "table" then ... else table.pack(...)
	
	local total: number = 0
	for index: number, value: number in ipairs(args) do
		total += value
	end
	local mean: number = total / #args
	
	for index: number, value: number in ipairs(args) do
		value = (value - mean)^2
	end
	
	total = 0
	for index: number, value: number in ipairs(args) do
		total += value
	end
	mean = total / #args
	
	return math.sqrt(mean)
end

-- Calculate difference as a percentage
function mathsModule.getPercentageChange(old: number, new: number): number
	if old == new then
		return 0
	else
		return (new - old) / math.abs(old)
	end
end

-- Find the angle between two vectors
function mathsModule.angleBetween(vectorA: Vector3, vectorB: Vector3): number
	return math.atan2(vectorA:Cross(vectorB).Magnitude, vectorA:Dot(vectorB))
end

-- Linearly interpolate between two values, alpha defaults to 0.5
function mathsModule.lerp(number1: number, number2: number, alpha: number?)
	alpha = alpha or 0.5
	return number1 + ((number2 - number1) * alpha :: number)
end

-- Check if a number is not infinite
function mathsModule.isFinite(number: number): boolean
	return number > -math.huge and number < math.huge
end

-- Check if a number is NaN (not a number)
function mathsModule.isNaN(number: number): boolean
	return number ~= number
end

-- Check if a number is not imaginary (i)
function mathsModule.isReal(number: number): boolean
	return number ~= number and (number > -math.huge and number < math.huge)
end

-- Check if a number is a natural number 
function mathsModule.isNatural(number: number, includeZero: boolean?): boolean
	if includeZero then
		return math.round(number) == number and not math.sign(number) == -1
	else
		return math.round(number) == number and math.sign(number) == 1
	end
end

return mathsModule
