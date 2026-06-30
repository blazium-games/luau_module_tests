extends AutoworkTest

const GDCLASS_PATH := "res://fixtures/scripts/gdclass/GdclassNode.luau"

func test_006_gdclass_syntax() -> void:
	if !ClassDB.class_exists("LuauScript"):
		pending("LuauScript not registered yet")
		return

	var script: Resource = ResourceLoader.load(GDCLASS_PATH)
	assert_true(script != null, "gdclass fixture should load as a resource")
	assert_eq(script.get_class(), "LuauScript", "Fixture should be a LuauScript resource")

	var instance: Object = script.new()
	assert_true(instance != null, "gdclass script should instantiate")
	add_child_autofree(instance as Node)

	if instance.has_method("GetSpeed"):
		assert_eq(instance.call("GetSpeed"), 42, "gdclass speed getter should return 42")
	elif "speed" in instance:
		assert_eq(instance.get("speed"), 42, "gdclass speed property should default to 42")
	else:
		pending("gdclass properties not yet exposed on instance")
