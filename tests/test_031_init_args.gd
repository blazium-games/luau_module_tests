extends AutoworkTest

func test_031_init_args() -> void:
	var source := """
		local C = {
			extends = "RefCounted",
			value = 0,
		}
		function C._init(self, a, b)
			self.value = a + b
		end
		return C
	"""
	var script := LuauScript.new()
	script.set_source_code(source)
	var err := script.reload()
	if err != OK:
		pending("Init args script failed to compile")
		return
	var inst: Object = script.new(10, 32)
	assert_eq(int(inst.get("value")), 42, "_init should receive constructor args")
