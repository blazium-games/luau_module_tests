-- ObjectExtendsNode.luau: Object-return style using global Node class stub
local ObjectExtendsNode = {
	extends = Node,
	class_name = "ObjectExtendsNode",
	value = export(0),
	ready_called = export(false),

	_ready = function(self)
		self.ready_called = true
		self.value = 1
	end,

	GetValue = function(self)
		return self.value
	end,
}

return gdclass(ObjectExtendsNode)
