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
- `"docs/0.0_Migration_SSO_-_Synth\303\250se.md"`
- `docs/1.0_Guides_de_migration_SSO.md`
- `"docs/1.1_Guide_migration_OIDC_-_Gestion_manag\303\251e.md"`
- `"docs/1.2_Guide_migration_OIDC_-_Gestion_priv\303\251e.md"`
- `"docs/1.3_Guide_migration_SAML_-_Gestion_priv\303\251e.md"`
- `docs/3.2_Flux_OIDC_et_PKCE_-_Guide_visuel.md`
- `docs/3.3_Flux_SAML_-_Guide_visuel.md`
- `"docs/6.0_Guide_de_formation_nouveaux_d\303\251veloppeurs.md"`
- `docs/0.0_Migration_SSO_-_Eagles.md`

### Last commits
- 0856657 docs(confluence): create md files from JiraConfluence procedures archive them all
- fcc8c5a docs(confluence): update migration guides for OIDC and SAML, enhance vulnerability tracking procedures, and replace audit file references with SBOM format
- 80dec0c chore(dependencies): update Symfony and development dependencies to latest versions
- abde548 docs(confluence): update .gitignore to include additional image formats and restructure visual flow diagrams for OIDC and SAML guides
- 3756f02 docs(confluence): restructure migration guides for SSO, add detailed steps for OIDC and SAML, and introduce new resources for vulnerability tracking and claim correspondence

### Diff summary
 .cursor/pr-draft.md                                |  68 +-------
 "docs/0.0_Migration_SSO_-_Synth\303\250se.md"      | 172 ---------------------
 docs/1.0_Guides_de_migration_SSO.md                |   2 +-
 ...ide_migration_OIDC_-_Gestion_manag\303\251e.md" |   2 +-
 ...uide_migration_OIDC_-_Gestion_priv\303\251e.md" |   2 +-
 ...uide_migration_SAML_-_Gestion_priv\303\251e.md" |   2 +-
 docs/3.2_Flux_OIDC_et_PKCE_-_Guide_visuel.md       |   2 +-
 docs/3.3_Flux_SAML_-_Guide_visuel.md               |   2 +-
 ...e_de_formation_nouveaux_d\303\251veloppeurs.md" |  12 +-
 9 files changed, 14 insertions(+), 250 deletions(-)
