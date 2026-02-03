# Guide Générique : Intégration SSO OAuth2/OpenID Connect dans Symfony

## 📋 Table des Matières

1. [Vue d'ensemble](#vue-densemble)
2. [Concepts Clés OAuth2/OpenID Connect](#concepts-clés-oauth2openid-connect)
3. [Prérequis et Configuration Initiale](#prérequis-et-configuration-initiale)
4. [Étape 1 : Configuration du Provider SSO](#étape-1--configuration-du-provider-sso)
5. [Étape 2 : Configuration de l'Application Symfony](#étape-2--configuration-de-lapplication-symfony)
6. [Étape 3 : Test de l'Authentification SSO](#étape-3--test-de-lauthentification-sso)
7. [Dépannage et Problèmes Courants](#dépannage-et-problèmes-courants)
8. [Exemples par Provider](#exemples-par-provider)

---

## Vue d'ensemble

Cette documentation vous guide pour intégrer n'importe quel système SSO (Single Sign-On) compatible OAuth2/OpenID Connect dans votre application Symfony 8. Cette approche générique fonctionne avec la plupart des providers : Google, GitHub, Keycloak, Auth0, Okta, etc.

### Objectif

Remplacer l'authentification actuelle par une authentification SSO via OAuth2/OpenID Connect, en gardant une approche générique et adaptable à différents providers.

---

## Concepts Clés OAuth2/OpenID Connect

### OAuth 2.0

**OAuth 2.0** est un protocole d'autorisation qui permet à une application d'accéder à des ressources protégées au nom d'un utilisateur, sans exposer le mot de passe de l'utilisateur.

### OpenID Connect (OIDC)

**OpenID Connect** est une couche d'identité construite sur OAuth 2.0. Il permet à l'application de vérifier l'identité de l'utilisateur et d'obtenir des informations de base sur celui-ci.

### Terminologie

- **Provider SSO** : Le service d'authentification (Google, GitHub, Keycloak, etc.)
- **Client ID** : Identifiant unique de votre application chez le provider
- **Client Secret** : Secret partagé pour l'authentification (à garder confidentiel)
- **Authorization Endpoint** : URL où l'utilisateur est redirigé pour s'authentifier
- **Token Endpoint** : URL pour échanger le code d'autorisation contre un token
- **Redirect URI / Callback URL** : URL de retour après authentification (doit correspondre exactement)
- **Scopes** : Permissions demandées (ex: `openid`, `profile`, `email`)
- **Claims** : Informations sur l'utilisateur retournées (email, nom, etc.)

### Flux d'Authentification OAuth2 (Authorization Code Flow)

```
1. Utilisateur → Application : Clique sur "Se connecter"
2. Application → Provider : Redirige vers l'Authorization Endpoint
3. Provider → Utilisateur : Affiche la page de connexion
4. Utilisateur → Provider : S'authentifie
5. Provider → Application : Redirige vers Redirect URI avec un code
6. Application → Provider : Échange le code contre un access token
7. Application → Provider : Récupère les informations utilisateur (claims)
8. Application : Crée/connecte l'utilisateur dans Symfony
```

---

## Prérequis et Configuration Initiale

### Prérequis Techniques

- ✅ Application Symfony 8 fonctionnelle
- ✅ Composer installé
- ✅ Accès au provider SSO (compte, permissions, etc.)
- ✅ Accès à Internet pour les appels API du provider
- ✅ PHP 8.2+ avec extensions nécessaires

### Prérequis Fonctionnels

- Comprendre le flux d'authentification actuel
- Identifier les utilisateurs qui devront se connecter
- Définir les permissions/claims nécessaires (email, nom, groupes, etc.)
- Choisir le provider SSO (Google, GitHub, Keycloak, Auth0, etc.)

### Checklist Pré-Implémentation

- [ ] Provider SSO choisi et accessible
- [ ] Compte administrateur ou permissions pour créer une application
- [ ] Documenter le flux d'authentification actuel
- [ ] Identifier les données utilisateur nécessaires
- [ ] Préparer un environnement de test isolé

---

## Étape 1 : Configuration du Provider SSO

Cette étape varie selon le provider, mais les concepts sont similaires. Consultez `EXEMPLES_PROVIDERS.md` pour des exemples concrets.

### 1.1 Créer une Application/OAuth Client

Dans votre provider SSO, créez une nouvelle application/OAuth client :

1. **Accéder au portail d'administration** du provider
2. **Créer une nouvelle application** (nom, description)
3. **Noter les identifiants** :
   - **Client ID** (aussi appelé Application ID, Consumer Key, etc.)
   - **Client Secret** (aussi appelé Application Secret, Consumer Secret, etc.)
   - ⚠️ **Copier immédiatement le secret** (il ne sera plus visible)

### 1.2 Configurer les URI de Redirection

Configurez les URI de redirection (Redirect URI / Callback URL) :

**Pour le développement local :**
```
https://votre-domaine.docker.localhost/login/check/{provider}
http://localhost:8000/login/check/{provider}
```

**Pour la production :**
```
https://votre-domaine.com/login/check/{provider}
```

⚠️ **Important** : Les URI doivent correspondre **exactement** à ceux configurés dans Symfony (protocole, domaine, port, chemin).

### 1.3 Configurer les Scopes/Permissions

Configurez les scopes nécessaires selon vos besoins :

**Scopes de base (OpenID Connect) :**
- `openid` : Nécessaire pour OpenID Connect
- `profile` : Informations de profil (nom, prénom)
- `email` : Adresse email

**Scopes additionnels (selon le provider) :**
- Groupes/rôles
- Informations organisationnelles
- Permissions spécifiques

### 1.4 Récupérer les Endpoints

Notez les URLs suivantes (généralement disponibles dans la documentation du provider) :

- **Authorization Endpoint** : URL pour l'authentification
- **Token Endpoint** : URL pour échanger le code contre un token
- **UserInfo Endpoint** : URL pour récupérer les informations utilisateur
- **JWKS URI** : URL pour les clés publiques (si JWT)

### 📝 Checklist de Configuration Provider

- [ ] Application créée avec un nom clair
- [ ] Client ID noté et sécurisé
- [ ] Client Secret créé et valeur copiée (⚠️ ne sera plus visible)
- [ ] URI de redirection configurés (exactement comme dans Symfony)
- [ ] Scopes configurés selon les besoins
- [ ] Endpoints notés (Authorization, Token, UserInfo)
- [ ] Permissions/consentement accordés si nécessaire

---

## Étape 2 : Configuration de l'Application Symfony

### 2.1 Installation des Dépendances

Dans votre projet Symfony, installez le bundle OAuth2 :

```bash
# Accéder au conteneur PHP
task console php

# Dans le conteneur
composer require knpuniversity/oauth2-client-bundle
```

> 💡 **Pourquoi ce bundle et pas HWIOAuthBundle ?**  
> `knpuniversity/oauth2-client-bundle` est plus léger et moderne : il s'appuie sur `league/oauth2-client`, s'intègre bien avec le système de sécurité actuel de Symfony et reste très simple à utiliser pour quelques providers (comme Google), là où HWIOAuthBundle est plus lourd et pensé pour des cas d'usage plus complexes ou historiques.

**Pour un provider spécifique**, installez le provider correspondant :

```bash
# Exemples (choisissez celui qui correspond à votre provider)
composer require league/oauth2-google
composer require league/oauth2-github
composer require stevenmaguire/oauth2-microsoft
# Ou un provider générique pour OAuth2 standard
composer require league/oauth2-client
```

### 2.2 Configuration du Bundle dans Symfony

#### 2.2.1 Fichier `.env`

Ajoutez les variables suivantes à votre fichier `.env` :

```env
###> SSO OAuth2 ###
SSO_CLIENT_ID=votre-client-id-ici
SSO_CLIENT_SECRET=votre-client-secret-ici
SSO_AUTHORIZATION_URL=https://provider.com/oauth/authorize
SSO_TOKEN_URL=https://provider.com/oauth/token
SSO_USERINFO_URL=https://provider.com/oauth/userinfo
SSO_SCOPES=openid profile email
###< SSO OAuth2 ###
```

⚠️ **Sécurité** : 
- Ne commitez **JAMAIS** le fichier `.env` avec les secrets
- Utilisez les variables d'environnement ou Symfony Secrets pour la production

#### 2.2.2 Fichier `config/packages/knpu_oauth2_client.yaml`

⚠️ **Important** : Après l'installation du bundle (`composer require knpuniversity/oauth2-client-bundle`), le fichier `config/packages/knpu_oauth2_client.yaml` est créé automatiquement avec un template. Vous devez le configurer selon la [documentation officielle du bundle](https://github.com/knpuniversity/oauth2-client-bundle?tab=readme-ov-file#configuring-a-client).

**Étapes de configuration :**

1. **Consulter la documentation officielle** :
   - 📚 **Lien direct** : https://github.com/knpuniversity/oauth2-client-bundle?tab=readme-ov-file#configuring-a-client
   - Cette documentation liste toutes les options disponibles pour chaque type de provider

2. **Configurer selon votre provider** :
   - ⚠️ **Attention** : Ne pas utiliser d'options qui n'existent pas pour votre provider
   - ⚠️ **Erreurs courantes** :
     - `graph_api_version` : Option spécifique à Facebook/Microsoft, **ne pas utiliser pour Google**
     - `scopes` : Les scopes sont configurés dans l'authenticator, **pas dans ce fichier** pour les providers spécifiques
   - ✅ **Options communes** : `type`, `client_id`, `client_secret`, `redirect_route`

**Exemple pour Google (voir EXEMPLES_PROVIDERS.md pour plus de détails) :**

```yaml
knpu_oauth2_client:
    clients:
        google:
            type: google
            client_id: '%env(GOOGLE_CLIENT_ID)%'
            client_secret: '%env(GOOGLE_CLIENT_SECRET)%'
            redirect_route: connect_google_check
            # Les scopes sont configurés dans l'authenticator, pas ici
```

**Exemple générique (OAuth2 standard) :**

```yaml
knpu_oauth2_client:
    clients:
        sso:
            type: generic
            provider_class: Your\Provider\Class
            client_id: '%env(SSO_CLIENT_ID)%'
            client_secret: '%env(SSO_CLIENT_SECRET)%'
            redirect_route: connect_sso_check
            # Pour un provider générique, vous pouvez spécifier les URLs
            # authorization_url: '%env(SSO_AUTHORIZATION_URL)%'
            # token_url: '%env(SSO_TOKEN_URL)%'
```

> 💡 **Référence complète** : Consultez `EXEMPLES_PROVIDERS.md` pour des exemples détaillés par provider (Google, GitHub, Microsoft, etc.)

#### 2.2.3 Configuration de la Sécurité (`config/packages/security.yaml`)

Ajoutez la configuration d'authentification :

```yaml
security:
    # ... configuration existante ...
    
    firewalls:
        main:
            # ... configuration existante ...
            
            # Ajouter le guard OAuth2
            oauth2:
                resource_owners:
                    sso:
                        login_path: /login
                        check_path: /login/check/sso
                        failure_path: /login
                        oauth_user_provider:
                            service: App\Security\SSOUserProvider
```

### 2.3 Création de l'Authenticator

Créez un fichier `src/Security/SSOAuthenticator.php` :

```php
<?php

namespace App\Security;

use KnpU\OAuth2ClientBundle\Security\Authenticator\OAuth2Authenticator;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\Routing\RouterInterface;
use Symfony\Component\Security\Core\Authentication\Token\TokenInterface;
use Symfony\Component\Security\Core\Exception\AuthenticationException;
use Symfony\Component\Security\Http\Authenticator\Passport\Badge\UserBadge;
use Symfony\Component\Security\Http\Authenticator\Passport\SelfValidatingPassport;
use League\OAuth2\Client\Provider\ResourceOwnerInterface;

class SSOAuthenticator extends OAuth2Authenticator
{
    public function __construct(
        private RouterInterface $router,
        private SSOUserProvider $userProvider
    ) {
        parent::__construct();
    }

    public function supports(Request $request): ?bool
    {
        return $request->attributes->get('_route') === 'login_check_sso';
    }

    public function authenticate(Request $request): SelfValidatingPassport
    {
        $client = $this->getClient();
        $accessToken = $this->fetchAccessToken($client);

        /** @var ResourceOwnerInterface $ssoUser */
        $ssoUser = $client->fetchUserFromToken($accessToken);

        // Adapter selon votre provider (voir EXEMPLES_PROVIDERS.md)
        $identifier = $ssoUser->getEmail() ?? $ssoUser->getId();

        return new SelfValidatingPassport(
            new UserBadge($identifier, function () use ($ssoUser) {
                return $this->userProvider->loadUserByIdentifier(
                    $ssoUser->getEmail() ?? $ssoUser->getId()
                );
            })
        );
    }

    public function onAuthenticationSuccess(Request $request, TokenInterface $token, string $firewallName): ?RedirectResponse
    {
        return new RedirectResponse($this->router->generate('app_home'));
    }

    public function onAuthenticationFailure(Request $request, AuthenticationException $exception): ?RedirectResponse
    {
        return new RedirectResponse($this->router->generate('app_login', ['error' => 'sso_auth_failed']));
    }
}
```

### 2.4 Création du User Provider

Créez un fichier `src/Security/SSOUserProvider.php` :

```php
<?php

namespace App\Security;

use Symfony\Component\Security\Core\User\UserInterface;
use Symfony\Component\Security\Core\User\UserProviderInterface;
use Symfony\Component\Security\Core\Exception\UnsupportedUserException;
use Symfony\Component\Security\Core\Exception\UserNotFoundException;

class SSOUserProvider implements UserProviderInterface
{
    public function loadUserByIdentifier(string $identifier): UserInterface
    {
        // TODO: Implémenter la logique de récupération/création de l'utilisateur
        // Option 1: Récupérer depuis votre base de données
        // Option 2: Créer automatiquement l'utilisateur si il n'existe pas
        
        // Exemple basique (à adapter selon vos besoins) :
        // $user = $this->userRepository->findOneBy(['email' => $identifier]);
        // if (!$user) {
        //     $user = $this->createUserFromSSO($identifier);
        // }
        // return $user;
        
        throw new UserNotFoundException(sprintf('User "%s" not found.', $identifier));
    }

    public function refreshUser(UserInterface $user): UserInterface
    {
        if (!$user instanceof YourUserClass) {
            throw new UnsupportedUserException(sprintf('Invalid user class "%s".', get_class($user)));
        }

        return $this->loadUserByIdentifier($user->getUserIdentifier());
    }

    public function supportsClass(string $class): bool
    {
        return YourUserClass::class === $class;
    }
}
```

### 2.5 Création des Routes

Dans `config/routes.yaml` ou dans un contrôleur :

```yaml
login:
    path: /login
    controller: App\Controller\SecurityController::login

login_check_sso:
    path: /login/check/sso
```

### 2.6 Création du Contrôleur de Login

Créez `src/Controller/SecurityController.php` :

```php
<?php

namespace App\Controller;

use KnpU\OAuth2ClientBundle\Client\ClientRegistry;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class SecurityController extends AbstractController
{
    #[Route('/login', name: 'app_login')]
    public function login(ClientRegistry $clientRegistry): Response
    {
        $client = $clientRegistry->getClient('sso');
        
        // Adapter les scopes selon votre provider
        return $client->redirect(['openid', 'profile', 'email']);
    }
}
```

### 📝 Checklist de Configuration Symfony

- [ ] Bundle `knpuniversity/oauth2-client-bundle` installé
- [ ] Provider spécifique installé (si nécessaire)
- [ ] Variables d'environnement configurées dans `.env`
- [ ] Fichier `knpu_oauth2_client.yaml` configuré
- [ ] Configuration de sécurité mise à jour
- [ ] Authenticator créé
- [ ] User Provider créé
- [ ] Routes configurées
- [ ] Contrôleur de login créé

---

## Étape 3 : Test de l'Authentification SSO

### 3.1 Vérification Pré-Test

Avant de tester, vérifiez :

1. **Les conteneurs Docker sont démarrés** :
   ```bash
   task start
   ```

2. **Les variables d'environnement sont chargées** :
   ```bash
   task console php
   php bin/console debug:container --parameter=env.SSO_CLIENT_ID
   ```

3. **Le cache est vidé** :
   ```bash
   task cc
   ```

### 3.2 Test du Flux d'Authentification

1. **Ouvrez votre navigateur** et allez sur :
   ```
   https://votre-domaine.docker.localhost/login
   ```

2. **Vous devriez être redirigé** vers la page de connexion du provider SSO

3. **Connectez-vous** avec un compte valide

4. **Acceptez les permissions** si demandé

5. **Vous devriez être redirigé** vers votre application Symfony

### 3.3 Vérification Post-Authentification

Après la connexion, vérifiez :

1. **L'utilisateur est bien connecté** :
   - Vérifiez la session Symfony
   - Vérifiez que l'utilisateur existe dans votre base de données (si applicable)

2. **Les données utilisateur sont correctes** :
   - Email
   - Nom
   - Autres claims configurés

3. **Les permissions/roles sont corrects** :
   - Vérifiez que les rôles sont bien assignés

### 📝 Checklist de Test

- [ ] Redirection vers le provider fonctionne
- [ ] Connexion provider réussie
- [ ] Redirection vers l'application fonctionne
- [ ] Utilisateur créé/récupéré correctement
- [ ] Session Symfony active
- [ ] Données utilisateur correctes
- [ ] Gestion des erreurs testée
- [ ] Logs vérifiés (pas d'erreurs)

---

## Dépannage et Problèmes Courants

### Problème 1 : "Redirect URI mismatch"

**Symptôme** : Erreur lors de la redirection depuis le provider

**Solution** :
1. Vérifiez que l'URI dans le provider correspond **exactement** à celui dans Symfony
2. Vérifiez le protocole (http vs https)
3. Vérifiez les ports si en local
4. Vérifiez qu'il n'y a pas d'espace ou de caractère spécial

### Problème 2 : "Invalid client secret"

**Symptôme** : Erreur d'authentification avec le secret

**Solution** :
1. Vérifiez que le secret est correct dans `.env`
2. Vérifiez que le secret n'a pas expiré (créez-en un nouveau si nécessaire)
3. Vérifiez qu'il n'y a pas d'espaces avant/après dans `.env`

### Problème 3 : "User not found"

**Symptôme** : L'authentification fonctionne mais l'utilisateur n'est pas trouvé dans Symfony

**Solution** :
1. Vérifiez l'implémentation du `UserProvider`
2. Vérifiez que l'identifiant (email, ID) correspond bien
3. Implémentez la création automatique d'utilisateur si nécessaire

### Problème 4 : "Permissions insuffisantes"

**Symptôme** : Erreur lors de la récupération des données utilisateur

**Solution** :
1. Vérifiez les scopes dans le provider
2. Accordez le consentement administrateur si nécessaire
3. Vérifiez les scopes demandés dans le code

### Problème 5 : Erreur SSL en local

**Symptôme** : Erreur de certificat SSL

**Solution** :
1. Utilisez `https://` avec un certificat valide
2. Ou configurez le provider pour accepter `http://localhost` (déconseillé en production)

### 📝 Logs Utiles

Pour déboguer, consultez les logs :

```bash
# Logs Symfony
task logs php

# Logs dans le conteneur
task console php
tail -f var/log/dev.log
```

---

## Exemples par Provider

Pour des exemples concrets et spécifiques à chaque provider, consultez le fichier **`EXEMPLES_PROVIDERS.md`** qui contient :

- Configuration détaillée pour Google OAuth2
- Configuration détaillée pour GitHub OAuth2
- Configuration détaillée pour Keycloak
- Configuration détaillée pour Auth0
- Configuration détaillée pour Okta
- Et d'autres providers courants

---

## 🔗 Ressources Externes

### 📘 Documentation Standards

- [OAuth 2.0 RFC 6749](https://tools.ietf.org/html/rfc6749)
- [OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html)
- [OAuth 2.0 Security Best Practices](https://tools.ietf.org/html/draft-ietf-oauth-security-topics)

### 🔧 Documentation Symfony

- [KnpUOAuth2ClientBundle](https://github.com/knpuniversity/oauth2-client-bundle)
- [Symfony Security](https://symfony.com/doc/current/security.html)
- [League OAuth2 Client](https://oauth2-client.thephpleague.com/)

---

## ✅ Prochaines Étapes

Une fois le test réussi :

1. Documenter votre expérience avec votre provider spécifique
2. Identifier les ajustements nécessaires
3. Valider avec des utilisateurs pilotes
4. Préparer le déploiement en production
5. Configurer le monitoring et les alertes

**Bonne intégration SSO ! 🚀**

