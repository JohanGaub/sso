#!/bin/bash
# Script pour vérifier et ajouter les variables Docker manquantes dans .env

set -e

ENV_FILE=".env"
ENV_EXAMPLE="env.example"

if [ ! -f "$ENV_FILE" ]; then
    echo "❌ Le fichier .env n'existe pas"
    exit 1
fi

echo "🔍 Vérification des variables Docker dans .env..."

# Variables Docker requises
REQUIRED_VARS=(
    "COMPOSE_PROJECT_NAME"
    "DOCKER_DEV_HOST_PATH"
    "DB_SERVER_VERSION"
    "DB_USER"
    "DB_PASSWORD"
    "DB_NAME"
    "REDIS_VERSION"
    "XDEBUG_ENABLE"
)

MISSING_VARS=()

# Vérifier chaque variable
for var in "${REQUIRED_VARS[@]}"; do
    if ! grep -q "^${var}=" "$ENV_FILE" && ! grep -q "^# ${var}=" "$ENV_FILE"; then
        MISSING_VARS+=("$var")
    fi
done

if [ ${#MISSING_VARS[@]} -eq 0 ]; then
    echo "✅ Toutes les variables Docker sont présentes dans .env"
    exit 0
fi

echo "⚠️  Variables Docker manquantes détectées :"
for var in "${MISSING_VARS[@]}"; do
    echo "   - $var"
done

# Lire les valeurs depuis env.example si disponible
if [ -f "$ENV_EXAMPLE" ]; then
    echo ""
    echo "📋 Ajout des variables manquantes depuis env.example..."

    # Extraire la section Docker de env.example
    DOCKER_SECTION=$(sed -n '/^###> docker ###/,/^###< docker ###/p' "$ENV_EXAMPLE")

    # Ajouter à la fin du .env si la section n'existe pas
    if ! grep -q "^###> docker ###" "$ENV_FILE"; then
        echo "" >> "$ENV_FILE"
        echo "$DOCKER_SECTION" >> "$ENV_FILE"
        echo "✅ Section Docker ajoutée à la fin de .env"
    else
        echo "⚠️  La section Docker existe déjà dans .env"
        echo "   Veuillez ajouter manuellement les variables manquantes :"
        for var in "${MISSING_VARS[@]}"; do
            # Extraire la valeur depuis env.example
            VALUE=$(grep "^${var}=" "$ENV_EXAMPLE" | cut -d'=' -f2-)
            echo "   ${var}=${VALUE}"
        done
    fi
else
    echo ""
    echo "⚠️  env.example introuvable. Voici les variables à ajouter manuellement :"
    echo ""
    echo "###> docker ###"
    echo "COMPOSE_PROJECT_NAME=sso"
    echo "# APP_DOMAIN est construit automatiquement : \${COMPOSE_PROJECT_NAME}.docker.localhost"
    echo "# APP_DOMAIN_DEVHOST est construit automatiquement : \${COMPOSE_PROJECT_NAME}.docker.devhost"
    echo "DOCKER_DEV_HOST_PATH=/home/jgaub@niji.fr/Public/Project/docker-dev-host"
    echo "DB_SERVER_VERSION=16"
    echo "DB_USER=symfony"
    echo "DB_PASSWORD=your-db-password-here"
    echo "DB_NAME=symfony"
    echo "REDIS_VERSION=7-alpine"
    echo "XDEBUG_ENABLE=1"
    echo "SYMFONY_CONTAINER_XML_PATH="
    echo "###< docker ###"
fi

echo ""
echo "💡 La DATABASE_URL sera construite automatiquement par docker-compose.yml à partir de DB_USER, DB_PASSWORD, DB_NAME et DB_SERVER_VERSION"
echo "   Format: postgresql://\${DB_USER}:\${DB_PASSWORD}@database:5432/\${DB_NAME}?serverVersion=\${DB_SERVER_VERSION}&charset=utf8"

