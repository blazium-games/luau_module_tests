local MathNode = {
	extends = "Node",

	function MathNode:get_vector_sum()
		local v = Vector2(1, 2)
		return v.x + v.y
	end,
}

return MathNode
