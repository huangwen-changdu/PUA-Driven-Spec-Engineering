# init-copilot.ps1
# Initialize project-level .copilot learning data AND .github agent-customization
# files in the target repository.
# IMPORTANT: This script must be ASCII-only. Windows PowerShell 5.1 reads
# BOM-less .ps1 files with the system ANSI codepage, which corrupts any
# non-ASCII literal embedded in here-strings. All user-facing text that
# needs CJK should be injected at runtime by the AI agent, not by this script.

param(
    [Parameter(Mandatory=$false)]
    [string]$Root = (Get-Location).Path,

    [Parameter(Mandatory=$false)]
    [string]$ProjectName = "",

    [switch]$Force
)

$ErrorActionPreference = "Stop"
$Root = (Resolve-Path $Root).Path
if ([string]::IsNullOrWhiteSpace($ProjectName)) {
    $ProjectName = Split-Path $Root -Leaf
}

# ============================================================
# 1. Create directory structures
# ============================================================

$CopilotDir = Join-Path $Root ".copilot"
$GitHubDir = Join-Path $Root ".github"
$Dirs = @(
    $CopilotDir,
    (Join-Path $CopilotDir "commands"),
    (Join-Path $CopilotDir "cards\global"),
    (Join-Path $CopilotDir "cards\project"),
    (Join-Path $CopilotDir "cards\modules"),
    (Join-Path $CopilotDir "snapshots"),
    (Join-Path $CopilotDir "archive"),
    (Join-Path $GitHubDir "instructions"),
    (Join-Path $GitHubDir "prompts")
)

foreach ($Dir in $Dirs) {
    New-Item -ItemType Directory -Path $Dir -Force | Out-Null
}

# ============================================================
# 2. Helper: write only if missing or -Force
# ============================================================

function Write-IfMissingOrForce {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Content
    )

    if ($Force -or -not (Test-Path $Path)) {
        Set-Content -Path $Path -Value $Content -Encoding utf8
        Write-Host "WRITE: $Path" -ForegroundColor Green
    }
    else {
        Write-Host "SKIP existing: $Path" -ForegroundColor DarkYellow
    }
}

# ============================================================
# 3. Detect project metadata
# ============================================================

$Solution = Get-ChildItem -Path $Root -Filter "*.sln" -File -ErrorAction SilentlyContinue | Select-Object -First 1
$SrcDir = Join-Path $Root "src"
$Csproj = if (Test-Path $SrcDir) {
    Get-ChildItem -Path $SrcDir -Filter "*.csproj" -File -Recurse -ErrorAction SilentlyContinue
} else {
    Get-ChildItem -Path $Root -Filter "*.csproj" -File -Recurse -ErrorAction SilentlyContinue
}
$MainProject = $Csproj | Where-Object { $_.FullName -notmatch "Tests|Test" } | Select-Object -First 1
$TestProject = $Csproj | Where-Object { $_.FullName -match "Tests|Test" } | Select-Object -First 1
$Date = Get-Date -Format "yyyy-MM-dd"

