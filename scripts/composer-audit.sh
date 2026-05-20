#!/usr/bin/env bash
# Lance composer audit dans le conteneur php.
# En cas de CVE : affiche le détail puis indique la commande manuelle task audit:fix
# (même principe que check-tools-versions.sh → task update:tools).

set -euo pipefail

FILES="${DOCKER_COMPOSE_FILES:--f docker-compose.yml}"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
NC='\033[0m'

if ! docker compose $FILES exec -T php true 2>/dev/null; then
  echo -e "${RED}Erreur : le conteneur php n'est pas démarré. Lancez : task start${NC}" >&2
  exit 1
fi

echo ""
echo -e "${BOLD}${UNDERLINE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${UNDERLINE}  AUDIT SÉCURITÉ COMPOSER (CVE)${NC}"
echo -e "${BOLD}${UNDERLINE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo ""

if docker compose $FILES exec -T php composer audit; then
  echo ""
  echo -e "${GREEN}${BOLD}✅ Aucune CVE détectée dans les dépendances Composer.${NC}"
  echo ""
  exit 0
fi

echo ""
echo -e "${BOLD}${RED}${UNDERLINE}⚠️  DES VULNÉRABILITÉS ONT ÉTÉ DÉTECTÉES${NC}"
echo ""
echo -e "${YELLOW}Pour tenter de corriger (commande *manuelle*, via le conteneur php) :${NC}"
echo -e "  ${BOLD}task audit:fix${NC}"
echo ""
echo -e "${YELLOW}Cette commande met à jour les paquets du bloc require (Symfony, Twig, etc.) puis relance l'audit.${NC}"
echo -e "${YELLOW}Elle n'est jamais exécutée automatiquement (pre-commit, task quality, etc.).${NC}"
echo ""
exit 1
