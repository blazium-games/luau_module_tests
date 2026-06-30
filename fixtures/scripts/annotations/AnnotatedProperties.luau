-- AnnotatedProperties.luau: typed @property with hints
--- @class AnnotatedProperties
--- @extends Node
local AnnotatedProperties = {}
local AnnotatedProperties_C = gdclass(AnnotatedProperties)

--- @property health number default=100 export hint=range hint_string=0,100,1
--- @property title string default="Luau" export
AnnotatedProperties.health = 100
AnnotatedProperties.title = "Luau"

return AnnotatedProperties_C
