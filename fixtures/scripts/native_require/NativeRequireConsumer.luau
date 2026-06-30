---@class NativeRequireConsumer

local NativeRequireConsumer = {
	extends = "Node",
	load_native = function(self)
		local mod = require("res://fixtures/scripts/native_require/native_module")
		return mod.value
	end,
}

return NativeRequireConsumer
