# 🚀 Phase 1 - MVP : Plan d'Implémentation Complète

> **Objectif** : Implémenter les fonctionnalités core du SSO (Authentification Unique, Compte Juste-à-Temps, Gestion des Rôles).  
> Cochez chaque étape au fur et à mesure de l'avancement.

---

## ⚠️ Point d'Entrée Important

> **💡 Vous êtes ici pour implémenter la solution complète.**  
> Si vous voulez juste **tester rapidement** le SSO (2h), utilisez plutôt `GUIDE_DEMARRAGE_RAPIDE_SSO.md`.  
> **Une fois que vous commencez ce document, suivez-le jusqu'au bout** - ne revenez pas en arrière vers le guide de démarrage rapide.

**Ce document couvre :**
- ✅ Installation et configuration complète
- ✅ Modèle de données (entité User)
- ✅ Authentification OAuth2 complète
- ✅ Compte Juste-à-Temps (JIT)
- ✅ Gestion des Rôles/Autorisations
- ✅ Tests et validation

**Temps estimé :** 1 semaine

---

## 🔌 Provider de Départ (IdP)

> **Important** : Choisissez le provider avec lequel vous souhaitez commencer.  
> Il est recommandé de commencer avec un seul provider pour valider le flux, puis d'étendre aux autres.

### Providers Disponibles

- [X] **Google** (Google OAuth2)
  - Documentation : https://developers.google.com/identity/protocols/oauth2
  - Scopes 
  - recommandés : `openid`, `email`, `profile`
  - Support des groupes : Via Google Workspace (entreprise)

- [ ] **Microsoft** (Azure AD / Microsoft Entra ID)
  - Documentation : https://learn.microsoft.com/en-us/entra/identity-platform/
  - Scopes recommandés : `openid`, `email`, `profile`, `User.Read`
  - Support des groupes : Oui (via Microsoft Graph API)

- [ ] **GitHub**
  - Documentation : https://docs.github.com/en/apps/oauth-apps/building-oauth-apps
  - Scopes recommandés : `read:user`, `user:email`
  - Support des groupes : Via organisations GitHub

- [ ] **Facebook**
  - Documentation : https://developers.facebook.com/docs/facebook-login/
  - Scopes recommandés : `email`, `public_profile`
  - Support des groupes : Limité

- [ ] **Apple** (Sign in with Apple)
  - Documentation : https://developer.apple.com/sign-in-with-apple/
  - Scopes recommandés : `email`, `name`
  - Support des groupes : Non

- [ ] **Okta**
  - Documentation : https://developer.okta.com/docs/guides/implement-oauth-for-okta/
  - Scopes recommandés : `openid`, `email`, `profile`
  - Support des groupes : Oui (via Okta Groups API)

- [ ] **Auth0**
  - Documentation : https://auth0.com/docs/get-started/authentication-and-authorization-flow
  - Scopes recommandés : `openid`, `email`, `profile`
  - Support des groupes : Oui (via Auth0 Management API)

- [ ] **Keycloak** (Self-hosted)
  - Documentation : https://www.keycloak.org/documentation
  - Scopes recommandés : `openid`, `email`, `profile`
  - Support des groupes : Oui (via Keycloak Groups API)

### Recommandation

Pour commencer, **Google** ou **Microsoft** sont les plus simples à configurer et les plus documentés.  
**GitHub** est également un bon choix si vous travaillez dans un environnement technique.

---

## 🔑 Scopes OAuth2

> **Important** : Les scopes définissent les permissions que l'application demande à l'IdP.  
> Cochez les scopes nécessaires selon vos besoins fonctionnels.

### Scopes Essentiels (Obligatoires pour le SSO de base)

Ces scopes sont **requis** pour le fonctionnement minimal du SSO :

- [X] **`openid`** (OpenID Connect)
  - **Nécessaire pour** : Authentification Unique (SSO)
  - **Description** : Active OpenID Connect, permet de recevoir un ID token
  - **Provider support** : Tous (standard OpenID Connect)

