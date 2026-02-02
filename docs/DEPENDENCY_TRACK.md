# 🔒 Dependency-Track - Guide Complet d'Intégration

## 📋 Table des Matières

1. [Vue d'Ensemble](#vue-densemble)
2. [Concepts Clés](#concepts-clés)
3. [Installation et Configuration Initiale](#installation-et-configuration-initiale)
4. [Génération de SBOM](#génération-de-sbom)
5. [Intégration dans le Workflow](#intégration-dans-le-workflow)
6. [Plan d'Intégration Détaillé](#plan-dintégration-détaillé)
7. [Utilisation Quotidienne](#utilisation-quotidienne)
8. [Dépannage](#dépannage)

---

## 🎯 Vue d'Ensemble

### Qu'est-ce que Dependency-Track ?

**Dependency-Track** est une plateforme d'analyse de composants (Component Analysis Platform) qui permet d'identifier et de réduire les risques de sécurité dans votre chaîne d'approvisionnement logicielle (software supply chain).

### Pourquoi l'utiliser ?

- ✅ **Détection proactive** : Identifie les vulnérabilités AVANT qu'elles ne soient exploitées
- ✅ **Analyse continue** : Surveille vos dépendances même sans rebuild
- ✅ **Conformité** : Vérifie le respect des politiques de sécurité et de licence
- ✅ **Priorisation intelligente** : Utilise EPSS pour prioriser les vulnérabilités les plus critiques
- ✅ **Traçabilité complète** : Historique de tous les composants utilisés

### Différence avec Composer Audit

| Fonctionnalité | Composer Audit | Dependency-Track |
|---------------|----------------|------------------|
| **Quand** | Au moment de `composer install/update` | Analyse continue |
| **Historique** | ❌ Non | ✅ Oui |
| **Politiques** | ❌ Non | ✅ Oui (sécurité, licence, opérationnel) |
| **Multi-projets** | ❌ Non | ✅ Oui (portefeuille complet) |
| **Intégrations** | ❌ Limitées | ✅ Nombreuses (Slack, Teams, webhooks, etc.) |
| **EPSS** | ❌ Non | ✅ Oui (priorisation intelligente) |

**Conclusion** : Dependency-Track complète Composer Audit en offrant une vision continue et centralisée de la sécurité.

---

## 📚 Concepts Clés

### SBOM (Software Bill of Materials)

**Définition** : Un SBOM est une liste complète de tous les composants logiciels (bibliothèques, frameworks, dépendances) utilisés dans votre application.

**Format CycloneDX** : Dependency-Track utilise le format **CycloneDX**, un standard OWASP et industriel pour les SBOM.

**Exemple de contenu** :
- Liste de toutes les dépendances Composer (avec versions)
- Informations sur les licences
- Métadonnées du projet
- Relations entre les dépendances

### Workflow Dependency-Track

```
1. Génération SBOM (CycloneDX)
   ↓
2. Publication vers Dependency-Track (REST API ou upload)
   ↓
3. Analyse automatique par Dependency-Track
   ↓
4. Détection de vulnérabilités (NVD, OSS Index, GitHub, etc.)
   ↓
5. Évaluation des politiques (sécurité, licence, opérationnel)
   ↓
6. Notifications (si configurées)
   ↓
7. Tableau de bord avec résultats
```

### Sources de Vulnérabilités

Dependency-Track interroge plusieurs sources :

- **NVD** (National Vulnerability Database) : Base de données officielle américaine
- **OSS Index** : Base de données Sonatype
- **GitHub Advisories** : Vulnérabilités détectées par GitHub
- **Snyk** : Base de données Snyk
- **OSV** : Open Source Vulnerabilities
- **VulnDB** : Base de données Risk Based Security

---

## 🚀 Installation et Configuration Initiale

### Étape 1 : Configuration dans docker-compose.yml

**✅ Dependency-Track est déjà intégré dans votre infrastructure Docker !**

Les services suivants sont configurés dans `docker-compose.yml` :

- **`dependency-track-api`** : API backend (port 8080 interne)
- **`dependency-track-frontend`** : Interface web (port 8080 interne)
- **`dependency-track-database`** : Base de données PostgreSQL dédiée

**Accès via Traefik** :
- **Interface web** : `https://dependency-track-${COMPOSE_PROJECT_NAME}.docker.localhost`
- **API** : `https://dependency-track-api-${COMPOSE_PROJECT_NAME}.docker.localhost`

**⚠️ Configuration HTTPS importante** :
- Le frontend Dependency-Track est configuré pour utiliser l'URL HTTPS de l'API via Traefik
- Cette configuration évite les erreurs "Mixed Content" (blocage des requêtes HTTP depuis une page HTTPS)
- La variable d'environnement `API_BASE_URL` du frontend pointe vers `https://dependency-track-api-${COMPOSE_PROJECT_NAME}.docker.localhost`

**Exemple** : Si `COMPOSE_PROJECT_NAME=sso`, les URLs seront :
- Interface web : `https://dependency-track-sso.docker.localhost`
- API : `https://dependency-track-api-sso.docker.localhost`

### Étape 2 : Configuration des Variables d'Environnement

**⚠️ IMPORTANT : Comprendre les deux types de mots de passe**

Il y a **DEUX mots de passe différents** à configurer :

1. **Mot de passe de la base de données** (dans `.env`) :
   - Utilisé par Dependency-Track pour se connecter à PostgreSQL
   - À mettre dans `.env` **AVANT** le premier démarrage
   - **Ce n'est PAS** le mot de passe pour se connecter à l'interface web

2. **Compte administrateur** (créé automatiquement) :
   - Utilisé pour se connecter à l'interface Dependency-Track
   - **Créé automatiquement** par Dependency-Track au premier démarrage
   - **Identifiants par défaut** : `admin` / `admin` (⚠️ À changer immédiatement)
   - **PAS besoin** de le mettre dans `.env`

#### Configuration dans `.env`

1. **Copier les variables dans votre `.env`** :

```bash
# Dependency-Track - Base de données PostgreSQL
# Ces variables sont utilisées par Dependency-Track pour se connecter à sa base de données
DEPENDENCY_TRACK_DB_NAME=dtrack
DEPENDENCY_TRACK_DB_USER=dtrack
DEPENDENCY_TRACK_DB_PASSWORD=your-dependency-track-db-password-here
```

2. **Modifier le mot de passe de la base de données** : 
   - Remplacez `your-dependency-track-db-password-here` par un mot de passe fort
   - **Ce mot de passe** est utilisé uniquement pour la connexion PostgreSQL
   - **Ce n'est PAS** votre mot de passe de connexion à l'interface web

### Étape 3 : Démarrer Dependency-Track

```bash
# Démarrer toute la stack (inclut Dependency-Track)
task start

# Ou seulement Dependency-Track
docker compose up -d dependency-track-api dependency-track-frontend dependency-track-database
```

**Vérification** :
```bash
# Vérifier que les conteneurs sont démarrés
docker compose ps | grep dependency-track

# Vérifier les logs
docker compose logs dependency-track-api
docker compose logs dependency-track-frontend
```

**Résultat attendu** :
- ✅ 3 conteneurs démarrés : `dependency-track-api`, `dependency-track-frontend`, `dependency-track-database`
- ✅ Interface web accessible via Traefik
- ✅ API accessible via Traefik

### Étape 4 : Se Connecter avec l'Utilisateur Admin par Défaut

**📝 IMPORTANT : Dependency-Track crée automatiquement un utilisateur administrateur par défaut**

Dependency-Track crée automatiquement un compte administrateur lors du premier démarrage. **Vous n'avez PAS besoin de créer un compte** - il existe déjà !

**🔑 Identifiants par défaut** :

- **Username** : `admin`
- **Email** : `admin@localhost`
- **Mot de passe** : `admin` (⚠️ **À changer immédiatement après la première connexion**)

**📝 Processus de connexion** :

1. **Ouvrir l'interface web** :
   - URL : `https://dependency-track-${COMPOSE_PROJECT_NAME}.docker.localhost`
   - **Exemple** : Si `COMPOSE_PROJECT_NAME=sso`, l'URL sera `https://dependency-track-sso.docker.localhost`
   - Cette URL est également affichée après `task start`

2. **Se connecter avec les identifiants par défaut** :
   - **Username** : `admin`
   - **Password** : `admin`
   - Cliquer sur **Login**

3. **⚠️ IMPORTANT : Changer le mot de passe immédiatement** :
   - **Après la connexion**, Dependency-Track vous redirige automatiquement vers la page **"Update Password"** (changement de mot de passe obligatoire)
   - Remplir le formulaire :
     - **Username** : `admin` (pré-rempli)
     - **Current password** : `admin` (le mot de passe actuel)
     - **New password** : Votre nouveau mot de passe fort
     - **Confirm new password** : Confirmer le nouveau mot de passe
   - Cliquer sur **Change password**
   - **⚠️ Ne jamais laisser le mot de passe par défaut `admin` en production !**

4. **Modifier votre profil (optionnel)** :
   - Une fois le mot de passe changé, vous êtes redirigé vers le dashboard
   - Pour modifier votre username ou email, aller dans **Administration > Access Management > Users**
   - Sélectionner l'utilisateur `admin`
   - Modifier les informations souhaitées
   - **Note** : Le changement de username doit se faire **APRÈS** le changement de mot de passe

**⚠️ Récapitulatif des mots de passe** :

| Type | Où le configurer | Quand | Usage |
|------|------------------|-------|-------|
| **Base de données** | Dans `.env` (`DEPENDENCY_TRACK_DB_PASSWORD`) | **AVANT** le premier démarrage | Connexion PostgreSQL |
| **Compte admin** | **Créé automatiquement** par Dependency-Track | **Au premier démarrage** | Connexion à l'interface Dependency-Track |
| **Mot de passe admin** | **Par défaut : `admin`** (⚠️ À changer) | **Après la première connexion** | Sécurité - changer immédiatement |

**💡 Exemple concret** :

1. **Avant le démarrage** : Ajouter dans `.env` :
   ```bash
   DEPENDENCY_TRACK_DB_PASSWORD=MonMotDePasseDB123!
   ```

2. **Démarrer** : `task start`

3. **Premier accès** : Aller sur `https://dependency-track-sso.docker.localhost`
   - Page de login s'affiche (c'est normal, l'utilisateur admin existe déjà)
   - Se connecter avec :
     - **Username** : `admin`
     - **Password** : `admin`

4. **Changer le mot de passe (obligatoire)** :
   - **Vous êtes automatiquement redirigé** vers la page "Update Password"
   - Remplir le formulaire :
     - **Current password** : `admin`
     - **New password** : Votre nouveau mot de passe fort
     - **Confirm new password** : Confirmer le nouveau mot de passe
   - Cliquer sur **Change password**
   - Vous êtes ensuite redirigé vers le dashboard

5. **Modifier votre profil (optionnel)** :
   - Si vous souhaitez changer votre username ou email, aller dans **Administration > Access Management > Users**
   - **Important** : Le changement de username doit se faire **APRÈS** le changement de mot de passe

6. **Accès suivants** : Utiliser `admin` (ou votre nouveau username) / `VotreNouveauMotDePasse` pour se connecter

#### 2.2 Configuration de Base

**Paramètres système** :
- **Alerts** : Configurer les notifications (email, webhooks, Slack, etc.)
- **Repositories** : Configurer les sources de vulnérabilités (déjà configurées par défaut)
- **Access Management** : Gérer les utilisateurs et permissions

**Créer un Team** (optionnel mais recommandé) :
1. Aller dans **Administration > Teams**
2. Créer un team (ex: "SSO Project")
3. Ajouter des membres avec les permissions appropriées

### Étape 5 : Créer un Projet

**📝 Processus de création du projet** :

1. **Aller dans Portfolio** :
   - Dans l'interface Dependency-Track, cliquer sur **Portfolio** dans le menu de gauche
   - Cliquer sur **Create Project** (bouton en haut à droite)

2. **Remplir les informations du projet** :
   - **Name** : `SSO Symfony Project` (ou nom de votre choix)
   - **Version** : `1.0.0` (ou version actuelle)
   - **Description** : Description du projet (optionnel mais recommandé)
   - **Tags** : `symfony`, `php`, `sso` (optionnel, permet de filtrer les projets)
   - **Classifier** : `Application` (ou autre selon votre cas)
   - **Active** : ✅ Cocher (important pour que le projet soit analysé)

3. **Créer le projet** :
   - Cliquer sur **Create**
   - Le projet est créé et affiché dans la liste

4. **Récupérer l'UUID du projet** (nécessaire pour GitHub Actions) :
   - Cliquer sur le projet créé
   - L'UUID est dans l'URL (ex: `/projects/123e4567-e89b-12d3-a456-426614174000`)
   - Ou aller dans **Settings** du projet, l'UUID est affiché

**Résultat** : Un projet vide est créé et prêt à recevoir des SBOM.

**💡 Astuce** : Notez l'UUID du projet, vous en aurez besoin pour configurer GitHub Actions (voir [Étape 3.3](#étape-33--intégration-github-actions-optionnel-mais-recommandé)).

---

## 📦 Génération de SBOM

### Qu'est-ce qu'un SBOM CycloneDX ?

Un SBOM CycloneDX est un fichier JSON ou XML qui liste tous les composants de votre application avec leurs métadonnées.

### Méthode 1 : Génération via cyclonedx-php (Recommandée)

#### Installation de cyclonedx-php

```bash
# Dans votre conteneur PHP
docker compose exec php composer require --dev cyclonedx/cyclonedx-php
```

#### Génération du SBOM

```bash
# Générer le SBOM depuis votre projet Symfony
docker compose exec php vendor/bin/cyclonedx --output-file bom.json

# Vérifier le fichier généré
cat bom.json | head -20
```

**Résultat** : Un fichier `bom.json` est créé à la racine du projet avec toutes les dépendances Composer.

#### Structure du SBOM généré

Le fichier `bom.json` contient :
- **Metadata** : Informations sur le projet (nom, version, outils utilisés)
- **Components** : Liste de toutes les dépendances avec :
  - Nom du package
  - Version
  - Type (library)
  - Licences
  - Hash (pour vérification d'intégrité)

### Méthode 2 : Génération via CI/CD

#### GitHub Actions - Configuration Complète

**⚠️ IMPORTANT : Configuration requise avant utilisation**

Pour que GitHub Actions puisse uploader les SBOM vers Dependency-Track, vous devez :

1. **Créer une API Key dans Dependency-Track** (voir [Phase 1 - Étape 1.2](#phase-1--installation-et-configuration-30-minutes))
2. **Récupérer l'UUID du projet** dans Dependency-Track
3. **Configurer les secrets GitHub** :
   - `DEPENDENCY_TRACK_API_KEY` : Votre clé API Dependency-Track
   - `DEPENDENCY_TRACK_PROJECT_UUID` : UUID de votre projet
   - `DEPENDENCY_TRACK_API_URL` : URL de l'API (ex: `https://dependency-track-api-sso.docker.localhost`)

**Configuration GitHub Actions** :

```yaml
# .github/workflows/sbom.yml
name: Generate and Upload SBOM

on:
  push:
    branches: [ main, develop-sso ]
  pull_request:
    branches: [ main, develop-sso ]

jobs:
  generate-sbom:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.2'
      
      - name: Install dependencies
        run: composer install --no-dev --optimize-autoloader
      
      - name: Generate SBOM
        run: |
          composer require --dev cyclonedx/cyclonedx-php
          vendor/bin/cyclonedx --output-file bom.json
      
      - name: Upload SBOM to Dependency-Track
        env:
          DEPENDENCY_TRACK_API_URL: ${{ secrets.DEPENDENCY_TRACK_API_URL }}
          DEPENDENCY_TRACK_API_KEY: ${{ secrets.DEPENDENCY_TRACK_API_KEY }}
          DEPENDENCY_TRACK_PROJECT_UUID: ${{ secrets.DEPENDENCY_TRACK_PROJECT_UUID }}
        run: |
          curl -k -X "POST" "${DEPENDENCY_TRACK_API_URL}/api/v1/bom" \
            -H "X-Api-Key: ${DEPENDENCY_TRACK_API_KEY}" \
            -H "Content-Type: multipart/form-data" \
            -F "project=${DEPENDENCY_TRACK_PROJECT_UUID}" \
            -F "bom=@bom.json"
      
      - name: Upload SBOM as artifact
        uses: actions/upload-artifact@v3
        with:
          name: sbom
          path: bom.json
```

**Configuration des secrets GitHub** :

1. Aller dans votre repository GitHub : **Settings > Secrets and variables > Actions**
2. Cliquer sur **New repository secret**
3. Ajouter les 3 secrets suivants :
   - **Name** : `DEPENDENCY_TRACK_API_URL`
     - **Value** : `https://dependency-track-api-${COMPOSE_PROJECT_NAME}.docker.localhost`
     - **Exemple** : `https://dependency-track-api-sso.docker.localhost`
   
   - **Name** : `DEPENDENCY_TRACK_API_KEY`
     - **Value** : Votre clé API Dependency-Track (voir [Phase 1 - Étape 1.2](#phase-1--installation-et-configuration-30-minutes))
   
   - **Name** : `DEPENDENCY_TRACK_PROJECT_UUID`
     - **Value** : UUID de votre projet Dependency-Track
     - **Comment trouver l'UUID** : Dans Dependency-Track, aller dans **Portfolio > Projects**, cliquer sur votre projet, l'UUID est dans l'URL ou dans les détails du projet

**Note** : L'option `-k` dans curl est nécessaire car Traefik utilise un certificat auto-signé en développement. En production avec un certificat valide, vous pouvez retirer cette option.

#### GitLab CI

```yaml
# .gitlab-ci.yml
generate-sbom:
  stage: build
  image: composer:latest
  script:
    - composer install --no-dev --optimize-autoloader
    - composer require --dev cyclonedx/cyclonedx-php
    - vendor/bin/cyclonedx --output-file bom.json
    - |
      curl -X "POST" "https://dependency-track-api-${COMPOSE_PROJECT_NAME}.docker.localhost/api/v1/bom" \
        -H "X-Api-Key: $DEPENDENCY_TRACK_API_KEY" \
        -H "Content-Type: multipart/form-data" \
        -F "project=$DEPENDENCY_TRACK_PROJECT_UUID" \
        -F "bom=@bom.json"
  artifacts:
    paths:
      - bom.json
    expire_in: 1 week
```

### Méthode 3 : Upload Manuel

1. Générer le SBOM (voir Méthode 1)
2. Aller dans Dependency-Track : **Portfolio > Projects**
3. Sélectionner votre projet
4. Cliquer sur **Upload BOM**
5. Sélectionner le fichier `bom.json`
6. Cliquer sur **Upload**

**Résultat** : Dependency-Track analyse automatiquement le SBOM.

---

## 🔄 Intégration dans le Workflow

### Workflow Recommandé

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Développement                                            │
│    - Modification du code                                   │
│    - Modification de composer.json (ajout dépendance)      │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. Build CI/CD                                              │
│    - composer install                                       │
│    - Génération SBOM (cyclonedx)                           │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. Publication SBOM                                          │
│    - Upload vers Dependency-Track (REST API)                │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. Analyse Automatique                                       │
│    - Dependency-Track analyse le SBOM                     │
│    - Recherche de vulnérabilités dans les bases            │
│    - Évaluation des politiques                              │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│ 5. Notifications (si configurées)                            │
│    - Email, Slack, Teams, Webhook                            │
│    - Alertes si vulnérabilités critiques détectées         │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│ 6. Consultation Dashboard                                    │
│    - Vue d'ensemble des vulnérabilités                      │
│    - Priorisation via EPSS                                  │
│    - Actions correctives                                    │
└─────────────────────────────────────────────────────────────┘
```

### Quand Générer un SBOM ?

**Recommandations** :

1. **À chaque commit** (si intégré dans CI/CD) :
   - Avantage : Détection immédiate des nouvelles vulnérabilités
   - Inconvénient : Plus de ressources utilisées

2. **À chaque Pull Request** :
   - Avantage : Vérification avant merge
   - Inconvénient : Légèrement moins réactif

3. **À chaque release/tag** :
   - Avantage : Moins de ressources
   - Inconvénient : Détection moins rapide

4. **Quotidiennement** (cron job) :
   - Avantage : Équilibre entre réactivité et ressources
   - Inconvénient : Peut manquer des vulnérabilités critiques entre deux analyses

**Recommandation pour votre projet SSO** : **À chaque Pull Request** + **Quotidiennement** (cron job).

---

## 📋 Plan d'Intégration Détaillé

### Phase 1 : Installation et Configuration (30 minutes)

#### Étape 1.1 : Vérification de l'Intégration Docker

**Objectif** : Vérifier que Dependency-Track est correctement intégré

**Actions** :
1. Vérifier que les variables sont dans `.env` :
   ```bash
   grep DEPENDENCY_TRACK .env
   ```
2. Démarrer la stack :
   ```bash
   task start
   ```
3. Vérifier que les conteneurs sont démarrés :
   ```bash
   docker compose ps | grep dependency-track
   ```
4. Accéder à l'interface web : `https://dependency-track-${COMPOSE_PROJECT_NAME}.docker.localhost`
5. Se connecter avec l'utilisateur admin par défaut :
   - **Username** : `admin`
   - **Password** : `admin`
6. **⚠️ IMPORTANT** : Changer le mot de passe immédiatement après la connexion
   - Vous serez automatiquement redirigé vers la page "Update Password"
   - Remplir le formulaire avec le mot de passe actuel (`admin`) et votre nouveau mot de passe fort

**Vérification** :
- ✅ Interface web accessible via Traefik
- ✅ API accessible via Traefik
- ✅ Connexion réussie avec l'utilisateur `admin`
- ✅ Mot de passe changé (sécurité)

**Temps estimé** : 15 minutes

#### Étape 1.2 : Configuration Initiale

**Objectif** : Configurer Dependency-Track pour votre usage

**Actions** :
1. Créer un **Team** (ex: "SSO Project")
2. Créer un **Projet** (ex: "SSO Symfony Project")
3. Générer une **API Key** :
   - Aller dans **Administration > Access Management > API Keys**
   - Créer une nouvelle clé avec les permissions nécessaires
   - **⚠️ IMPORTANT** : Sauvegarder la clé (elle ne sera plus affichée)

**Vérification** :
- ✅ Team créé
- ✅ Projet créé
- ✅ API Key générée et sauvegardée

**Temps estimé** : 20 minutes

#### Étape 1.3 : Configuration des Notifications (Optionnel mais Recommandé)

**Objectif** : Recevoir des alertes en cas de vulnérabilités

**Actions** :
1. Aller dans **Administration > Notifications**
2. Configurer au moins une notification :
   - **Email** : Pour les alertes critiques
   - **Slack/Teams** : Pour l'équipe (si utilisé)
   - **Webhook** : Pour intégration avec d'autres outils

**Vérification** :
- ✅ Au moins une notification configurée
- ✅ Test de notification réussi

**Temps estimé** : 30 minutes

**Résultat Phase 1** : Dependency-Track est installé, configuré et prêt à recevoir des SBOM.

---

### Phase 2 : Génération et Test de SBOM (1 heure)

#### Étape 2.1 : Installation de cyclonedx-php

**Objectif** : Avoir l'outil de génération de SBOM

**Actions** :
```bash
# Dans votre conteneur PHP
docker compose exec php composer require --dev cyclonedx/cyclonedx-php
```

**Vérification** :
- ✅ Package installé : `composer show cyclonedx/cyclonedx-php`

**Temps estimé** : 5 minutes

#### Étape 2.2 : Génération Manuelle du Premier SBOM

**Objectif** : Générer et tester le premier SBOM

**Actions** :
```bash
# Générer le SBOM
docker compose exec php vendor/bin/cyclonedx --output-file bom.json

# Vérifier le contenu
cat bom.json | jq '.components | length'  # Nombre de composants
```

**Vérification** :
- ✅ Fichier `bom.json` créé
- ✅ Fichier contient des composants (vérifier avec `jq`)

**Temps estimé** : 10 minutes

#### Étape 2.3 : Upload Manuel du SBOM

**Objectif** : Tester l'upload et l'analyse

**Actions** :
1. Aller dans Dependency-Track : **Portfolio > Projects**
2. Sélectionner votre projet
3. Cliquer sur **Upload BOM**
4. Sélectionner `bom.json`
5. Cliquer sur **Upload**
6. Attendre l'analyse (quelques secondes à quelques minutes)

**Vérification** :
- ✅ SBOM uploadé avec succès
- ✅ Analyse terminée (vérifier dans le dashboard)
- ✅ Vulnérabilités affichées (s'il y en a)

**Temps estimé** : 15 minutes

**Résultat Phase 2** : Vous savez générer et uploader un SBOM, et Dependency-Track analyse correctement.

---

### Phase 3 : Automatisation (2-3 heures)

#### Étape 3.1 : Script de Génération et Upload

**Objectif** : Automatiser la génération et l'upload du SBOM

**Actions** :
1. Créer un script `scripts/generate-and-upload-sbom.sh`
2. Le script doit :
   - Générer le SBOM
   - Uploader vers Dependency-Track via API
   - Gérer les erreurs

**Exemple de script** :
```bash
#!/bin/bash
set -e

# Variables (à définir dans .env)
# Récupérer COMPOSE_PROJECT_NAME depuis .env
if [[ -f .env ]]; then
  PROJECT_NAME=$(grep "^COMPOSE_PROJECT_NAME=" .env | cut -d'=' -f2 | tr -d '"' | tr -d "'" || basename "$(pwd)")
else
  PROJECT_NAME=$(basename "$(pwd)")
fi

DEPENDENCY_TRACK_API_URL="https://dependency-track-api-${PROJECT_NAME}.docker.localhost"
DEPENDENCY_TRACK_API_KEY="${DEPENDENCY_TRACK_API_KEY}"
DEPENDENCY_TRACK_PROJECT_UUID="${DEPENDENCY_TRACK_PROJECT_UUID}"

# Générer le SBOM
echo "🔍 Génération du SBOM..."
docker compose exec -T php vendor/bin/cyclonedx --output-file bom.json

# Upload vers Dependency-Track
echo "📤 Upload du SBOM vers Dependency-Track..."
curl -k -X "POST" "${DEPENDENCY_TRACK_API_URL}/api/v1/bom" \
  -H "X-Api-Key: ${DEPENDENCY_TRACK_API_KEY}" \
  -H "Content-Type: multipart/form-data" \
  -F "project=${DEPENDENCY_TRACK_PROJECT_UUID}" \
  -F "bom=@bom.json"

echo "✅ SBOM uploadé avec succès !"
```

**Note** : L'option `-k` dans curl est nécessaire car Traefik utilise un certificat auto-signé en développement. En production, vous pouvez retirer cette option.

**Vérification** :
- ✅ Script créé et exécutable
- ✅ Test manuel réussi

**Temps estimé** : 30 minutes

#### Étape 3.2 : Intégration dans Taskfile

**Objectif** : Ajouter une task pour générer et uploader le SBOM

**Actions** :
1. Ajouter une task `sbom:generate` dans `Taskfile.yml`
2. Ajouter une task `sbom:upload` dans `Taskfile.yml`
3. Ajouter une task `sbom` qui combine les deux

**Vérification** :
- ✅ Tasks créées
- ✅ Test : `task sbom` fonctionne

**Temps estimé** : 20 minutes

#### Étape 3.3 : Intégration GitHub Actions (Optionnel mais Recommandé)

**Objectif** : Générer et uploader le SBOM automatiquement depuis GitHub Actions

**Prérequis** :
- ✅ Dependency-Track est démarré et accessible
- ✅ Compte administrateur créé dans Dependency-Track
- ✅ Projet créé dans Dependency-Track
- ✅ API Key générée dans Dependency-Track

**Actions** :

1. **Créer le workflow GitHub Actions** :
   - Créer le fichier `.github/workflows/sbom.yml` (voir [Méthode 2 : Génération via CI/CD](#méthode-2--génération-via-cicd))

2. **Configurer les secrets GitHub** :
   - Aller dans votre repository GitHub : **Settings > Secrets and variables > Actions**
   - Cliquer sur **New repository secret**
   - Ajouter les 3 secrets suivants :
     - **`DEPENDENCY_TRACK_API_URL`** : `https://dependency-track-api-${COMPOSE_PROJECT_NAME}.docker.localhost`
       - **Exemple** : `https://dependency-track-api-sso.docker.localhost`
     - **`DEPENDENCY_TRACK_API_KEY`** : Votre clé API Dependency-Track
       - **Comment obtenir** : Dependency-Track > Administration > Access Management > API Keys > Create
     - **`DEPENDENCY_TRACK_PROJECT_UUID`** : UUID de votre projet Dependency-Track
       - **Comment obtenir** : Dependency-Track > Portfolio > Projects > Cliquer sur votre projet > UUID dans l'URL ou les détails

3. **Tester le workflow** :
   - Faire un commit et push
   - Vérifier dans GitHub Actions que le workflow s'exécute
   - Vérifier dans Dependency-Track que le SBOM est uploadé

**Vérification** :
- ✅ Workflow créé (`.github/workflows/sbom.yml`)
- ✅ Secrets GitHub configurés
- ✅ Test sur un commit : SBOM généré et uploadé
- ✅ SBOM visible dans Dependency-Track

**Temps estimé** : 30-45 minutes

**⚠️ Note importante** :
- Si Dependency-Track est sur votre machine locale (pas accessible depuis GitHub), vous devrez utiliser un tunnel (ex: ngrok) ou déployer Dependency-Track sur un serveur accessible publiquement.
- Pour le développement local, préférez la génération manuelle ou via script (voir [Méthode 1](#méthode-1--génération-via-cyclonedx-php-recommandée)).

**Résultat Phase 3** : La génération et l'upload du SBOM sont automatisés.

---

### Phase 4 : Configuration des Politiques (1-2 heures)

#### Étape 4.1 : Créer des Politiques de Sécurité

**Objectif** : Définir des règles pour identifier les risques

**Actions** :
1. Aller dans **Administration > Policies**
2. Créer des politiques de sécurité :
   - **Critical** : Bloquer les vulnérabilités critiques (CVSS >= 9.0)
   - **High** : Alerter sur les vulnérabilités élevées (CVSS >= 7.0)
   - **Medium** : Informer sur les vulnérabilités moyennes (CVSS >= 4.0)

**Exemple de politique** :
- **Name** : "Critical Vulnerabilities"
- **Violation State** : Fail
- **Operator** : >=
- **Value** : 9.0
- **Subject** : Severity

**Vérification** :
- ✅ Politiques créées
- ✅ Test : Uploader un SBOM avec une vulnérabilité critique → Politique déclenchée

**Temps estimé** : 30 minutes

#### Étape 4.2 : Créer des Politiques de Licence

**Objectif** : Vérifier la conformité des licences

**Actions** :
1. Créer des politiques de licence :
   - **Licences interdites** : GPL-3.0, AGPL-3.0 (selon vos besoins)
   - **Licences autorisées** : MIT, Apache-2.0, BSD-3-Clause

**Vérification** :
- ✅ Politiques de licence créées
- ✅ Test : Uploader un SBOM avec une licence interdite → Politique déclenchée

**Temps estimé** : 30 minutes

#### Étape 4.3 : Appliquer les Politiques au Projet

**Objectif** : Activer les politiques pour votre projet

**Actions** :
1. Aller dans **Portfolio > Projects**
2. Sélectionner votre projet
3. Aller dans l'onglet **Policies**
4. Activer les politiques créées

**Vérification** :
- ✅ Politiques activées pour le projet
- ✅ Test : Uploader un SBOM → Politiques évaluées

**Temps estimé** : 15 minutes

**Résultat Phase 4** : Les politiques sont configurées et actives.

---

### Phase 5 : Monitoring et Alertes (1 heure)

#### Étape 5.1 : Configuration des Notifications par Projet

**Objectif** : Recevoir des alertes spécifiques au projet

**Actions** :
1. Aller dans **Portfolio > Projects**
2. Sélectionner votre projet
3. Aller dans l'onglet **Notifications**
4. Configurer les notifications :
   - **Nouvelle vulnérabilité détectée**
   - **Politique violée**
   - **Composant obsolète détecté**

**Vérification** :
- ✅ Notifications configurées
- ✅ Test : Créer une vulnérabilité de test → Notification reçue

**Temps estimé** : 30 minutes

#### Étape 5.2 : Dashboard et Rapports

**Objectif** : Comprendre comment consulter les résultats

**Actions** :
1. Explorer le **Dashboard** :
   - Vue d'ensemble des vulnérabilités
   - Graphiques de tendances
   - Top 10 des composants vulnérables
2. Explorer les **Rapports** :
   - Rapport de vulnérabilités
   - Rapport de conformité
   - Rapport VDR (Vulnerability Disclosure Report)

**Vérification** :
- ✅ Dashboard consulté et compris
- ✅ Rapports générés et consultés

**Temps estimé** : 30 minutes

**Résultat Phase 5** : Le monitoring est configuré et vous savez consulter les résultats.

---

## 📅 Utilisation Quotidienne

### Workflow Quotidien Recommandé

#### Matin (5 minutes)

1. **Consulter le Dashboard Dependency-Track**
   - Vérifier les nouvelles vulnérabilités
   - Vérifier les violations de politiques
   - Prioriser selon EPSS

#### Pendant le Développement

1. **Avant d'ajouter une dépendance** :
   ```bash
   # Vérifier si la dépendance a des vulnérabilités connues
   composer require package/name
   task sbom  # Générer et uploader le SBOM
   # Consulter Dependency-Track pour voir les vulnérabilités
   ```

2. **Après un `composer update`** :
   ```bash
   composer update
   task sbom  # Générer et uploader le SBOM
   # Vérifier les nouvelles vulnérabilités dans Dependency-Track
   ```

#### Avant un Release (15 minutes)

1. **Générer un SBOM final** :
   ```bash
   task sbom
   ```

2. **Vérifier dans Dependency-Track** :
   - Aucune vulnérabilité critique non résolue
   - Aucune violation de politique
   - Tous les composants à jour (si possible)

3. **Générer un rapport VDR** (si nécessaire pour la conformité) :
   - Dependency-Track > Projet > Reports > VDR

### Checklist Hebdomadaire (30 minutes)

- [ ] Consulter le dashboard Dependency-Track
- [ ] Vérifier les nouvelles vulnérabilités
- [ ] Prioriser les correctifs selon EPSS
- [ ] Mettre à jour les dépendances critiques
- [ ] Vérifier la conformité des licences
- [ ] Générer un rapport de statut (si nécessaire)

---

## 🐛 Dépannage

### Problème 1 : SBOM non généré

**Symptôme** : Erreur lors de la génération du SBOM

**Solutions** :
1. Vérifier que `cyclonedx-php` est installé :
   ```bash
   composer show cyclonedx/cyclonedx-php
   ```
2. Vérifier que `composer.json` est valide :
   ```bash
   composer validate
   ```
3. Vérifier les permissions :
   ```bash
   ls -la bom.json
   ```

### Problème 2 : Upload échoué

**Symptôme** : Erreur 401 ou 403 lors de l'upload

**Solutions** :
1. Vérifier l'API Key :
   - Aller dans Dependency-Track > Administration > API Keys
   - Vérifier que la clé est active
   - Vérifier les permissions de la clé
2. Vérifier l'URL :
   ```bash
   # Récupérer le nom du projet
   PROJECT_NAME=$(grep "^COMPOSE_PROJECT_NAME=" .env | cut -d'=' -f2 | tr -d '"' | tr -d "'")
   curl -k -I "https://dependency-track-api-${PROJECT_NAME}.docker.localhost/api/v1/bom"
   ```
3. Vérifier le format du SBOM :
   ```bash
   cat bom.json | jq .  # Doit être un JSON valide
   ```

### Problème 3 : Aucune vulnérabilité détectée (alors qu'il y en a)

**Symptôme** : Dependency-Track ne détecte pas de vulnérabilités connues

**Solutions** :
1. Vérifier que les sources de vulnérabilités sont synchronisées :
   - Administration > Repositories
   - Vérifier que NVD, OSS Index, etc. sont synchronisés
2. Attendre quelques minutes (la synchronisation peut prendre du temps)
3. Vérifier que le composant est bien dans le SBOM :
   ```bash
   cat bom.json | jq '.components[] | select(.name == "package/name")'
   ```

### Problème 4 : Notifications non reçues

**Symptôme** : Aucune notification reçue malgré la configuration

**Solutions** :
1. Vérifier la configuration des notifications :
   - Administration > Notifications
   - Vérifier que les notifications sont activées
2. Vérifier les paramètres du projet :
   - Portfolio > Projects > Votre projet > Notifications
   - Vérifier que les notifications sont activées pour le projet
3. Vérifier les logs :
   ```bash
   docker-compose logs dtrack-api | grep -i notification
   ```

---

## 📊 Métriques et KPIs

### Métriques à Suivre

1. **Nombre de vulnérabilités** :
   - Total
   - Par sévérité (Critical, High, Medium, Low)
   - Tendance (augmentation/diminution)

2. **Taux de conformité** :
   - % de composants conformes aux politiques
   - % de licences conformes

3. **Temps de réponse** :
   - Temps moyen entre détection et correction
   - Temps moyen pour corriger une vulnérabilité critique

4. **Couverture** :
   - % de projets avec SBOM à jour
   - Fréquence de mise à jour des SBOM

### Objectifs Recommandés

- **Vulnérabilités critiques** : 0 (zéro tolérance)
- **Vulnérabilités élevées** : < 5 par projet
- **Temps de réponse critique** : < 24 heures
- **Couverture SBOM** : 100% des projets

---

## 🔗 Ressources

### Documentation Officielle

- **Dependency-Track** : https://docs.dependencytrack.org/
- **CycloneDX** : https://cyclonedx.org/
- **OWASP** : https://owasp.org/www-project-dependency-track/

### Outils

- **cyclonedx-php** : https://github.com/CycloneDX/cyclonedx-php
- **CycloneDX Generator** : https://github.com/CycloneDX/cyclonedx-cli

### Standards

- **CycloneDX Specification** : https://cyclonedx.org/specification/
- **SPDX** : https://spdx.dev/ (autre format SBOM)

---

## ✅ Checklist d'Intégration Complète

### Phase 1 : Installation
- [ ] Dependency-Track installé et démarré
- [ ] Compte administrateur créé
- [ ] Team créé
- [ ] Projet créé
- [ ] API Key générée et sauvegardée

### Phase 2 : Génération SBOM
- [ ] cyclonedx-php installé
- [ ] Premier SBOM généré manuellement
- [ ] SBOM uploadé avec succès
- [ ] Analyse terminée dans Dependency-Track

### Phase 3 : Automatisation
- [ ] Script de génération et upload créé
- [ ] Tasks Taskfile créées
- [ ] Intégration CI/CD (optionnel)

### Phase 4 : Politiques
- [ ] Politiques de sécurité créées
- [ ] Politiques de licence créées
- [ ] Politiques appliquées au projet

### Phase 5 : Monitoring
- [ ] Notifications configurées
- [ ] Dashboard consulté et compris
- [ ] Rapports générés

### Utilisation Quotidienne
- [ ] Workflow quotidien établi
- [ ] Checklist hebdomadaire en place
- [ ] Métriques suivies

---

**🎉 Félicitations ! Vous avez maintenant Dependency-Track intégré dans votre projet SSO Symfony.**
