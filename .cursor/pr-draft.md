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
- `docs/0.0_Migration_SSO_-_Eagles.md`
- `docs/1.0_Guides_de_migration_SSO.md`
- `"docs/1.1_Guide_migration_OIDC_-_Gestion_manag\303\251e.md"`
- `"docs/1.2_Guide_migration_OIDC_-_Gestion_priv\303\251e.md"`
- `"docs/1.3_Guide_migration_SAML_-_Gestion_priv\303\251e.md"`
- `docs/3.2_Flux_OIDC_et_PKCE_-_Guide_visuel.md`
- `docs/3.3_Flux_SAML_-_Guide_visuel.md`
- `"docs/6.0_Guide_de_formation_nouveaux_d\303\251veloppeurs.md"`
- `docs/1.0_Introduction_migration_SSO.md`

### Last commits
- f94aa92 docs(confluence): introduce new 'Eagles' migration guide, update references in existing documents, and remove outdated content
- 0856657 docs(confluence): create md files from JiraConfluence procedures archive them all
- fcc8c5a docs(confluence): update migration guides for OIDC and SAML, enhance vulnerability tracking procedures, and replace audit file references with SBOM format
- 80dec0c chore(dependencies): update Symfony and development dependencies to latest versions
- abde548 docs(confluence): update .gitignore to include additional image formats and restructure visual flow diagrams for OIDC and SAML guides

### Diff summary
 .cursor/pr-draft.md                                | 16 ++---------
 .../0.0_Migration_SSO_-_Eagles_-_Vue d_ensemble.md |  4 +--
 docs/1.0_Guides_de_migration_SSO.md                | 32 ----------------------
 ...ide_migration_OIDC_-_Gestion_manag\303\251e.md" |  2 +-
 ...uide_migration_OIDC_-_Gestion_priv\303\251e.md" |  2 +-
 ...uide_migration_SAML_-_Gestion_priv\303\251e.md" |  2 +-
 docs/3.2_Flux_OIDC_et_PKCE_-_Guide_visuel.md       |  2 +-
 docs/3.3_Flux_SAML_-_Guide_visuel.md               |  2 +-
 ...e_de_formation_nouveaux_d\303\251veloppeurs.md" | 10 +++----
 9 files changed, 15 insertions(+), 57 deletions(-)
