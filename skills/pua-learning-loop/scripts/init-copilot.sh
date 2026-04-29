#!/usr/bin/env bash
# init-copilot.sh
# Initialize project-level .copilot learning data AND .github agent-customization
# files in the target repository.
# Cross-platform alternative to init-copilot.ps1 for Linux/macOS.

set -euo pipefail

ROOT="${1:-$(pwd)}"
PROJECT_NAME="${2:-}"
FORCE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -Root) ROOT="$2"; shift 2 ;;
    -ProjectName) PROJECT_NAME="$2"; shift 2 ;;
    -Force) FORCE=true; shift ;;
    *) shift ;;
  esac
done

ROOT="$(cd "$ROOT" && pwd)"
if [[ -z "$PROJECT_NAME" ]]; then
  PROJECT_NAME="$(basename "$ROOT")"
fi

DATE="$(date +%Y-%m-%d)"

# ============================================================
# 1. Create directory structures
# ============================================================

COPILOT_DIR="$ROOT/.copilot"
GITHUB_DIR="$ROOT/.github"

mkdir -p "$COPILOT_DIR"/{commands,cards/{global,project,modules},snapshots,archive}
mkdir -p "$GITHUB_DIR"/{instructions,prompts}

# ============================================================
# 2. Helper: write only if missing or -Force
# ============================================================

write_if_missing() {
  local path="$1"
  local content="$2"
  if $FORCE || [[ ! -f "$path" ]]; then
    echo "$content" > "$path"
    echo "WRITE: $path"
  else
    echo "SKIP existing: $path"
  fi
}

# ============================================================
# 3. Detect project metadata
# ============================================================

SOLUTION_FILE="$(find "$ROOT" -maxdepth 1 -name "*.sln" -type f 2>/dev/null | head -1)"
SOLUTION_NAME="$(basename "${SOLUTION_FILE:-}")"

# Try to detect main/test project
MAIN_PROJECT=""
TEST_PROJECT=""
if [[ -d "$ROOT/src" ]]; then
  MAIN_PROJECT="$(find "$ROOT/src" -name "*.csproj" -not -path "*/Test*" -type f 2>/dev/null | head -1)"
  TEST_PROJECT="$(find "$ROOT/src" -name "*.csproj" -path "*/Test*" -type f 2>/dev/null | head -1)"
fi
if [[ -z "$MAIN_PROJECT" ]]; then
  MAIN_PROJECT="$(find "$ROOT" -maxdepth 3 -name "*.csproj" -not -path "*/Test*" -type f 2>/dev/null | head -1)"
  TEST_PROJECT="$(find "$ROOT" -maxdepth 3 -name "*.csproj" -path "*/Test*" -type f 2>/dev/null | head -1)"
fi

MAIN_PROJECT="${MAIN_PROJECT#"${ROOT}/"}"
TEST_PROJECT="${TEST_PROJECT#"${ROOT}/"}"

GRAPH_REPORT=""
HAS_GRAPH_REPORT=false

# ============================================================
# 4. .copilot/ content templates
# ============================================================

write_if_missing "$COPILOT_DIR/README.md" \
"# .copilot Project Learning Library

This directory stores project-level AI learning data.

## Progressive Disclosure

