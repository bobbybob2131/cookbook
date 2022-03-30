local function prettyConcatenate(array: {[number]: any}): string
	if #array == 1 then
		return tostring(array[1])
	elseif #array == 2 then
		return array[1] .. " and " .. array[2]
	else
		local lastItem: any = table.remove(array)
		local text: string = table.concat(array, ", ") .. ", and " .. lastItem
		table.insert(array, lastItem)
		return text
	end
end

-- Make sure a tuple (...) is a table
local function normaliseTuple(...: any)
	return if type(...) == "table" then ... else {...}
end
