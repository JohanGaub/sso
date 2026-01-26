# 📋 Instructions détaillées pour créer votre nouveau projet

## 🎯 Vue d'ensemble

Ce guide vous explique **étape par étape** comment créer votre nouveau projet Symfony 8 avec PHP 8.5, dockerisé, en utilisant Task.

## 📍 Étape 1 : Quitter le projet actuel

Depuis votre répertoire actuel (`/home/jgaub@niji.fr/Public/Project/sso`) :

```bash
cd ..
```

Vous devriez maintenant être dans `/home/jgaub@niji.fr/Public/Project/`

## 📁 Étape 2 : Créer le nouveau répertoire

```bash
# Remplacez "mon-nouveau-projet" par le nom de votre choix
mkdir mon-nouveau-projet
cd mon-nouveau-projet
```

## 🔧 Étape 3 : Installer Task (si nécessaire)

**Vérifier si Task est installé :**
```bash
task --version
```

**Si ce n'est pas installé :**

**Sur Linux :**
```bash
sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"
```

**Sur macOS :**
```bash
brew install go-task/tap/go-task
```

**Sur Windows (avec Chocolatey) :**
```bash
choco install task
```

## 🌐 Étape 3.5 : Configuration docker-dev-host (automatique)

**Important :** Ce projet utilise Traefik pour gérer le routage et le SSL. Le boilerplate démarre automatiquement `docker-dev-host` si nécessaire.

**Configuration dans `.env` :**
```env
# Chemin vers docker-dev-host (ajustez si nécessaire)
DOCKER_DEV_HOST_PATH=/home/jgaub@niji.fr/Public/Project/docker-dev-host
```

**Note :** Lorsque vous lancez `task start` ou `task launch`, le boilerplate :
- ✅ Vérifie automatiquement si docker-dev-host est démarré
- ✅ Le démarre automatiquement si ce n'est pas le cas
- ✅ Vérifie que les réseaux `public-dev` et `traefik-global-proxy` existent
- ✅ Les crée automatiquement si nécessaire

**Vous n'avez rien à faire manuellement !** 🎉

## 📦 Étape 4 : Créer le projet Symfony 8 (100% dockerisé)

**Approche 100% dockerisée (recommandée) :**

1. **Créer un répertoire vide et copier les fichiers Docker :**
   ```bash
   mkdir mon-nouveau-projet
   cd mon-nouveau-projet
   
   # Copier les fichiers du boilerplate depuis le projet SSO
   # Note: Adaptez le chemin selon votre structure de projets
   cp -r /home/jgaub@niji.fr/Public/Project/sso/* .
   cp -r /home/jgaub@niji.fr/Public/Project/sso/.* . 2>/dev/null || true
   ```

2. **Configurer les variables d'environnement :**
   ```bash
   cp env.example .env
   nano .env  # Modifier avec vos valeurs
   ```

