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
- `"docs/0.0_Migration_SSO_-_Synth\303\250se.confluence"`
- `"docs/1.0_Guide_migration_OIDC_-_Gestion_manag\303\251e.confluence"`
- `"docs/2.0_Guide_migration_OIDC_-_Gestion_priv\303\251e.confluence"`
- `"docs/3.0_Guide_migration_SAML_-_Gestion_priv\303\251e.confluence"`
- `docs/3.1_Checklist_de_demande_IAM_-_Raccordement_SAML.confluence`
- `docs/4.0_Correspondance_des_claims_OIDC.confluence`

### Last commits
- edf6b60 chore(deps): allow phpunit 13.1.10 and refresh lock file
- a8a75ef docs(saml-private): align guide with oidc private patterns and fix numbering
- 04a106f feat(quality): add composer audit scripts and manual audit:fix task
- 17fdc46 fix(deps): bump symfony and twig to address security advisories
- 9690c67 docs(oidc-private): align guide with managed patterns and clarify pkce

### Diff summary
 .cursor/pr-draft.md                                | 15 +++---
 ...0.0_Migration_SSO_-_Synth\303\250se.confluence" |  8 ++--
 ...ation_OIDC_-_Gestion_manag\303\251e.confluence" |  6 +--
 ...ration_OIDC_-_Gestion_priv\303\251e.confluence" | 54 +++++++++++-----------
 ...ration_SAML_-_Gestion_priv\303\251e.confluence" | 42 ++++++++---------
 ...t_de_demande_IAM_-_Raccordement_SAML.confluence |  6 +--
 docs/4.0_Correspondance_des_claims_OIDC.confluence |  8 ++--
 7 files changed, 70 insertions(+), 69 deletions(-)
