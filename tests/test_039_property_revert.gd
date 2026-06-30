extends AutoworkTest

const REVERT_SCRIPT := "res://fixtures/scripts/property_revert/RevertProps.luau"

func test_039_property_revert() -> void:
	if !ClassDB.class_exists("LuauScript"):
		pending("LuauScript not registered yet")
		return

	var script: LuauScript = ResourceLoader.load(REVERT_SCRIPT) as LuauScript
	assert_true(script != null, "Property revert fixture should load")

	var node := Node.new()
	node.set_script(script)
	add_child_autofree(node)

	assert_true(node.property_can_revert("health"), "Exported default should be revertible")
	assert_eq(node.property_get_revert("health"), 100, "Revert value should match default")
