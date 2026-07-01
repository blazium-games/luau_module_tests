local MathNode = {
	extends = "Node",

	get_vector_sum = function(self)
		local v = Vector2(1, 2)
		return v.x + v.y
	end,
}

return MathNode
