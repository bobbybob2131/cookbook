--!strict
-- Author(s): bobbybob2131
-- Last edited: 6 April 2022
-- Description: 17 functions for strings.

--[[
function stringModule.levenshteinDistance(string1: string, string2: string): number Calculate the Levenshtein distance between two strings (how different they are)
function stringModule.capitaliseFirstLetter(target: string): string Capitalise the first letter of a string
function stringModule.capitaliseAllWords(target: string): string Capitalise the first letter of every word in a string
function stringModule.capitaliseSubstring(target: string, startPos: number?, endPos: number?): string Capitalise part of a string
function stringModule.lowerFirstLetter(target: string): string Make the first letter of a string lowercase
function stringModule.lowerSubstring(target: string, startPos: number?, endPos: number?): string Make part of a string lowercase
function stringModule.includes(target: string, substring: string): boolean Check if a string includes a substring
function stringModule.explode(target: string): {string} Get an array of every character in a string
function stringModule.index(target: string, index: number?): string Index a string like a table, returning the nth character
function stringModule.insert(target: string, substring: string, startPos: number?, endPos: number?): string Insert a substring into a string
function stringModule.concat(separator: string, ...): string Concatenate a bunch of strings together
function stringModule.startsWith(target: string, start: string): boolean Check if a string starts with a given string/pattern
function stringModule.endsWith(target: string, start: string): boolean Check if a string ends with a given string/pattern
function stringModule.sanitiseRichText(target: string): string Clean rich text characters from a string, it still displays properly, but doesn't mess up RichText
function stringModule.words(target: string): {string} Get an array of all the words in a string
function stringModule.iterateLetters(target: string): () -> (string) Iterate over each letter in a string
function stringModule.substitute(target: string, ...): string Substitue ${var} for provided variables, in order
]]

local stringModule = {}

-- Calculate the Levenshtein distance between two strings (how different they are)
function stringModule.levenshteinDistance(string1: string, string2: string): number?
	local rows: number = #string1 + 1
	local columns: number = #string2 + 1
	local matrix: {{number}} = table.create(rows, table.create(columns, 0))
	local cost: number
	for rowIndex: number = 1, rows do
		matrix[rowIndex][1] = rowIndex - 1
	end
	for columnIndex = 1, columns do
		matrix[1][columnIndex] = columnIndex - 1
	end
	for rowIndex: number = 2, rows do
		for columnIndex = 2, columns do
			local rowIndexReduced: number = rowIndex - 1
			local columnIndexReduced: number = columnIndex - 1
			if string.sub(string1, rowIndexReduced, rowIndexReduced) == string.sub(string2, columnIndexReduced, columnIndexReduced) then
				cost = 0
			else
				cost = 1
			end
			matrix[rowIndex][columnIndex] = math.min(
				matrix[rowIndexReduced][columnIndex] + 1,
				matrix[rowIndex][columnIndexReduced] + 1,
				matrix[rowIndexReduced][columnIndexReduced] + cost
			)
		end
	end
	return matrix[rows][columns]
end

-- Capitalise the first letter of a string
function stringModule.capitaliseFirstLetter(target: string): string
	return string.gsub(target, "^%l", string.upper)
end

-- Capitalise the first letter of every word in a string
function stringModule.capitaliseAllWords(target: string): string
	return string.gsub(target, "(%w[%w]*)", function(match: string)
		return string.gsub(target, "^%l", string.upper)
	end)
end

-- Capitalise part of a string
function stringModule.capitaliseSubstring(target: string, startPos: number?, endPos: number?): string
	startPos = startPos or 1
	endPos = endPos or #target
	local substring: string = string.sub(target, startPos :: number, endPos)
	return string.gsub(target, substring, string.upper(substring))
end

-- Make the first letter of a string lowercase
function stringModule.lowerFirstLetter(target: string): string
	return string.gsub(target, "^%u", string.lower)
end

-- Make part of a string lowercase
function stringModule.lowerSubstring(target: string, startPos: number?, endPos: number?): string
	startPos = startPos or 1
	endPos = endPos or #target
	local substring: string = string.sub(target, startPos :: number, endPos)
	return string.gsub(target, substring, string.lower(substring))
end

-- Check if a string includes a substring
function stringModule.includes(target: string, substring: string): boolean
	return if string.find(target, substring) then true else false
end

-- Get an array of every character in a string
function stringModule.explode(target: string): {string}
	local chars: {string} = table.create(#target)
	local index: number = 1
	for char: string in string.gmatch(target, ".") do
		index += 1
		chars[index] = char
	end
	return chars
end

-- Index a string like a table, returning the nth character
function stringModule.index(target: string, index: number?): string
	index = index or 1
	return string.sub(target, index :: number, index)
end

-- Insert a substring into a string
function stringModule.insert(target: string, substring: string, startPos: number?, endPos: number?): string
	startPos = startPos or 1
	endPos = endPos or #target
	return string.sub(target, 1, startPos) .. substring .. string.sub(target, endPos :: number + 1)
end

-- Concatenate a bunch of strings together
function stringModule.concat(separator: string, ...): string
	return table.concat(if type(...) == "table" then ... else {...}, separator)
end

-- Check if a string starts with a given string/pattern
function stringModule.startsWith(target: string, start: string): boolean
	return if string.find(target, "^" .. start) then true else false
end

-- Check if a string ends with a given string/pattern
function stringModule.endsWith(target: string, start: string): boolean
	return if string.find(target, start .. "$") then true else false
end

-- Clean rich text characters from a string, it still displays properly, but doesn't mess up RichText
function stringModule.sanitiseRichText(target: string): string
	return string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(target,
		"&", "&amp;"),
		"<", "&lt;"),
		">", "&gt;"),
		"\"", "&quot;"),
		"'", "&apos;"
	)
end

-- Get an array of all the words in a string
function stringModule.words(target: string): {string}
	local words: {string} = {}
	for word: string in string.gmatch(target, "%w+") do
		table.insert(words, word)
	end
	return words
end

-- Iterate over each letter in a string
function stringModule.iterateLetters(target: string): () -> (string)
	local index: number = 0
	return function()
		index += 1
		return string.sub(target, index, index)
	end
end

-- Substitue ${var} for provided variables, in order
function stringModule.substitute(target: string, ...): string
	local args: {any} = if type(...) == "table" then ... else {...}
	for index: number, value: any in ipairs(args) do
		target = string.gsub(target, "%$%b{}", tostring(value), 1)
	end
	return target
end

return stringModule
