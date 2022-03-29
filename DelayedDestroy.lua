-- Destroy an Instance after `lifetime` seconds
local function delayedDestroy(object: Instance, lifetime: number?)
	task.delay(lifetime or 10, function()
		if object then -- Might already be destroyed
			object:Destroy()
		end
	end)
end
