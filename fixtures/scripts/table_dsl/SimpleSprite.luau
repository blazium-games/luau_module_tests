-- Format A: minimal Node2D table DSL fixture

local SimpleSprite = {
	extends = Node2D,
	class_name = "LuauFixtureTableDslSprite",
	linear_velocity = export(100),
}

function SimpleSprite:_ready()
	self.ready_called = true
end

return SimpleSprite
