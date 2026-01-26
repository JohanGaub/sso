# 🏗️ Documentation Infrastructure du Projet SSO

> **Objectif** : Maîtriser parfaitement l'infrastructure du projet pour pouvoir la reproduire ailleurs.

## 📋 Table des Matières

- [Phase 1 : Fondations](#phase-1--fondations)
  - [1. Structure du Projet](#1-structure-du-projet)
  - [2. Configuration de Base (.env)](#2-configuration-de-base-env)
- [Phase 2 : Docker et Orchestration](#phase-2--docker-et-orchestration)
  - [3. Docker Compose](#3-docker-compose)
  - [4. Taskfile.yml](#4-taskfileyml)
- [Phase 3 : Traefik et Routage](#phase-3--traefik-et-routage)
  - [5. Traefik - Concepts](#5-traefik---concepts)
  - [6. Traefik - Configuration Pratique](#6-traefik---configuration-pratique)
  - [7. Certificats SSL](#7-certificats-ssl)
- [Phase 4 : Automatisation et Qualité](#phase-4--automatisation-et-qualité)
  - [8. Scripts Shell](#8-scripts-shell)
  - [9. Git Hooks](#9-git-hooks)
- [Phase 5 : Flux Complet et Synthèse](#phase-5--flux-complet-et-synthèse)
  - [10. Flux de Démarrage Complet](#10-flux-de-démarrage-complet)
  - [11. Debugging et Troubleshooting](#11-debugging-et-troubleshooting)
- [Phase 6 : Validation Finale](#phase-6--validation-finale)
  - [12. Quiz de Synthèse](#12-quiz-de-synthèse)

---

# Phase 1 : Fondations

## 1. Structure du Projet

### 🎯 Objectif
Comprendre l'organisation des dossiers et fichiers clés du projet, leur rôle et leur importance.

### 📚 Explication

#### Vue d'Ensemble

Ce projet Symfony 8 est organisé selon une structure standard, mais avec des ajouts spécifiques pour le développement Docker, la qualité de code, et l'automatisation.

#### Diagramme de l'Organisation du Projet

```mermaid
graph TB
    subgraph "Point d'Entrée"
        A[public/index.php] --> B[src/Kernel.php]
    end
    
    subgraph "Code Source"
        B --> C[src/Controller/]
        B --> D[src/Services/]
    end
    
    subgraph "Configuration"
        E[config/] --> B
        F[.env] --> E
        F --> G[docker-compose.yml]
    end
    
    subgraph "Docker"
        G --> H[Conteneurs Docker]
        I[docker/] --> H
    end
    
    subgraph "Automatisation"
        J[Taskfile.yml] --> H
        J --> K[hooks/pre-commit]
        L[scripts/] --> J
    end
    
    subgraph "Qualité de Code"
        M[.php-cs-fixer.php] --> K
        N[phpmd.xml] --> K
        O[phpstan.neon] --> K
        P[rector.php] --> K
    end
    
    subgraph "Tests"
        Q[tests/] --> R[phpunit.xml.dist]
        R --> K
    end
    
    style A fill:#e1f5ff
    style B fill:#e1f5ff
    style F fill:#fff4e1
    style G fill:#e8f5e9
    style J fill:#f3e5f5
    style K fill:#fce4ec
```

#### Arborescence Principale

```
sso/
├── bin/                    # Scripts exécutables
├── config/                 # Configuration Symfony
├── docker/                 # Configuration Docker (Dockerfiles, configs)
├── docs/                   # Documentation du projet
├── hooks/                  # Git hooks (pre-commit, commit-msg)
├── public/                 # Point d'entrée web (index.php)
├── scripts/                # Scripts shell utilitaires
├── src/                    # Code source de l'application
├── tests/                  # Tests PHPUnit
├── var/                    # Fichiers générés (cache, logs, uploads)
├── vendor/                 # Dépendances Composer (gitignored)
├── .env                    # Variables d'environnement (gitignored)
├── .php-cs-fixer.php       # Configuration PHP CS Fixer
├── composer.json           # Dépendances PHP
├── docker-compose.yml      # Services Docker principaux
├── docker-compose-tools.yml # Services Docker pour outils (theme, security)
├── phpmd.xml              # Configuration PHPMD
├── phpstan.neon           # Configuration PHPStan
├── phpunit.xml.dist       # Configuration PHPUnit
├── rector.php             # Configuration Rector
├── Taskfile.yml           # Tâches automatisées (Task)
└── README.md              # Documentation principale
```

#### Détail des Dossiers Clés

##### `bin/` - Scripts Exécutables
- **`console`** : Point d'entrée pour les commandes Symfony (`bin/console cache:clear`)
- **`phpunit`** : Wrapper pour PHPUnit (utilisé par les tests)
- **`rector-wrapper.sh`** : Wrapper pour Rector

**Rôle** : Scripts directement exécutables, généralement appelés depuis le conteneur Docker ou via Task.

##### `config/` - Configuration Symfony
- **`bundles.php`** : Activation des bundles Symfony
- **`services.yaml`** : Configuration des services (DI container)
- **`packages/`** : Configuration par bundle (cache, framework, routing)
- **`routes.yaml`** : Définition des routes
- **`reference.php`** : Fichier de référence généré (gitignored généralement)

**Rôle** : Toute la configuration de l'application Symfony.

##### `docker/` - Configuration Docker
- **`php/Dockerfile`** : Image PHP personnalisée avec extensions
- **`php/docker-php.ini`** : Configuration PHP
- **`php/docker-entrypoint.sh`** : Script d'initialisation du conteneur PHP
- **`nginx/Dockerfile`** : Image Nginx pour servir l'application
- **`nginx/symfony.template`** : Template de configuration Nginx

**Rôle** : Définition des images Docker et configuration des conteneurs.

##### `docs/` - Documentation
- **`INDEX_DOCUMENTATION.md`** : Index de la documentation SSO
- **`GUIDE_SSO_GENERIQUE.md`** : Guide complet SSO
- **`GUIDE_DEMARRAGE_RAPIDE_SSO.md`** : Guide rapide SSO
- **`EXEMPLES_PROVIDERS.md`** : Exemples par provider
- **`INFRASTRUCTURE.md`** : Ce fichier (documentation infrastructure)

**Rôle** : Toute la documentation du projet.

##### `hooks/` - Git Hooks
- **`pre-commit`** : Exécuté avant chaque commit (vérifications qualité)
- **`commit-msg`** : Validation du format des messages de commit

**Rôle** : Automatisation et validation avant les commits Git.

##### `public/` - Point d'Entrée Web
- **`index.php`** : Point d'entrée unique de l'application (front controller)

**Rôle** : Fichiers accessibles publiquement via le serveur web.

##### `scripts/` - Scripts Shell Utilitaires
- **`check-tools-versions.sh`** : Vérifie les versions des outils de qualité

**Rôle** : Scripts réutilisables pour automatiser des tâches.

##### `src/` - Code Source
- **`Controller/`** : Contrôleurs Symfony
- **`Kernel.php`** : Classe Kernel Symfony (point d'entrée de l'application)

**Rôle** : Code source de l'application (PSR-4 autoloading).

##### `tests/` - Tests
- **`bootstrap.php`** : Initialisation pour les tests
- **`ExampleTest.php`** : Exemple de test PHPUnit

**Rôle** : Tests unitaires et d'intégration.

##### `var/` - Fichiers Générés
- **`cache/`** : Cache Symfony (gitignored)
- **`log/`** : Logs de l'application (gitignored)
- **`uploads/`** : Fichiers uploadés par les utilisateurs (gitignored)
- **`ci/`** : Fichiers pour CI/CD (gitignored)

**Rôle** : Fichiers générés dynamiquement, non versionnés.

##### `vendor/` - Dépendances
- Toutes les dépendances Composer (gitignored)

**Rôle** : Bibliothèques externes installées via Composer.

#### Fichiers de Configuration Racine

##### `.env` (gitignored)
Variables d'environnement spécifiques à l'environnement (dev, prod, etc.).

##### `composer.json`
Définit les dépendances PHP et les scripts Composer.

##### `docker-compose.yml`
Définit les services Docker principaux (php, nginx, postgres, redis, mailcatcher).

##### `docker-compose-tools.yml`
Services Docker pour outils de développement (theme Node.js, security scanner).

##### `Taskfile.yml`
Définit toutes les tâches automatisées du projet (start, stop, quality, etc.).

##### Fichiers de Configuration Qualité
- **`.php-cs-fixer.php`** : Règles de formatage PHP
- **`phpmd.xml`** : Règles de détection de code smells
- **`phpstan.neon`** : Configuration d'analyse statique
- **`phpunit.xml.dist`** : Configuration des tests
- **`rector.php`** : Règles de refactoring automatique

### 📖 Lecture Guidée

**Fichiers à lire et commenter :**

1. **`README.md`** : Vue d'ensemble du projet
2. **`composer.json`** : Dépendances et scripts
3. **`Taskfile.yml`** (premières lignes) : Structure des tâches
4. **`docker-compose.yml`** (premières lignes) : Services Docker

**Questions à vous poser en lisant :**
- Quel est le rôle de chaque dossier ?
- Pourquoi certains fichiers sont-ils gitignored ?
- Comment les différents composants interagissent-ils ?

### ✅ Quiz - Structure du Projet

1. **Quel est le rôle du dossier `var/` et pourquoi est-il gitignored ?**
   - [ ] A) Contient le code source, gitignored pour éviter les conflits
   - [ ] B) Contient les fichiers générés dynamiquement (cache, logs), gitignored car non versionnés
   - [ ] C) Contient les tests, gitignored pour réduire la taille du repo

2. **Quelle est la différence entre `docker-compose.yml` et `docker-compose-tools.yml` ?**
   - [ ] A) Aucune différence, ce sont des alias
   - [ ] B) `docker-compose.yml` = services principaux (php, nginx, db), `docker-compose-tools.yml` = outils de dev (theme, security)
   - [ ] C) `docker-compose.yml` = production, `docker-compose-tools.yml` = développement

3. **Pourquoi le dossier `vendor/` est-il gitignored ?**
   - [ ] A) Parce qu'il contient du code propriétaire
   - [ ] B) Parce qu'il est généré par Composer et peut être recréé avec `composer install`
   - [ ] C) Parce qu'il est trop volumineux pour Git

4. **Quel est le point d'entrée web de l'application Symfony ?**
   - [ ] A) `src/Kernel.php`
   - [ ] B) `public/index.php`
   - [ ] C) `bin/console`

5. **Quel fichier définit les tâches automatisées comme `task start` ou `task quality` ?**
   - [ ] A) `composer.json`
   - [ ] B) `Taskfile.yml`
   - [ ] C) `docker-compose.yml`

<details>
<summary>📝 Réponses</summary>

1. **B** - `var/` contient les fichiers générés dynamiquement (cache, logs, uploads). Ils sont gitignored car ils sont régénérés et spécifiques à chaque environnement.

2. **B** - `docker-compose.yml` définit les services principaux nécessaires au fonctionnement de l'application (php, nginx, postgres, redis, mailcatcher). `docker-compose-tools.yml` définit les services pour les outils de développement (theme Node.js, security scanner) qui ne sont pas toujours nécessaires.

3. **B** - `vendor/` est généré par Composer à partir de `composer.json` et `composer.lock`. Il peut être recréé avec `composer install`, donc pas besoin de le versionner.

4. **B** - `public/index.php` est le front controller Symfony, point d'entrée unique pour toutes les requêtes HTTP.

5. **B** - `Taskfile.yml` définit toutes les tâches automatisées du projet, utilisées via la commande `task`.

</details>

---

## 2. Configuration de Base (.env)

### 🎯 Objectif
Comprendre les variables d'environnement, leur rôle, et comment elles sont utilisées dans le projet.

### 📚 Explication

#### Qu'est-ce qu'un fichier `.env` ?

Le fichier `.env` contient les **variables d'environnement** spécifiques à votre environnement de développement. Ces variables sont chargées par Symfony et Docker Compose pour configurer l'application.

**Important** : Le fichier `.env` est **gitignored** car il contient des informations sensibles (mots de passe, secrets) et des configurations spécifiques à chaque développeur/machine.

#### Structure du `.env`

Le fichier `.env` est organisé en sections délimitées par des commentaires :

```env
###> symfony/framework-bundle ###
# Variables Symfony
###< symfony/framework-bundle ###

###> docker ###
# Variables Docker
###< docker ###
```

Cette organisation permet à Symfony Flex de gérer automatiquement les sections lors des mises à jour.

#### Variables Essentielles

##### Variables Symfony

```env
APP_ENV=dev                    # Environnement : dev, test, prod
APP_SECRET=your-secret-key     # Clé secrète pour le chiffrement (générée aléatoirement)
```

- **`APP_ENV`** : Détermine l'environnement d'exécution. En `dev`, Symfony active le debug, les erreurs détaillées, etc.
- **`APP_SECRET`** : Clé utilisée pour signer les cookies, tokens CSRF, etc. **Doit être unique et secrète en production !**

##### Variables Docker

```env
COMPOSE_PROJECT_NAME=sso       # Nom du projet Docker (préfixe des conteneurs)
DOCKER_DEV_HOST_PATH=/path     # Chemin vers docker-dev-host (pour Traefik)
```

- **`COMPOSE_PROJECT_NAME`** : Utilisé comme préfixe pour les noms de conteneurs (`sso_php`, `sso_nginx`, etc.) et pour construire les domaines (`sso.docker.localhost`).
- **`DOCKER_DEV_HOST_PATH`** : Chemin vers le projet `docker-dev-host` qui contient Traefik. Utilisé par `Taskfile.yml` pour démarrer automatiquement Traefik si nécessaire.

##### Variables Base de Données

```env
DB_SERVER_VERSION=16           # Version PostgreSQL
DB_USER=symfony                # Utilisateur PostgreSQL
DB_PASSWORD=your-password      # Mot de passe PostgreSQL
DB_NAME=symfony                # Nom de la base de données
```

Ces variables sont utilisées pour construire automatiquement `DATABASE_URL` dans `docker-compose.yml` :

```yaml
DATABASE_URL: postgresql://${DB_USER}:${DB_PASSWORD}@postgres:5432/${DB_NAME}?serverVersion=${DB_SERVER_VERSION}&charset=utf8
```

**Pourquoi cette construction ?**
- Centralisation : toutes les infos DB au même endroit
- Sécurité : le mot de passe n'apparaît qu'une fois dans `.env`
- Flexibilité : changement de version/configuration facile

##### Variables Redis

```env
REDIS_VERSION=7-alpine         # Version Redis
```

##### Variables Xdebug

```env
XDEBUG_ENABLE=1                # Active Xdebug dans le conteneur PHP
SYMFONY_CONTAINER_XML_PATH=    # Chemin vers le container XML (pour PHPStan)
```

#### Diagramme du Flux des Variables d'Environnement

```mermaid
graph LR
    A[.env<br/>Variables locales] --> B[Docker Compose]
    A --> C[Symfony]
    A --> D[Taskfile.yml]
    
    B --> E[Conteneur PHP<br/>APP_ENV, DATABASE_URL]
    B --> F[Conteneur Nginx<br/>Labels Traefik]
    B --> G[Conteneur Postgres<br/>DB_USER, DB_PASSWORD]
    
    C --> H[Application Symfony<br/>Configuration runtime]
    
    D --> I[Scripts shell<br/>COMPOSE_PROJECT_NAME]
    
    E --> J[Construction DATABASE_URL<br/>à partir de DB_*]
    
    style A fill:#fff4e1
    style B fill:#e8f5e9
    style C fill:#e1f5ff
    style D fill:#f3e5f5
```

#### Comment les Variables sont Utilisées

##### Dans Docker Compose

Les variables sont injectées dans les conteneurs via `${VARIABLE_NAME}` :

```yaml
container_name: ${COMPOSE_PROJECT_NAME}_php
environment:
    APP_ENV: ${APP_ENV}
    DATABASE_URL: postgresql://${DB_USER}:${DB_PASSWORD}@postgres:5432/${DB_NAME}
```

##### Dans Symfony

Symfony charge automatiquement le `.env` au démarrage. Les variables sont accessibles via :

```php
$_ENV['APP_ENV']
// ou
getenv('APP_ENV')
```

##### Dans Taskfile.yml

Les variables peuvent être utilisées dans les scripts shell :

```yaml
cmds:
  - echo "Project: ${COMPOSE_PROJECT_NAME}"
```

#### Fichier `env.example`

Le fichier `env.example` (versionné) sert de **template** pour créer le `.env`. Il contient :
- Toutes les variables nécessaires
- Des valeurs d'exemple ou par défaut
- Des commentaires explicatifs

**Workflow typique :**
1. Nouveau développeur clone le projet
2. Copie `env.example` vers `.env` : `cp env.example .env`
3. Modifie les valeurs selon son environnement

### 📖 Lecture Guidée

**Fichiers à lire et commenter :**

1. **`env.example`** : Template des variables
2. **`docker-compose.yml`** (lignes 18, 28-35, 65) : Utilisation des variables
3. **`Taskfile.yml`** (lignes 29-69) : Utilisation dans les scripts

**Questions à vous poser :**
- Pourquoi `DATABASE_URL` est construite automatiquement ?
- Comment `COMPOSE_PROJECT_NAME` influence-t-il les noms de conteneurs ?
- Pourquoi certaines variables sont-elles optionnelles ?

### ✅ Quiz - Configuration de Base (.env)

1. **Pourquoi le fichier `.env` est-il gitignored ?**
   - [ ] A) Parce qu'il est trop volumineux
   - [ ] B) Parce qu'il contient des informations sensibles (mots de passe, secrets) et des configurations spécifiques à chaque environnement
   - [ ] C) Parce qu'il est généré automatiquement

