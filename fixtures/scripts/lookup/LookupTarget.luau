--- @class LookupTarget
--- @extends Node
--- @property speed number export default=7
--- @registerMethod get_speed
local LookupTarget = {}

function LookupTarget:get_speed()
	return self.speed
end

return LookupTarget
