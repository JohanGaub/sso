#!/bin/bash
# Wrapper pour Rector qui filtre les warnings Deprecated du vendor

# Exécuter Rector et capturer la sortie
# $(...) capture la sortie standard (stdout) de la commande exécutée à l'intérieur.

# Grâce à "$@", lorsque vous exécutez ./run_rector.sh --dry-run src/ --config=rector.php, le shell interprète :
# $0 = ./run_rector.sh (le nom du script).
# $1 = --dry-run (le premier argument).
# $2 = src/ (le deuxième argument).
# $3 = --config=rector.php (le troisième argument).
# Et c'est "$@" qui va se développer en :
# --dry-run src/ --config=rector.php
#
# Le $0 n'est JAMAIS inclus dans "$@" (ni dans $*, ni dans $1, etc.). "$@" contient uniquement les arguments
# qui suivent le nom du script sur la ligne de commande. Dans notre exemple, "$@" va être remplacé par :
# --dry-run src/ --config=rector.php
#
# La commande complète exécutée dans le conteneur deviendra alors :
# docker compose exec -T -e XDEBUG_MODE=off php vendor/bin/rector --dry-run src/ --config=rector.php
# Ce qui est exactement ce que vous auriez tapé si vous appeliez rector directement dans le conteneur.

# 2>&1 : C'est une redirection des flux.
# 2 représente le descripteur de fichier pour la sortie d'erreur standard (stderr).
# 1 représente le descripteur de fichier pour la sortie standard (stdout).
# >& redirige un flux vers un autre.
# Donc, 2>&1 signifie "rediriger la sortie d'erreur standard vers la sortie standard". Cela a pour effet de fusionner stderr avec stdout.
OUTPUT=$(docker compose exec -T -e XDEBUG_MODE=off php vendor/bin/rector "$@" 2>&1)
EXIT_CODE=$?

# Filtrer les lignes Deprecated qui viennent du vendor
# -v "Deprecated:" filtre et supprime les lignes de sortie contenant "Deprecated:".
# ^ correspond au début d'une ligne.
# $ correspond à la fin d'une ligne.
# ^$ ensemble correspond donc à une ligne vide.
# Effet : Cette partie du script filtre et supprime toutes les lignes vides de la sortie. Cela permet de "nettoyer" la sortie finale, la rendant plus lisible en supprimant les espaces superflus.
echo "$OUTPUT" | grep -v "Deprecated:" | grep -v "^$"

# Retourner le code de sortie original
exit $EXIT_CODE