3. **Démarrer le conteneur PHP (vide pour l'instant) :**
   ```bash
   task start
   ```

4. **Créer le projet Symfony dans le conteneur :**
   ```bash
   # Accéder au conteneur PHP
   task console php
   
   # Dans le conteneur, créer le projet Symfony
   composer create-project symfony/skeleton:"8.*" /var/www/symfony --no-interaction
   
   # Sortir du conteneur
   exit
   ```

5. **Redémarrer la stack pour que tout soit configuré :**
   ```bash
   task restart
   ```

**Alternative : Si vous avez Composer sur votre machine hôte :**

**Option A : Avec Composer (recommandé)**
```bash
composer create-project symfony/skeleton:"8.*" .
```

**Option B : Avec Symfony CLI**
```bash
symfony new . --version=8
```

**Note :** Le point (`.`) signifie que le projet sera créé dans le répertoire actuel.

## 📋 Étape 5 : Copier les fichiers du boilerplate

Tous les fichiers nécessaires sont dans le projet SSO actuel.

**Depuis votre nouveau projet, copiez les fichiers :**

```bash
# Depuis le répertoire de votre nouveau projet
# Remplacez le chemin par le chemin réel vers le projet SSO
cp -r /home/jgaub@niji.fr/Public/Project/sso/* .
cp -r /home/jgaub@niji.fr/Public/Project/sso/.* . 2>/dev/null || true
```

**Note :** Assurez-vous de ne pas copier le dossier `.git` et les fichiers sensibles comme `.env`. Vous pouvez utiliser `.gitignore` pour exclure ces fichiers.

**Ou manuellement, copiez :**
- `Taskfile.yml` → à la racine
- `docker-compose.yml` → à la racine
- `docker-compose-tools.yml` → à la racine
- `env.example` → à la racine (vous le renommerez en `.env`)
- Tout le dossier `docker/` → à la racine

## ⚙️ Étape 6 : Configurer les variables d'environnement

```bash
# Copier le fichier d'exemple
cp env.example .env

# Éditer le fichier .env
nano .env  # ou utilisez votre éditeur préféré
```

**Variables importantes à modifier :**

```env
# Nom du projet (utilisé pour les noms de conteneurs)
COMPOSE_PROJECT_NAME=mon-nouveau-projet

# Domaine local (recommandé : utiliser *.docker.localhost)
APP_DOMAIN=mon-nouveau-projet.docker.localhost

# Domaine alternatif (déprécié, mais encore supporté)
APP_DOMAIN_DEVHOST=mon-nouveau-projet.docker.devhost

# Base de données
# Note: DATABASE_URL est construite automatiquement par docker-compose.yml
DB_USER=symfony
DB_PASSWORD=your-db-password-here
DB_NAME=symfony

# Secret Symfony (générez-en un nouveau)
APP_SECRET=votre-secret-aleatoire-ici
```

**Générer un nouveau secret Symfony :**
```bash
# Vous pouvez utiliser cette commande plus tard dans le conteneur
php bin/console secrets:generate-keys
```

## 🐳 Étape 7 : Vérification automatique (déjà fait !)

**Note :** Les réseaux `public-dev` et `traefik-global-proxy` sont vérifiés et créés automatiquement lors de `task start` ou `task launch`.

Vous n'avez rien à faire manuellement ! ✅

## 🚀 Étape 8 : Démarrer la stack Docker

```bash
# Démarrer la stack (build + création des conteneurs)
task start
```

Cette commande va :
- Construire les images Docker
- Créer et démarrer tous les conteneurs
- Installer les dépendances Composer
- Attendre que PostgreSQL soit prêt
- Exécuter les migrations
- Nettoyer et réchauffer le cache

**Vérifier que tout fonctionne :**
```bash
# Voir les logs
task logs php

# Voir tous les conteneurs
docker ps
```

## 🗄️ Étape 9 : Configurer la base de données

```bash
# Créer la base de données
task create-db

# Exécuter les migrations
task migration

# (Optionnel) Charger des fixtures si vous en avez
task load-fixtures
```

**Ou tout en une fois :**
```bash
task data
```

## ✅ Étape 10 : Vérifier que tout fonctionne

**Accéder au site :**
Ouvrez votre navigateur et allez sur : `https://mon-nouveau-projet.docker.localhost`

**⚠️ Si vous voyez une erreur SSL dans votre navigateur :**
Voir la section [Certificats SSL](#-certificats-ssl) ci-dessous.

**Accéder à la console PHP :**
```bash
task console php
```

**Voir les logs :**
```bash
task logs php
```

## 🔒 Certificats SSL

### Gestion automatique par Traefik

Les certificats SSL sont **gérés automatiquement** par `docker-dev-host` via Traefik. Votre projet Symfony n'a **rien à faire** avec les certificats.

Traefik utilise un certificat auto-signé wildcard `*.docker.localhost` qui est valide jusqu'en **2034**.

### Installation du certificat CA dans votre navigateur

Si votre navigateur affiche une erreur SSL (cadenas rouge, "Votre connexion n'est pas privée"), vous devez installer le certificat d'autorité de certification (CA) dans votre navigateur.

**Localisation du certificat CA :**
```
/home/jgaub@niji.fr/Public/Project/docker-dev-host/self-signed-ssl/CA.pem
```

**Instructions pour Chrome/Edge :**

1. Ouvrir les paramètres du navigateur et chercher "certificat"
2. Aller dans **Sécurité** → **Gérer les certificats**
3. Ouvrir l'onglet **"Autorités de certification racines de confiance"**
4. Cliquer sur **"Importer..."**
5. Sélectionner le fichier `CA.pem` (⚠️ changer le filtre sur `*` pour voir les fichiers `.pem`)
6. Cocher **"Faire confiance à ce certificat pour identifier les sites web"**
7. Valider
8. **Fermer TOUTES les instances du navigateur** et relancer

**Vérification :**
Après avoir redémarré le navigateur, vous devriez voir un cadenas vert sur `https://mon-nouveau-projet.docker.localhost`

**Note :** Cette opération n'est nécessaire qu'une seule fois par navigateur. Le certificat est valide jusqu'en 2034.

**Pour plus de détails :**
Consultez le README dans `/home/jgaub@niji.fr/Public/Project/docker-dev-host/self-signed-ssl/README.MD`

## 📝 Utilisation des commandes Task

### Commandes de base

```bash
# Afficher toutes les tâches disponibles
task --list

# Démarrer la stack
task start

# Arrêter la stack
task stop

# Redémarrer la stack
task restart

# Arrêter et supprimer les volumes
task kill
```

### Commandes avec arguments

**Pour les commandes qui nécessitent des arguments, utilisez des variables d'environnement :**

```bash
# Console dans un conteneur spécifique
CLI_ARGS=nginx task console

# Logs d'un conteneur spécifique
CLI_ARGS=database task logs

# Tests avec filtre
CLI_ARGS=UserTest task run-tests

# Thème avec commande
CLI_ARGS="node -v" task theme

# Messenger avec worker spécifique
CLI_ARGS=async task run-messenger
```

### Commandes de développement

```bash
# Vider le cache
task cc

# Exécuter les migrations
task migration

# Lancer les tests
task run-tests

# Lancer les tests avec couverture
task run-tests-with-coverage

# Lancer tous les contrôles qualité
task run-qa
```

## 🔍 Dépannage

### Le conteneur PHP ne démarre pas

```bash
# Voir les logs
task logs php

# Vérifier les erreurs
docker logs mon-nouveau-projet_php
```

### Problème de permissions

```bash
task update-permissions
```

### Base de données non accessible

```bash
# Vérifier que PostgreSQL est démarré
task logs database

# Vérifier la connexion depuis le conteneur PHP
task console php
# Puis dans le conteneur :
php bin/console doctrine:database:create
```

### Les réseaux Docker n'existent pas

Les réseaux sont créés automatiquement lors de `task start`. Si vous avez une erreur :

```bash
# Vérifier que docker-dev-host peut être démarré
task ensure-docker-dev-host

# Puis redémarrer votre projet
task restart
```

### Erreur "port already in use"

Si le port 5432 est déjà utilisé :

```bash
# Modifier docker-compose.yml et changer le port
# Exemple : "5433:5432" au lieu de "5432:5432"
```

## 📚 Prochaines étapes

1. **Installer les bundles nécessaires :**
   ```bash
   task console php
   composer require doctrine/doctrine-bundle
   composer require symfony/orm-pack
   # etc.
   ```

2. **Configurer votre application :**
   - Modifier `config/packages/`
   - Créer vos entités
   - Configurer les routes

3. **Développer :**
   - Créer vos contrôleurs
   - Créer vos services
   - Écrire vos tests

## 🎉 Félicitations !

Votre nouveau projet Symfony 8 avec PHP 8.5 est maintenant prêt à être utilisé avec Docker et Task !

## 📖 Ressources

- [Documentation Task](https://taskfile.dev/)
- [Documentation Symfony 8](https://symfony.com/doc/8.0/index.html)
- [Documentation Docker Compose](https://docs.docker.com/compose/)


