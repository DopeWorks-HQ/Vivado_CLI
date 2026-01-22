param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName
)

$ErrorActionPreference = "Stop"

$scriptDir   = Split-Path -Parent $MyInvocation.MyCommand.Path
$templateDir = Join-Path $scriptDir "Windows"
$projDir     = Join-Path $scriptDir $ProjectName
$projWinDir  = Join-Path $projDir "Windows"
$rtlDir      = Join-Path $projDir "rtl"

if (-not (Test-Path $templateDir)) {
    throw "Template folder not found: $templateDir"
}
if (Test-Path $projDir) {
    throw "Project '$ProjectName' already exists: $projDir"
}

New-Item -ItemType Directory -Path $projDir | Out-Null
New-Item -ItemType Directory -Path $rtlDir  | Out-Null

Copy-Item -Path $templateDir -Destination $projWinDir -Recurse -Force

# Only do @PROJECT@ replacement in likely-text files
$textExts = @(
    ".tcl", ".ys", ".ps1", ".bat", ".cmd", ".txt", ".md",
    ".v", ".sv", ".vh", ".svh", ".f", ".mk", ".make", ".json", ".yaml", ".yml"
)

Get-ChildItem -Path $projWinDir -Recurse -File | ForEach-Object {
    $path = $_.FullName
    $ext  = $_.Extension.ToLowerInvariant()

    if ($textExts -notcontains $ext) {
        return
    }

    $content = Get-Content -LiteralPath $path -Raw -ErrorAction Stop
    if ($null -eq $content) {
        return
    }

    $newContent = $content.Replace("@PROJECT@", $ProjectName)
    if ($newContent -ne $content) {
        Set-Content -LiteralPath $path -Value $newContent -Encoding UTF8
    }
}

Write-Host "Project '$ProjectName' created at: $projDir"
Write-Host "Next:"
Write-Host "  Put RTL in: $rtlDir"
Write-Host "  Use scripts in: $projWinDir"
