#!/usr/bin/env bash
# [MANUEL UNIQUEMENT] Met à jour les dépendances runtime quand composer audit signale des CVE.
# Ne pas appeler depuis pre-commit, task quality ou un hook automatique.
# Usage : task audit:fix   ou   bash scripts/fix-composer-security.sh

set -euo pipefail

FILES="${DOCKER_COMPOSE_FILES:--f docker-compose.yml}"
COMPOSER_JSON="${COMPOSER_JSON:-composer.json}"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

compose() {
  docker compose $FILES exec -T php "$@"
}

if [[ ! -f "$COMPOSER_JSON" ]]; then
  echo -e "${RED}Erreur : $COMPOSER_JSON introuvable${NC}" >&2
  exit 1
fi

if ! docker compose $FILES exec -T php true 2>/dev/null; then
  echo -e "${RED}Erreur : le conteneur php n'est pas démarré. Lancez : task start${NC}" >&2
  exit 1
fi

echo ""
echo -e "${BOLD}1/3 — Audit Composer (état initial)${NC}"
if compose composer audit; then
  echo ""
  echo -e "${GREEN}${BOLD}✅ Aucune CVE détectée — rien à corriger.${NC}"
  echo ""
  exit 0
fi

echo ""
echo -e "${YELLOW}${BOLD}CVE détectées — mise à jour des dépendances runtime (require)...${NC}"
echo ""

# Paquets directs du projet (hors php / extensions), pas les outils dev
if command -v jq >/dev/null 2>&1; then
  mapfile -t PACKAGES < <(jq -r '.require | keys[] | select(. != "php" and (startswith("ext-") | not))' "$COMPOSER_JSON")
else
  mapfile -t PACKAGES < <(grep -A 200 '"require"' "$COMPOSER_JSON" | grep -E '^\s+"[^"]+":' | sed -E 's/.*"([^"]+)".*/\1/' | grep -v '^php$' | grep -v '^ext-' || true)
fi

if [[ ${#PACKAGES[@]} -eq 0 ]]; then
  echo -e "${RED}Erreur : impossible de lister les paquets require depuis $COMPOSER_JSON${NC}" >&2
  exit 1
fi

echo -e "${BOLD}Paquets ciblés :${NC} ${PACKAGES[*]}"
echo ""

echo -e "${BOLD}2/3 — composer update (avec dépendances transitives)${NC}"
compose composer update "${PACKAGES[@]}" --with-all-dependencies

echo ""
echo -e "${BOLD}3/3 — Re-audit${NC}"
if compose composer audit; then
  echo ""
  echo -e "${GREEN}${BOLD}✅ Audit OK après mise à jour.${NC}"
  echo -e "${YELLOW}Pensez à commiter composer.json et composer.lock :${NC}"
  echo -e "  git add composer.json composer.lock"
  echo -e "  git commit -m \"fix(deps): bump dependencies to address security advisories\""
  echo ""
  exit 0
fi

echo ""
echo -e "${RED}${BOLD}❌ Des CVE subsistent après mise à jour automatique.${NC}"
echo -e "${YELLOW}Actions possibles :${NC}"
echo -e "  - Vérifier les advisories : task audit"
echo -e "  - Mettre à jour manuellement les contraintes dans composer.json"
echo -e "  - Consulter https://symfony.com/blog/category/living-on-the-edge"
echo ""
exit 1
