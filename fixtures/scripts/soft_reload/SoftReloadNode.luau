local SoftReloadNode = {
	extends = "Node",

	speed = export { 5 },

	function SoftReloadNode:get_speed()
		return self.speed
	end,
}

return SoftReloadNode
