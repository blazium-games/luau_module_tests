extends AutoworkTest

func test_043_validate_property() -> void:
	if !ClassDB.class_exists("LuauScript"):
		pending("LuauScript not registered yet")
		return

	var script: LuauScript = ResourceLoader.load(SCRIPT_PATH) as LuauScript
	assert_true(script != null, "ValidateProperty fixture should load")

	var node := Node.new()
	node.set_script(script)
	add_child_autofree(node)

	var property := {
		"name": &"score",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_NONE,
		"hint_string": "",
		"usage": PROPERTY_USAGE_DEFAULT,
	}
	var updated: Variant = node.call("_validate_property", property)
	if updated is Dictionary:
		property = updated
	assert_eq(property["hint"], PROPERTY_HINT_RANGE, "_validate_property should adjust hint")
	assert_eq(property["hint_string"], "0,100,1", "_validate_property should adjust hint_string")

const SCRIPT_PATH := "res://fixtures/scripts/validate_property/ValidateProperty.luau"
