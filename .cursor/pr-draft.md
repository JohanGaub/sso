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
- `composer.json`
- `composer.lock`

### Last commits
- a8a75ef docs(saml-private): align guide with oidc private patterns and fix numbering
- 04a106f feat(quality): add composer audit scripts and manual audit:fix task
- 17fdc46 fix(deps): bump symfony and twig to address security advisories
- 9690c67 docs(oidc-private): align guide with managed patterns and clarify pkce
- f5eca46 docs(guides): refine oidc managed guide and add cam to glossary

### Diff summary
 .cursor/pr-draft.md |  22 +-
 composer.json       |   2 +-
 composer.lock       | 562 ++++++++++++++++++++++++++++++++++------------------
 3 files changed, 369 insertions(+), 217 deletions(-)
