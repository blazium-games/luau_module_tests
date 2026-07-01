local Consumer = {
	extends = "RefCounted",
	get_combined = function(self)
		local Helper = require("res://fixtures/scripts/require/HelperModule.mod")
		return Helper.value .. "_loaded"
	end,
}

return Consumer
