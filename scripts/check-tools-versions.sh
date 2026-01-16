#!/bin/bash

# Couleurs ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
NC='\033[0m'

FILES="${DOCKER_COMPOSE_FILES:--f docker-compose.yml}"

echo ""
echo -e "${BOLD}${UNDERLINE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${UNDERLINE}  VÉRIFICATION DES VERSIONS DES OUTILS DE QUALITÉ${NC}"
echo -e "${BOLD}${UNDERLINE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo ""

# Récupérer les versions installées
INSTALLED_PHPSTAN=$(docker compose $FILES exec -T php composer show phpstan/phpstan 2>/dev/null | grep "versions" | awk '{print $NF}' | head -1)
INSTALLED_RECTOR=$(docker compose $FILES exec -T php composer show rector/rector 2>/dev/null | grep "versions" | awk '{print $NF}' | head -1)
INSTALLED_CSFIXER=$(docker compose $FILES exec -T php composer show friendsofphp/php-cs-fixer 2>/dev/null | grep "versions" | awk '{print $NF}' | head -1)
INSTALLED_PHPMD=$(docker compose $FILES exec -T php composer show phpmd/phpmd 2>/dev/null | grep "versions" | awk '{print $NF}' | head -1)
INSTALLED_PHPUNIT=$(docker compose $FILES exec -T php composer show phpunit/phpunit 2>/dev/null | grep "versions" | awk '{print $NF}' | head -1)

# Versions requises dans composer.json
REQUIRED_PHPSTAN="^2.1.33"
REQUIRED_RECTOR="^2.3.1"
REQUIRED_CSFIXER="^3.92.5"
REQUIRED_PHPMD="3.x-dev"
REQUIRED_PHPUNIT="^12.5"

echo -e "${BOLD}PHPStan:${NC}     ${GREEN}${INSTALLED_PHPSTAN}${NC} (requis: ${REQUIRED_PHPSTAN})"
echo -e "${BOLD}Rector:${NC}      ${GREEN}${INSTALLED_RECTOR}${NC} (requis: ${REQUIRED_RECTOR})"
echo -e "${BOLD}PHP CS Fixer:${NC} ${GREEN}${INSTALLED_CSFIXER}${NC} (requis: ${REQUIRED_CSFIXER})"
echo -e "${BOLD}PHPMD:${NC}        ${GREEN}${INSTALLED_PHPMD}${NC} (requis: ${REQUIRED_PHPMD})"
echo -e "${BOLD}PHPUnit:${NC}      ${GREEN}${INSTALLED_PHPUNIT}${NC} (requis: ${REQUIRED_PHPUNIT})"
echo ""

# Vérifier si des mises à jour sont disponibles (exclure les versions dev)
OUTDATED=$(docker compose $FILES exec -T php composer outdated --direct 2>/dev/null | grep -E "phpstan|rector|php-cs-fixer|phpmd|phpunit" | grep -v "dev-master\|3.x-dev" || true)

if [ -n "$OUTDATED" ]; then
    echo -e "${BOLD}${RED}${UNDERLINE}⚠️  ATTENTION : DES MISES À JOUR SONT DISPONIBLES !${NC}"
    echo ""
    echo "$OUTDATED"
    echo ""
    echo -e "${YELLOW}Pour mettre à jour, exécutez :${NC}"
    echo -e "${BOLD}docker compose exec php composer update phpstan/phpstan phpstan/phpstan-symfony phpstan/phpstan-doctrine rector/rector friendsofphp/php-cs-fixer phpunit/phpunit${NC}"
    echo ""
    echo -e "${YELLOW}Note : Les versions dev (comme phpmd/phpmd 3.x-dev) ne sont pas incluses dans cette vérification.${NC}"
    echo ""
else
    echo -e "${GREEN}${BOLD}✅ Tous les outils sont à jour !${NC}"
    echo ""
    echo -e "${YELLOW}Note : Les versions dev (comme phpmd/phpmd 3.x-dev) ne sont pas vérifiées automatiquement.${NC}"
    echo ""
fi
