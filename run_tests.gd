extends SceneTree

func _setup_autoloads() -> void:
	# ProjectSettings.get_setting("autoload") is not a Dictionary at runtime; use known test autoloads.
	var entries := {
		"LuauAutoload": "res://fixtures/autoload/LuauAutoload.luau",
	}
	for autoload_name in entries:
		if root.get_node_or_null(NodePath(autoload_name)) != null:
			continue

		var path: String = entries[autoload_name]
		var res: Resource = ResourceLoader.load(path)
		if res == null:
			push_warning("Autoload setup: failed to load %s" % path)
			continue

		var node: Node = null
		if res is Script:
			var script := res as Script
			var base_type := script.get_instance_base_type()
			if not ClassDB.is_parent_class(base_type, "Node"):
				push_warning("Autoload setup: %s base %s is not a Node" % [path, base_type])
				continue
			node = ClassDB.instantiate(base_type) as Node
			if node == null:
				continue
			node.set_script(script)
		elif res is PackedScene:
			node = (res as PackedScene).instantiate() as Node
			if node == null:
				continue

		node.name = autoload_name
		root.add_child(node)

		var luau_lang = LuauScriptLanguage.get_singleton()
		if luau_lang:
			luau_lang.add_global_constant(autoload_name, node)

func _initialize() -> void:
	_setup_autoloads()

	var autowork = ClassDB.instantiate("Autowork")
	root.add_child(autowork)
	autowork.run_tests()
	quit(autowork.get_fail_count())
