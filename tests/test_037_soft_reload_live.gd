extends AutoworkTest

const SOFT_RELOAD_PATH := "res://fixtures/scripts/soft_reload/SoftReloadNode.luau"

func test_037_soft_reload_live() -> void:
	if !ClassDB.class_exists("LuauScript"):
		pending("LuauScript not registered yet")
		return

	var script: Resource = ResourceLoader.load(SOFT_RELOAD_PATH)
	assert_true(script != null, "Soft reload fixture should load")

	var node: Node = script.new() as Node
	assert_true(node != null, "Soft reload fixture should instantiate")
	add_child_autofree(node)

	if "speed" in node:
		node.set("speed", 9)
		assert_eq(node.get("speed"), 9, "Property should be mutable before reload")

	script.set_source_code(script.get_source_code().replace("return self.speed", "return self.speed + 1"))
	var reload_err := script.reload(true)
	assert_eq(reload_err, OK, "Soft reload should succeed while instances are live")

	if node.has_method("get_speed"):
		assert_eq(node.call("get_speed"), 10, "Soft reload should preserve properties and run updated methods")
	elif "speed" in node:
		assert_eq(node.get("speed"), 9, "Soft reload should preserve property values")
	else:
		pending("Soft reload instance API not exposed yet")
