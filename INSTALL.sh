#!/bin/bash
# Script d'aide pour installer le boilerplate dans un nouveau projet

set -e

echo "🚀 Installation du boilerplate Symfony 7.4 avec PHP 8.5 et Task"
echo ""

# Vérifier que nous sommes dans le bon répertoire
if [[ ! -f "Taskfile.yml" ]]; then
    echo "❌ Erreur : Ce script doit être exécuté depuis le répertoire du boilerplate"
    echo "   ou depuis le répertoire de destination où vous avez copié les fichiers."
    exit 1
fi

# Rendre l'entrypoint exécutable
if [[ -f "docker/php/docker-entrypoint.sh" ]]; then
    chmod +x docker/php/docker-entrypoint.sh
    echo "✅ docker-entrypoint.sh rendu exécutable"
fi

# Créer le fichier .env si il n'existe pas
if [[ ! -f ".env" ]] && [[ -f "env.example" ]]; then
    cp env.example .env
    echo "✅ Fichier .env créé depuis env.example"
    echo "⚠️  N'oubliez pas de modifier le fichier .env avec vos valeurs !"
fi

echo ""
echo "✅ Installation terminée !"
echo ""
echo "📝 Prochaines étapes :"
echo "   1. Modifiez le fichier .env avec vos valeurs"
echo "   2. Assurez-vous que le réseau Docker 'traefik-network' existe"
echo "   3. Lancez 'task start' pour démarrer la stack"
echo "   4. Consultez docs/INSTRUCTIONS_DETAILLEES.md pour plus d'informations"
echo ""


