-- ClassReturnNode.luau: class() userdata return style
local ClassReturnNode = {
	extends = Node,
	class_name = "ClassReturnNode",
	speed = export(7),

	_ready = function(self)
		self.ready_called = true
	end,
}

return class(ClassReturnNode)
