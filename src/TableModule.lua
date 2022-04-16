--!strict
-- Author(s): bobbybob2131 
-- Last edited: 16 April 2022
-- Description: 2 types and 13 functions for the manipulation of tables

--[[
type proxy userdata
type metatable Table with a metatable

function tableModule.concatenateNonStrings(array: {[number]: any}, separator: string?, startPos: number?, endPos: number?, separateEnding: boolean?): string
	Concatenate an array with non-string values (e.g. booleans), using the same defaults/functionality as the builtin
function tableModule.prettyConcatenate(array: {[number]: any}): string Concatenate an array with commas and the ending "x and y"
function tableModule.normaliseTuple(...: any) Make sure a tuple (...) is a table, for iteration over
function tableModule.find(haystack: {[any]: any}, needle: any, recursive: boolean?): any? Check if a table contains a value (works recursively, and on dictionaries)
function tableModule.keys(dictionary: {[any]: any}): {any} Create an array of the keys of a dictionary
function tableModule.reverse(array: {[number]: any}) Reverse the values in an array
function tableModule.shuffle(array: {[number]: any}) Randomly shuffle the order of values in an array
function tableModule.toProxy(oldTable: any, copyMetatable: boolean?): (proxyWithMeta | proxy, {[string]: any}?)
	Convert a table (and metatable) to a proxy, `oldTable` is an array/dictionary, potentially with a metatable
function tableModule.length(target: {[any]: any}): number Get the length of a table (works on dictionaries)
function tableModule.isEmpty(target: {[any]: any}): boolean Check if a table is empty
function tableModule.concatenateDictionary(dictionary: {[any]: any}, separator: string?, keyValueSeparator: string?, startPos: number, endPos: number): string
	Same as table.concat, but works on dictionaries
function tableModule.copy(target: {[any]: any}, deep: boolean?): {[any]: any}
	Copy a table, with the option to do the same for all child tables
function tableModule.swapRemove(array: {any}, index: number?) Quickly remove a value from an array, but without preserving order
]]

--[[
local testTable = {
	{"a", 1, 2},
	{["hi"] = 1, 3, {"c", "d", {["testing"] = true}}},
	2,
	"hello",
	Vector3.new()
}
]]

local tableModule = {}

local blankProxy = newproxy()

export type proxy = typeof(blankProxy)
export type metatable = typeof(getmetatable(setmetatable({}, {})))

-- Concatenate an array with non-string values (e.g. booleans), using the same defaults/functionality as the builtin
function tableModule.concatenateNonStrings(array: {[number]: any}, separator: string?, startPos: number?, endPos: number?, separateEnding: boolean?): string
	separator = separator or ""
	startPos = startPos or 1
	endPos = endPos or #array
	local concatenatedTable: string = ""
	
	if separateEnding then
		for index: number = startPos :: number, endPos :: number - 1 do
			concatenatedTable ..= tostring(array[index]) .. separator :: string
		end

		return concatenatedTable .. tostring(array[endPos :: number]) -- Otherwise it would end with the separator
	else
		for index: number = startPos :: number, endPos :: number do
			concatenatedTable ..= tostring(array[index]) .. separator :: string
		end
		return concatenatedTable
	end
end

-- Concatenate an array with commas and the ending "x and y"
function tableModule.prettyConcatenate(array: {[number]: any}): string
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

-- Make sure a tuple (...) is a table, for iteration over
function tableModule.normaliseTuple(...: any)
	return if type(...) == "table" then ... else table.pack(...)
end

-- Check if a table contains a value (works recursively, and on dictionaries)
function tableModule.find(haystack: {[any]: any}, needle: any, recursive: boolean?): any?
	if recursive then
		local function search(subHaystack: {[any]: any}): any?
			for key: any, value: any in pairs(subHaystack) do
				if value == needle then
					return key
				end

				if typeof(value) == "table" then
					search(value)
				end
			end
		end
		search(haystack)
	else
		for key: any, value: any in pairs(haystack) do
			if value == needle then
				return key
			end
		end
	end
end

-- Create an array of the keys of a dictionary
function tableModule.keys(dictionary: {[any]: any}): {any}
	local keyTable = {}
	for key in pairs(dictionary) do
		table.insert(keyTable, key)
	end
	return keyTable
end

-- Reverse the values in an array
function tableModule.reverse(array: {[number]: any})
	local length: number = #array
	for index: number = 1, length do
		array[index] = array[length - index + 1]
	end
end

-- Randomly shuffle the order of values in an array
function tableModule.shuffle(array: {[number]: any})
	local length: number = #array
	for index: number = 1, length do
		local randomNumber = math.random(1, length)
		array[index] = array[randomNumber] -- Switch values to preserve them
		array[randomNumber] = array[index]
	end
end

-- Convert a table (and metatable) to a proxy, `oldTable` is an array/dictionary, potentially with a metatable
function tableModule.toProxy(oldTable: any, copyMetatable: boolean?): (proxy, {[string]: any}?)
	if copyMetatable then
		local proxy: proxy = newproxy(true)
		local proxyMeta: {[string]: any} = getmetatable(proxy)
		local tableMeta: {[string]: any} = getmetatable(oldTable)
		
		if tableMeta then
			for key: any, value: any in pairs(oldTable) do -- Set values first so as not to trigger metamethods
				proxy[key] = value
			end
			setmetatable(proxy, proxyMeta)
		end
		return proxy, proxyMeta
	else
		local proxy: proxy = newproxy()
		for key: any, value: any in pairs(oldTable) do
			proxy[key] = value
		end
		return proxy
	end
end

-- Get the length of a table (works on dictionaries)
function tableModule.length(target: {[any]: any}): number
	local length: number = 0
	for _ in pairs(target) do
		length += 1
	end
	return length
end

-- Check if a table is empty
function tableModule.isEmpty(target: {[any]: any}): boolean
	if next(target) == nil then
		return true
	else
		return false
	end
end

-- Same as table.concat, but works on dictionaries
function tableModule.concatenateDictionary(dictionary: {[any]: any}, separator: string?, keyValueSeparator: string?, startPos: number, endPos: number): string
	local length: number = 0
	for _ in pairs(dictionary) do
		length += 1
	end
	separator = separator or ""
	keyValueSeparator = keyValueSeparator or "="
	startPos = startPos or 1
	endPos = endPos or length
	
	local concatenatedDict: string = ""
	
	for key: string, value: string in pairs(dictionary) do
		concatenatedDict ..= tostring(key) .. keyValueSeparator :: string .. tostring(value) .. separator :: string
	end
	
	return concatenatedDict
end

-- Copy a table, with the option to do the same for all child tables
function tableModule.copy(target: {[any]: any}, deep: boolean?): {[any]: any}
	if #target > 0 then -- Array
		return table.move(target, 1, #target, 1, table.create(#target))
	else
		local copiedTable: {[any]: any} = {}
		for key: any, value: any in pairs(target) do
			copiedTable[key] = value
		end
		return copiedTable
	end
end

-- Quickly remove a value from an array, but without preserving order
function tableModule.swapRemove(array: {any}, index: number?)
	local length: number = #array
	array[index or 1] = array[length] 
	array[length] = nil
end

return tableModule