- [X] **`email`**
  - **Nécessaire pour** : Authentification Unique, Compte Juste-à-Temps
  - **Description** : Accès à l'adresse email de l'utilisateur
  - **Provider support** : Tous

- [X] **`profile`**
  - **Nécessaire pour** : Authentification Unique, Compte Juste-à-Temps
  - **Description** : Accès aux informations de profil (nom, prénom, photo, etc.)
  - **Provider support** : Tous

### Scopes Optionnels (Fonctionnalités avancées)

Ces scopes sont **optionnels** selon les fonctionnalités souhaitées :

- [X] **`groups`** ou **`GroupMember.Read.All`** (Microsoft) / **`https://www.googleapis.com/auth/admin.directory.group.readonly`** (Google)
  - **Nécessaire pour** : Gestion des Rôles/Autorisations (Phase 1)
  - **Description** : Accès aux groupes/équipes de l'utilisateur
  - **Provider support** : Microsoft, Google Workspace, Okta, Auth0, Keycloak
  - **Note** : Nécessite des permissions administrateur pour certains providers

- [ ] **`roles`** ou **`Directory.Read.All`** (Microsoft)
  - **Nécessaire pour** : Gestion des Rôles/Autorisations (Phase 1)
  - **Description** : Accès aux rôles de l'utilisateur
  - **Provider support** : Microsoft, Okta, Auth0, Keycloak
  - **Note** : Alternative ou complément aux groupes selon le provider

- [ ] **`offline_access`** ou **`refresh_token`**
  - **Nécessaire pour** : Gestion des Sessions (Phase 2)
  - **Description** : Permet d'obtenir un refresh token pour renouveler l'accès
  - **Provider support** : Tous (nom peut varier)

- [ ] **`User.Read`** (Microsoft) / **`userinfo.email`** (Google)
  - **Nécessaire pour** : Mise à Jour du Profil Utilisateur (Phase 2)
  - **Description** : Lecture des informations utilisateur (peut être inclus dans `profile`)
  - **Provider support** : Microsoft, Google

### Recommandations par Phase

**Phase 1 (MVP) - Scopes minimum :**
- ✅ `openid` (obligatoire)
- ✅ `email` (obligatoire)
- ✅ `profile` (obligatoire)
- ✅ `groups` ou `roles` (si Gestion des Rôles activée)

**Phase 2 - Scopes additionnels :**
- `offline_access` (si Gestion des Sessions activée)
- `User.Read` (si Mise à Jour du Profil activée)

### Notes Importantes

- ⚠️ **Demander uniquement les scopes nécessaires** : Principe du moindre privilège
- ⚠️ **Vérifier les permissions requises** : Certains scopes (comme `groups`) nécessitent des permissions administrateur
- ⚠️ **Variations par provider** : Les noms des scopes peuvent varier selon l'IdP (ex: `groups` vs `GroupMember.Read.All`)
- ⚠️ **Consentement utilisateur** : Plus de scopes = plus de permissions demandées à l'utilisateur

---

## 📦 1. Installation et Configuration de Base

### 1.1 Installation du Bundle OAuth2
- [X] Installer `knpuniversity/oauth2-client-bundle` (bundle OAuth2 pour Symfony)
  ```bash
  composer require knpuniversity/oauth2-client-bundle
  ```
  > 💡 Le bundle crée automatiquement `config/packages/knpu_oauth2_client.yaml` avec un template
- [X] Installer `symfony/security-bundle` (déjà présent, vérifier)
- [X] Installer `doctrine/orm-pack` (déjà présent, vérifier)

### 1.2 Configuration OAuth2 Client
⚠️ **Important** : Cette étape doit être faite **AVANT** d'installer le provider spécifique (`league/oauth2-google`), sinon vous aurez des erreurs lors de l'installation.

