---@class InputHookNode
---@property name=input_seen type=bool default=false export

local InputHookNode = {
	extends = "Node",
	input_seen = false,
	_input = function(self, _event)
		self.input_seen = true
	end,
}

return InputHookNode
