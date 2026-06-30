-- AnnotatedInheritance.luau: extends annotated base class
--- @class AnnotatedChild
--- @extends AnnotatedNode
local AnnotatedChild = {
	extends = "AnnotatedNode",
	class_name = "AnnotatedChild",
	_ready = function(self)
		self.super._ready()
		self.label = self.label .. "_child"
	end,
}
local AnnotatedChild_C = gdclass(AnnotatedChild)

return AnnotatedChild_C
