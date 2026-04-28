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
- `docs/0_GUIDE_MIGRATION_SSO_SYNTHESE.confluence`
- `docs/1_GUIDE_MIGRATION_OIDC_GESTION_MANEGE.confluence`
- `docs/2_GUIDE_MIGRATION_OIDC_GESTION_PRIVEE.confluence`
- `docs/4_1_CHECKLIST_DEMANDE_IAM_RACCORDEMENT_SAML.confluence`
- `docs/4_GUIDE_MIGRATION_SAML_GESTION_PRIVEE.confluence`
- `docs/5_CORRESPONDANCE_DES_CLAIMS_OIDC.confluence`
- `docs/3_GUIDE_MIGRATION_SAML_GESTION_MANEGE.confluence`

### Last commits
- 28418d5 docs(oidc): add Jira mail traceability comments to follow-up table
- f46c033 docs(saml): clarify guide 4 reading flow to remove pass overlap
- 5fbaf71 docs(saml): simplify IAM checklist wording for readability
- 5ee8162 docs(saml): add IAM request checklist and link it from guide 4
- c9be8bb chore(deps): bump phpstan phpunit rector and related lockfile packages

### Diff summary
 .cursor/pr-draft.md                                |  11 +-
 docs/0_GUIDE_MIGRATION_SSO_SYNTHESE.confluence     |  39 ++---
 ..._GUIDE_MIGRATION_OIDC_GESTION_MANEGE.confluence |   5 +-
 ..._GUIDE_MIGRATION_OIDC_GESTION_PRIVEE.confluence | 184 ++++++++-------------
 4 files changed, 103 insertions(+), 136 deletions(-)
