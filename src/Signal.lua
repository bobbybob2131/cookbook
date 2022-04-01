--!strict
-- Author(s): bobbybob2131
-- Last edited: 1 April 2022
-- Description: Super simple signal class

--[[
type Signal Signal object (similar to RBXScriptConnection)

constructor signal.new(): Signal Create a new signal object

method signalObject:Connect(func) Call the function when the event is raised
method signalObject:Wait() Yield current thread until the event is raised
method signalObject:Fire(...) Raise the event
method signalObject:Destroy() Destroy a signal
]]

local signal = {}

-- Create a new signal object
function signal.new(): Signal
	local signalObject = {
		bindable = Instance.new("BindableEvent")
	}
	
	-- Call the function when the event is raised
	function signalObject:Connect(func)
		self.bindable:Connect(func)
	end
	
	-- Yield current thread until the event is raised
	function signalObject:Wait()
		self.bindable:Wait()
	end
	
	-- Raise the event
	function signalObject:Fire(...)
		self.bindable:Fire(...)
	end
	
	-- Destroy a signal
	function signalObject:Destroy()
		self.bindable:Destroy()
	end
	
	return signalObject
end
local typeSignal: Signal = signal.new()
export type Signal = typeof(typeSignal)
typeSignal:Destroy()

return signal