2. **Quelle variable détermine le préfixe des noms de conteneurs Docker ?**
   - [ ] A) `APP_ENV`
   - [ ] B) `COMPOSE_PROJECT_NAME`
   - [ ] C) `DB_NAME`

3. **Comment `DATABASE_URL` est-elle construite ?**
   - [ ] A) Elle est définie directement dans `.env`
   - [ ] B) Elle est construite automatiquement dans `docker-compose.yml` à partir de `DB_USER`, `DB_PASSWORD`, `DB_NAME`, `DB_SERVER_VERSION`
   - [ ] C) Elle est générée par Symfony au démarrage

4. **Quel est le rôle de `DOCKER_DEV_HOST_PATH` ?**
   - [ ] A) Définit le chemin vers les volumes Docker
   - [ ] B) Définit le chemin vers le projet `docker-dev-host` qui contient Traefik, utilisé pour démarrer automatiquement Traefik
   - [ ] C) Définit le chemin vers les logs Docker

5. **Pourquoi utiliser `env.example` comme template ?**
   - [ ] A) Pour éviter de versionner le `.env`
   - [ ] B) Pour documenter les variables nécessaires et permettre aux nouveaux développeurs de créer leur `.env` facilement
   - [ ] C) Pour tester différentes configurations

<details>
<summary>📝 Réponses</summary>

