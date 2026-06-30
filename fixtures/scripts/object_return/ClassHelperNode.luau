-- ClassHelperNode.luau: helper for object-return tests
--- @class ClassHelperNode
--- @extends Node
local ClassHelperNode = {
	extends = "Node",
	class_name = "ClassHelperNode",

	MakeRef = function(self)
		return RefCounted.new()
	end,

	MakeObject = function(self)
		return Object.new()
	end,

	WrapVector = function(self, x, y)
		return Vector2(x, y)
	end,
}

local ClassHelperNode_C = gdclass(ClassHelperNode)
return ClassHelperNode_C
