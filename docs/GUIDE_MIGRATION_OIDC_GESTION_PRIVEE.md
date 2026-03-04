# Guide de migration – OIDC / Gestion privée

Extrait de `GUIDE_MIGRATION_SSO_CIBLE.md`.  
Ce document couvre les parcours **OIDC – Gestion privée** (sections 4.1 et 4.2 du guide complet).

Les exemples de code détaillés sont disponibles dans `GUIDE_MIGRATION_SSO_CIBLE_EXEMPLES_CODE.md` (section 4.1).

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