function Relative-OrEmpty {
    param([object]$Item)
    if ($null -eq $Item) { return "" }
    return $Item.FullName.Replace($Root + '\', '')
}

$SolutionName = if ($null -eq $Solution) { "" } else { $Solution.Name }
$MainProjectPath = Relative-OrEmpty $MainProject
$TestProjectPath = Relative-OrEmpty $TestProject
$HasGraphReport = $false

# ============================================================
# 4. .copilot/ content templates
# ============================================================

$Readme = @"
# .copilot Project Learning Library

This directory stores project-level AI learning data.

## Progressive Disclosure

1. Normal task: read ``PROJECT_BRIEF.md`` if needed.
2. Learning signal: read ``LEARNING_INDEX.md``.
3. Trigger match: read only the matched ``cards/**/*.md``.
4. Architecture or impact question: search code and read project docs.

## Commands

``````powershell
.\.copilot\commands\init-project-learning.ps1 -Force
.\.copilot\commands\add-learning-card.ps1 -Id "example" -Trigger "signal text" -Scope "project" -Domain "workflow" -Lesson "lesson text" -Action "next time do Y, not Z"
``````
"@

$ProjectBrief = @"
# $ProjectName

> This file stores project metadata and data source index only. Collaboration rules live in ``AGENTS.md``, coding conventions in project-level instruction files.

## Basic Info

- Project: ``$ProjectName``
- Solution: ``$SolutionName``
- Main Project: ``$MainProjectPath``
- Test Project: ``$TestProjectPath``
- AI Flow: ``superpowers-pua``

## Data Source Index

| Source | Path | Responsibility | When to Read |
|--------|------|----------------|-------------|
| Collaboration Rules | ``AGENTS.md`` | Skill flow, user rules, read policy | Startup |
| Coding Conventions | Project instruction files | Auto-loaded by applyTo | Editing matching files |
| Code Structure | Project docs / code search | Module relations, impact surface | Architecture / cross-module questions |
| Learning Index | ``.copilot/LEARNING_INDEX.md`` | Pitfall index | Learning signal triggered |
| Learning Cards | ``.copilot/cards/**/*.md`` | Specific lessons and next actions | Index trigger matched |

Initialized: $Date
"@

$LearningIndex = @"
# Learning Index

> Progressive disclosure index. Read this file first; read card body only when trigger matches.

| id | trigger | scope | domain | confidence | related | file |
|---|---|---|---|---:|---|---|
| project-init | Initialize project learning library; explain .copilot scope | project | workflow | 0.5 | - | ``cards/project/project-init.md`` |

## Read Rules

- Do not read learning cards without user correction, repeated failure, workflow deviation, missing verification, or project convention question.
- Read only cards matching trigger/domain/related.
- Do not full-read ``cards/**`` or ``archive/**`` at startup.
- Repeated match raises confidence; 3+ matches can promote to ``AGENTS.md``, CodeBuddy ``RULE.mdc``, or PUA skill.
"@

$ProjectInitCard = @"
---
id: project-init
trigger: Initialize project learning library; explain .copilot scope
scope: project
domain: workflow
confidence: 0.5
related:
  files:
    - .copilot/PROJECT_BRIEF.md
    - .copilot/LEARNING_INDEX.md
---

# Project learning library initialized

## Lesson

Project learning data should stay small at startup: index first, card on match, graph for structure.

## Next Action

When initializing a project, handling learning signals, or encountering repeated pitfalls: read ``.copilot/LEARNING_INDEX.md`` first, then read the matched card only. Do not full-read ``cards/**``.

## Not Applicable

- One-off business facts.
- Pure architecture lookup without a learning signal.

## Evidence

- Source: ``pua-learning-loop`` initialization
- Date: $Date
"@

$ProjectStructure = @"
# Project Structure Snapshot

> Lightweight snapshot generated by ``.copilot`` initialization.

## Root

``````text
$Root
+-- AGENTS.md
+-- $SolutionName
+-- README.md
+-- docs/
+-- src/
+-- .copilot/
+-- .github/
    +-- instructions/
    +-- prompts/
``````

## Projects

- Solution: ``$SolutionName``
- Main Project: ``$MainProjectPath``
- Test Project: ``$TestProjectPath``

## Usage

- Project entry: read this file or ``PROJECT_BRIEF.md``.
- Architecture relations: search code or read project architecture docs.
- Historical pitfalls: read ``.copilot/LEARNING_INDEX.md``, then matched card.

Initialized: $Date
"@

$AddLearningCard = @'
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
'@

$LocalInit = @'
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
'@

# ============================================================
# 5. .github/instructions/ content templates
# ============================================================

$CodingStyleInstructions = @"
---
applyTo: "**"
description: "General coding style rules for this project"
---

# Coding Style

## Language

- Keep identifiers, error messages, API paths, and log messages in English.
- Comments and docs may use the team's working language.

## Naming

- Follow the project's existing naming conventions.
- Be consistent with the patterns already in the codebase.

## Patterns

- Prefer composition over inheritance.
- Use dependency injection where the project framework supports it.
- Keep methods short and focused; extract when they grow too long.
- Early return / guard clause over deep nesting.

## Comments

- Comment only: business rules, boundary conditions, non-obvious implementation reasons.
- Do not comment obvious code; rename to clarify instead.
"@

$ModelInstructions = @"
---
applyTo: "**/Model/**,**/Entity/**,**/Dto/**,**/Vo/**,**/Input/**"
description: "Model / Entity / DTO layer conventions"
---

# Model Layer Rules

## Entity Conventions

- Follow the project's existing ORM and entity patterns.
- Keep entity classes as pure data containers; do not put business logic in entities.
- Use the project's base class if one exists for audit fields.

## DTO Conventions

- Keep DTOs flat; avoid nested DTOs unless the API shape requires it.
- Use the project's naming patterns for read vs write DTOs.

## File Organization

- One type per file.
- File name matches type name.
"@

$RepositoryInstructions = @"
---
applyTo: "**/Repository/**"
description: "Repository layer conventions"
---

# Repository Layer Rules

## Class Structure

- One repository per aggregate root or entity group.
- Use constructor injection for data access dependencies.
- Keep repository stateless; caching belongs in a separate layer.

## Query Patterns

- Use the project's query patterns consistently.
- Prefer typed query builders over raw SQL where possible.
- Use deterministic ordering for paginated results.

## Transactions

- Keep transaction scope as small as possible.
- Do not call external services inside a transaction.
"@

$ServiceInstructions = @"
---
applyTo: "**/Service/**"
description: "Service layer conventions"
---

# Service Layer Rules

## Class Structure

- One service per business domain.
- Use constructor injection for dependencies.
- Follow the project's DI registration conventions.

## Method Design

- Service methods orchestrate repository calls and enforce business rules.
- Do not leak data access details through the service interface.
- Return DTOs or domain types, not entity objects.
- Throw meaningful exceptions; add context when wrapping lower-level exceptions.

## Transaction Pattern

- When a method modifies multiple aggregates, wrap in a transaction at the service layer.
- Do not open transactions in repositories for cross-entity operations.
"@

# ============================================================
# 6. .github/prompts/ content templates
# ============================================================

$NewApiPrompt = @"
---
mode: "agent"
description: "Scaffold a new API endpoint following project conventions"
---

# New API Endpoint

## Instructions

You are creating a new API endpoint for this project. Follow these steps in order:

1. **Entity**: Create or reuse a data entity following the project's existing patterns.

2. **DTO**: Create request/response DTOs following the project's naming conventions.

3. **Repository**: Create a repository class following the project's data access patterns.

4. **Service**: Create a service class that orchestrates repository calls and enforces business rules.

5. **Controller/Handler**: Create an API endpoint following the project's routing and auth conventions.

6. **DI Registration**: Register the new service and repository in the DI container.

## Rules

- Follow the project's existing patterns for each layer.
- Read the relevant instruction files before writing code.
- Keep each layer's responsibilities clear; do not leak concerns across layers.
"@

$NewServicePrompt = @"
---
mode: "agent"
description: "Scaffold a new service class with DI registration"
---

# New Service

## Instructions

You are creating a new service class for this project. Follow these steps:

1. **Choose Base Class**: Determine the correct base class or pattern based on existing services in the project.

2. **Create Service Class**: Follow the project's directory structure and naming conventions.
   - Use constructor injection for dependencies.
   - Define clear method signatures returning DTOs or domain types.
   - Keep methods focused on a single business operation.

3. **DI Registration**: Register in the DI container following the project's conventions.

4. **Error Handling**: Define or reuse appropriate exception types.
   - Do not swallow exceptions silently.
   - Add context when wrapping lower-level exceptions.

## Rules

- Follow the project's existing service patterns.
- Do not add repository logic in the service; delegate to repository methods.
"@

# ============================================================
# 7. Write all files
# ============================================================

# --- .copilot/ ---
Write-IfMissingOrForce -Path (Join-Path $CopilotDir "README.md") -Content $Readme
Write-IfMissingOrForce -Path (Join-Path $CopilotDir "PROJECT_BRIEF.md") -Content $ProjectBrief
Write-IfMissingOrForce -Path (Join-Path $CopilotDir "LEARNING_INDEX.md") -Content $LearningIndex
Write-IfMissingOrForce -Path (Join-Path $CopilotDir "cards\project\project-init.md") -Content $ProjectInitCard
Write-IfMissingOrForce -Path (Join-Path $CopilotDir "snapshots\project-structure.md") -Content $ProjectStructure
Write-IfMissingOrForce -Path (Join-Path $CopilotDir "commands\add-learning-card.ps1") -Content $AddLearningCard
Write-IfMissingOrForce -Path (Join-Path $CopilotDir "commands\init-project-learning.ps1") -Content $LocalInit

# --- .github/instructions/ ---
Write-IfMissingOrForce -Path (Join-Path $GitHubDir "instructions\coding-style.instructions.md") -Content $CodingStyleInstructions
Write-IfMissingOrForce -Path (Join-Path $GitHubDir "instructions\model.instructions.md") -Content $ModelInstructions
Write-IfMissingOrForce -Path (Join-Path $GitHubDir "instructions\repository.instructions.md") -Content $RepositoryInstructions
Write-IfMissingOrForce -Path (Join-Path $GitHubDir "instructions\service.instructions.md") -Content $ServiceInstructions

# --- .github/prompts/ ---
Write-IfMissingOrForce -Path (Join-Path $GitHubDir "prompts\new-api.prompt.md") -Content $NewApiPrompt
Write-IfMissingOrForce -Path (Join-Path $GitHubDir "prompts\new-service.prompt.md") -Content $NewServicePrompt

Write-Host ""
Write-Host "POST-INIT: Run agent-customization-pua skill to review/create agent customization files (AGENTS.md, .instructions.md, .prompt.md, .agent.md, SKILL.md)." -ForegroundColor Magenta
Write-Host "INIT done: $CopilotDir + $GitHubDir" -ForegroundColor Cyan
