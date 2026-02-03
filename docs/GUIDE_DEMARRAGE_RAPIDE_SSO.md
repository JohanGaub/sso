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

#### 2.1 Installation du Bundle OAuth2

- [ ] **Installer le bundle principal** :
  ```bash
  task console php
  composer require knpuniversity/oauth2-client-bundle
  ```
  > 💡 Le bundle va créer automatiquement le fichier `config/packages/knpu_oauth2_client.yaml`

- [ ] **Installer le provider spécifique** (voir EXEMPLES_PROVIDERS.md pour votre provider) :
  ```bash
  # Exemple pour Google
  composer require league/oauth2-google
  
  # Exemple pour GitHub
  composer require league/oauth2-github
  
  # Exemple pour Microsoft
  composer require stevenmaguire/oauth2-microsoft
  ```

#### 2.2 Configuration du Fichier `knpu_oauth2_client.yaml`

⚠️ **Important** : Après l'installation, le bundle crée un fichier `config/packages/knpu_oauth2_client.yaml` avec un template. Vous devez le configurer selon la [documentation officielle du bundle](https://github.com/knpuniversity/oauth2-client-bundle?tab=readme-ov-file#configuring-a-client).

- [ ] **Consulter la documentation officielle** :
  - 📚 **Lien direct** : https://github.com/knpuniversity/oauth2-client-bundle?tab=readme-ov-file#configuring-a-client
  - Cette documentation liste toutes les options disponibles pour chaque type de provider

- [ ] **Configurer le fichier** `config/packages/knpu_oauth2_client.yaml` :
  - ⚠️ **Ne pas utiliser** d'options qui n'existent pas pour votre provider (ex: `graph_api_version` pour Google, `scopes` dans la config)
  - ✅ **Options communes** : `type`, `client_id`, `client_secret`, `redirect_route`
  - 📖 **Référence** : Voir `EXEMPLES_PROVIDERS.md` pour des exemples concrets par provider

- [ ] **Ajouter les variables dans `.env`** :
  ```env
  ###> SSO Google ###
  GOOGLE_CLIENT_ID=votre-client-id
  GOOGLE_CLIENT_SECRET=votre-client-secret
  ###< SSO Google ###
  ```

#### 2.3 Suite de la Configuration

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

---

## 🎯 Que Faire Après le Test Réussi ?

Vous avez deux options :

### Option 1 : Test Rapide Terminé ✅

Si vous vouliez juste **tester rapidement** que le SSO fonctionne, c'est terminé ! Vous pouvez :
- Documenter votre expérience
- Valider avec des utilisateurs pilotes
- Préparer le déploiement en production

### Option 2 : Implémentation Complète 🚀

Si vous voulez **implémenter toutes les fonctionnalités** (Authentification, Compte Juste-à-Temps, Gestion des Rôles, etc.) :

> **➡️ Basculer vers `PHASE_1_MVP.md`**  
> ⚠️ **Important** : Une fois que vous basculez vers PHASE_1_MVP.md, **ne revenez plus sur ce guide**. PHASE_1_MVP.md reprend tout depuis le début avec plus de détails et couvre toutes les fonctionnalités.

**Ce que vous allez trouver dans PHASE_1_MVP.md :**
- ✅ Installation et configuration détaillée (vous pouvez sauter si déjà fait)
- ✅ Modèle de données (entité User avec champs SSO)
- ✅ Authentification OAuth2 complète
- ✅ Compte Juste-à-Temps (création automatique d'utilisateurs)
- ✅ Gestion des Rôles/Autorisations
- ✅ Tests et validation

**Temps estimé pour l'implémentation complète :** 1 semaine

