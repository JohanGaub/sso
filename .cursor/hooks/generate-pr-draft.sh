#!/usr/bin/env bash
set -euo pipefail

# Consume hook JSON payload from stdin (not needed for now).
cat >/dev/null || true

ROOT_DIR="$(pwd)"
OUTPUT_FILE="${ROOT_DIR}/.cursor/pr-draft.md"
TEMPLATE_FILE="${ROOT_DIR}/.github/pull_request_template.md"

# If the repository is clean, keep previous draft untouched.
if [[ -z "$(git status --short 2>/dev/null)" ]]; then
  exit 0
fi

BRANCH_NAME="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")"
CHANGED_FILES="$(git status --short | awk '{print $2}' | sed 's/^/- `/' | sed 's/$/`/')"
LAST_COMMITS="$(git log --oneline -n 5 2>/dev/null | sed 's/^/- /')"

{
  echo "# PR Draft (${BRANCH_NAME})"
  echo
  echo "_Generated automatically by Cursor hook: \`.cursor/hooks/generate-pr-draft.sh\`._"
  echo
  if [[ -f "${TEMPLATE_FILE}" ]]; then
    cat "${TEMPLATE_FILE}"
  else
    cat <<'EOF'
## Summary
- [ ] Explain the goal in 1-2 bullets
- [ ] Explain why this change is needed

## Changes
- [ ] List key code changes
- [ ] List impacted modules/areas

## Test plan
- [ ] `task quality`
- [ ] Relevant functional/integration tests
- [ ] Manual checks (if any): describe briefly

## Risks and rollback
- [ ] Risks identified (security, performance, data, behavior)
- [ ] Rollback strategy documented
EOF
  fi
  echo
  echo "## Auto-collected context"
  echo
  echo "### Changed files"
  echo "${CHANGED_FILES}"
  echo
  echo "### Last commits"
  echo "${LAST_COMMITS}"
  echo
  echo "### Diff summary"
  git diff --stat || true
} >"${OUTPUT_FILE}"

exit 0

