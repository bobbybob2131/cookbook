--!strict
-- Author(s): bobbybob2131 
-- Last edited: 30 March 2022
-- Description: A function for strings.

--[[
function stringModule.levenshteinDistance(string1: string, string2: string): number Calculate the Levenshtein distance between two strings (how different they are)
]]

local stringModule = {}

-- Calculate the Levenshtein distance between two strings (how different they are)
function stringModule.levenshteinDistance(string1: string, string2: string): number
	if string1 == "" then
		return string.len(string2)
	elseif string2 == "" then
		return string.len(string1)
	elseif string.sub(string1, 0, 1) == string.sub(string2, 0, 1) then
		return stringModule.levenshteinDistance(string.sub(string1, 2, -1), string.sub(string2, 2, -1))
	else
		return 1 + math.min(
			stringModule.levenshteinDistance(string.sub(string1, 2, -1), string.sub(string2, 2, -1)),
			stringModule.levenshteinDistance(string1, string.sub(string2, 2, -1)),
			stringModule.levenshteinDistance(string.sub(string1, 2, -1), string2)
		)
	end
end

return stringModule
