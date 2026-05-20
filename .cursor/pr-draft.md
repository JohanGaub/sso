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
- `Taskfile.yml`
- `composer.json`
- `composer.lock`
- `config/reference.php`
- `"docs/3.0_Guide_migration_SAML_-_Gestion_priv\303\251e.confluence"`
- `docs/CONTRIBUTING.md`
- `hooks/pre-commit`
- `scripts/composer-audit.sh`
- `scripts/fix-composer-security.sh`

### Last commits
- 9690c67 docs(oidc-private): align guide with managed patterns and clarify pkce
- f5eca46 docs(guides): refine oidc managed guide and add cam to glossary
- 1fcb327 docs(synthesis): restructure glossary, routing table and prereq actors
- 53351fc docs(synthesis): restructure glossary and clarify prereq actors
- 4087ff0 docs(guides): clarify checklist pointers and saml prereq step 4

### Diff summary
 .cursor/pr-draft.md  |  11 +-
 Taskfile.yml         |  11 +-
 composer.json        |  30 +--
 composer.lock        | 606 ++++++++++++++++++++++++++-------------------------
 config/reference.php | 171 ++++++++-------
 docs/CONTRIBUTING.md |   6 +
 hooks/pre-commit     |   3 +-
 7 files changed, 435 insertions(+), 403 deletions(-)
