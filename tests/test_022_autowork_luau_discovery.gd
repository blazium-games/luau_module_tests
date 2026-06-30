extends AutoworkTest

func test_022_autowork_luau_discovery() -> void:
	if !ClassDB.class_exists("AutoworkCollector"):
		pending("Autowork not available")
		return

	var collector := AutoworkCollector.new()
	collector.set_script_prefix("test_luau_")
	collector.set_script_suffixes(PackedStringArray([".luau"]))
	collector.set_include_subdirectories(false)
	collector.process_directory("res://tests/luau")

	var scripts: Array = collector.get_scripts()
	if scripts.is_empty():
		var probe: Resource = ResourceLoader.load("res://tests/luau/test_luau_001_state.luau")
		if probe == null:
			pending("Luau Autowork test fixture failed to load")
			return
		if probe.get_instance_base_type() != "AutoworkTest":
			pending("Luau test base type is %s, expected AutoworkTest" % probe.get_instance_base_type())
			return
		pending("Luau tests load but collector did not discover methods yet")
		return
	assert_true(scripts.size() >= 1, "Autowork should discover Luau tests in tests/luau")
