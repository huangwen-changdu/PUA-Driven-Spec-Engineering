# Initialize project-level AI learning library.

param(
    [string]$ProjectName = "",
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$Root = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$Tool = Join-Path $env:USERPROFILE ".claude\skills\pua-learning-loop\scripts\init-copilot.ps1"
if (-not (Test-Path $Tool)) {
    throw "Missing global init tool: $Tool"
}

$params = @("-Root", $Root)
if (-not [string]::IsNullOrWhiteSpace($ProjectName)) {
    $params += @("-ProjectName", $ProjectName)
}
if ($Force) {
    $params += "-Force"
}

& powershell -NoProfile -ExecutionPolicy Bypass -File $Tool @params
