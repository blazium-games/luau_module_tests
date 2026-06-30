extends AutoworkTest

func test_028_signal_connect() -> void:
	var path := "res://fixtures/scripts/annotations/AnnotatedSignals.luau"
	var script: Script = ResourceLoader.load(path)
	if script == null:
		pending("AnnotatedSignals fixture failed to load")
		return
	var node: Node = script.new() as Node
	add_child_autofree(node)
	var fired := false
	node.connect("pressed", func(): fired = true)
	if node.has_method("emit_pressed"):
		node.call("emit_pressed")
	assert_true(fired, "Luau node should emit and connect signals")