1. **B** - Le `.env` contient des informations sensibles (mots de passe, secrets) et des configurations spécifiques à chaque environnement/développeur. Il ne doit jamais être versionné.

2. **B** - `COMPOSE_PROJECT_NAME` est utilisé comme préfixe pour les noms de conteneurs (ex: `sso_php`, `sso_nginx`).

3. **B** - `DATABASE_URL` est construite dans `docker-compose.yml` à partir des variables individuelles (`DB_USER`, `DB_PASSWORD`, etc.) pour centraliser la configuration et éviter la duplication.

4. **B** - `DOCKER_DEV_HOST_PATH` pointe vers le projet `docker-dev-host` qui contient Traefik. Il est utilisé par `Taskfile.yml` pour démarrer automatiquement Traefik si nécessaire.

5. **B** - `env.example` documente les variables nécessaires et sert de template pour que les nouveaux développeurs puissent créer leur `.env` rapidement sans oublier de variables.

</details>

---

**🎉 Phase 1 terminée !** Vous maîtrisez maintenant la structure du projet et la configuration de base.

**Prochaine étape** : [Phase 3 - Traefik et Routage](#phase-3--traefik-et-routage)

---

# Phase 3 : Traefik et Routage

## 5. Traefik - Concepts

### 🎯 Objectif
Comprendre ce qu'est Traefik, son rôle dans l'infrastructure, et comment il route les requêtes vers vos services.

### 📚 Explication

#### Qu'est-ce que Traefik ?

**Traefik** est un **reverse proxy** et un **load balancer** moderne, conçu pour les environnements conteneurisés (Docker, Kubernetes, etc.). Il agit comme un "gardien" qui :

1. **Écoute** les requêtes HTTP/HTTPS entrantes (port 80/443)
2. **Analyse** l'en-tête `Host` de chaque requête
3. **Route** la requête vers le bon conteneur/service selon des règles
4. **Gère automatiquement** les certificats SSL/TLS (HTTPS)

**Analogie** : Traefik est comme un **réceptionniste intelligent** dans un grand immeuble. Quand quelqu'un arrive et dit "Je cherche l'appartement de M. Dupont", le réceptionniste consulte son registre et indique "C'est au 3ème étage, porte 301".

#### Pourquoi Traefik dans ce Projet ?

Sans Traefik, vous devriez :
- Exposer chaque service sur un port différent (`localhost:8080`, `localhost:8081`, etc.)
- Gérer manuellement les certificats SSL pour chaque service
- Configurer Nginx/Apache pour chaque nouveau projet

Avec Traefik :
- **Un seul point d'entrée** : tous les services passent par Traefik (port 80/443)
- **Routage par nom de domaine** : `sso.docker.localhost` → conteneur nginx du projet SSO
- **SSL automatique** : Traefik génère et renouvelle les certificats automatiquement
- **Configuration déclarative** : vous déclarez vos services via des **labels** Docker, Traefik fait le reste

#### Architecture Traefik dans ce Projet

```mermaid
graph TB
    subgraph "Internet / Navigateur"
        A[Utilisateur<br/>https://sso.docker.localhost]
    end
    
    subgraph "Traefik (docker-dev-host)"
        B[Traefik<br/>Port 443 HTTPS<br/>Port 80 HTTP]
        C[Entrypoint: websecure<br/>HTTPS avec TLS]
        D[Entrypoint: web<br/>HTTP]
    end
    
    subgraph "Réseau Docker: traefik-global-proxy"
        E[Conteneur nginx<br/>sso_nginx]
        F[Conteneur mailcatcher<br/>sso_mailcatcher]
        G[Conteneur adminer<br/>sso_adminer]
    end
    
    subgraph "Routage Traefik"
        H[Router: sso_nginx<br/>Rule: Host sso.docker.localhost]
        I[Router: sso_mailcatcher<br/>Rule: Host mail-sso.docker.localhost]
        J[Router: sso_adminer<br/>Rule: Host adminer-sso.docker.localhost]
    end
    
    A -->|1. Requête HTTPS| B
    B -->|2. Analyse Host header| C
    C -->|3. Routage selon rule| H
    C -->|3. Routage selon rule| I
    C -->|3. Routage selon rule| J
    H -->|4. Forward vers service| E
    I -->|4. Forward vers service| F
    J -->|4. Forward vers service| G
    
    style A fill:#e1f5ff
    style B fill:#fff4e1
    style C fill:#fff4e1
    style E fill:#e8f5e9
    style F fill:#e8f5e9
    style G fill:#e8f5e9
```

#### Concepts Clés de Traefik

##### 1. Entrypoint (Point d'Entrée)

Un **entrypoint** définit un port d'écoute et un protocole (HTTP ou HTTPS).

**Dans ce projet :**
- **`web`** : Port 80 (HTTP) - redirige généralement vers HTTPS
- **`websecure`** : Port 443 (HTTPS) - point d'entrée principal avec SSL

**Exemple dans docker-compose.yml :**
```yaml
labels:
  - "traefik.http.routers.${COMPOSE_PROJECT_NAME}_mailcatcher.entrypoints=websecure"
```
→ Le service `mailcatcher` écoute sur l'entrypoint `websecure` (HTTPS).

##### 2. Router (Routeur)

Un **router** définit une **règle de routage** qui détermine vers quel service diriger une requête.

**Règle la plus courante : `Host()`**
- Analyse l'en-tête `Host` de la requête HTTP
- Compare avec le domaine configuré
- Si match → route vers le service associé

**Exemple dans docker-compose.yml :**
```yaml
labels:
  - "traefik.http.routers.${COMPOSE_PROJECT_NAME}_nginx.rule=Host(`${COMPOSE_PROJECT_NAME}.docker.localhost`) || Host(`${COMPOSE_PROJECT_NAME}.docker.devhost`)"
```

**Décortiquons cette règle :**
- `Host(\`sso.docker.localhost\`)` → Si le domaine est `sso.docker.localhost`
- `||` → OU
- `Host(\`sso.docker.devhost\`)` → Si le domaine est `sso.docker.devhost`
- **Résultat** : Les deux domaines pointent vers le même service

**Autres règles possibles :**
- `PathPrefix(\`/api\`)` → Si l'URL commence par `/api`
- `Host(\`example.com\`) && PathPrefix(\`/admin\`)` → Combinaison de conditions

##### 3. Service

Un **service** représente le conteneur/service backend qui va traiter la requête.

**Exemple dans docker-compose.yml :**
```yaml
labels:
  - "traefik.http.routers.${COMPOSE_PROJECT_NAME}_nginx.service=${COMPOSE_PROJECT_NAME}_nginx"
  - "traefik.http.services.${COMPOSE_PROJECT_NAME}_nginx.loadbalancer.server.port=80"
```

**Décortiquons :**
- `traefik.http.routers.XXX.service=YYY` → Le router `XXX` pointe vers le service `YYY`
- `traefik.http.services.YYY.loadbalancer.server.port=80` → Le service `YYY` écoute sur le port 80 du conteneur

**Note** : Si le nom du service est identique au nom du router, la ligne `service=` peut être omise (Traefik l'infère automatiquement).

##### 4. Labels Docker

Les **labels** sont des métadonnées attachées aux conteneurs Docker. Traefik les lit pour découvrir automatiquement les services.

**Avantages :**
- **Découverte automatique** : Traefik scanne les conteneurs et lit leurs labels
- **Configuration déclarative** : Pas besoin de fichier de config central
- **Isolation** : Chaque service déclare sa propre configuration

**Exemple complet :**
```yaml
services:
  nginx:
    labels:
      - "traefik.enable=true"                    # Active Traefik pour ce service
      - "traefik.port=80"                         # Port du service dans le conteneur
      - "traefik.http.routers.sso_nginx.rule=Host(`sso.docker.localhost`)"  # Règle de routage
      - "traefik.http.routers.sso_nginx.tls=true" # Active HTTPS
      - "traefik.docker.network=traefik-global-proxy"  # Réseau Docker à utiliser
```

##### 5. Réseaux Docker

Traefik doit être sur le **même réseau Docker** que vos services pour pouvoir communiquer avec eux.

**Dans ce projet :**
- **`traefik-global-proxy`** : Réseau partagé entre Traefik et tous les services
- **`public-dev`** : Réseau pour la communication entre services de développement
- **`back`** : Réseau privé pour la communication interne (PHP ↔ Database, PHP ↔ Redis)

**Exemple dans docker-compose.yml :**
```yaml
networks:
  - traefik-global-proxy  # Pour que Traefik puisse accéder au service
  - back                   # Pour communiquer avec PHP, Database, etc.
```

**Important** : Le label `traefik.docker.network=traefik-global-proxy` indique à Traefik quel réseau utiliser pour communiquer avec le service.

#### Flux Complet d'une Requête

```mermaid
sequenceDiagram
    participant U as Utilisateur
    participant T as Traefik
    participant N as Nginx
    participant P as PHP-FPM
    participant S as Symfony

    U->>T: 1. GET https://sso.docker.localhost/
    Note over T: 2. Analyse Host header<br/>"sso.docker.localhost"
    Note over T: 3. Trouve Router: sso_nginx<br/>Rule: Host(sso.docker.localhost)
    Note over T: 4. Trouve Service: sso_nginx<br/>Port: 80, Network: traefik-global-proxy
    T->>N: 5. Forward HTTP vers sso_nginx:80
    Note over N: 6. Nginx reçoit la requête<br/>sur le port 80 interne
    N->>P: 7. FastCGI vers php:9000<br/>(via réseau 'back')
    P->>S: 8. Exécute index.php
    S->>P: 9. Réponse HTML
    P->>N: 10. Réponse HTML
    N->>T: 11. Réponse HTML
    T->>U: 12. Réponse HTTPS (avec SSL)
```

### 📖 Lecture Guidée

**Fichiers à lire et commenter :**

1. **`docker-compose.yml`** (lignes 47-67, 96-115, 117-133) : Configuration Traefik pour nginx, mailcatcher, adminer
2. **`Taskfile.yml`** (lignes 71-119) : Démarrage automatique de docker-dev-host (Traefik)
3. **`docker/nginx/symfony.template`** : Configuration Nginx qui reçoit les requêtes de Traefik

**Questions à vous poser en lisant :**
- Pourquoi chaque service a-t-il le label `traefik.docker.network=traefik-global-proxy` ?
- Comment Traefik sait-il quel port utiliser pour chaque service ?
- Pourquoi certains services ont `entrypoints=websecure` et d'autres non ?

### ✅ Quiz - Traefik Concepts

1. **Quel est le rôle principal de Traefik ?**
   - [ ] A) Gérer les bases de données
   - [ ] B) Agir comme reverse proxy et router les requêtes HTTP/HTTPS vers les bons services
   - [ ] C) Compiler le code PHP

