local TableDslNode = {
	extends = "Node",
	class_name = "LuauFixtureTableDsl",
	speed = export(42),
	label = export("table_dsl"),
	ready_called = export(false),
	notif_hits = export(0),
	_ready = function(self)
		self.ready_called = true
	end,
	_notification = function(self, n)
		if n == 42 then
			self.notif_hits = self.notif_hits + 1
		end
	end,
	_Notification = function(self, n)
		if n == 42 then
			self.notif_hits = self.notif_hits + 1
		end
	end,
}

return TableDslNode
