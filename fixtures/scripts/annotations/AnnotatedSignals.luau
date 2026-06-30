-- AnnotatedSignals.luau: @signal declarations
--- @class AnnotatedSignals
--- @extends Node
local AnnotatedSignals = {
	extends = "Node",
	class_name = "AnnotatedSignals",
	pressed = signal(),
	value_changed = signal(),
}
local AnnotatedSignals_C = gdclass(AnnotatedSignals)

--- @signal pressed
--- @signal value_changed

function AnnotatedSignals:emit_pressed()
	self.self:emit_signal("pressed")
end

return AnnotatedSignals_C
