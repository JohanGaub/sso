#!/bin/bash

# Couleurs ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
NC='\033[0m'

FILES="${DOCKER_COMPOSE_FILES:--f docker-compose.yml}"
COMPOSER_JSON="${COMPOSER_JSON:-composer.json}"

echo ""
echo -e "${BOLD}${UNDERLINE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${UNDERLINE}  VÉRIFICATION DES VERSIONS DES OUTILS DE QUALITÉ${NC}"
echo -e "${BOLD}${UNDERLINE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo ""

# Vérifier que composer.json existe
if [[ ! -f "$COMPOSER_JSON" ]]; then
    echo -e "${RED}Erreur : $COMPOSER_JSON introuvable${NC}" >&2
    exit 1
fi

# Fonction pour extraire une contrainte de version depuis composer.json
# Utilise jq si disponible, sinon grep/sed
get_constraint() {
    local package=$1
    if command -v jq >/dev/null 2>&1; then
        jq -r ".[\"require-dev\"][\"$package\"] // empty" "$COMPOSER_JSON" 2>/dev/null
    else
        grep -A 100 '"require-dev"' "$COMPOSER_JSON" | grep "\"$package\"" | sed -E 's/.*"'"$package"'":\s*"([^"]+)".*/\1/' | head -1
    fi
}

# Fonction pour récupérer la dernière version disponible sur Packagist
# Exclut les versions dev, alpha, beta, RC
get_latest_version() {
    local package=$1
    local versions=$(docker compose $FILES exec -T php composer show -a "$package" 2>/dev/null | \
        grep "versions" | \
        awk -F: '{print $2}')
    
    if [[ -z "$versions" ]]; then
        return
    fi
    
    echo "$versions" | \
        tr ',' '\n' | \
        sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | \
        sed 's/^\*[[:space:]]*//' | \
        grep -vE "dev-|alpha|beta|RC|rc|\.x-dev$|^dev" | \
        grep -E "^v?[0-9]+\.[0-9]+" | \
        sed 's/^v//' | \
        sort -V -r | \
        head -1
}

# Fonction pour comparer deux versions (retourne 1 si v1 < v2, 0 sinon)
version_lt() {
    local v1=$1
    local v2=$2
    # Normaliser les versions (enlever les préfixes v, ^, ~, etc.)
    v1=$(echo "$v1" | sed 's/^[vV^~]//' | sed 's/-dev$//' | sed 's/-.*$//')
    v2=$(echo "$v2" | sed 's/^[vV^~]//' | sed 's/-dev$//' | sed 's/-.*$//')
    
    # Comparaison avec sort -V
    if [[ "$(printf '%s\n' "$v1" "$v2" | sort -V | head -1)" != "$v1" ]]; then
        return 1
    fi
    return 0
}

# Définir les packages à vérifier
declare -A PACKAGES
PACKAGES[phpstan/phpstan]="PHPStan"
PACKAGES[rector/rector]="Rector"
PACKAGES[friendsofphp/php-cs-fixer]="PHP CS Fixer"
PACKAGES[phpmd/phpmd]="PHPMD"
PACKAGES[phpunit/phpunit]="PHPUnit"

HAS_UPDATES=false
UPDATE_PACKAGES=()

echo -e "${BOLD}Vérification en cours...${NC}"
echo ""

# Pour chaque package, récupérer les informations
for package in "${!PACKAGES[@]}"; do
    name="${PACKAGES[$package]}"
    
    # Récupérer la contrainte depuis composer.json
    constraint=$(get_constraint "$package")
    if [[ -z "$constraint" ]]; then
        continue
    fi
    
    # Récupérer la version installée
    installed=$(docker compose $FILES exec -T php composer show "$package" 2>/dev/null | grep -E "^\s+versions\s+:" | awk -F: '{print $2}' | awk '{print $1}' | head -1)
    if [[ -z "$installed" ]] || [[ "$installed" = "*" ]]; then
        # Essayer une autre méthode
        installed=$(docker compose $FILES exec -T php composer show "$package" 2>/dev/null | grep -E "versions" | awk '{print $NF}' | grep -v "^\*$" | head -1)
    fi
    if [[ -z "$installed" ]] || [[ "$installed" = "*" ]]; then
        installed="non installé"
    fi
    
    # Récupérer la dernière version disponible (sauf pour les versions dev)
    if [[ "$constraint" == *"dev"* ]] || [[ "$constraint" == *"x-dev"* ]]; then
        latest="dev (non vérifié)"
        needs_update=false
    else
        latest=$(get_latest_version "$package")
        if [[ -z "$latest" ]]; then
            latest="indisponible"
            needs_update=false
        else
            # Comparer installed avec latest (enlever les préfixes pour la comparaison)
            installed_clean=$(echo "$installed" | sed 's/^[vV]//' | sed 's/-.*$//' | xargs)
            latest_clean=$(echo "$latest" | sed 's/^[vV]//' | sed 's/-.*$//' | xargs)
            
            # Comparer strictement (ne mettre à jour que si installed < latest)
            if [[ -n "$installed_clean" ]] && [[ -n "$latest_clean" ]] && [[ "$installed_clean" != "$latest_clean" ]]; then
                if version_lt "$installed_clean" "$latest_clean"; then
                    needs_update=true
                    HAS_UPDATES=true
                    UPDATE_PACKAGES+=("$package")
                else
                    needs_update=false
                fi
            else
                needs_update=false
            fi
        fi
    fi
    
    # Afficher les informations
    if [[ "$needs_update" = true ]]; then
        echo -e "${BOLD}${name}:${NC}     ${GREEN}${installed}${NC} → ${YELLOW}${latest}${NC} disponible (contrainte: ${constraint})"
    else
        if [[ "$constraint" == *"dev"* ]] || [[ "$constraint" == *"x-dev"* ]]; then
            echo -e "${BOLD}${name}:${NC}     ${GREEN}${installed}${NC} (contrainte: ${constraint} - version dev non vérifiée)"
        else
            echo -e "${BOLD}${name}:${NC}     ${GREEN}${installed}${NC} (dernière: ${latest}, contrainte: ${constraint})"
        fi
    fi
done

echo ""

# Afficher les recommandations de mise à jour
if [[ "$HAS_UPDATES" = true ]]; then
    echo -e "${BOLD}${RED}${UNDERLINE}⚠️  ATTENTION : DES MISES À JOUR SONT DISPONIBLES !${NC}"
    echo ""
    echo -e "${YELLOW}Packages pouvant être mis à jour :${NC}"
    for pkg in "${UPDATE_PACKAGES[@]}"; do
        echo -e "  - ${BOLD}${pkg}${NC}"
    done
    echo ""
    echo -e "${YELLOW}Pour mettre à jour, exécutez :${NC}"
    echo -e "  ${BOLD}task update:tools${NC}"
    echo ""
    echo -e "${YELLOW}Note : Les versions dev (comme phpmd/phpmd 3.x-dev) ne sont pas vérifiées automatiquement.${NC}"
    echo ""
else
    echo -e "${GREEN}${BOLD}✅ Tous les outils sont à jour par rapport aux dernières versions disponibles !${NC}"
    echo ""
    echo -e "${YELLOW}Note : Les versions dev (comme phpmd/phpmd 3.x-dev) ne sont pas vérifiées automatiquement.${NC}"
    echo ""
fi
