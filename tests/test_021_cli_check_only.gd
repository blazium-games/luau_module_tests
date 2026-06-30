extends AutoworkTest

const VALID := "res://fixtures/scripts/table_dsl/TableDslNode.luau"
const INVALID := "res://fixtures/scripts/invalid_syntax.luau"

func test_021_cli_check_only() -> void:
	if !ClassDB.class_exists("LuauScript"):
		pending("LuauScript not registered yet")
		return

	var exe := OS.get_executable_path()
	var project := ProjectSettings.globalize_path("res://")

	var valid_out: Array = []
	var valid_code := OS.execute(exe, ["--headless", "--path", project, "--check-only", "-s", VALID], valid_out, true, true)
	assert_eq(valid_code, 0, "Valid Luau script should pass --check-only")

	if !FileAccess.file_exists(INVALID):
		var f := FileAccess.open(INVALID, FileAccess.WRITE)
		f.store_string("local x = { return\n")
		f.close()

	var invalid_out: Array = []
	var invalid_code := OS.execute(exe, ["--headless", "--path", project, "--check-only", "-s", INVALID], invalid_out, true, true)
	assert_ne(invalid_code, 0, "Invalid Luau script should fail --check-only")
