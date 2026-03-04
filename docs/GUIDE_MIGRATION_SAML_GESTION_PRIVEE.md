# Guide de migration – SAML v2 / Gestion privée

Extrait de `GUIDE_MIGRATION_SSO_CIBLE.md`.  
Ce document couvre les parcours **SAML v2 – Gestion privée** (sections 6.1 et 6.2 du guide complet).

Les exemples de code détaillés sont disponibles dans `GUIDE_MIGRATION_SSO_CIBLE_EXEMPLES_CODE.md` (section 6.1).

---

## 6. SAML v2 – Gestion privée (modification du flux + attributs)

Vous devez **reconfigurer le flux SAML** (métadonnées SP/IdP, endpoints, binding, attributs) en plus des attributs.

### 6.1 SAML v2 – Gestion privée – Autonome

**Suivi des étapes à réaliser (cocher étape lorsque réalisée)**

| Étape | Acteur | Action | Durée | Étape réalisée |
|-------|--------|--------|-------|------------------|
| 1 | Équipe applicative | Documenter le flux actuel (SP-initiated ou IdP-initiated, HTTP-POST/Redirect). | À estimer | [ ] |
| 2 | Équipe applicative | Générer ou actualiser les métadonnées SP (EntityID, ACS, SLO, certificats). | À estimer | [ ] |
| 3 | Équipe IAM | Enregistrer les métadonnées SP chez l’IdP et fournir les métadonnées IdP. | À estimer | [ ] |
| 4 | Équipe applicative | Configurer l’application (bibliothèque SAML, URLs IdP, certificats, mapping attributs), implémenter le callback ACS (réception Response SAML, vérification signature, lecture des attributs) et tester le flux complet (connexion, attributs, déconnexion SLO si applicable). | À estimer | [ ] |
| **Total** | — | Durée totale (somme des étapes 1 à 4) | À estimer | [ ] |

**Schéma de flux (SP-initiated, simplifié)**

```
[App/SP] --> Génère AuthnRequest --> Redirection vers IdP
[IdP] --> Authentification utilisateur
[IdP] --> Envoi Response SAML (POST vers ACS)
[SP] --> Vérification signature, lecture NameID + attributs
[SP] --> Création de session
```

**Pièges courants**

- **Métadonnées** : EntityID et ACS doivent être cohérents entre SP et IdP ; attention aux environnements (dev/preprod/prod).
- **Certificats** : expiration, bon certificat (signature vs chiffrement) selon la config IdP.
- **Binding** : HTTP-POST vs HTTP-Redirect pour Request/Response ; adapter la bibliothèque et l’IdP.

---

### 6.2 SAML v2 – Gestion privée – Accompagné / Délégué

Mêmes étapes que la section 6.1 (tableau ci-dessous).

**Suivi des étapes à réaliser (cocher étape lorsque réalisée)**

| Étape | Acteur | Action | Durée | Étape réalisée |
|-------|--------|--------|-------|------------------|
| 1 | Équipe applicative ou Équipe de raccordement applicatif | Documenter le flux actuel (SP-initiated ou IdP-initiated, HTTP-POST/Redirect). | À estimer | [ ] |
| 2 | Équipe applicative ou Équipe de raccordement applicatif | Générer ou actualiser les métadonnées SP (EntityID, ACS, SLO, certificats). | À estimer | [ ] |
| 3 | Équipe IAM | Enregistrer les métadonnées SP chez l'IdP et fournir les métadonnées IdP. | À estimer | [ ] |
| 4 | Équipe applicative ou Équipe de raccordement applicatif | Configurer l'application (bibliothèque SAML, URLs IdP, certificats, mapping attributs), implémenter le callback ACS (réception Response SAML, vérification signature, lecture des attributs) et tester le flux complet (connexion, attributs, déconnexion SLO si applicable). | À estimer | [ ] |
| **Total** | — | Durée totale (somme des étapes 1 à 4) | À estimer | [ ] |

