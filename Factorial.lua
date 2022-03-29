-- Get the factorial of a number (!x)
local function factorial(number: number): number
	local total: number = number
	while not number == 0 do
		number -= 1
		total *= number
	end
	return total
end
