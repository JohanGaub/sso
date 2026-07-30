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
- `"docs/1.1_Guide_migration_OIDC_-_Gestion_manag\303\251e.confluence"`
- `"docs/1.2_Guide_migration_OIDC_-_Gestion_priv\303\251e.confluence"`
- `"docs/1.3_Guide_migration_SAML_-_Gestion_priv\303\251e.confluence"`
- `docs/2.0_Suivi_vulnerabilites_migration.confluence`

### Last commits
- 80dec0c chore(dependencies): update Symfony and development dependencies to latest versions
- abde548 docs(confluence): update .gitignore to include additional image formats and restructure visual flow diagrams for OIDC and SAML guides
- 3756f02 docs(confluence): restructure migration guides for SSO, add detailed steps for OIDC and SAML, and introduce new resources for vulnerability tracking and claim correspondence
- c246935 docs(confluence): renumber vulnerability tracking guide to 8.0
- 9af77e9 docs(confluence): add vulnerability tracking guide for SSO migration and update step counts in OIDC and SAML guides for clarity

### Diff summary
 .cursor/pr-draft.md                                | 37 ++--------
 ...ation_OIDC_-_Gestion_manag\303\251e.confluence" |  4 +-
 ...ration_OIDC_-_Gestion_priv\303\251e.confluence" |  4 +-
 ...ration_SAML_-_Gestion_priv\303\251e.confluence" |  4 +-
 docs/2.0_Suivi_vulnerabilites_migration.confluence | 82 +++++++++++++++-------
 5 files changed, 68 insertions(+), 63 deletions(-)
