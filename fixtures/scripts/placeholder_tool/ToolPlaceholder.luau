---@tool
---@class ToolPlaceholderNode

local ToolPlaceholderNode = {
	extends = "Node",
	tool = true,
	_ready_called = false,
	_ready = function(self)
		self._ready_called = true
	end,
}

return ToolPlaceholderNode
