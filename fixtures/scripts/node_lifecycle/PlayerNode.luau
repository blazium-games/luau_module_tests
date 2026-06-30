local PlayerNode = {
	extends = "Node",
	process_ticks = export(0),
	enter_tree_called = export(false),
	_ready = function(self)
		self.enter_tree_called = true
	end,
	_enter_tree = function(self)
		self.enter_tree_called = true
	end,
	_process = function(self, delta)
		self.process_ticks = self.process_ticks + 1
	end,
}

return PlayerNode
