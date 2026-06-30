# luau_module_tests

Autowork integration tests for the Blazium Engine **Luau** built-in module.

## Requirements

Build Blazium with:

```powershell
python -m SCons platform=windows target=editor module_luau_module_enabled=yes module_autowork_enabled=yes tests=yes
```

Use a build from a branch that includes `modules/luau_module`.

## Run locally

```powershell
blazium --headless --path . -s run_tests.gd
```

Filter a single test:

```powershell
blazium --headless --path . --aw-test=test_007_require
```

CI exports JUnit to `results/junit.xml` on failure.

## Fixtures

| Path | Purpose |
|------|---------|
| `fixtures/scripts/table_dsl/` | Table DSL scripts |
| `fixtures/scripts/gdclass/` | Annotation + `gdclass()` syntax |
| `fixtures/scripts/require/` | `require()` modules |

Exit code equals the Autowork fail count (`0` = pass).
