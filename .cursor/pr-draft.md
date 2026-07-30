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
- `.gitignore`
- `docs/3.2_Flux_OIDC_et_PKCE_-_Guide_visuel.confluence`
- `docs/3.3_Flux_SAML_-_Guide_visuel.confluence`
- `docs/images/4.2/4.2-01-flux-web-app.png`
- `docs/images/4.2/4.2-02-flux-spa-pkce.png`
- `docs/images/4.2/4.2-03-demo-attaque-pkce.png`
- `docs/images/4.2/4.2-04-arbre-decision.png`
- `docs/images/4.3/4.3-01-flux-sp-initiated.png`
- `docs/images/4.3/4.3-02-flux-idp-initiated.png`
- `docs/images/4.3/4.3-03-demo-attaque-signature.png`
- `docs/images/4.3/4.3-04-arbre-decision.png`
- `docs/images/3.2/`
- `docs/images/3.3/`
- `docs/images/habilitations.svg`
- `docs/images/poste-de-travail.svg`

### Last commits
- 3756f02 docs(confluence): restructure migration guides for SSO, add detailed steps for OIDC and SAML, and introduce new resources for vulnerability tracking and claim correspondence
- c246935 docs(confluence): renumber vulnerability tracking guide to 8.0
- 9af77e9 docs(confluence): add vulnerability tracking guide for SSO migration and update step counts in OIDC and SAML guides for clarity
- f110c6d docs(confluence): update OIDC and SAML migration guides to correct step counts and enhance clarity in operational procedures
- 061fec0 docs(confluence): enhance SAML and OIDC guides with new visual aids, refine documentation for clarity, and update .gitignore to include image files

### Diff summary
 .cursor/pr-draft.md                                |  74 ++++-----------------
 .gitignore                                         |   8 ++-
 ...3.2_Flux_OIDC_et_PKCE_-_Guide_visuel.confluence |   8 +--
 docs/3.3_Flux_SAML_-_Guide_visuel.confluence       |   8 +--
 docs/images/4.2/4.2-01-flux-web-app.png            | Bin 96160 -> 0 bytes
 docs/images/4.2/4.2-02-flux-spa-pkce.png           | Bin 93733 -> 0 bytes
 docs/images/4.2/4.2-03-demo-attaque-pkce.png       | Bin 30507 -> 0 bytes
 docs/images/4.2/4.2-04-arbre-decision.png          | Bin 23223 -> 0 bytes
 docs/images/4.3/4.3-01-flux-sp-initiated.png       | Bin 73096 -> 0 bytes
 docs/images/4.3/4.3-02-flux-idp-initiated.png      | Bin 67547 -> 0 bytes
 docs/images/4.3/4.3-03-demo-attaque-signature.png  | Bin 57026 -> 0 bytes
 docs/images/4.3/4.3-04-arbre-decision.png          | Bin 32865 -> 0 bytes
 12 files changed, 28 insertions(+), 70 deletions(-)
