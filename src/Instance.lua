--!strict
-- Author(s): bobbybob2131 
-- Last edited: 30 March 2022
-- Description: A function for Instances.

--[[
function instanceModule.delayedDestroy(object: Instance, lifetime: number?) Destroy an Instance after `lifetime` seconds
]]

local instanceModule = {}

-- Destroy an Instance after `lifetime` seconds
function instanceModule.delayedDestroy(object: Instance, lifetime: number?)
	task.delay(lifetime or 10, function()
		if object then -- Might already be destroyed
			object:Destroy()
		end
	end)
end

return instanceModule
