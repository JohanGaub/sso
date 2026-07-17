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
- `"docs/0.0_Migration_SSO_-_Synth\303\250se.confluence"`
- `"docs/1.0_Guide_migration_OIDC_-_Gestion_manag\303\251e.confluence"`
- `"docs/2.0_Guide_migration_OIDC_-_Gestion_priv\303\251e.confluence"`
- `"docs/3.0_Guide_migration_SAML_-_Gestion_priv\303\251e.confluence"`
- `"docs/6.0_Guides_de_d\303\251ploiement.confluence"`
- `"docs/6.1_Guide_de_d\303\251ploiement_hors_production.confluence"`
- `mise.toml`

### Last commits
- 4c6f766 docs(sso): update deploy intro
- bd736c2 docs(sso): align env phases, PV validation and deployment scope across guides
- 3a75a44 docs(confluence): introduce migration SSO scope and update$ guide 1.0
- 7dcabf7 docs(confluence): update intro migration SSO
- 00f138d docs(confluence): improve section 6 scope and generalize deployment guide

### Diff summary
 .cursor/pr-draft.md                                | 11 ++-
 ...0.0_Migration_SSO_-_Synth\303\250se.confluence" |  2 +-
 ...ation_OIDC_-_Gestion_manag\303\251e.confluence" | 10 +--
 ...ration_OIDC_-_Gestion_priv\303\251e.confluence" | 10 +--
 ...ration_SAML_-_Gestion_priv\303\251e.confluence" | 10 +--
 "docs/6.0_Guides_de_d\303\251ploiement.confluence" |  4 +-
 ..._Guide_de_d\303\251ploiement_manuel.confluence" | 95 +++++++++++++++-------
 7 files changed, 92 insertions(+), 50 deletions(-)
