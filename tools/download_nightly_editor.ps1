param(
    [string]$EngineVersion = "",
    [string]$DownloadsDir = "",
    [string]$EditorRoot = ""
)

$ErrorActionPreference = "Stop"

if (-not $DownloadsDir) {
    $DownloadsDir = Join-Path (Get-Location) "downloads"
}
if (-not $EditorRoot) {
    $EditorRoot = Join-Path (Get-Location) "blazium_editor"
}

function Get-LatestNightlyVersion {
    $entries = Invoke-RestMethod -Uri "https://blazium.app/api/versions/data/nightly"
    $best = $null
    foreach ($entry in $entries) {
        if (-not $best) {
            $best = $entry.version
            continue
        }
        $bestParts = $best -split '\.' | ForEach-Object { [int]$_ }
        $entryParts = $entry.version -split '\.' | ForEach-Object { [int]$_ }
        for ($i = 0; $i -lt [Math]::Max($bestParts.Count, $entryParts.Count); $i++) {
            $bv = if ($i -lt $bestParts.Count) { $bestParts[$i] } else { 0 }
            $ev = if ($i -lt $entryParts.Count) { $entryParts[$i] } else { 0 }
            if ($ev -gt $bv) {
                $best = $entry.version
                break
            }
            if ($ev -lt $bv) {
                break
            }
        }
    }
    if (-not $best) {
        throw "Could not resolve latest nightly engine version."
    }
    return $best
}

function Select-WindowsEditorEntry {
    param([array]$Entries, [string]$Version)

    $candidates = @($Entries | Where-Object {
        $name = $_.filename.ToLower()
        $name -like "*$($Version.ToLower())*" -and
        $name -like "*windows*" -and
        ($name -like "*64bit*" -or $name -like "*x86_64*") -and
        $name -notlike "*mono*"
    })
    if ($candidates.Count -eq 0) {
        throw "No Windows x86_64 editor entry found for version $Version."
    }
    return $candidates[0]
}

function Find-BlaziumEditorExe {
    param([string]$Root)

    $allExe = Get-ChildItem $Root -Recurse -Filter "*.exe" -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -notmatch '^(D3D12|d3d12|vulkan|openvr)' }

    $console = $allExe | Where-Object {
        $_.Name -like "*.console.exe" -and
        ($_.Name -like "BlaziumEditor*" -or $_.Name -like "blazium.windows.editor*")
    } | Select-Object -First 1
    if ($console) {
        return $console
    }

    $editor = $allExe | Where-Object {
        ($_.Name -like "BlaziumEditor*" -or $_.Name -like "blazium.windows.editor*") -and
        $_.Name -notlike "*.console.exe"
    } | Select-Object -First 1
    if ($editor) {
        return $editor
    }

    return $null
}

function Write-Log {
    param([string]$Message)
    [Console]::Error.WriteLine($Message)
}

$resolvedVersion = if ($EngineVersion) { $EngineVersion } else { Get-LatestNightlyVersion }
Write-Log "Using Blazium engine version: $resolvedVersion"

$editorsUrl = "https://cdn.blazium.app/nightly/$resolvedVersion/editors.json"
$editors = Invoke-RestMethod -Uri $editorsUrl
$entry = Select-WindowsEditorEntry -Entries $editors -Version $resolvedVersion

New-Item -ItemType Directory -Force -Path $DownloadsDir | Out-Null
$zipPath = Join-Path $DownloadsDir ([IO.Path]::GetFileName($entry.download_url))
Write-Log "Downloading editor from $($entry.download_url)"
Invoke-WebRequest -Uri $entry.download_url -OutFile $zipPath

New-Item -ItemType Directory -Force -Path $EditorRoot | Out-Null
Expand-Archive -Path $zipPath -DestinationPath $EditorRoot -Force

$exe = Find-BlaziumEditorExe -Root $EditorRoot
if (-not $exe) {
    Write-Log "Extracted editor contents:"
    Get-ChildItem $EditorRoot -Recurse | ForEach-Object { Write-Log $_.FullName }
    throw "No Blazium editor binary found under $EditorRoot"
}

Write-Log "Using editor: $($exe.FullName)"
Write-Output $exe.FullName
