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
- `docs/4.0_Ressources_techniques.confluence`
- `docs/4.1_Correspondance_des_claims_OIDC.confluence`
- `docs/4.2_Flux_OIDC_et_PKCE_-_Guide_visuel.confluence`
- `docs/4.3_Flux_SAML_-_Guide_visuel.confluence`
- `docs/5.0_Templates_de_mail.confluence`
- `"docs/5.1_template_guide_1_-_\303\251tape_prise_en_charge_technique_gestion_manag\303\251e.confluence"`
- `"docs/5.2_template_guide_1_-_\303\251tape_fin_intervention_technique.confluence"`
- `"docs/5.3_template_guide_2_-_\303\251tape_prise_en_charge_gestion_privee.confluence"`
- `"docs/5.4_template_guide_2_-_\303\251tape_information_utilisateurs_intervention.confluence"`
- `"docs/5.5_template_guide_2_-_\303\251tape_fin_intervention_technique.confluence"`
- `"docs/6.0_Guides_de_d\303\251ploiement.confluence"`
- `"docs/6.1_Guide_de_d\303\251ploiement_manuel.confluence"`
- `"docs/7.0_Guide_de_formation_nouveaux_d\303\251veloppeurs.confluence"`
- `docs/8.0_Suivi_vulnerabilites_migration.confluence`
- `docs/GUIDE_MIGRATION_SSO_CIBLE.md`
- `docs/1.0_Guides_de_migration_SSO.confluence`
- `"docs/1.1_Guide_migration_OIDC_-_Gestion_manag\303\251e.confluence"`
- `"docs/1.2_Guide_migration_OIDC_-_Gestion_priv\303\251e.confluence"`
- `"docs/1.3_Guide_migration_SAML_-_Gestion_priv\303\251e.confluence"`
- `docs/2.0_Suivi_vulnerabilites_migration.confluence`
- `docs/3.0_Ressources_techniques.confluence`
- `docs/3.1_Correspondance_des_claims_OIDC.confluence`
- `docs/3.2_Flux_OIDC_et_PKCE_-_Guide_visuel.confluence`
- `docs/3.3_Flux_SAML_-_Guide_visuel.confluence`
- `docs/3.4_Checklist_de_demande_IAM_-_Raccordement_SAML.confluence`
- `docs/4.0_Templates_de_mail.confluence`
- `"docs/4.1_template_guide_1.1_-_\303\251tape_prise_en_charge_technique_gestion_manag\303\251e.confluence"`
- `"docs/4.2_template_guide_1.1_-_\303\251tape_fin_intervention_technique.confluence"`
- `"docs/4.3_template_guide_1.2_-_\303\251tape_prise_en_charge_gestion_privee.confluence"`
- `"docs/4.4_template_guide_1.1_1.2_et_1.3_-_\303\251tape_information_utilisateurs_intervention.confluence"`
- `"docs/4.5_template_guide_1.2_-_\303\251tape_fin_intervention_technique.confluence"`
- `"docs/5.0_Guides_de_d\303\251ploiement.confluence"`
- `"docs/5.1_Guide_de_d\303\251ploiement_manuel.confluence"`
- `"docs/6.0_Guide_de_formation_nouveaux_d\303\251veloppeurs.confluence"`

### Last commits
- c246935 docs(confluence): renumber vulnerability tracking guide to 8.0
- 9af77e9 docs(confluence): add vulnerability tracking guide for SSO migration and update step counts in OIDC and SAML guides for clarity
- f110c6d docs(confluence): update OIDC and SAML migration guides to correct step counts and enhance clarity in operational procedures
- 061fec0 docs(confluence): enhance SAML and OIDC guides with new visual aids, refine documentation for clarity, and update .gitignore to include image files
- 924bccf docs(confluence): update OIDC and PKCE guides, refine training materials, and enhance document structure

### Diff summary
 .cursor/pr-draft.md                                |  44 +-
 ...0.0_Migration_SSO_-_Synth\303\250se.confluence" |  29 +-
 ...ation_OIDC_-_Gestion_manag\303\251e.confluence" | 134 ------
 ...ration_OIDC_-_Gestion_priv\303\251e.confluence" | 415 ----------------
 ...ration_SAML_-_Gestion_priv\303\251e.confluence" | 334 -------------
 ...t_de_demande_IAM_-_Raccordement_SAML.confluence |  74 ---
 docs/4.0_Ressources_techniques.confluence          |   7 -
 docs/4.1_Correspondance_des_claims_OIDC.confluence |  59 ---
 ...4.2_Flux_OIDC_et_PKCE_-_Guide_visuel.confluence | 418 -----------------
 docs/4.3_Flux_SAML_-_Guide_visuel.confluence       | 324 -------------
 docs/5.0_Templates_de_mail.confluence              |  10 -
 ...ge_technique_gestion_manag\303\251e.confluence" |  18 -
 ...\251tape_fin_intervention_technique.confluence" |  26 -
 ...tape_prise_en_charge_gestion_privee.confluence" |  22 -
 ...formation_utilisateurs_intervention.confluence" |  22 -
 ...\251tape_fin_intervention_technique.confluence" |  87 ----
 "docs/6.0_Guides_de_d\303\251ploiement.confluence" |   9 -
 ..._Guide_de_d\303\251ploiement_manuel.confluence" | 465 ------------------
 ...mation_nouveaux_d\303\251veloppeurs.confluence" | 522 ---------------------
 docs/8.0_Suivi_vulnerabilites_migration.confluence |  68 ---
 docs/GUIDE_MIGRATION_SSO_CIBLE.md                  |  82 +---
 21 files changed, 72 insertions(+), 3097 deletions(-)