2. **Qu'est-ce qu'un "router" dans Traefik ?**
   - [ ] A) Un équipement réseau physique
   - [ ] B) Une règle de routage qui détermine vers quel service diriger une requête selon des critères (Host, Path, etc.)
   - [ ] C) Un conteneur Docker spécial

3. **Pourquoi les services doivent-ils être sur le réseau `traefik-global-proxy` ?**
   - [ ] A) Pour améliorer les performances
   - [ ] B) Pour que Traefik puisse communiquer avec eux (même réseau Docker)
   - [ ] C) Pour sécuriser les communications

4. **Que signifie la règle `Host(\`sso.docker.localhost\`)` ?**
   - [ ] A) Elle bloque les requêtes vers ce domaine
   - [ ] B) Elle route les requêtes dont l'en-tête Host est `sso.docker.localhost` vers le service associé
   - [ ] C) Elle crée un nouveau domaine

5. **Quel est l'avantage d'utiliser des labels Docker pour configurer Traefik ?**
   - [ ] A) Les labels sont plus rapides
   - [ ] B) Configuration déclarative, découverte automatique, isolation par service
   - [ ] C) Les labels sont obligatoires avec Docker

<details>
<summary>📝 Réponses</summary>

1. **B** - Traefik est un reverse proxy qui route les requêtes HTTP/HTTPS vers les bons services selon des règles (Host, Path, etc.).

