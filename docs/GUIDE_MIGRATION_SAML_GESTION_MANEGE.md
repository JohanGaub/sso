# Guide de migration – SAML v2 / Gestion managée

Extrait de `GUIDE_MIGRATION_SSO_CIBLE.md`.  
Ce document couvre les parcours **SAML v2 – Gestion managée** (sections 5.1 et 5.2 du guide complet).

Les exemples de code détaillés sont disponibles dans `GUIDE_MIGRATION_SSO_CIBLE_EXEMPLES_CODE.md` (section 5.1).

---

## 5. SAML v2 – Gestion managée (modification des attributs)

Le flux SAML est géré en interne ; seuls les **attributs SAML** doivent être mis à jour (côté IdP et éventuellement SP).

### 5.1 SAML v2 – Gestion managée – Autonome

**Suivi des étapes à réaliser (cocher étape lorsque réalisée)**

| Étape | Acteur | Action | Durée | Étape réalisée |
|-------|--------|--------|-------|------------------|
| 1 | Équipe applicative | Identifier les attributs SAML requis (ex. id, email, nom, role) et transmettre la liste à l’administrateur SSO cible. | À estimer | [ ] |
| 2 | Administrateur SSO cible | Configurer l’IdP pour envoyer ces attributs dans l’Assertion SAML (noms et format attendus). | À estimer | [ ] |
| 3 | Équipe applicative | Vérifier la réception des attributs côté SP (logs, outil de validation SAML si besoin) et adapter l’application pour les lire et les utiliser (lecture, validation, accès). | À estimer | [ ] |
| **Total** | — | Durée totale (somme des étapes 1 à 3) | À estimer | [ ] |

**Validation** : Utiliser un outil en ligne de décodage/validation SAML (ou un validateur local) pour vérifier la présence et le format des attributs dans l’Assertion reçue.

**Pièges courants**

- **Noms d’attributs** : différence entre URI, basic, unspecified ; s’assurer que l’IdP et l’SP utilisent le même nom (ou un mapping explicite).
- **Multiples valeurs** : les attributs SAML sont souvent des tableaux ; prendre la première valeur ou gérer la liste selon la sémantique.
- **Signature et chiffrement** : ne pas désactiver la vérification de signature en production.

---

### 5.2 SAML v2 – Gestion managée – Accompagné / Délégué

Mêmes étapes que la section 5.1 (tableau ci-dessous).

**Suivi des étapes à réaliser (cocher étape lorsque réalisée)**

| Étape | Acteur | Action | Durée | Étape réalisée |
|-------|--------|--------|-------|------------------|
| 1 | Équipe applicative ou Équipe de raccordement applicatif | Identifier les attributs SAML requis (ex. id, email, nom, role) et transmettre la liste à l'administrateur SSO cible. | À estimer | [ ] |
| 2 | Administrateur SSO cible | Configurer l'IdP pour envoyer ces attributs dans l'Assertion SAML (noms et format attendus). | À estimer | [ ] |
| 3 | Équipe applicative ou Équipe de raccordement applicatif | Vérifier la réception des attributs côté SP (logs, outil de validation SAML si besoin) et adapter l'application pour les lire et les utiliser (lecture, validation, accès). | À estimer | [ ] |
| **Total** | — | Durée totale (somme des étapes 1 à 3) | À estimer | [ ] |

