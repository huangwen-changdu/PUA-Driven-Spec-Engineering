# Add project-level learning card and update LEARNING_INDEX.md.

param(
    [Parameter(Mandatory=$true)][ValidatePattern('^[a-z0-9][a-z0-9-]*$')][string]$Id,
    [Parameter(Mandatory=$true)][string]$Trigger,
    [Parameter(Mandatory=$true)][ValidateSet('session','project','global','skill','module')][string]$Scope,
    [Parameter(Mandatory=$true)][string]$Domain,
    [Parameter(Mandatory=$false)][ValidateRange(0.1, 1.0)][double]$Confidence = 0.5,
    [Parameter(Mandatory=$true)][string]$Lesson,
    [Parameter(Mandatory=$true)][string]$Action,
    [Parameter(Mandatory=$false)][string]$RelatedGraph = "",
    [Parameter(Mandatory=$false)][string[]]$RelatedFiles = @(),
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$Root = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$CopilotDir = Join-Path $Root ".copilot"
$IndexFile = Join-Path $CopilotDir "LEARNING_INDEX.md"
$CardsRoot = Join-Path $CopilotDir "cards"
$ScopeDir = if ($Scope -eq 'module') { Join-Path $CardsRoot "modules" } else { Join-Path $CardsRoot $Scope }
$CardFile = Join-Path $ScopeDir "$Id.md"
$Date = Get-Date -Format "yyyy-MM-dd"

New-Item -ItemType Directory -Path $ScopeDir -Force | Out-Null

if ((Test-Path $CardFile) -and -not $Force) {
    throw "Learning card already exists: $CardFile. Use -Force to overwrite."
}

$RelatedFilesText = if ($RelatedFiles.Count -gt 0) {
    ($RelatedFiles | ForEach-Object { "    - $_" }) -join "`r`n"
} else {
    "    - "
}

$Card = @"
---
id: $Id
trigger: $Trigger
scope: $Scope
domain: $Domain
confidence: $Confidence
related:
  files:
$RelatedFilesText
---

# $Trigger

## Lesson

$Lesson

## Next Action

$Action

## Not Applicable

- One-off business facts.
- Temporary context that does not match the trigger.

## Evidence

- Source: project learning
- Date: $Date
"@

Set-Content -Path $CardFile -Value $Card -Encoding utf8

if (-not (Test-Path $IndexFile)) {
    Set-Content -Path $IndexFile -Value "# Learning Index`r`n`r`n| id | trigger | scope | domain | confidence | related | file |`r`n|---|---|---|---|---:|---|---|`r`n`r`n## Read Rules`r`n" -Encoding utf8
}

$RelativeCard = $CardFile.Replace($CopilotDir + '\', '').Replace('\','/')
$Related = if ([string]::IsNullOrWhiteSpace($RelatedGraph)) { "-" } else { $RelatedGraph }
$Row = "| $Id | $Trigger | $Scope | $Domain | $Confidence | ``$Related`` | ``$RelativeCard`` |"
$IndexContent = Get-Content -Path $IndexFile -Raw -Encoding utf8

if ($IndexContent -match "\|\s*$([regex]::Escape($Id))\s*\|") {
    $IndexContent = [regex]::Replace($IndexContent, "(?m)^\|\s*$([regex]::Escape($Id))\s*\|.*$", [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $Row })
    Set-Content -Path $IndexFile -Value $IndexContent -Encoding utf8
    Write-Host "Index row updated: $Id" -ForegroundColor Cyan
} elseif ($IndexContent -match "(?m)^##\s+") {
    $IndexContent = [regex]::Replace($IndexContent, "(?m)^##\s+", [System.Text.RegularExpressions.MatchEvaluator]{ param($m) "$Row`r`n`r`n$($m.Value)" }, 1)
    Set-Content -Path $IndexFile -Value $IndexContent -Encoding utf8
} else {
    Add-Content -Path $IndexFile -Value $Row -Encoding utf8
}

Write-Host "Card created: $CardFile" -ForegroundColor Green
Write-Host "Index updated: $IndexFile" -ForegroundColor Cyan