2. **B** - Un router définit une règle de routage (ex: `Host(\`sso.docker.localhost\`)`) qui détermine vers quel service diriger une requête.

3. **B** - Traefik et les services doivent être sur le même réseau Docker (`traefik-global-proxy`) pour pouvoir communiquer entre eux.

4. **B** - La règle `Host(\`sso.docker.localhost\`)` analyse l'en-tête `Host` de la requête et, si elle correspond, route vers le service associé.

5. **B** - Les labels permettent une configuration déclarative (chaque service déclare sa config), une découverte automatique (Traefik scanne les conteneurs), et une isolation (chaque service est indépendant).

</details>

---

## 6. Traefik - Configuration Pratique

### 🎯 Objectif
Analyser en détail la configuration Traefik du projet et comprendre chaque label.

### 📚 Explication

#### Configuration du Service Nginx

Analysons ligne par ligne la configuration Traefik du service `nginx` dans `docker-compose.yml` :

```yaml
nginx:
  # ... autres configurations ...
  networks:
    - public-dev
    - traefik-global-proxy  # ← Réseau partagé avec Traefik
    - back
  labels:
    - "traefik.enable=true"  # ← Active Traefik pour ce service
```

**Décortiquons chaque label :**

##### Label 1 : `traefik.enable=true`

```yaml
- "traefik.enable=true"
```

**Rôle** : Active explicitement Traefik pour ce service.

**Pourquoi explicite ?**
- Par défaut, Traefik ignore les conteneurs sans labels Traefik
- Ce label dit "Oui, je veux que Traefik gère ce service"
- **Alternative** : Si vous avez beaucoup de conteneurs, vous pouvez désactiver Traefik par défaut et activer seulement ceux qui ont ce label

##### Label 2 : `traefik.port=80`

```yaml
- "traefik.port=80"
```

**Rôle** : Indique à Traefik le **port interne du conteneur** sur lequel le service écoute.

**Important** : C'est le port **dans le conteneur**, pas le port exposé sur l'hôte !

**Dans ce projet :**
- Nginx écoute sur le port 80 **à l'intérieur du conteneur**
- Ce port n'est **pas exposé** sur l'hôte (pas de `ports: - "80:80"` dans docker-compose.yml)
- Traefik communique directement avec le conteneur via le réseau Docker

**Pourquoi pas de port exposé ?**
- **Sécurité** : Le service n'est accessible que via Traefik
- **Simplicité** : Pas de conflit de ports entre projets
- **Isolation** : Chaque projet peut avoir son propre Nginx sur le port 80 interne

##### Label 3 : `traefik.http.routers.XXX.rule`

```yaml
- "traefik.http.routers.${COMPOSE_PROJECT_NAME}_nginx.rule=Host(`${COMPOSE_PROJECT_NAME}.docker.localhost`) || Host(`${COMPOSE_PROJECT_NAME}.docker.devhost`)"
```

**Décortiquons :**

1. **`traefik.http.routers.${COMPOSE_PROJECT_NAME}_nginx`**
   - Crée un router nommé `sso_nginx` (si `COMPOSE_PROJECT_NAME=sso`)
   - Le préfixe `traefik.http.routers.` est obligatoire
   - Le nom du router peut être personnalisé (ici, on utilise le nom du projet)

2. **`.rule=Host(...)`**
   - Définit la règle de routage
   - `Host(\`sso.docker.localhost\`)` → Si le domaine est `sso.docker.localhost`
   - `||` → Opérateur logique OU
   - `Host(\`sso.docker.devhost\`)` → Si le domaine est `sso.docker.devhost`

