#!/bin/bash
set -e
XDEBUG_MODE=off

echo "🚀 Démarrage de l'entrypoint..."
echo "📊 Environment: $APP_ENV"

# Création des dossiers nécessaires dans var s'ils n'existent pas
echo "📁 Vérification des dossiers var..."
mkdir -p var/cache
mkdir -p var/ci/phpstan var/ci/rector var/ci/phpunit var/ci/phpcsfixer
mkdir -p var/log
mkdir -p var/uploads
mkdir -p var/uploads/editions
mkdir -p var/uploads/inscriptions/temporaires

# Configuration des permissions
echo "🔒 Configuration des permissions..."
# Utiliser chmod sur macOS/Darwin ou setfacl sur Linux
if command -v setfacl >/dev/null 2>&1; then
    echo "📁 Utilisation de setfacl (Linux)"
    setfacl -R -m u:www-data:rwX -m u:1000:rwX var public vendor 2>/dev/null || true
    setfacl -dR -m u:www-data:rwX -m u:1000:rwX var public vendor 2>/dev/null || true
    # Permissions pour le répertoire config/ (pour permettre Git de modifier les fichiers)
    setfacl -m u:www-data:rwX -m u:1000:rwX config/ 2>/dev/null || true
    setfacl -dR -m u:www-data:rwX -m u:1000:rwX config/ 2>/dev/null || true
else
    echo "📁 Utilisation de chmod (macOS/Docker Desktop)"
    chmod -R 775 var public vendor 2>/dev/null || true
    chown -R www-data:www-data var public vendor 2>/dev/null || true
    # Permissions pour le répertoire config/ (pour permettre Git de modifier les fichiers)
    chmod 775 config/ 2>/dev/null || true
    chown 1000:1000 config/ 2>/dev/null || true
    # Permissions pour le répertoire config/ (pour permettre Git de modifier les fichiers)
    chmod 775 config/ 2>/dev/null || true
    chown 1000:1000 config/ 2>/dev/null || true
fi

# Si le premier argument commence par un tiret, on le traite comme une commande PHP
if [ "${1#-}" != "$1" ]; then
    set -- php "$@"
fi

# Installation des dépendances et configuration initiale
if [[ "$1" = "php-fpm" ]] || [[ "$1" = "php" ]]; then
    # Création automatique du projet Symfony si nécessaire
    if [ ! -f "composer.json" ]; then
        echo "📦 Projet Symfony introuvable. Création automatique..."

        # Vérifier si le répertoire est vide (sauf fichiers Docker)
        FILES_COUNT=$(find . -maxdepth 1 -type f ! -name ".*" ! -name "docker-compose*.yml" ! -name "Taskfile.yml" ! -name "*.md" ! -name "*.sh" ! -name "env.example" | wc -l)
        DIRS_COUNT=$(find . -maxdepth 1 -type d ! -name "." ! -name "docker" ! -name "var" ! -name "public" | wc -l)

        if [ "$FILES_COUNT" -eq 0 ] && [ "$DIRS_COUNT" -eq 0 ]; then
            # Répertoire vide, créer directement
            echo "📦 Création du projet Symfony 7.4..."
            composer create-project symfony/skeleton:"7.4.*" . --no-interaction || {
                echo "❌ Erreur lors de la création du projet Symfony"
                exit 1
            }
            echo "✅ Projet Symfony créé avec succès"
        else
            # Répertoire contient des fichiers, créer dans un répertoire temporaire puis déplacer
            echo "📦 Répertoire non vide, création dans un répertoire temporaire..."
            TEMP_DIR="/tmp/symfony-init-$$"
            composer create-project symfony/skeleton:"7.4.*" "$TEMP_DIR" --no-interaction || {
                echo "❌ Erreur lors de la création du projet Symfony"
                exit 1
            }

            # Déplacer uniquement les fichiers Symfony (exclure les fichiers Docker existants)
            echo "📦 Copie des fichiers Symfony..."
            cp -r "$TEMP_DIR"/* . 2>/dev/null || true
            cp -r "$TEMP_DIR"/.[!.]* . 2>/dev/null || true

            # Nettoyer
            rm -rf "$TEMP_DIR"
            echo "✅ Projet Symfony créé avec succès"
        fi
    fi

    # Installation des dépendances avec Composer
    if [ -f "composer.json" ]; then
        echo "🔄 Installation des dépendances avec Composer..."
        # Installation des dépendances avec Composer selon l'environnement
        if [ "$APP_ENV" = "dev" ]; then
            echo "🛠️  Mode développement : installation de toutes les dépendances"
            composer install --no-interaction --optimize-autoloader
        else
            echo "🏭 Mode production : installation des dépendances sans dev"
            composer install --no-interaction --optimize-autoloader --no-dev
        fi
        echo "✅ Installation des dépendances terminée"
    fi

    # Vérifier si le projet Symfony existe avant de continuer
    if [ -f "composer.json" ] && [ -f "bin/console" ]; then
        echo "⏳ Attente de la base de données PostgreSQL..."
        # Attente que la base de données soit prête
        until nc -z postgres 5432; do
            echo "⌛ PostgreSQL n'est pas encore prêt... nouvelle tentative dans 1 seconde"
            sleep 1
        done
        echo "✅ PostgreSQL est prêt !"

        echo "🔄 Exécution des migrations de la base de données..."
        # Exécution des migrations (ignore l'erreur si Doctrine n'est pas installé)
        php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration 2>/dev/null || echo "⚠️  Doctrine non installé, migrations ignorées"
        echo "✅ Migrations vérifiées"

        # Nettoyage du cache après toutes les opérations
        echo "🧹 Nettoyage du cache..."
        php bin/console cache:clear --no-warmup
        php bin/console cache:warmup
        echo "✅ Cache nettoyé et réchauffé"
    else
        echo "⏭️  Migrations et cache ignorés (projet Symfony non créé)"
    fi

    # Réapplication des permissions après toutes les opérations
    echo "🔒 Réapplication des permissions finales..."
    if command -v setfacl >/dev/null 2>&1; then
        echo "📁 Réapplication setfacl (Linux)"
        setfacl -R -m u:www-data:rwX -m u:1000:rwX var 2>/dev/null || true
        setfacl -dR -m u:www-data:rwX -m u:1000:rwX var 2>/dev/null || true
        # Réappliquer les permissions pour le répertoire config/
        setfacl -m u:www-data:rwX -m u:1000:rwX config/ 2>/dev/null || true
        setfacl -dR -m u:www-data:rwX -m u:1000:rwX config/ 2>/dev/null || true
    else
        echo "📁 Réapplication chmod (macOS/Docker Desktop)"
        chmod -R 775 var 2>/dev/null || true
        chown -R www-data:www-data var 2>/dev/null || true
        # Réappliquer les permissions pour le répertoire config/
        chmod 775 config/ 2>/dev/null || true
        chown 1000:1000 config/ 2>/dev/null || true
    fi
fi

echo "🚀 Démarrage de la commande principale : $@"
XDEBUG_MODE=debug
# Exécution de la commande passée en argument
exec "$@"


