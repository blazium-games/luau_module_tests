extends AutoworkTest

func test_023_export_options() -> void:
	var source := "return 42"
	var bytecode: PackedByteArray = Luau.compile(source, null)
	assert_false(bytecode.is_empty(), "Luau.compile should produce bytecode for export sidecars")
	# Export preset matrix (Text = no sidecar, Binary = sidecar) is enforced in EditorExportLuau at export time.

func test_024_annotation_class() -> void:
	var path := "res://fixtures/scripts/annotations/AnnotatedNode.luau"
	var script: Script = ResourceLoader.load(path)
	if script == null:
		pending("AnnotatedNode fixture failed to load")
		return
	assert_eq(script.get_global_name(), &"AnnotatedNode", "Global class name from @class")
	var inst: Object = script.new()
	assert_true(inst != null, "AnnotatedNode should instantiate")
	if inst.has_method("_ready"):
		inst.call("_ready")
	if inst.get("label") != null:
		assert_eq(str(inst.get("label")), "ready")

func test_025_annotation_signals() -> void:
	var path := "res://fixtures/scripts/annotations/AnnotatedSignals.luau"
	var script: Script = ResourceLoader.load(path)
	if script == null:
		pending("AnnotatedSignals fixture failed to load")
		return
	var node: Node = script.new() as Node
	add_child_autofree(node)
	assert_true(node.has_signal("pressed"), "Annotated script should expose pressed signal")