**Résultat** : Les deux domaines (`sso.docker.localhost` et `sso.docker.devhost`) pointent vers le même service.

**Pourquoi deux domaines ?**
- **`.docker.localhost`** : Domaine principal (recommandé par Docker)
- **`.docker.devhost`** : Domaine alternatif (pour compatibilité avec certains outils)

##### Label 4 : `traefik.http.routers.XXX.tls=true`

```yaml
- "traefik.http.routers.${COMPOSE_PROJECT_NAME}_nginx.tls=true"
```

**Rôle** : Active le **chiffrement HTTPS (TLS)** pour ce router.

**Ce que ça fait :**
- Traefik termine la connexion SSL (déchiffre la requête HTTPS)
- Communique avec Nginx en HTTP (non chiffré, mais sur le réseau privé Docker)
- Rechiffre la réponse avant de l'envoyer au client

**Sécurité** : Même si la communication Traefik ↔ Nginx est en HTTP, elle se fait sur le réseau Docker privé, donc sécurisée.

##### Label 5 : `traefik.docker.network=traefik-global-proxy`

```yaml
- "traefik.docker.network=traefik-global-proxy"
```

**Rôle** : Indique à Traefik quel **réseau Docker** utiliser pour communiquer avec ce service.

**Pourquoi nécessaire ?**
- Un conteneur peut être sur **plusieurs réseaux** (ici : `public-dev`, `traefik-global-proxy`, `back`)
- Traefik doit savoir sur quel réseau il doit chercher le service
- Sans ce label, Traefik pourrait essayer de communiquer sur le mauvais réseau et échouer

**Dans ce projet :**
- `traefik-global-proxy` est le réseau partagé entre Traefik et tous les services
- Tous les services qui doivent être accessibles via Traefik doivent avoir ce label

#### Configuration du Service MailCatcher

Analysons maintenant la configuration plus complexe de `mailcatcher` :

```yaml
mailcatcher:
  # ... autres configurations ...
  labels:
    - "traefik.enable=true"
    - "traefik.port=1080"  # ← Port différent (1080 au lieu de 80)
    - "traefik.http.routers.${COMPOSE_PROJECT_NAME}_mailcatcher.rule=Host(`mail-${COMPOSE_PROJECT_NAME}.docker.localhost`) || Host(`mail-${COMPOSE_PROJECT_NAME}.docker.devhost`)"
    - "traefik.http.routers.${COMPOSE_PROJECT_NAME}_mailcatcher.entrypoints=websecure"  # ← Entrypoint explicite
    - "traefik.http.routers.${COMPOSE_PROJECT_NAME}_mailcatcher.tls=true"
    - "traefik.http.routers.${COMPOSE_PROJECT_NAME}_mailcatcher.service=${COMPOSE_PROJECT_NAME}_mailcatcher"  # ← Service explicite
    - "traefik.http.services.${COMPOSE_PROJECT_NAME}_mailcatcher.loadbalancer.server.port=1080"  # ← Port du service
    - "traefik.docker.network=traefik-global-proxy"
```

**Différences avec Nginx :**

1. **`traefik.port=1080`** : MailCatcher écoute sur le port 1080 (interface web)

2. **`entrypoints=websecure`** : Spécifie explicitement l'entrypoint HTTPS
   - **Pourquoi explicite ?** Par défaut, Traefik utilise tous les entrypoints disponibles
   - Ici, on force l'utilisation de `websecure` (HTTPS uniquement)

3. **`service=${COMPOSE_PROJECT_NAME}_mailcatcher`** : Définit explicitement le nom du service
   - **Pourquoi explicite ?** Par défaut, Traefik infère le nom du service depuis le nom du router
   - Ici, on le spécifie explicitement pour plus de clarté

4. **`traefik.http.services.XXX.loadbalancer.server.port=1080`** : Définit le port du service
   - **Pourquoi redondant avec `traefik.port` ?** 
   - `traefik.port` est un raccourci pour les cas simples
   - `traefik.http.services.XXX.loadbalancer.server.port` est plus explicite et permet de définir plusieurs serveurs (load balancing)

#### Diagramme de la Configuration Complète

```mermaid
graph TB
    subgraph "Traefik (docker-dev-host)"
        T[Traefik Container<br/>Ports 80, 443]
        E1[Entrypoint: web<br/>Port 80 HTTP]
        E2[Entrypoint: websecure<br/>Port 443 HTTPS]
    end
    
    subgraph "Réseau: traefik-global-proxy"
        subgraph "Service: sso_nginx"
            N[nginx Container<br/>Port 80 interne]
            R1[Router: sso_nginx<br/>Rule: Host sso.docker.localhost<br/>TLS: true]
        end
        
        subgraph "Service: sso_mailcatcher"
            M[mailcatcher Container<br/>Port 1080 interne]
            R2[Router: sso_mailcatcher<br/>Rule: Host mail-sso.docker.localhost<br/>Entrypoint: websecure<br/>TLS: true]
        end
        
        subgraph "Service: sso_adminer"
            A[adminer Container<br/>Port 8080 interne]
            R3[Router: sso_adminer<br/>Rule: Host adminer-sso.docker.localhost<br/>Entrypoint: websecure<br/>TLS: true]
        end
    end
    
    T --> E1
    T --> E2
    E2 --> R1
    E2 --> R2
    E2 --> R3
    R1 --> N
    R2 --> M
    R3 --> A
    
    style T fill:#fff4e1
    style E1 fill:#fff4e1
    style E2 fill:#fff4e1
    style R1 fill:#e8f5e9
    style R2 fill:#e8f5e9
    style R3 fill:#e8f5e9
```

### 📖 Lecture Guidée

**Fichiers à lire et commenter :**

1. **`docker-compose.yml`** (lignes 47-67) : Configuration complète du service nginx avec tous les labels Traefik
2. **`docker-compose.yml`** (lignes 96-115) : Configuration mailcatcher (plus détaillée)
3. **`docker-compose.yml`** (lignes 117-133) : Configuration adminer
4. **`Taskfile.yml`** (lignes 71-119) : Comment docker-dev-host (Traefik) est démarré automatiquement

**Exercice pratique :**
1. Ouvrez `docker-compose.yml`
2. Pour chaque service avec des labels Traefik, identifiez :
   - Le nom du router
   - La règle de routage
   - Le port du service
   - L'entrypoint utilisé
   - Si TLS est activé

**Questions à vous poser :**
- Pourquoi `nginx` n'a pas de label `entrypoints=websecure` alors que `mailcatcher` l'a ?
- Pourquoi `mailcatcher` définit explicitement le service alors que `nginx` ne le fait pas ?
- Que se passerait-il si deux services avaient la même règle `Host()` ?

### ✅ Quiz - Configuration Pratique

1. **Que signifie `traefik.port=80` dans les labels ?**
   - [ ] A) Le port 80 de la machine hôte
   - [ ] B) Le port 80 à l'intérieur du conteneur Docker
   - [ ] C) Le port 80 de Traefik