- [ ] Configurer `config/packages/knpu_oauth2_client.yaml` :
  - 📚 Consulter la [documentation officielle](https://github.com/knpuniversity/oauth2-client-bundle?tab=readme-ov-file#configuring-a-client)
  - ⚠️ Ne pas utiliser d'options invalides (`graph_api_version`, `scopes` dans la config pour Google)
  - ✅ Configuration minimale pour Google :
    ```yaml
    knpu_oauth2_client:
        clients:
            google:
                type: google
                client_id: '%env(GOOGLE_CLIENT_ID)%'
                client_secret: '%env(GOOGLE_CLIENT_SECRET)%'
                redirect_route: connect_google_check
    ```
- [ ] Configurer les variables d'environnement dans `.env` :
  ```env
  ###> SSO Google ###
  GOOGLE_CLIENT_ID=votre-client-id-google.apps.googleusercontent.com
  GOOGLE_CLIENT_SECRET=votre-client-secret-google
  ###< SSO Google ###
  ```
- [ ] Ajouter les mêmes variables dans `env.example` (sans les valeurs réelles)
- [ ] Vérifier la configuration : `task cc` (doit fonctionner sans erreur)

### 1.3 Installation du Provider Spécifique
⚠️ **Important** : Cette étape doit être faite **APRÈS** la configuration de `knpu_oauth2_client.yaml` (étape 1.2).

- [X] Installer `league/oauth2-google` (provider Google OAuth2)
  ```bash
  composer require league/oauth2-google
  ```
  > 💡 Si vous avez une erreur, vérifiez que `knpu_oauth2_client.yaml` est correctement configuré (étape 1.2)

### 1.4 Configuration Security
- [ ] Configurer `config/packages/security.yaml` avec le firewall SSO
- [ ] Ajouter l'authenticator OAuth2 dans le firewall `main`
- [ ] Configurer le provider d'utilisateurs (User Provider)
- [ ] Définir les routes publiques (`/login`, `/login/check/google`) et protégées
- [ ] Configurer `access_control` pour les routes nécessitant une authentification

---

## 🗄️ 2. Modèle de Données

### 2.1 Entité User
- [ ] Utiliser `php bin/console make:user` pour générer l'entité User (recommandé Symfony)
  - Répondre "yes" pour stocker dans la base de données
  - Choisir `email` comme identifiant unique
  - Répondre "no" pour le hashage de mot de passe (SSO, pas de mot de passe local)
- [ ] Ajouter les champs supplémentaires nécessaires pour SSO :
  - `idpIdentifier` (string, unique, identifiant unique de l'IdP)
  - `idpProvider` (string, nom du provider : google, microsoft, etc.)
  - `firstName` / `lastName` (string, nullable, depuis l'IdP)
  - `avatar` (string, nullable, URL de la photo de profil)
- [ ] Implémenter `UserInterface` (déjà fait par `make:user`)
- [ ] Ajouter les contraintes de validation (Assert) sur les champs

### 2.2 Migration Doctrine
- [ ] Générer la migration : `php bin/console make:migration`
- [ ] Vérifier le SQL généré
- [ ] Exécuter la migration : `php bin/console doctrine:migrations:migrate`

---

## 🔐 3. Authentification OAuth2

### 3.1 Service UserProvider
- [ ] Créer `src/Security/OAuth2UserProvider.php`
- [ ] Implémenter `OAuth2UserProviderInterface` (ou créer un service personnalisé)
- [ ] Implémenter la logique de récupération/création d'utilisateur depuis l'IdP
- [ ] Gérer le mapping des données IdP → User (email, firstName, lastName, etc.)
- [ ] Gérer le Compte Juste-à-Temps (création automatique si utilisateur inexistant)

### 3.2 Authenticator OAuth2
- [ ] Créer `src/Security/GoogleAuthenticator.php` (ou utiliser `OAuth2Authenticator` du bundle)
- [ ] Étendre `KnpU\OAuth2ClientBundle\Security\Authenticator\OAuth2Authenticator`
- [ ] Implémenter `authenticate()` : récupérer l'utilisateur depuis le token OAuth2
- [ ] Implémenter `onAuthenticationSuccess()` : redirection après connexion réussie
- [ ] Implémenter `onAuthenticationFailure()` : gestion des erreurs d'authentification
- [ ] Configurer l'authenticator dans `security.yaml` (firewall `main`)

### 3.3 Contrôleur d'Authentification
- [ ] Créer `src/Controller/SecurityController.php`
- [ ] Route `/login` : redirection vers l'IdP (utiliser `KnpUOAuth2ClientBundle:Client:redirect`)
- [ ] Route `/login/check/google` : callback OAuth2 (géré automatiquement par le bundle)
- [ ] Route `/logout` : déconnexion (géré par Symfony Security)

---

## 👤 4. Compte Juste-à-Temps (JIT)

### 4.1 Logique de Création Automatique
- [ ] Dans `OAuth2UserProvider`, vérifier si l'utilisateur existe (par `idpIdentifier`)
- [ ] Si inexistant, créer automatiquement un nouveau `User`
- [ ] Mapper les données de l'IdP vers l'entité User
- [ ] Persister l'utilisateur en base

### 4.2 Mapping des Données IdP
- [ ] Définir le mapping email (obligatoire)
- [ ] Définir le mapping firstName / lastName (si disponibles)
- [ ] Gérer les cas où certaines données sont absentes

---

## 🎭 5. Gestion des Rôles/Autorisations

### 5.1 Service de Mapping des Rôles
- [ ] Créer `src/Service/RoleMapperService.php`
- [ ] Implémenter la logique de mapping IdP → Symfony
- [ ] Exemple : groupe "Administrateurs" → `ROLE_ADMIN`

### 5.2 Configuration des Mappings
- [ ] Créer `config/packages/sso.yaml` pour les mappings de rôles
- [ ] Définir les mappings par provider (Google, Microsoft, etc.)
- [ ] Gérer les rôles par défaut (ex: `ROLE_USER`)

### 5.3 Attribution des Rôles
- [ ] Dans `OAuth2UserProvider`, appeler `RoleMapperService`
- [ ] Attribuer les rôles à l'utilisateur lors de la création/mise à jour
- [ ] Vérifier que les rôles sont bien persistés

---

## 🧪 6. Tests et Validation

### 6.1 Tests Fonctionnels
- [ ] Tester le flux complet : `/login` → redirection IdP → callback → création User
- [ ] Tester la création JIT d'un nouvel utilisateur
- [ ] Tester la connexion d'un utilisateur existant
- [ ] Tester l'attribution des rôles

### 6.2 Tests de Sécurité
- [ ] Vérifier que les routes protégées nécessitent une authentification
- [ ] Vérifier que les tokens OAuth2 sont valides
- [ ] Tester le cas d'erreur (IdP indisponible, token invalide)

### 6.3 Documentation
- [ ] Documenter les variables d'environnement nécessaires
- [ ] Documenter le flux d'authentification
- [ ] Créer un exemple de configuration pour un provider (ex: Google)

---

## 📋 Checklist de Validation Finale

- [ ] Un utilisateur peut se connecter via l'IdP
- [ ] Un nouvel utilisateur est automatiquement créé (JIT)
- [ ] Les rôles sont correctement mappés depuis l'IdP
- [ ] Les routes protégées fonctionnent avec l'authentification SSO
- [ ] La déconnexion fonctionne
- [ ] Aucune erreur PHPStan
- [ ] Les migrations sont appliquées
- [ ] La documentation est à jour

---

## 🔗 Ordre d'Implémentation Recommandé

1. **Installation et Configuration de Base** (1.1 → 1.2 → 1.3 → 1.4)
   - ⚠️ **Ordre important** : Bundle → Config YAML → Provider → Security
2. **Modèle de Données** (2.1, 2.2)
3. **Authentification OAuth2** (3.1, 3.2, 3.3)
4. **Compte Juste-à-Temps** (4.1, 4.2)
5. **Gestion des Rôles** (5.1, 5.2, 5.3)
6. **Tests** (6.1, 6.2, 6.3)

---

## 📝 Notes

- **Provider choisi** : Cochez le provider de départ dans la section "Provider de Départ" ci-dessus.
- Commencer par un seul provider pour valider le flux, puis étendre aux autres.
- Les étapes sont conçues pour être itératives : tester après chaque section.
- En cas de blocage, vérifier la documentation Symfony Security et OAuth2 Client.
- Les configurations spécifiques à chaque provider seront documentées au fur et à mesure de l'implémentation.
