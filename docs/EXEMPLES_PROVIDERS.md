# Exemples d'Intégration SSO par Provider

Ce document fournit des exemples concrets d'intégration pour différents providers SSO compatibles OAuth2/OpenID Connect.

## 📋 Providers Disponibles

- [Google OAuth2](#google-oauth2)
- [GitHub OAuth2](#github-oauth2)
- [Keycloak](#keycloak)
- [Auth0](#auth0)
- [Okta](#okta)
- [Provider Générique OAuth2](#provider-générique-oauth2)

---

## Google OAuth2

### Configuration Google Cloud Console

- [X] **Accéder à** : https://console.cloud.google.com/
- [X] **Créer un projet** ou sélectionner un projet existant
  - Exemple de nom : `sso-project-001`
- [X] **Activer l'API** : ⚠️ **Non nécessaire pour un SSO simple**
  - Pour un SSO basique (email, nom, profil), aucune API à activer
  - L'OAuth2 de base fonctionne sans activation d'API spécifique
  - Si besoin d'accéder à d'autres services Google (Drive, Gmail, etc.), activer l'API correspondante

### Configuration Traefik pour localtest.me (Développement)

⚠️ **Pour utiliser HTTPS avec Google OAuth2, configurer Traefik pour `localtest.me`**

- [X] **Ajouter la règle Traefik pour `localtest.me`** :
  - ✅ **Déjà configuré** dans `docker-compose.yml` :
    ```yaml
    traefik.http.routers.${COMPOSE_PROJECT_NAME}_nginx.rule=Host(`${COMPOSE_PROJECT_NAME}.docker.localhost`) || Host(`${COMPOSE_PROJECT_NAME}.docker.devhost`) || Host(`${COMPOSE_PROJECT_NAME}.localtest.me`)
    traefik.http.routers.${COMPOSE_PROJECT_NAME}_nginx.entrypoints=websecure
    traefik.http.routers.${COMPOSE_PROJECT_NAME}_nginx.tls=true
    ```
  - ⚠️ **Important** : `entrypoints=websecure` force HTTPS (port 443)
  - ⚠️ **Important** : `tls=true` active le chiffrement SSL/TLS
  - Redémarrer les conteneurs : `task restart`
- [X] **Vérifier l'accès HTTPS** :
  - Accéder à `https://sso.localtest.me/test` (le certificat SSL auto-signé fonctionnera)
  - ⚠️ **Note** : `localtest.me` résout automatiquement vers `127.0.0.1`, donc pas besoin de modifier `/etc/hosts`
  - ⚠️ **Sécurité** : Le trafic est chiffré entre le navigateur et Traefik (HTTPS)
  - ✅ **Vérification** : La page `/test` doit afficher "HTTPS Actif" (badge vert)

### Configuration Symfony : Trusted Proxies (Détection HTTPS)

⚠️ **Important** : Traefik fait du SSL termination (déchiffre HTTPS et transmet en HTTP à Nginx).  
Pour que Symfony détecte correctement HTTPS, il faut configurer les trusted proxies.

- [X] **Configuration Nginx** (`docker/nginx/symfony.template`) :
  - ✅ **Déjà configuré** : Les headers `X-Forwarded-*` sont transmis à PHP-FPM
  - Nginx transmet automatiquement les headers de Traefik vers PHP-FPM

- [X] **Configuration Symfony** (`config/packages/framework.yaml`) :
  - ✅ **Déjà configuré** selon la [documentation officielle Symfony](https://symfony.com/doc/current/deployment/proxies.html) :
    ```yaml
    framework:
        trusted_proxies: 'private_ranges'  # Réseaux privés Docker
        trusted_headers:
            - 'x-forwarded-for'
            - 'x-forwarded-host'
            - 'x-forwarded-proto'
            - 'x-forwarded-port'
    ```
  - ⚠️ **Important** : Cette configuration permet à Symfony de détecter HTTPS via le header `X-Forwarded-Proto: https` envoyé par Traefik

- [X] **Vérification** :
  - Accéder à `https://sso.localtest.me/test`
  - La page de test doit afficher "HTTPS Actif" (badge vert) ✅
  - La section "Sécurité & Certificat SSL" doit afficher "Certificat SSL validé" ✅
  - `$request->isSecure()` doit retourner `true` dans Symfony
  - 💡 **Astuce** : La page `/test` explique en détail le flux de données et la configuration

📚 **Documentation complète** : Voir `docs/INFRASTRUCTURE.md` - Section "Configuration Symfony : Trusted Proxies"

### Configuration de l'Écran de Consentement OAuth (Obligatoire)

⚠️ **Cette étape est obligatoire avant de créer les identifiants OAuth 2.0**

- [X] **Accéder à l'écran de consentement** :
  - Dans le menu latéral gauche : **API et services** → **Écran de consentement OAuth**
- [X] **Choisir le type d'utilisateur** :
  - Sélectionner **Externe** (pour que n'importe qui avec un compte Gmail puisse se connecter)
  - Cliquer sur **Créer**
- [X] **Remplir les informations obligatoires** :
  - [X] **Nom de l'application** : Le nom de votre projet (ex: "sso-project-001")
  - [X] **E-mail d'assistance utilisateur** : Votre adresse email
  - [X] **Coordonnées développeur** : Votre adresse email
- [X] **Enregistrer et continuer** :
  - Passer les étapes suivantes (Scopes et Utilisateurs tests)
  - ⚠️ **Important** : En phase de développement, ajouter votre propre email dans **"Utilisateurs tests"** pour pouvoir tester la connexion

### Création des Identifiants OAuth 2.0

- [ ] **Créer des identifiants OAuth 2.0** :
  - Dans le menu de gauche : **Identifiants**
  - Cliquer sur **+ CRÉER DES IDENTIFIANTS** → **ID client OAuth**
  - [X] **Type d'application** : Sélectionner **Application Web**
  - [X] **Nom** : Nom de votre client (ex: "Client Web 1")
  - [ ] **Origines JavaScript autorisées** (optionnel pour SSO) :
    - ⚠️ **Format** : Juste le domaine avec le protocole (sans chemin, sans port si port standard)
    - `https://sso.localtest.me` ✅ **Recommandé pour le développement**
    - ⚠️ **Important** : Pas de chemin à la fin, juste `https://sso.localtest.me` (pas `/login/check/google`)
    - `https://sso.docker.localhost` (si vous utilisez ce domaine)
    - `http://localhost:8000` (fallback si HTTPS non disponible, avec le port)
  - [ ] **URI de redirection autorisés** (⚠️ **OBLIGATOIRE**) :
    - ⚠️ **Important** : Google n'accepte **PAS** les domaines `.localhost` (ex: `sso.docker.localhost`)
    - **Solution recommandée pour le développement** : Utiliser `localtest.me` avec HTTPS
      - `https://sso.localtest.me/login/check/google` ✅ **Recommandé**
      - `localtest.me` résout automatiquement vers `127.0.0.1` (gratuit, pas d'installation)
      - ⚠️ **Note** : Le certificat SSL auto-signé fonctionne parfaitement pour OAuth2 en développement
      - ⚠️ **Fallback** : Si Google rejette `localtest.me`, utiliser `http://localhost:8000/login/check/google` (mais HTTPS est préférable)
    - Pour la production : `https://ton-domaine.com/login/check/google` (utiliser un vrai domaine avec certificat signé)
    - ⚠️ **Note** : Avec `knpuniversity/oauth2-client-bundle`, l'URI est généralement `/login/check/google` ou `/connect/google/check` selon votre configuration
    - ⚠️ **Sécurité** : HTTPS est requis pour OAuth2, mais un certificat auto-signé fonctionne en développement
  - Cliquer sur **Créer**

- [ ] **Copier immédiatement le Client ID et le Client Secret** :
  - ⚠️ **Le Client Secret ne sera plus visible après fermeture de la fenêtre**
  - **Client ID** : Copiez la valeur (ex: `123456789-abc.apps.googleusercontent.com`)
  - **Client Secret** : Cliquez sur "Afficher" et copiez la valeur

- [ ] **Ajouter ces valeurs dans votre fichier `.env`** :
  ```env
  ###> SSO Google ###
  GOOGLE_CLIENT_ID=123456789-abc.apps.googleusercontent.com
  GOOGLE_CLIENT_SECRET=GOCSPX-votre-secret-ici
  ###< SSO Google ###
  ```
  > 💡 Remplacez les valeurs par celles que vous venez de copier depuis Google Cloud Console

### Installation

#### Étape 1 : Installer le Bundle OAuth2

- [ ] **Installer le bundle principal** :
  ```bash
  task console php
  composer require knpuniversity/oauth2-client-bundle
  ```
  > 💡 Le bundle va créer automatiquement le fichier `config/packages/knpu_oauth2_client.yaml` avec un template

#### Étape 2 : Installer le Provider Google

- [ ] **Installer le provider Google** :
  ```bash
  composer require league/oauth2-google
  ```

### Configuration `.env`

- [ ] **Vérifier que les variables sont déjà dans `.env`** (vous les avez ajoutées lors de la création des identifiants OAuth ci-dessus)
- [ ] **Ajouter les mêmes variables dans `env.example`** (sans les valeurs réelles) :
  ```env
  ###> SSO Google ###
  GOOGLE_CLIENT_ID=
  GOOGLE_CLIENT_SECRET=
  ###< SSO Google ###
  ```

### Configuration `config/packages/knpu_oauth2_client.yaml`

⚠️ **Important** : Le fichier `config/packages/knpu_oauth2_client.yaml` est créé automatiquement lors de l'installation du bundle. Vous devez le configurer selon la [documentation officielle du bundle](https://github.com/knpuniversity/oauth2-client-bundle?tab=readme-ov-file#configuring-a-client).

**Étapes :**

1. **Consulter la documentation officielle** :
   - 📚 **Lien direct** : https://github.com/knpuniversity/oauth2-client-bundle?tab=readme-ov-file#configuring-a-client
   - Cette documentation liste toutes les options disponibles pour Google

2. **Configurer le fichier** :
   - ⚠️ **Ne pas utiliser** d'options qui n'existent pas pour Google :
     - ❌ `graph_api_version` : Option spécifique à Facebook/Microsoft
     - ❌ `scopes` : Les scopes sont configurés dans l'authenticator, pas ici
   - ✅ **Options valides pour Google** : `type`, `client_id`, `client_secret`, `redirect_route`, `redirect_params`, `use_state`, `access_type`, `hosted_domain`, `user_fields`, `use_oidc_mode`

3. **Configuration minimale recommandée** :
  ```yaml
  knpu_oauth2_client:
      clients:
          google:
              type: google
              client_id: '%env(GOOGLE_CLIENT_ID)%'
              client_secret: '%env(GOOGLE_CLIENT_SECRET)%'
              redirect_route: connect_google_check
              # Les scopes (openid, profile, email) sont configurés dans l'authenticator
  ```

4. **Vérifier la configuration** :
  ```bash
  task cc  # Vider le cache pour vérifier qu'il n'y a pas d'erreur
  ```

### Authenticator (exemple)

```php
use League\OAuth2\Client\Provider\GoogleUser;

// Dans authenticate()
/** @var GoogleUser $googleUser */
$googleUser = $client->fetchUserFromToken($accessToken);
$identifier = $googleUser->getEmail();
```

---

## GitHub OAuth2

### Configuration GitHub

1. **Accéder à** : https://github.com/settings/developers
2. **Nouvelle OAuth App** :
   - Application name : Nom de votre application
   - Homepage URL : URL de votre application
   - Authorization callback URL :
     - `https://votre-domaine.docker.localhost/login/check/github`
     - `http://localhost:8000/login/check/github`
3. **Noter** :
   - Client ID
   - Client Secret

### Installation

```bash
composer require league/oauth2-github
```

### Configuration `.env`

```env
###> SSO GitHub ###
GITHUB_CLIENT_ID=votre-client-id-github
GITHUB_CLIENT_SECRET=votre-client-secret-github
###< SSO GitHub ###
```

### Configuration `config/packages/knpu_oauth2_client.yaml`

```yaml
knpu_oauth2_client:
    clients:
        github:
            type: github
            client_id: '%env(GITHUB_CLIENT_ID)%'
            client_secret: '%env(GITHUB_CLIENT_SECRET)%'
            scopes: ['user:email', 'read:user']
```

### Authenticator (exemple)

```php
use League\OAuth2\Client\Provider\GithubResourceOwner;

// Dans authenticate()
/** @var GithubResourceOwner $githubUser */
$githubUser = $client->fetchUserFromToken($accessToken);
$identifier = $githubUser->getEmail() ?? $githubUser->getId();
```

---

## Keycloak

### Configuration Keycloak

1. **Accéder au console Keycloak** : `https://votre-keycloak.com/admin`
2. **Créer un Client** :
   - Client ID : Nom de votre application
   - Client Protocol : `openid-connect`
   - Access Type : `confidential` (ou `public` pour les apps publiques)
   - Valid Redirect URIs :
     - `https://votre-domaine.docker.localhost/login/check/keycloak`
     - `http://localhost:8000/login/check/keycloak`
3. **Dans l'onglet "Credentials"** :
   - Noter le Client Secret
4. **Noter** :
   - Client ID
   - Client Secret
   - Realm name
   - Base URL de Keycloak

### Installation

```bash
composer require stevenmaguire/oauth2-keycloak
```

### Configuration `.env`

```env
###> SSO Keycloak ###
KEYCLOAK_CLIENT_ID=votre-client-id
KEYCLOAK_CLIENT_SECRET=votre-client-secret
KEYCLOAK_REALM=votre-realm
KEYCLOAK_BASE_URL=https://votre-keycloak.com
###< SSO Keycloak ###
```

### Configuration `config/packages/knpu_oauth2_client.yaml`

```yaml
knpu_oauth2_client:
    clients:
        keycloak:
            type: keycloak
            client_id: '%env(KEYCLOAK_CLIENT_ID)%'
            client_secret: '%env(KEYCLOAK_CLIENT_SECRET)%'
            realm: '%env(KEYCLOAK_REALM)%'
            base_url: '%env(KEYCLOAK_BASE_URL)%'
            scopes: ['openid', 'profile', 'email']
```

### Authenticator (exemple)

```php
use Stevenmaguire\OAuth2\Client\Provider\KeycloakResourceOwner;

// Dans authenticate()
/** @var KeycloakResourceOwner $keycloakUser */
$keycloakUser = $client->fetchUserFromToken($accessToken);
$identifier = $keycloakUser->getEmail() ?? $keycloakUser->getId();
```

---

## Auth0

### Configuration Auth0

1. **Accéder à** : https://manage.auth0.com/
2. **Créer une Application** :
   - Type : Regular Web Application
   - Allowed Callback URLs :
     - `https://votre-domaine.docker.localhost/login/check/auth0`
     - `http://localhost:8000/login/check/auth0`
3. **Dans l'onglet "Settings"** :
   - Noter le Client ID
   - Noter le Client Secret
   - Noter le Domain (ex: `votre-tenant.auth0.com`)

### Installation

```bash
composer require auth0/auth0-php
# Ou utiliser le provider générique
composer require league/oauth2-client
```

### Configuration `.env`

```env
###> SSO Auth0 ###
AUTH0_CLIENT_ID=votre-client-id
AUTH0_CLIENT_SECRET=votre-client-secret
AUTH0_DOMAIN=votre-tenant.auth0.com
###< SSO Auth0 ###
```

### Configuration `config/packages/knpu_oauth2_client.yaml`

```yaml
knpu_oauth2_client:
    clients:
        auth0:
            type: generic
            client_id: '%env(AUTH0_CLIENT_ID)%'
            client_secret: '%env(AUTH0_CLIENT_SECRET)%'
            authorization_url: 'https://%env(AUTH0_DOMAIN)%/authorize'
            token_url: 'https://%env(AUTH0_DOMAIN)%/oauth/token'
            user_info_url: 'https://%env(AUTH0_DOMAIN)%/userinfo'
            scopes: ['openid', 'profile', 'email']
```

---

## Okta

### Configuration Okta

1. **Accéder à** : https://developer.okta.com/
2. **Créer une Application** :
   - Application type : Web
   - Sign-in redirect URIs :
     - `https://votre-domaine.docker.localhost/login/check/okta`
     - `http://localhost:8000/login/check/okta`
3. **Noter** :
   - Client ID
   - Client Secret
   - Okta Domain (ex: `votre-tenant.okta.com`)

### Installation

```bash
composer require league/oauth2-client
```

### Configuration `.env`

```env
###> SSO Okta ###
OKTA_CLIENT_ID=votre-client-id
OKTA_CLIENT_SECRET=votre-client-secret
OKTA_DOMAIN=votre-tenant.okta.com
###< SSO Okta ###
```

### Configuration `config/packages/knpu_oauth2_client.yaml`

```yaml
knpu_oauth2_client:
    clients:
        okta:
            type: generic
            client_id: '%env(OKTA_CLIENT_ID)%'
            client_secret: '%env(OKTA_CLIENT_SECRET)%'
            authorization_url: 'https://%env(OKTA_DOMAIN)%/oauth2/default/v1/authorize'
            token_url: 'https://%env(OKTA_DOMAIN)%/oauth2/default/v1/token'
            user_info_url: 'https://%env(OKTA_DOMAIN)%/oauth2/default/v1/userinfo'
            scopes: ['openid', 'profile', 'email']
```

---

## Provider Générique OAuth2

Pour tout provider OAuth2 standard qui n'a pas de package spécifique.

### Configuration `.env`

```env
###> SSO Générique ###
SSO_CLIENT_ID=votre-client-id
SSO_CLIENT_SECRET=votre-client-secret
SSO_AUTHORIZATION_URL=https://provider.com/oauth/authorize
SSO_TOKEN_URL=https://provider.com/oauth/token
SSO_USERINFO_URL=https://provider.com/oauth/userinfo
SSO_SCOPES=openid profile email
###< SSO Générique ###
```

### Configuration `config/packages/knpu_oauth2_client.yaml`

```yaml
knpu_oauth2_client:
    clients:
        sso:
            type: generic
            client_id: '%env(SSO_CLIENT_ID)%'
            client_secret: '%env(SSO_CLIENT_SECRET)%'
            authorization_url: '%env(SSO_AUTHORIZATION_URL)%'
            token_url: '%env(SSO_TOKEN_URL)%'
            user_info_url: '%env(SSO_USERINFO_URL)%'
            scopes: ['openid', 'profile', 'email']
```

### Installation

```bash
composer require league/oauth2-client
```

---

## 🔍 Comment Choisir le Bon Provider ?

### Critères de Sélection

1. **Coût** :
   - ✅ Gratuit : Google, GitHub (limité), Keycloak (self-hosted)
   - 💰 Payant : Auth0, Okta, Microsoft Entra ID Premium

2. **Complexité** :
   - 🟢 Simple : Google, GitHub
   - 🟡 Moyen : Auth0, Okta
   - 🔴 Complexe : Keycloak (self-hosted), Microsoft Entra ID

3. **Fonctionnalités** :
   - **Gestion des utilisateurs** : Auth0, Okta, Keycloak
   - **Multi-tenant** : Keycloak, Auth0, Okta
   - **SSO entre applications** : Tous
   - **MFA/2FA** : Auth0, Okta, Microsoft Entra ID

4. **Contrôle** :
   - **Self-hosted** : Keycloak (contrôle total)
   - **SaaS** : Google, GitHub, Auth0, Okta (géré par le provider)

---

## 📚 Ressources par Provider

### Google
- [Documentation Google OAuth2](https://developers.google.com/identity/protocols/oauth2)
- [Google Identity Platform](https://developers.google.com/identity)

### GitHub
- [Documentation GitHub OAuth](https://docs.github.com/en/apps/oauth-apps)
- [GitHub OAuth Apps](https://github.com/settings/developers)

### Keycloak
- [Documentation Keycloak](https://www.keycloak.org/documentation)
- [Keycloak Server Administration Guide](https://www.keycloak.org/docs/latest/server_admin/)

### Auth0
- [Documentation Auth0](https://auth0.com/docs)
- [Auth0 Quickstarts](https://auth0.com/docs/quickstarts)

### Okta
- [Documentation Okta](https://developer.okta.com/docs/)
- [Okta OAuth 2.0](https://developer.okta.com/docs/guides/implement-oauth-for-okta/)

---

**💡 Conseil** : Commencez par un provider simple (Google ou GitHub) pour valider l'architecture, puis migrez vers votre provider final si nécessaire.

