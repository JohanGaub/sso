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
- `"docs/5.2_template_guide_1_-_\303\251tape_fin_intervention_technique.confluence"`
- `"docs/5.5_template_guide_2_-_\303\251tape_fin_intervention_technique.confluence"`
- `"docs/6.0_Guides_de_d\303\251ploiement.confluence"`
- `"docs/6.1_Guide_de_d\303\251ploiement_hors_production.confluence"`
- `docs/GUIDE_MIGRATION_SSO_CIBLE.md`
- `docs/archives/3_GUIDE_MIGRATION_SAML_GESTION_MANEGE.confluence`

### Last commits
- 3a75a44 docs(confluence): introduce migration SSO scope and update$ guide 1.0
- 7dcabf7 docs(confluence): update intro migration SSO
- 00f138d docs(confluence): improve section 6 scope and generalize deployment guide
- 5574967 build(deps): bump dev dependencies to fix security advisories
- 1a7bc89 docs(confluence): add deployment guides for section 6

### Diff summary
 .cursor/pr-draft.md                                |  24 ++--
 ...0.0_Migration_SSO_-_Synth\303\250se.confluence" |   6 +-
 ...ation_OIDC_-_Gestion_manag\303\251e.confluence" |  36 +++---
 ...ration_OIDC_-_Gestion_priv\303\251e.confluence" |  87 +++++++------
 ...ration_SAML_-_Gestion_priv\303\251e.confluence" | 109 +++++++++--------
 ...t_de_demande_IAM_-_Raccordement_SAML.confluence |   2 +-
 ...\251tape_fin_intervention_technique.confluence" |   4 +-
 ...\251tape_fin_intervention_technique.confluence" |   6 +-
 "docs/6.0_Guides_de_d\303\251ploiement.confluence" |  33 +++--
 ..._d\303\251ploiement_hors_production.confluence" | 134 +++++++++++++--------
 docs/GUIDE_MIGRATION_SSO_CIBLE.md                  |   6 +-
 ..._GUIDE_MIGRATION_SAML_GESTION_MANEGE.confluence |   6 +-
 12 files changed, 261 insertions(+), 192 deletions(-)
