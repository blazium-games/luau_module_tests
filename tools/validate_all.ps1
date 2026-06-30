$ErrorActionPreference = "Stop"

function Resolve-BlaziumExe {
    if ($env:BLAZIUM_EXE -and (Test-Path $env:BLAZIUM_EXE)) {
        return $env:BLAZIUM_EXE
    }

    $repoRoot = Split-Path $PSScriptRoot -Parent
    $candidates = @(
        (Join-Path $repoRoot "..\blazium\bin\blazium.windows.editor.x86_64.console.exe"),
        (Join-Path $repoRoot "..\blazium\bin\blazium.windows.editor.x86_64.exe"),
        (Join-Path $repoRoot "..\blazium\bin\blazium.windows.editor.tests.x86_64.exe")
    )
    foreach ($candidate in $candidates) {
        $resolved = [System.IO.Path]::GetFullPath($candidate)
        if (Test-Path $resolved) {
            return $resolved
        }
    }

    return $null
}

function Resolve-TestProject {
    if ($env:TEST_PROJECT) {
        return $env:TEST_PROJECT
    }
    return (Split-Path $PSScriptRoot -Parent)
}

$BlaziumExe = Resolve-BlaziumExe
$TestProject = Resolve-TestProject

if (-not $BlaziumExe) {
    Write-Error "Blazium editor binary not found. Set BLAZIUM_EXE or build blazium locally."
}

Write-Host "=== Luau Module Validation Gate ===" -ForegroundColor Cyan
Write-Host "Editor:  $BlaziumExe" -ForegroundColor DarkGray
Write-Host "Project: $TestProject" -ForegroundColor DarkGray

$AwJunitArg = @()
if ($env:AW_JUNIT) {
    $junitDir = Split-Path $env:AW_JUNIT -Parent
    if ($junitDir -and -not (Test-Path $junitDir)) {
        New-Item -ItemType Directory -Force -Path $junitDir | Out-Null
    }
    $AwJunitArg = @("--aw-junit=$($env:AW_JUNIT)")
}

Write-Host "[1/5] Generate .luauc fixture (if missing)..." -ForegroundColor Yellow
$LuaucFixture = Join-Path $TestProject "fixtures\scripts\table_dsl\TableDslNode.luauc"
if (-not (Test-Path $LuaucFixture)) {
    & $BlaziumExe --headless --path $TestProject --script res://tools/generate_luauc_fixture.gd
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Could not generate .luauc fixture (exit code $LASTEXITCODE)"
    }
}

Write-Host "[2/5] C++ unit tests (tests=yes build)..." -ForegroundColor Yellow
$TestsBinary = $BlaziumExe -replace "\.console\.exe$", ".tests.x86_64.exe"
if ($TestsBinary -eq $BlaziumExe) {
    $TestsBinary = Join-Path (Split-Path $BlaziumExe -Parent) "blazium.windows.editor.tests.x86_64.exe"
}
$TestsConsole = $TestsBinary -replace "\.tests\.x86_64\.exe$", ".tests.x86_64.console.exe"
if (Test-Path $TestsConsole) {
    $TestsBinary = $TestsConsole
}
if (Test-Path $TestsBinary) {
    & $TestsBinary --test --test-filter="[LuauModule]"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Luau module C++ tests failed with exit code $LASTEXITCODE"
    }
} else {
    Write-Warning "Tests binary not found ($TestsBinary); skipping C++ LuauModule filter"
}

Write-Host "[3/5] Autowork GDScript suite..." -ForegroundColor Yellow
$prevEap = $ErrorActionPreference
$ErrorActionPreference = "Continue"
& $BlaziumExe --headless --path $TestProject --script res://run_tests.gd @AwJunitArg 2>&1 | Out-Host
$awExit = $LASTEXITCODE
$ErrorActionPreference = $prevEap
if ($awExit -ne 0) {
    Write-Error "Autowork GDScript suite failed with exit code $awExit"
}

Write-Host "[4/5] Autowork Luau discovery smoke..." -ForegroundColor Yellow
$ErrorActionPreference = "Continue"
& $BlaziumExe --headless --path $TestProject --script res://run_tests.gd --aw-file=res://tests/test_022_autowork_luau_discovery.gd 2>&1 | Out-Host
$luauExit = $LASTEXITCODE
$ErrorActionPreference = $prevEap
if ($luauExit -ne 0) {
    Write-Error "Autowork Luau discovery test failed with exit code $luauExit"
}

Write-Host "[5/5] Export template smoke (optional, soft-gate)..." -ForegroundColor Yellow
Write-Host "  Luau export: compile_bytecode + strip_source in EditorExportLuau; Text script mode skips .luauc" -ForegroundColor DarkGray
Write-Host "  Templates can be fetched via: blazium-cli --download --template-file ..." -ForegroundColor DarkGray
$ExportScript = Join-Path $PSScriptRoot "export_and_run.ps1"
$ExportBinary = Join-Path $TestProject "export\luau_module_tests.exe"
if (-not (Test-Path $ExportBinary)) {
    Write-Warning "Export binary missing ($ExportBinary) - test_016 remains pending until template_debug export"
}
if (Test-Path $ExportScript) {
    $env:BLAZIUM_EXE = $BlaziumExe
    $env:TEST_PROJECT = $TestProject
    & $ExportScript
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Export smoke failed - run manually after template_debug build"
    }
}

Write-Host "Validation gate passed." -ForegroundColor Green
