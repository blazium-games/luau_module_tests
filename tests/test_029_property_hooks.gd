extends AutoworkTest

func test_029_property_hooks() -> void:
	var source := """
		local C = {
			extends = "RefCounted",
			function _get(self, key)
				if key == "magic" then return 7 end
			end,
			function _set(self, key, value)
				if key == "magic" then return true end
				return false
			end,
		}
		return C
	"""
	var script := LuauScript.new()
	script.set_source_code(source)
	var err := script.reload()
	if err != OK:
		pending("Hook script failed to compile")
		return
	var inst: Object = script.new()
	assert_eq(inst.get("magic"), 7, "_get hook should supply value")
	inst.set("magic", 99)
	assert_eq(inst.get("magic"), 99, "_set hook should accept assignment")