1. Normal task: read \`PROJECT_BRIEF.md\` if needed.
2. Learning signal: read \`LEARNING_INDEX.md\`.
3. Trigger match: read only the matched \`cards/**/*.md\`.
4. Architecture or impact question: search code and read project docs.

## Commands

\`\`\`bash
./.copilot/commands/init-project-learning.sh -Force
./.copilot/commands/add-learning-card.sh -Id \"example\" -Trigger \"signal text\" -Scope \"project\" -Domain \"workflow\" -Lesson \"lesson text\" -Action \"next time do Y, not Z\"
\`\`\`
"

write_if_missing "$COPILOT_DIR/PROJECT_BRIEF.md" \
"# $PROJECT_NAME

> This file stores project metadata and data source index only. Collaboration rules live in \`AGENTS.md\`, coding conventions in project-level instruction files.

## Basic Info

- Project: \`$PROJECT_NAME\`
- Solution: \`$SOLUTION_NAME\`
- Main Project: \`$MAIN_PROJECT\`
- Test Project: \`$TEST_PROJECT\`
- AI Flow: \`superpowers-pua\`

## Data Source Index

| Source | Path | Responsibility | When to Read |
|--------|------|----------------|-------------|
| Collaboration Rules | \`AGENTS.md\` | Skill flow, user rules, read policy | Startup |
| Coding Conventions | Project instruction files | Auto-loaded by applyTo | Editing matching files |
| Code Structure | Project docs / code search | Module relations, impact surface | Architecture / cross-module questions |
| Learning Index | \`.copilot/LEARNING_INDEX.md\` | Pitfall index | Learning signal triggered |
| Learning Cards | \`.copilot/cards/**/*.md\` | Specific lessons and next actions | Index trigger matched |

Initialized: $DATE
"

write_if_missing "$COPILOT_DIR/LEARNING_INDEX.md" \
"# Learning Index

> Progressive disclosure index. Read this file first; read card body only when trigger matches.

| id | trigger | scope | domain | confidence | related | file |
|---|---|---|---|---:|---|---|
| project-init | Initialize project learning library; explain .copilot scope | project | workflow | 0.5 | - | \`cards/project/project-init.md\` |

## Read Rules

- Do not read learning cards without user correction, repeated failure, workflow deviation, missing verification, or project convention question.
- Read only cards matching trigger/domain/related.
- Do not full-read \`cards/**\` or \`archive/**\` at startup.
- Repeated match raises confidence; 3+ matches can promote to \`AGENTS.md\`, CodeBuddy \`RULE.mdc\`, or PUA skill.
"

write_if_missing "$COPILOT_DIR/cards/project/project-init.md" \
"---
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

When initializing a project, handling learning signals, or encountering repeated pitfalls: read \`.copilot/LEARNING_INDEX.md\` first, then read the matched card only. Do not full-read \`cards/**\`.

## Not Applicable

- One-off business facts.
- Pure architecture lookup without a learning signal.

## Evidence

- Source: \`pua-learning-loop\` initialization
- Date: $DATE
"

write_if_missing "$COPILOT_DIR/snapshots/project-structure.md" \
"# Project Structure Snapshot

> Lightweight snapshot generated by \`.copilot\` initialization.

## Root

\`\`\`text
$ROOT
+-- AGENTS.md
+-- README.md
+-- docs/
+-- src/
+-- .copilot/
+-- .github/
    +-- instructions/
    +-- prompts/
\`\`\`

## Projects

- Solution: \`$SOLUTION_NAME\`
- Main Project: \`$MAIN_PROJECT\`
- Test Project: \`$TEST_PROJECT\`

## Usage

- Project entry: read this file or \`PROJECT_BRIEF.md\`.
- Architecture relations: search code or read project architecture docs.
- Historical pitfalls: read \`.copilot/LEARNING_INDEX.md\`, then matched card.

Initialized: $DATE
"

# --- .github/instructions/ ---

write_if_missing "$GITHUB_DIR/instructions/coding-style.instructions.md" \
"---
applyTo: \"**\"
description: \"General coding style rules for this project\"
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
"

write_if_missing "$GITHUB_DIR/instructions/model.instructions.md" \
"---
applyTo: \"**/Model/**,**/Entity/**,**/Dto/**,**/Vo/**,**/Input/**\"
description: \"Model / Entity / DTO layer conventions\"
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
"

write_if_missing "$GITHUB_DIR/instructions/repository.instructions.md" \
"---
applyTo: \"**/Repository/**\"
description: \"Repository layer conventions\"
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
"

write_if_missing "$GITHUB_DIR/instructions/service.instructions.md" \
"---
applyTo: \"**/Service/**\"
description: \"Service layer conventions\"
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
"

# --- .github/prompts/ ---

write_if_missing "$GITHUB_DIR/prompts/new-api.prompt.md" \
"---
mode: \"agent\"
description: \"Scaffold a new API endpoint following project conventions\"
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
"

write_if_missing "$GITHUB_DIR/prompts/new-service.prompt.md" \
"---
mode: \"agent\"
description: \"Scaffold a new service class with DI registration\"
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
"

echo ""
echo "POST-INIT: Run agent-customization-pua skill to review/create agent customization files (AGENTS.md, .instructions.md, .prompt.md, .agent.md, SKILL.md)."
echo "INIT done: $COPILOT_DIR + $GITHUB_DIR"
