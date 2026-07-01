---@tool
---@class ValidatePropertyNode
---@property name=score type=int default=0 export

local ValidatePropertyNode = {
	extends = "Node",
	tool = true,
	score = 0,
	_validate_property = function(self, property)
		if tostring(property.name) == "score" then
			property.hint = 1
			property.hint_string = "0,100,1"
		end
		return property
	end,
}

return ValidatePropertyNode
