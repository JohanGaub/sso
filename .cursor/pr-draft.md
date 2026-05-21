# PR Draft (develop-sso)

_Generated automatically by Cursor hook: `.cursor/hooks/generate-pr-draft.sh`._

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

## Checklist
- [ ] Commit messages follow Conventional Commits
- [ ] No secrets committed
- [ ] Docs updated if needed (`docs/README.md`, `docs/INDEX_DOCUMENTATION.md`)
- [ ] Rules/subagents/docs remain coherent when changed


## Auto-collected context

### Changed files
- `.cursor/pr-draft.md`
- `composer.json`
- `composer.lock`

### Last commits
- 029956e fix(docs): escape asterisk in confluence wiki markup to fix import errors
- 64ce7ee docs(confluence): fix wiki markup for confluence import
- edf6b60 chore(deps): allow phpunit 13.1.10 and refresh lock file
- a8a75ef docs(saml-private): align guide with oidc private patterns and fix numbering
- 04a106f feat(quality): add composer audit scripts and manual audit:fix task

### Diff summary
 .cursor/pr-draft.md | 14 +++-----------
 composer.json       |  2 +-
 composer.lock       | 40 ++++++++++++++++++++--------------------
 3 files changed, 24 insertions(+), 32 deletions(-)
