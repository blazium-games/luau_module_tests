--- @class LuauFixtureGdclassSprite
--- @extends Node2D
local GdclassSprite = {}
local GdclassSpriteC = gdclass(GdclassSprite)

export type GdclassSprite = Node2D & typeof(GdclassSprite) & {
	--- @property
	--- @default 100
	linear_velocity: number,
}

function GdclassSprite:_Ready()
	self.ready_called = true
end

return GdclassSpriteC
