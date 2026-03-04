# Guide de migration SSO actuel → SSO cible

Documentation unique pour migrer des applications (PHP, Python, TypeScript, OIDC, SAML) vers un SSO cible, avec parcours adaptés au mode de gestion et au niveau d'autonomie.

---

## 1. Introduction (1 page max)

### Pourquoi migrer ?

- **Sécurité renforcée** : Authentification centralisée, gestion des sessions et des tokens conforme aux bonnes pratiques.
- **Expérience utilisateur** : Connexion unique (SSO) entre plusieurs applications.
- **Maintenabilité** : Un seul point de configuration pour l’identité et les attributs.
- **Conformité** : Alignement avec les standards (OIDC, SAML v2) et les politiques de sécurité.

### À qui s’adresse ce guide ?

- **Équipe applicative** : en charge de l’application ; réalise les étapes côté application en fonction de leur niveau d'autonomie (autonome / accompagné / délégué).
- **Équipe IAM** : configure l’IdP / SSO cible (applications, claims, métadonnées).
- **Équipe de raccordement applicatif** : accompagne l’équipe applicative (parcours accompagné ou délégué).

### Comment utiliser ce document ?

1. **Répondre à 3 questions** dans l’[arbre de décision](#2-arbre-de-décision-visuel) : protocole (OIDC / SAML v2), mode de gestion (managée / privée), niveau d’autonomie (autonome / accompagné / délégué).
2. **Aller à la section correspondant à vos réponses** (ex. 3.1, 5.2) et suivre les étapes du tableau (cocher au fur et à mesure). Vous trouverez en plus des exemples de code et les pièges courants à éviter.
3. **Consulter les annexes** pour le glossaire, la FAQ et les ressources externes.

---

## 2. Arbre de décision visuel

Répondez aux trois questions ci-dessous, puis reportez-vous au **tableau** pour trouver la section à consulter.

**Question 1** : Quel protocole utilisez-vous ? → **OIDC** ou **SAML v2**  
**Question 2** : Votre application est-elle en **gestion managée** (modification des attributs uniquement) ou **gestion privée** (modification du flux d’authentification + attributs) ?  
**Question 3** : Quel est votre niveau d’autonomie ? → **Autonome** / **Accompagné** / **Délégué**

### Tableau de routage

| Protocole | Gestion | Niveau d'autonomie | Section à consulter | Contenu de la section |
|-----------|---------|--------------------|---------------------|------------------------|
| OIDC | Managée | Autonome | **3.1** | Actualiser les claims OIDC (mapping, validation, exemples). |
| OIDC | Managée | Accompagné / Délégué | **3.2** | Actualiser les claims OIDC + consulter la FAQ et les contacts d'accompagnement. |
| OIDC | Privée | Autonome | **4.1** | Reconfigurer le flux OIDC (schéma, code PHP/TypeScript/Python). |
| OIDC | Privée | Accompagné / Délégué | **4.2** | Reconfigurer le flux OIDC + solliciter l'assistance et consulter les exemples avancés. |
| SAML v2 | Managée | Autonome | **5.1** | Actualiser les attributs SAML (ex. XML, validation via outil en ligne). |
| SAML v2 | Managée | Accompagné / Délégué | **5.2** | Actualiser les attributs SAML + consulter la FAQ et les contacts dédiés. |
| SAML v2 | Privée | Autonome | **6.1** | Reconfigurer le flux SAML (diagramme, code PHP/TypeScript). |
| SAML v2 | Privée | Accompagné / Délégué | **6.2** | Reconfigurer le flux SAML + solliciter l'assistance et consulter les exemples avancés. |

---

## 3. OIDC – Gestion managée (modification des attributs)

Le flux OIDC est géré en interne ; seuls les **attributs (claims)** doivent être ajustés. L’authentification est déjà déléguée au SSO cible ; l’application valide les tokens et consomme les claims.

### 3.1 OIDC – Gestion managée – Autonome

**Suivi des étapes à réaliser (cocher étape lorsque réalisée)**

| Étape | Acteur | Action | Durée | Étape réalisée |
|-------|--------|--------|-------|------------------|
| 1 | Équipe applicative | Identifier les nouveaux claims requis (ex. `id`, `email`, `nom`, `role`) et transmettre à l’équipe IAM la liste des claims attendus. | À estimer | [ ] |
| 2 | Équipe IAM | Actualiser la configuration de l’IdP pour que les tokens contiennent ces claims (l’IdP puise les valeurs dans son annuaire) ; vérifier que les attributs sources (id, email, nom, role, etc.) sont bien exposés avec les noms attendus. | À estimer | [ ] |
| 3 | Équipe applicative | Adapter et tester la consommation des claims dans l’application : actualiser le code (lecture, validation) puis tester la connexion au SSO cible et vérifier que les claims attendus sont bien reçus et utilisés (connexion OK, valeurs visibles dans l’appli). | À estimer | [ ] |
| **Total** | — | Durée totale (somme des étapes 1 à 3) | À estimer | [ ] |

**Pièges courants**

- Oublier de actualiser le **schéma de validation** des claims (liste des claims autorisés, types).
- Confusion entre claims **standard** (ex. `id`, `email`, `nom`) et **personnalisés** (ex. `role`) : bien documenter la source (IdP) et le nom exact du claim.
- Ne pas ignorer les erreurs quand l’application lit les claims :
  - **en développement/préproduction** : enregistrer dans les logs ce que le SSO envoie vraiment, pour comprendre pourquoi une valeur manque ou est incorrecte ;
  - **en production** : limiter le détail des logs (pas de données sensibles), mais garder au moins un message clair indiquant qu’un claim attendu est manquant ou invalide.

---

### 3.2 OIDC – Gestion managée – Accompagné / Délégué

Mêmes étapes que la section 3.1 (tableau ci-dessous).

**Suivi des étapes à réaliser (cocher étape lorsque réalisée)**

| Étape | Acteur | Action | Durée | Étape réalisée |
|-------|--------|--------|-------|------------------|
| 1 | Équipe applicative ou Équipe de raccordement applicatif | Identifier les nouveaux claims requis (ex. `id`, `email`, `nom`, `role`) et transmettre à l’équipe IAM la liste des claims attendus. | À estimer | [ ] |
| 2 | Équipe IAM | Actualiser la configuration de l’IdP pour que les tokens contiennent ces claims (l’IdP puise les valeurs dans son annuaire) ; vérifier que les attributs sources (id, email, nom, role, etc.) sont bien exposés avec les noms attendus. | À estimer | [ ] |
| 3 | Équipe applicative ou Équipe de raccordement applicatif | Adapter et tester la consommation des claims dans l’application : actualiser le code (lecture, validation) puis tester la connexion au SSO cible et vérifier que les claims attendus sont bien reçus et utilisés (connexion OK, valeurs visibles dans l’appli). | À estimer | [ ] |
| **Total** | — | Durée totale (somme des étapes 1 à 3) | À estimer | [ ] |

---

## 4. OIDC – Gestion privée (modification du flux + attributs)

Vous devez **reconfigurer le flux OIDC** (endpoints, redirect_uri, scopes, client) en plus des attributs.

### 4.1 OIDC – Gestion privée – Autonome

**Suivi des étapes à réaliser (cocher étape lorsque réalisée)**

| Étape | Acteur | Action | Durée | Étape réalisée |
|-------|--------|--------|-------|------------------|
| 1 | Équipe applicative | Documenter le flux actuel (flux par code : redirection vers l’IdP, puis échange du code contre les tokens ; préciser si PKCE est utilisé — recommandé pour sécuriser) et transmettre à l’équipe IAM les éléments nécessaires à l’enregistrement du client (URLs de redirection, scopes attendus). | À estimer | [ ] |
| 2 | Équipe IAM | Créer ou actualiser le client auprès de l’IdP (Client ID, Secret, Redirect URIs, scopes `openid`, `profile`, `email` + personnalisés). | À estimer | [ ] |
| 3 | Équipe applicative | **Débrancher** l’authentification locale : s’assurer que l’application ne valide que les tokens du SSO (issuer, client_id, audiences, signature, `exp`) ; désactiver l’ancienne page de connexion (login / mot de passe) ; documenter que l’accès se fait uniquement via le SSO cible. | À estimer | [ ] |
| 4 | Équipe applicative | Actualiser la configuration de l’application (URLs, scopes, mapping des claims) et implémenter ou adapter le callback (échange du code contre tokens, récupération userinfo). | À estimer | [ ] |
| 5 | Équipe applicative | Gérer les erreurs (redirect_uri mismatch, invalid_grant, consent refusé) et tester le flux complet (connexion, rafraîchissement, déconnexion si applicable). | À estimer | [ ] |
| **Total** | — | Durée totale (somme des étapes 1 à 5) | À estimer | [ ] |

**Schéma de flux (rappel)**

```
[App] --> Redirection vers IdP (authorization endpoint)
[IdP] --> Authentification utilisateur
[IdP] --> Redirection vers App (redirect_uri + code)
[App] --> Échange code contre access_token (et id_token)
[App] --> (Optionnel) UserInfo endpoint pour claims supplémentaires
[App] --> Création de session / utilisateur local
```

**Pièges courants**

- **Redirect URI** : doit être exactement identique (protocole, domaine, port, chemin) entre IdP et application.
- **Scopes** : oublier `openid` rend le flux non conforme OIDC ; les claims personnalisés peuvent nécessiter des scopes ou des claims mapping côté IdP.
- **Secret** : ne pas exposer le client_secret (variables d’environnement, pas de commit).

---

### 4.2 OIDC – Gestion privée – Accompagné / Délégué

Mêmes étapes que la section 4.1 (tableau ci-dessous).

**Suivi des étapes à réaliser (cocher étape lorsque réalisée)**

| Étape | Acteur | Action | Durée | Étape réalisée |
|-------|--------|--------|-------|------------------|
| 1 | Équipe applicative ou Équipe de raccordement applicatif | Documenter le flux actuel (flux par code : redirection vers l’IdP, puis échange du code contre les tokens ; préciser si PKCE est utilisé — recommandé pour sécuriser) et transmettre à l’équipe IAM les éléments nécessaires à l’enregistrement du client (URLs de redirection, scopes attendus). | À estimer | [ ] |
| 2 | Équipe IAM | Créer ou actualiser le client auprès de l’IdP (Client ID, Secret, Redirect URIs, scopes `openid`, `profile`, `email` + personnalisés). | À estimer | [ ] |
| 3 | Équipe applicative ou Équipe de raccordement applicatif | **Débrancher** l’authentification locale : s’assurer que l’application ne valide que les tokens du SSO (issuer, client_id, audiences, signature, `exp`) ; désactiver l’ancienne page de connexion (login / mot de passe) ; documenter que l’accès se fait uniquement via le SSO cible. | À estimer | [ ] |
| 4 | Équipe applicative ou Équipe de raccordement applicatif | Actualiser la configuration de l’application (URLs, scopes, mapping des claims) et implémenter ou adapter le callback (échange du code contre tokens, récupération userinfo). | À estimer | [ ] |
| 5 | Équipe applicative ou Équipe de raccordement applicatif | Gérer les erreurs (redirect_uri mismatch, invalid_grant, consent refusé) et tester le flux complet (connexion, rafraîchissement, déconnexion si applicable). | À estimer | [ ] |
| **Total** | — | Durée totale (somme des étapes 1 à 5) | À estimer | [ ] |

---

## 5. SAML v2 – Gestion managée (modification des attributs)

Le flux SAML est géré en interne ; seuls les **attributs SAML** doivent être mis à jour (côté IdP et éventuellement SP).

### 5.1 SAML v2 – Gestion managée – Autonome

**Suivi des étapes à réaliser (cocher étape lorsque réalisée)**

| Étape | Acteur | Action | Durée | Étape réalisée |
|-------|--------|--------|-------|------------------|
| 1 | Équipe applicative | Identifier les attributs SAML requis (ex. id, email, nom, role) et transmettre la liste à l’équipe IAM. | À estimer | [ ] |
| 2 | Équipe IAM | Configurer l’IdP pour envoyer ces attributs dans l’Assertion SAML (noms et format attendus). | À estimer | [ ] |
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
| 1 | Équipe applicative ou Équipe de raccordement applicatif | Identifier les attributs SAML requis (ex. id, email, nom, role) et transmettre la liste à l’équipe IAM. | À estimer | [ ] |
| 2 | Équipe IAM | Configurer l'IdP pour envoyer ces attributs dans l'Assertion SAML (noms et format attendus). | À estimer | [ ] |
| 3 | Équipe applicative ou Équipe de raccordement applicatif | Vérifier la réception des attributs côté SP (logs, outil de validation SAML si besoin) et adapter l'application pour les lire et les utiliser (lecture, validation, accès). | À estimer | [ ] |
| **Total** | — | Durée totale (somme des étapes 1 à 3) | À estimer | [ ] |

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

---

## 7. Annexes

### Glossaire

| Terme | Définition |
|-------|------------|
| **ACS** | Assertion Consumer Service – endpoint du SP qui reçoit la Response SAML (souvent appelé « callback ACS »). |
| **Assertion (SAML)** | Message XML envoyé par l’IdP au SP contenant l’identité et les attributs de l’utilisateur. |
| **Attributs SAML** | Éléments dans l’Assertion SAML décrivant l’utilisateur (rôles, groupes, etc.). |
| **Binding (SAML)** | Mode de transport des messages SAML : HTTP-POST ou HTTP-Redirect. |
| **Claims** | Informations sur l’utilisateur fournies par le SSO, sous forme **clé–valeur** (ex. `id`, `email`, `nom`, `role`). L’application les lit dans le token pour identifier l’utilisateur et gérer les droits. |
| **EntityID** | Identifiant unique du SP ou de l’IdP dans les métadonnées SAML. |
| **Gestion managée** | Seuls les attributs/claims sont modifiés ; le flux est géré en interne. |
| **Gestion privée** | Modification du flux d’authentification (client, métadonnées, endpoints) et des attributs. |
| **IdP** | Identity Provider – fournisseur d’identité (authentification). |
| **IAM** | Identity & Access Management – équipe et services qui gèrent les identités, les habilitations et la configuration du SSO cible (environnements, applications, métadonnées). |
| **IdP-initiated / SP-initiated** | **SP-initiated** : l’application (SP) envoie une AuthnRequest vers l’IdP. **IdP-initiated** : l’IdP envoie la Response SAML sans requête préalable. |
| **JWT** | JSON Web Token – format courant pour id_token et access_token en OIDC. |
| **OIDC** | OpenID Connect – couche d’identité sur OAuth 2.0 (id_token, userinfo, scopes `openid`). |
| **PKCE** | Proof Key for Code Exchange – mécanisme de sécurisation du flux Authorization Code (OIDC), recommandé pour les clients publics. |
| **redirect_uri** | URL vers laquelle l’IdP redirige l’utilisateur après authentification (OIDC) ; doit être exactement enregistrée pour le client. |
| **SAML v2** | Security Assertion Markup Language 2.0 – protocole d’échange d’assertions d’identité (XML). |
| **SLO** | Single Logout – déconnexion unique (SAML) ; endpoint et flux permettant de fermer la session côté IdP et SP. |
| **SP** | Service Provider – application qui consomme l’authentification (SAML). |
| **userinfo** | Endpoint OIDC renvoyant les claims utilisateur ; utilisé en complément ou à la place des claims présents dans le id_token. |

### FAQ

- **Comment tester en local ?**  
  Utiliser un redirect_uri autorisé pour l’environnement local (ex. `http://localhost:8000/login/check/oidc`) et un client IdP dédié dev si possible. Pour SAML, enregistrer les métadonnées SP avec l’URL locale (HTTP si accepté par l’IdP).

- **Où configurer les nouveaux claims/attributs ?**  
  Côté IdP (mapping des attributs / claims depuis la source d’identité). L’application ne fait qu’autoriser et consommer ; en gestion managée, pas de changement de flux.

- **Que faire en cas d’erreur « redirect_uri mismatch » (OIDC) ?**  
  Vérifier que l’URI utilisée par l’application (protocole, host, port, path) est exactement une de celles enregistrées pour le client dans l’IdP.

- **Que faire si les attributs SAML n’arrivent pas au SP ?**  
  Vérifier la configuration des attributs côté IdP (release policy), le nom des attributs dans l’Assertion (logs ou outil de décodage), et le mapping côté SP (noms d’attributs).

- **Autonome vs accompagné vs délégué ?**  
  **Autonome** : vous suivez ce guide et les exemples seuls. **Accompagné** : vous faites la mise en œuvre avec revue et aide de l’équipe SSO. **Délégué** : vous fournissez les exigences (claims/attributs, environnement) et l’équipe SSO réalise la configuration ou une partie.

### Ressources externes

- [OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html)
- [OAuth 2.0 RFC 6749](https://tools.ietf.org/html/rfc6749)
- [SAML 2.0 Core](http://docs.oasis-open.org/security/saml/v2.0/saml-core-2.0-os.pdf)
- [Symfony Security](https://symfony.com/doc/current/security.html)
- [KnpU OAuth2 Client Bundle](https://github.com/knpuniversity/oauth2-client-bundle)
