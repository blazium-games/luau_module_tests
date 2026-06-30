local GdclassNode = {
	extends = "Node",
	class_name = "LuauFixtureGdclass",
	speed = export(42),
	label = export("gdclass"),

	_ready = function(self)
		self.ready_called = true
	end,

	GetSpeed = function(self)
		return self.speed
	end,
}

return gdclass(GdclassNode)