2. **Pourquoi le service nginx n'expose-t-il pas de port sur l'hôte (pas de `ports: - "80:80"`) ?**
   - [ ] A) Parce que c'est une erreur de configuration
   - [ ] B) Parce que le service est accessible uniquement via Traefik sur le réseau Docker, ce qui est plus sécurisé
   - [ ] C) Parce que Nginx ne peut pas écouter sur le port 80

3. **Que fait le label `traefik.http.routers.XXX.tls=true` ?**
   - [ ] A) Il désactive HTTPS
   - [ ] B) Il active le chiffrement HTTPS (TLS) pour ce router
   - [ ] C) Il configure un certificat SSL manuel

4. **Pourquoi le label `traefik.docker.network=traefik-global-proxy` est-il nécessaire ?**
   - [ ] A) Pour améliorer les performances
   - [ ] B) Pour indiquer à Traefik sur quel réseau Docker chercher le service (un conteneur peut être sur plusieurs réseaux)
   - [ ] C) Pour créer le réseau automatiquement

5. **Quelle est la différence entre `traefik.port=1080` et `traefik.http.services.XXX.loadbalancer.server.port=1080` ?**
   - [ ] A) Aucune différence, c'est redondant
   - [ ] B) `traefik.port` est un raccourci, `loadbalancer.server.port` est plus explicite et permet le load balancing avec plusieurs serveurs
   - [ ] C) `traefik.port` est pour HTTP, `loadbalancer.server.port` est pour HTTPS

<details>
<summary>📝 Réponses</summary>

1. **B** - `traefik.port=80` indique le port **à l'intérieur du conteneur**, pas le port de l'hôte.

2. **B** - Le service n'expose pas de port sur l'hôte car il est accessible uniquement via Traefik sur le réseau Docker privé, ce qui est plus sécurisé (pas d'exposition directe).

3. **B** - `traefik.http.routers.XXX.tls=true` active le chiffrement HTTPS (TLS) pour ce router. Traefik gère automatiquement les certificats.

4. **B** - Un conteneur peut être sur plusieurs réseaux Docker. Ce label indique à Traefik sur quel réseau chercher le service pour communiquer avec lui.

5. **B** - `traefik.port` est un raccourci pratique pour les cas simples. `loadbalancer.server.port` est plus explicite et permet de définir plusieurs serveurs pour le load balancing.

</details>

---

## 7. Certificats SSL

### 🎯 Objectif
Comprendre comment Traefik gère automatiquement les certificats SSL, comment ils sont créés, et comment les installer sur d'autres machines.

### 📚 Explication

#### Qu'est-ce qu'un Certificat SSL ?

Un **certificat SSL/TLS** est un fichier numérique qui :
1. **Authentifie** l'identité d'un serveur (prouve que `sso.docker.localhost` est bien votre serveur)
2. **Chiffre** les communications entre le navigateur et le serveur (HTTPS)

**Sans certificat** : Le navigateur affiche "Connexion non sécurisée" et bloque l'accès (ou affiche un avertissement).

**Avec certificat valide** : Le navigateur affiche un cadenas vert et la connexion est sécurisée.

#### Types de Certificats

##### 1. Certificats Auto-Signés (Self-Signed)

**Dans ce projet** : Traefik génère automatiquement des certificats auto-signés pour les domaines `*.docker.localhost`.

**Caractéristiques :**
- ✅ **Gratuit** et instantané
- ✅ **Automatique** : Traefik les génère et les renouvelle
- ❌ **Non reconnu par les navigateurs** : Affiche un avertissement "Certificat non fiable"
- ❌ **Développement uniquement** : Ne doit jamais être utilisé en production

**Pourquoi un avertissement ?**
- Les certificats auto-signés ne sont pas signés par une Autorité de Certification (CA) reconnue
- Le navigateur ne peut pas vérifier leur authenticité
- **Solution en dev** : Accepter l'exception dans le navigateur (cliquer sur "Avancé" → "Continuer quand même")

##### 2. Certificats Signés par une CA (Certificate Authority)

**En production** : Vous utilisez des certificats signés par une CA reconnue (Let's Encrypt, DigiCert, etc.).

**Caractéristiques :**
- ✅ **Reconnu par les navigateurs** : Pas d'avertissement
- ✅ **Gratuit avec Let's Encrypt** : Traefik peut les générer automatiquement
- ❌ **Nécessite un domaine public** : Let's Encrypt ne peut pas signer des domaines locaux (`*.docker.localhost`)

#### Comment Traefik Gère les Certificats

Traefik peut gérer les certificats de deux façons :

##### 1. Certificats Auto-Signés (Développement)

**Configuration dans docker-dev-host (Traefik) :**

Traefik génère automatiquement des certificats auto-signés pour tous les domaines qu'il route, **sans configuration supplémentaire**.

**Workflow :**
1. Un service déclare `traefik.http.routers.XXX.tls=true`
2. Traefik détecte le domaine depuis la règle `Host()`
3. Traefik génère automatiquement un certificat auto-signé pour ce domaine
4. Le certificat est stocké dans un volume Docker (généralement dans docker-dev-host)
5. Traefik utilise ce certificat pour toutes les requêtes HTTPS vers ce domaine

**Où sont stockés les certificats ?**
- Généralement dans un volume Docker de Traefik : `/traefik/certs/` ou similaire
- Vous pouvez vérifier avec : `docker volume ls` dans le projet docker-dev-host

##### 2. Let's Encrypt (Production)

**Configuration dans docker-dev-host (Traefik) :**

Pour utiliser Let's Encrypt en production, Traefik doit être configuré avec :
- Un **email** pour les notifications de renouvellement
- Un **challenge** (HTTP-01 ou DNS-01) pour prouver que vous contrôlez le domaine
- Un **storage** (fichier ou base de données) pour stocker les certificats

**Exemple de configuration Traefik (dans docker-dev-host) :**
```yaml
certificatesResolvers:
  letsencrypt:
    acme:
      email: votre-email@example.com
      storage: /acme.json
      httpChallenge:
        entryPoint: web
```

**Dans docker-compose.yml de votre projet :**
```yaml
labels:
  - "traefik.http.routers.XXX.tls=true"
  - "traefik.http.routers.XXX.tls.certresolver=letsencrypt"  # ← Utilise Let's Encrypt
```

#### Installation de Certificats sur d'Autres Machines

##### Scénario : Développement en Équipe

Si vous travaillez en équipe et que chaque développeur a sa propre machine, chaque machine doit avoir ses propres certificats (ou partager les certificats).

**Option 1 : Certificats Individuels (Recommandé)**

Chaque développeur :
1. Lance `task start` sur sa machine
2. Traefik génère automatiquement des certificats auto-signés
3. Chaque développeur accepte l'exception dans son navigateur

**Avantages :**
- ✅ Isolation : Chaque machine est indépendante
- ✅ Pas de partage de fichiers sensibles
- ✅ Automatique

**Inconvénients :**
- ❌ Chaque développeur doit accepter l'exception dans son navigateur

##### Option 2 : Partager un Certificat CA Racine

**Workflow avancé :**

1. **Créer une CA (Certificate Authority) racine** sur une machine :
   ```bash
   # Dans docker-dev-host ou un script dédié
   openssl genrsa -out ca-key.pem 4096
   openssl req -new -x509 -days 365 -key ca-key.pem -out ca.pem -subj "/CN=Local Dev CA"
   ```

2. **Configurer Traefik pour utiliser cette CA** :
   - Modifier la configuration Traefik dans docker-dev-host
   - Pointer vers `ca.pem` et `ca-key.pem`

3. **Installer `ca.pem` sur chaque machine** :
   - **Linux** : Copier dans `/usr/local/share/ca-certificates/` et exécuter `update-ca-certificates`
   - **macOS** : Double-cliquer sur `ca.pem` et l'ajouter au trousseau de clés système
   - **Windows** : Importer dans le magasin de certificats Windows

4. **Résultat** : Tous les certificats signés par cette CA seront automatiquement reconnus par les navigateurs

**Avantages :**
- ✅ Pas d'avertissement dans les navigateurs
- ✅ Expérience utilisateur fluide

**Inconvénients :**
- ❌ Configuration plus complexe
- ❌ Nécessite de partager `ca.pem` (mais pas `ca-key.pem` qui reste secret)

#### Diagramme du Flux des Certificats

```mermaid
graph TB
    subgraph "Première Requête HTTPS"
        A[Navigateur<br/>https://sso.docker.localhost] -->|1. Requête HTTPS| B[Traefik]
        B -->|2. Vérifie certificat| C{Certificat existe ?}
        C -->|Non| D[Génère certificat<br/>auto-signé]
        C -->|Oui| E[Utilise certificat existant]
        D --> F[Stocke dans volume Docker]
        E --> G[Envoie certificat au navigateur]
        F --> G
        G -->|3. Avertissement si auto-signé| A
    end
    
    subgraph "Requêtes Suivantes"
        H[Navigateur] -->|Requête HTTPS| I[Traefik]
        I -->|Certificat en cache| J[Envoie certificat]
        J --> H
    end
    
    subgraph "Renouvellement Let's Encrypt"
        K[Traefik] -->|30 jours avant expiration| L[Let's Encrypt API]
        L -->|Nouveau certificat| K
        K --> M[Met à jour certificat]
    end
    
    style A fill:#e1f5ff
    style B fill:#fff4e1
    style D fill:#e8f5e9
    style E fill:#e8f5e9
    style L fill:#f3e5f5
```

### 📖 Lecture Guidée

**Fichiers à explorer :**

1. **Projet docker-dev-host** : Configuration Traefik (généralement dans `traefik.yml` ou `docker-compose.yml`)
   - Cherchez la section `certificatesResolvers` pour Let's Encrypt
   - Cherchez les volumes pour le stockage des certificats

2. **`docker-compose.yml`** (lignes 66, 112, 132) : Labels `tls=true` qui activent HTTPS

**Exercice pratique :**

1. **Vérifier les certificats générés :**
   ```bash
   # Dans le projet docker-dev-host
   docker volume ls | grep traefik
   docker volume inspect <volume-name>
   ```

2. **Tester la connexion HTTPS :**
   - Ouvrez `https://sso.docker.localhost` dans votre navigateur
   - Observez l'avertissement de certificat auto-signé
   - Cliquez sur "Avancé" → "Continuer quand même"
   - Vérifiez que le site charge correctement

3. **Inspecter le certificat :**
   - Dans le navigateur, cliquez sur le cadenas à côté de l'URL
   - Consultez les détails du certificat (émetteur, expiration, etc.)

**Questions à vous poser :**
- Pourquoi les certificats auto-signés affichent-ils un avertissement ?
- Comment Traefik sait-il quel certificat utiliser pour quel domaine ?
- Que se passe-t-il si un certificat Let's Encrypt expire ?

### ✅ Quiz - Certificats SSL

1. **Qu'est-ce qu'un certificat SSL auto-signé ?**
   - [ ] A) Un certificat signé par Let's Encrypt
   - [ ] B) Un certificat généré par Traefik qui n'est pas signé par une CA reconnue, utilisé en développement
   - [ ] C) Un certificat qui expire automatiquement

