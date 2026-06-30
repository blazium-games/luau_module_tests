extends AutoworkTest

const SCRIPT_PATH := "res://fixtures/scripts/validate_property/ValidateProperty.luau"

func test_043_validate_property() -> void:
	if !ClassDB.class_exists("LuauScript"):
		pending("LuauScript not registered yet")
		return

	var script: LuauScript = ResourceLoader.load(SCRIPT_PATH) as LuauScript
	assert_true(script != null, "ValidateProperty fixture should load")

	var node := Node.new()
	node.set_script(script)
	add_child_autofree(node)

	var info := PropertyInfo.new()
	info.name = &"score"
	info.type = TYPE_INT

	var instance := node.get_script_instance()
	assert_true(instance != null, "Script instance should be created")
	instance.validate_property(info)
	assert_eq(info.hint, PROPERTY_HINT_RANGE, "_validate_property should adjust hint")
	assert_eq(info.hint_string, "0,100,1", "_validate_property should adjust hint_string")
