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
