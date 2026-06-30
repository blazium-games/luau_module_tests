extends AutoworkTest

const EXPORTED_BINARY_WINDOWS := "d:/app_ports/blazium_luau/luau_module_tests/export/luau_module_tests.exe"
const EXPORTED_BINARY_LINUX := "d:/app_ports/blazium_luau/luau_module_tests/export/luau_module_tests"

func test_016_export_template_run() -> void:
	var binary_path := ""
	if OS.get_name() == "Windows":
		binary_path = EXPORTED_BINARY_WINDOWS
	else:
		binary_path = EXPORTED_BINARY_LINUX

	if !FileAccess.file_exists(binary_path):
		pending("No exported binary at %s — build template_debug export locally first".format([binary_path]))
		return

	var output: Array = []
	var exit_code: int = OS.execute(binary_path, ["--headless", "-s", "run_tests.gd"], output, true, true)
	assert_eq(exit_code, 0, "Exported binary headless test run should exit 0: %s".format([output]))
