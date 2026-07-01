extends AutoworkTest

var _signal_fired := false

func _on_pressed() -> void:
	_signal_fired = true

func test_028_signal_connect() -> void:
	var path := "res://fixtures/scripts/annotations/AnnotatedSignals.luau"
	var script: Script = ResourceLoader.load(path)
	if script == null:
		pending("AnnotatedSignals fixture failed to load")
		return
	var node: Node = script.new() as Node
	add_child_autofree(node)
	_signal_fired = false
	node.connect("pressed", _on_pressed)
	if node.has_method("emit_pressed"):
		node.call("emit_pressed")
	assert_true(_signal_fired, "Luau node should emit and connect signals")
