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
- `"docs/0.0_Migration_SSO_-_Synth\303\250se.confluence"`
- `"docs/1.0_Guide_migration_OIDC_-_Gestion_manag\303\251e.confluence"`
- `"docs/2.0_Guide_migration_OIDC_-_Gestion_priv\303\251e.confluence"`
- `"docs/3.0_Guide_migration_SAML_-_Gestion_priv\303\251e.confluence"`
- `docs/4.0_Ressources_techniques.confluence`
- `docs/4.2_Flux_OIDC_et_PKCE_-_Guide_visuel.confluence`
- `docs/5.0_Templates_de_mail.confluence`
- `"docs/5.1_template_guide_1_-_\303\251tape_prise_en_charge_technique_gestion_manag\303\251e.confluence"`
- `"docs/5.2_template_guide_1_-_\303\251tape_fin_intervention_technique.confluence"`
- `"docs/5.3_template_guide_2_-_\303\251tape_prise_en_charge_gestion_privee.confluence"`
- `"docs/5.4_template_guide_2_-_\303\251tape_information_utilisateurs_intervention.confluence"`
- `"docs/6.1_Guide_de_d\303\251ploiement_manuel.confluence"`
- `"docs/7.0_Guide_de_formation_nouveaux_d\303\251veloppeurs.confluence"`
- `docs/4.3_Flux_SAML_-_Guide_visuel.confluence`
- `docs/images/`

### Last commits
- 924bccf docs(confluence): update OIDC and PKCE guides, refine training materials, and enhance document structure
- 660432c docs(confluence): update visual flow diagrams and standardize code claim prefixes in training materials
- bb03b90 docs(confluence): refine training guide for new developers and standardize claim prefixes in code examples
- e79f495 docs(confluence): update migration guides to reflect new claim correspondence and enhance visual flow documentation
- 4c55b49 docs(confluence): enhance OIDC and SAML migration guides, update deployment references, and improve link formatting

### Diff summary
 .cursor/pr-draft.md                                |  20 +++-
 .gitignore                                         |   6 +-
 ...0.0_Migration_SSO_-_Synth\303\250se.confluence" |   6 +-
 ...ation_OIDC_-_Gestion_manag\303\251e.confluence" |  10 +-
 ...ration_OIDC_-_Gestion_priv\303\251e.confluence" |  48 +++++-----
 ...ration_SAML_-_Gestion_priv\303\251e.confluence" | 105 +++++++++++----------
 docs/4.0_Ressources_techniques.confluence          |   1 +
 ...4.2_Flux_OIDC_et_PKCE_-_Guide_visuel.confluence |   2 +-
 docs/5.0_Templates_de_mail.confluence              |   6 +-
 ...ge_technique_gestion_manag\303\251e.confluence" |   2 +-
 ...\251tape_fin_intervention_technique.confluence" |   4 +-
 ...tape_prise_en_charge_gestion_privee.confluence" |   8 +-
 ...formation_utilisateurs_intervention.confluence" |   4 +-
 ..._Guide_de_d\303\251ploiement_manuel.confluence" |   6 +-
 ...mation_nouveaux_d\303\251veloppeurs.confluence" |   6 +-
 15 files changed, 125 insertions(+), 109 deletions(-)
