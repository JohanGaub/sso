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

**Prochaine étape** : [Phase 2 - Docker et Orchestration](#phase-2--docker-et-orchestration)

---
