local LuauAutoload = {
	extends = "Node",
	ready_flag = export(false),
	_ready = function(self)
		self.ready_flag = true
	end,
	get_flag = function(self)
		return self.ready_flag
	end,
}

return LuauAutoload
