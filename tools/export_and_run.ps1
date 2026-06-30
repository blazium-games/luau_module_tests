$ErrorActionPreference = "Stop"
$TestProject = if ($env:TEST_PROJECT) { $env:TEST_PROJECT } else { Split-Path $PSScriptRoot -Parent }
$BlaziumExe = if ($env:BLAZIUM_EXE) {
    $env:BLAZIUM_EXE
} else {
    Join-Path (Split-Path $TestProject -Parent) "blazium\bin\blazium.windows.editor.x86_64.console.exe"
}
$ExportDir = Join-Path $TestProject "export"
$ExportBinary = Join-Path $ExportDir "luau_module_tests.exe"

if (-not (Test-Path $BlaziumExe)) {
    Write-Warning "Editor binary not found; skipping export smoke"
    exit 0
}

if (-not (Test-Path $ExportBinary)) {
    Write-Host "No exported binary at $ExportBinary - export manually with template_debug" -ForegroundColor Yellow
    exit 0
}

Write-Host "Running exported binary smoke test..." -ForegroundColor Yellow
& $ExportBinary --headless -s "run_tests.gd"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Exported binary failed with exit code $LASTEXITCODE"
}
Write-Host "Export smoke passed." -ForegroundColor Green
