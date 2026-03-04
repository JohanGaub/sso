# Migration SSO – Synthèse en 1 page

Ce document donne une **vue d’ensemble** de la migration vers le SSO cible.
Les détails par cas (OIDC/SAML, gestion managée/privée) se trouvent dans les **guides dédiés** listés plus bas.

### À qui s’adresse ce document ?

Équipe applicative ; équipe IAM ; équipe de raccordement applicatif (en mode accompagné ou délégué : accompagne ou réalise à la place de l’équipe applicative). La synthèse permet de se repérer (prérequis, étapes communes) et de choisir le bon guide détaillé.

### Comment utiliser ce document ?

1. Vérifier les **prérequis** (contexte, accès Préprod auprès de l’équipe IAM).
2. Parcourir les **étapes communes** pour situer où vous en êtes.
3. Choisir le **guide détaillé** correspondant à votre cas (tableau de routage en fin de page) et suivre les étapes décrites dedans.

---

## 1. Pré‑requis communs

- **Identifier le contexte actuel** :
  - Protocole : **OIDC** ou **SAML v2**.
  - Mode : **gestion managée** (attributs/claims uniquement) ou **gestion privée** (flux d’auth + attributs).
  - Niveau d’autonomie : **autonome**, **accompagné**, **délégué**.
- **Environnement de départ** : on commence toujours par le raccordement sur **Préprod**. L’**équipe IAM** met à disposition cet environnement ; l’équipe applicative doit s’assurer auprès d’elle qu’un compte / une application en préprod est disponible avant de démarrer. Une fois les tests validés en préprod, on passe en production.

### Prérequis administratifs

Avant de commencer les étapes techniques : **demande** (formulaire + matrice des rôles) envoyée à l’équipe IAM, et **validation** (accord et accès préprod). Le **passage en prod** fait l’objet d’une demande dédiée (dossier : PV de test, fiche renseignement, métadonnées prod) puis récupération des métadonnées IdP prod pour intégration dans l’application. Le détail du process (qui envoie quoi, PV, etc.) est géré en dehors de ce guide technique.

---

## 2. Étapes communes de la migration (vue métier)

| Étape | Objectif | Acteurs |
|-------|----------|--------------------|
| 1 | Choisir le bon parcours de migration (en fonction du protocole, du mode et de l’autonomie) | Équipe applicative + équipe SSO |
| 2 | **Aligner les identités** : définir les claims/attributs nécessaires (id, email, nom, rôle, etc.) | Équipe applicative + administrateur SSO cible |
| 3 | Si gestion privée : **valider le flux d’authentification** (OIDC Authorization Code, SAML SP/IdP‑initiated, ACS, SLO, etc.) | Équipe applicative + équipe SSO |
| 4 | **Actualiser l’application** : configuration (URLs, clients, certificats) + lecture et usage des infos d’authentification côté code | Équipe applicative |
| 5 | **Tester la migration** : scénarios de connexion / déconnexion / erreurs sur dev puis préprod, avant passage en prod | Équipe applicative + équipe SSO |

> Les détails techniques (tableaux d’étapes, schémas de flux, pièges courants) sont décrits dans les guides par type de raccordement ci‑dessous.

---

## 3. Choisir votre guide détaillé

À partir de votre contexte (protocole + mode de gestion), consultez le guide correspondant :

| Protocole | Mode | Guide détaillé |
|-----------|------|----------------|
| OIDC | Gestion managée (attributs/claims uniquement) | `GUIDE_MIGRATION_OIDC_GESTION_MANEGE.md` |
| OIDC | Gestion privée (flux + attributs) | `GUIDE_MIGRATION_OIDC_GESTION_PRIVEE.md` |
| SAML v2 | Gestion managée (attributs uniquement) | `GUIDE_MIGRATION_SAML_GESTION_MANEGE.md` |
| SAML v2 | Gestion privée (flux + attributs) | `GUIDE_MIGRATION_SAML_GESTION_PRIVEE.md` |

**Exemples de code par cas** : `GUIDE_MIGRATION_SSO_CIBLE_EXEMPLES_CODE.md`.

---

## 4. Glossaire (termes clés)

| Terme | Définition |
|-------|------------|
| **OIDC** | OpenID Connect – couche d’identité au‑dessus d’OAuth 2.0 (id_token, userinfo, scopes `openid`). |
| **SAML v2** | Security Assertion Markup Language 2.0 – protocole d’échange d’assertions d’identité (XML). |
| **IAM** | Identity & Access Management – équipe et services qui gèrent les identités, les habilitations et la configuration du SSO cible (environnements, applications, métadonnées). |
| **IdP** | Identity Provider – fournisseur d’identité (service SSO). |
| **SP** | Service Provider – application qui consomme l’authentification fournie par l’IdP. |
| **ACS** | Assertion Consumer Service – endpoint du SP qui reçoit la Response SAML (souvent appelé « callback ACS »). |
| **SLO** | Single Logout – déconnexion unique : fermeture de session côté IdP et SP. |

