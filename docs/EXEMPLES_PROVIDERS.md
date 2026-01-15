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

1. **Accéder à** : https://console.cloud.google.com/
2. **Créer un projet** ou sélectionner un projet existant
3. **Activer l'API** : "Google+ API" ou "Google Identity"
4. **Créer des identifiants OAuth 2.0** :
   - Type : Application Web
   - URI de redirection autorisés :
     - `https://votre-domaine.docker.localhost/login/check/google`
     - `http://localhost:8000/login/check/google`
5. **Noter** :
   - Client ID
   - Client Secret

### Installation

```bash
composer require league/oauth2-google
```

### Configuration `.env`

```env
###> SSO Google ###
GOOGLE_CLIENT_ID=votre-client-id-google.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=votre-client-secret-google
###< SSO Google ###
```

### Configuration `config/packages/knpu_oauth2_client.yaml`

```yaml
knpu_oauth2_client:
    clients:
        google:
            type: google
            client_id: '%env(GOOGLE_CLIENT_ID)%'
            client_secret: '%env(GOOGLE_CLIENT_SECRET)%'
            scopes: ['openid', 'profile', 'email']
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

