# Guide de Démarrage Rapide : Intégration SSO OAuth2/OpenID Connect

## 🚀 Pour Commencer Maintenant

Ce guide vous permet d'intégrer rapidement un système SSO (Single Sign-On) compatible OAuth2/OpenID Connect dans votre projet Symfony.

### ⏱️ Temps Estimé

- **Configuration Provider SSO** : 30-45 minutes
- **Configuration Symfony** : 30-45 minutes
- **Test** : 15 minutes
- **Total** : ~2 heures

---

## 📋 Checklist Rapide

### Étape 1 : Configuration du Provider SSO (30-45 min)

**Choisissez votre provider** (Google, GitHub, Keycloak, Auth0, etc.) et suivez les étapes :

- [ ] Accéder au portail d'administration du provider
- [ ] Créer une application/OAuth client
- [ ] Noter le **Client ID**
- [ ] Créer un secret client
- [ ] **Copier la valeur du secret** (⚠️ ne sera plus visible)
- [ ] Configurer les URI de redirection :
  - `https://votre-domaine.docker.localhost/login/check/{provider}`
  - `http://localhost:8000/login/check/{provider}` (si test local)
- [ ] Configurer les scopes/permissions (openid, profile, email minimum)
- [ ] Noter les endpoints (Authorization, Token, UserInfo)

**💡 Exemples concrets** : Consultez `EXEMPLES_PROVIDERS.md` pour des guides détaillés par provider.

### Étape 2 : Configuration Symfony (30-45 min)

- [ ] Installer les dépendances :
  ```bash
  task console php
  composer require knpuniversity/oauth2-client-bundle
  # + le provider spécifique (voir EXEMPLES_PROVIDERS.md)
  ```

- [ ] Ajouter les variables dans `.env` :
  ```env
  SSO_CLIENT_ID=votre-client-id
  SSO_CLIENT_SECRET=votre-client-secret
  # + autres variables selon le provider
  ```

- [ ] Configurer `config/packages/knpu_oauth2_client.yaml`
- [ ] Créer l'Authenticator (`src/Security/SSOAuthenticator.php`)
- [ ] Créer le User Provider (`src/Security/SSOUserProvider.php`)
- [ ] Créer les routes
- [ ] Créer le contrôleur de login
- [ ] Vider le cache : `task cc`

### Étape 3 : Test (15 min)

- [ ] Accéder à : `https://votre-domaine.docker.localhost/login`
- [ ] Vérifier la redirection vers le provider SSO
- [ ] Se connecter avec un compte valide
- [ ] Vérifier le retour sur l'application
- [ ] Vérifier la session Symfony

---

## 🔗 Liens Utiles

- **Documentation complète** : `GUIDE_SSO_GENERIQUE.md`
- **Exemples par provider** : `EXEMPLES_PROVIDERS.md`

---

## ⚠️ Points d'Attention

1. **Secret Client** : Copiez-le immédiatement, il ne sera plus visible
2. **URI de Redirection** : Doivent correspondre **exactement** entre le provider et Symfony
3. **Scopes** : Configurez les permissions nécessaires (openid, profile, email minimum)
4. **Cache** : Videz le cache Symfony après chaque modification de configuration

---

## 🆘 Besoin d'Aide ?

Consultez la section **"Dépannage et Problèmes Courants"** dans `GUIDE_SSO_GENERIQUE.md`

---

## ✅ Prochaines Étapes

Une fois le test réussi :

1. Documenter votre expérience avec votre provider spécifique
2. Identifier les ajustements nécessaires
3. Valider avec des utilisateurs pilotes
4. Préparer le déploiement en production