2. **Pourquoi les navigateurs affichent-ils un avertissement pour les certificats auto-signés ?**
   - [ ] A) Parce qu'ils sont expirés
   - [ ] B) Parce qu'ils ne sont pas signés par une Autorité de Certification (CA) reconnue par les navigateurs
   - [ ] C) Parce qu'ils sont mal configurés

3. **Comment Traefik génère-t-il automatiquement les certificats auto-signés ?**
   - [ ] A) Il faut les créer manuellement
   - [ ] B) Traefik les génère automatiquement dès qu'un service déclare `tls=true` et qu'il détecte un domaine via `Host()`
   - [ ] C) Il faut installer un plugin

4. **Que faut-il pour utiliser Let's Encrypt avec Traefik ?**
   - [ ] A) Rien, c'est automatique
   - [ ] B) Un domaine public, une configuration `certificatesResolvers` dans Traefik, et un email pour les notifications
   - [ ] C) Un abonnement payant

5. **Où sont stockés les certificats générés par Traefik ?**
   - [ ] A) Dans le conteneur du service
   - [ ] B) Dans un volume Docker de Traefik (généralement dans docker-dev-host)
   - [ ] C) Dans le répertoire du projet

<details>
<summary>📝 Réponses</summary>

1. **B** - Un certificat auto-signé est généré par Traefik (ou vous-même) et n'est pas signé par une CA reconnue. Il est utilisé en développement car il est gratuit et instantané, mais affiche un avertissement dans les navigateurs.

2. **B** - Les navigateurs affichent un avertissement car les certificats auto-signés ne sont pas signés par une CA reconnue. Le navigateur ne peut pas vérifier leur authenticité.

3. **B** - Traefik génère automatiquement les certificats auto-signés dès qu'un service déclare `tls=true` et qu'il détecte un domaine via la règle `Host()`. Aucune configuration supplémentaire n'est nécessaire.

4. **B** - Pour utiliser Let's Encrypt, il faut : un domaine public (Let's Encrypt ne peut pas signer des domaines locaux), une configuration `certificatesResolvers` dans Traefik, et un email pour les notifications de renouvellement.

5. **B** - Les certificats sont stockés dans un volume Docker de Traefik, généralement dans le projet docker-dev-host. Vous pouvez les inspecter avec `docker volume ls` et `docker volume inspect`.

</details>

---

**🎉 Phase 3 terminée !** Vous maîtrisez maintenant Traefik, le routage, et les certificats SSL.

**Prochaine étape** : [Phase 2 - Docker et Orchestration](#phase-2--docker-et-orchestration) (à venir) ou [Phase 4 - Automatisation et Qualité](#phase-4--automatisation-et-qualité) (à venir)

---
