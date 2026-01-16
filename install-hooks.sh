#!/bin/bash

# Script d'installation des hooks Git
# Copie les hooks depuis hooks/ vers .git/hooks/

set -e

echo "🔧 Installation des hooks Git..."

# Vérifier que nous sommes dans un repository Git
if [ ! -d .git ]; then
    echo "❌ Erreur : Ce n'est pas un repository Git"
    exit 1
fi

# Créer le dossier .git/hooks s'il n'existe pas
mkdir -p .git/hooks

# Copier les hooks
if [ -f hooks/pre-commit ]; then
    cp hooks/pre-commit .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
    echo "✅ Hook pre-commit installé"
else
    echo "⚠️  hooks/pre-commit introuvable"
fi

if [ -f hooks/commit-msg ]; then
    cp hooks/commit-msg .git/hooks/commit-msg
    chmod +x .git/hooks/commit-msg
    echo "✅ Hook commit-msg installé"
else
    echo "⚠️  hooks/commit-msg introuvable"
fi

echo ""
echo "✅ Hooks Git installés avec succès !"
echo ""
echo "💡 Les hooks seront automatiquement exécutés lors de vos commits."


