local SoftReloadNode = {
	extends = "Node",

	speed = export { 5 },

	get_speed = function(self)
		return self.speed
	end,
}

return SoftReloadNode
