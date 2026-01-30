# Nouveau Projet Symfony 8 avec PHP 8.5

Ce projet utilise :
- **Symfony 8**
- **PHP 8.5**
- **Docker** avec Docker Compose
- **Task** pour l'automatisation des tâches

## 🚀 Démarrage rapide

### Prérequis
- Docker et Docker Compose
- Task installé ([installation](https://taskfile.dev/installation/))
- **docker-dev-host** accessible (démarrage automatique si nécessaire)

### ⚠️ Important : docker-dev-host

Ce projet utilise **Traefik** pour gérer le routage et le SSL. Le boilerplate **démarre automatiquement** docker-dev-host si nécessaire.

**Configuration dans `.env` :**
```env
DOCKER_DEV_HOST_PATH=/home/jgaub@niji.fr/Public/Project/docker-dev-host
```

**Note :** Lors de `task start` ou `task launch`, le boilerplate :
- ✅ Vérifie et démarre automatiquement docker-dev-host
- ✅ Crée les réseaux Docker si nécessaire
- ✅ Vous n'avez rien à faire manuellement !

### Installation (Approche 100% dockerisée)

1. **Créer un répertoire vide et copier les fichiers**
   ```bash
   mkdir mon-nouveau-projet
   cd mon-nouveau-projet
   # Copier tous les fichiers de ce boilerplate
   ```

2. **Configurer les variables d'environnement**
   ```bash
   cp env.example .env
   # Éditer .env et adapter les valeurs (COMPOSE_PROJECT_NAME, APP_DOMAIN, etc.)
   ```

3. **Démarrer la stack (le conteneur PHP sera vide)**
   ```bash
   task start
   ```

4. **Créer le projet Symfony dans le conteneur**
   ```bash
   # Accéder au conteneur
   task console php
   
   # Dans le conteneur, créer Symfony
   composer create-project symfony/skeleton:"8.*" /var/www/symfony --no-interaction
   
   # Sortir
   exit
   ```

5. **Redémarrer et configurer**
   ```bash
   task restart
   task data  # Créer la base de données et charger les fixtures
   ```

## 📝 Commandes disponibles

Afficher toutes les commandes :
```bash
task --list
```

Commandes principales :
- `task start` : Démarre la stack Docker
- `task stop` : Arrête la stack
- `task console php` : Accède à la console PHP

## 🤝 Contribution

Avant de contribuer, veuillez lire le [Guide de Contribution](./docs/CONTRIBUTING.md) qui contient :
- Les conventions de commit (Conventional Commits)
- Les règles de qualité du code
- Le workflow de développement
- Les outils et commandes disponibles
- `task migration` : Exécute les migrations
- `task run-tests` : Lance les tests
- `task run-qa` : Lance tous les contrôles qualité

## 🌐 Réseaux Docker

Ce projet se connecte aux réseaux Docker suivants (créés par docker-dev-host) :
- `public-dev` : Réseau public pour la communication entre conteneurs
- `traefik-global-proxy` : Réseau utilisé par Traefik pour le routage

Ces réseaux sont créés automatiquement lorsque vous démarrez docker-dev-host avec `make start`.

## 🔒 Certificats SSL

Les certificats SSL sont gérés automatiquement par `docker-dev-host` via Traefik. Un certificat auto-signé wildcard `*.docker.localhost` est utilisé (valide jusqu'en 2034).

**Si votre navigateur affiche une erreur SSL :**
Vous devez installer le certificat CA dans votre navigateur. Voir `docs/INSTRUCTIONS_DETAILLEES.md` section "Certificats SSL" pour les instructions détaillées.

**Fichier du certificat CA :**
```
/home/jgaub@niji.fr/Public/Project/docker-dev-host/self-signed-ssl/CA.pem
```

## 📚 Documentation

### Documentation Générale
- `docs/INSTRUCTIONS_DETAILLEES.md` : Instructions complètes étape par étape pour le projet
- `docs/SECURITE.md` : Guide de sécurité et bonnes pratiques
- `docs/CORRECTIONS_SECURITE.md` : Résumé des corrections de sécurité appliquées

### Documentation SSO OAuth2/OpenID Connect
- `docs/INDEX_DOCUMENTATION.md` : Index de la documentation SSO
- `docs/GUIDE_DEMARRAGE_RAPIDE_SSO.md` : Guide rapide pour intégrer un SSO
- `docs/GUIDE_SSO_GENERIQUE.md` : Guide complet générique OAuth2/OIDC
- `docs/EXEMPLES_PROVIDERS.md` : Exemples concrets par provider (Google, GitHub, Keycloak, etc.)

**💡 Pour commencer avec SSO** : Consultez `docs/INDEX_DOCUMENTATION.md`
