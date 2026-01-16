#!/bin/bash
# Wrapper pour Rector qui filtre les warnings Deprecated du vendor

# Exécuter Rector et capturer la sortie
OUTPUT=$(docker compose exec -T -e XDEBUG_MODE=off php vendor/bin/rector "$@" 2>&1)
EXIT_CODE=$?

# Filtrer les lignes Deprecated qui viennent du vendor
echo "$OUTPUT" | grep -v "Deprecated:" | grep -v "^$"

# Retourner le code de sortie original
exit $EXIT_CODE


