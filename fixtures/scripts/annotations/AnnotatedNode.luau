-- AnnotatedNode.luau: @class / @extends Node / @tool / lifecycle methods
--- @class AnnotatedNode
--- @extends Node
--- @tool
local AnnotatedNode = {
	extends = "Node",
	class_name = "AnnotatedNode",
	label = "hello",
	_ready = function(self)
		self.label = "ready"
	end,
}
local AnnotatedNode_C = gdclass(AnnotatedNode)

--- @property label string default="hello" export

return AnnotatedNode_C
