# 🔒 Guide de Sécurité - Gestion des Secrets

## ⚠️ Règles Importantes

1. **JAMAIS de secrets en dur dans le code source**
2. **Tous les secrets doivent être dans `.env`** (non versionné)
3. **Utiliser des placeholders dans les exemples** (`your-db-password-here`, `your-secret-key-here`)
4. **Utiliser Symfony Secrets pour la production**

---

## 📋 Variables d'Environnement Requises

### Base de Données

```env
DB_SERVER_VERSION=16
DB_USER=symfony
DB_PASSWORD=your-db-password-here  # ⚠️ À CHANGER
DB_NAME=symfony
```

**Note** : `DATABASE_URL` est construite automatiquement par `docker-compose.yml` à partir de ces variables.

### Symfony

```env
APP_ENV=dev
APP_SECRET=your-secret-key-here-change-in-production  # ⚠️ À CHANGER
```

### SSO OAuth2 (si applicable)

```env
SSO_CLIENT_ID=your-client-id-here
SSO_CLIENT_SECRET=your-client-secret-here
# ... autres variables selon le provider
```

---

## 🔧 Fichiers de Configuration

### `.env` (non versionné)
- **Contient les vraies valeurs** pour le développement local
- **Ne JAMAIS commiter** ce fichier
- Créer depuis `env.example` ou `env.dev.example`

### `env.example` (versionné)
- **Contient uniquement des placeholders**
- Utilisé comme template pour créer `.env`
- Tous les secrets doivent être remplacés par des placeholders

### `env.dev.example` (versionné)
- Template pour l'environnement de développement
- Contient des placeholders sécurisés

---

## ✅ Checklist de Sécurité

Avant de commiter :

- [ ] Aucun secret en dur dans le code source
- [ ] `.env` et `.env.dev` sont dans `.gitignore` et **non versionnés**
- [ ] `env.example` et `env.dev.example` contiennent uniquement des placeholders
- [ ] Tous les scripts utilisent des variables d'environnement
- [ ] Aucun mot de passe dans les messages d'aide/echo
- [ ] Les URLs de base de données utilisent des variables

### ⚠️ Si des fichiers .env ont été versionnés par erreur

Si vous découvrez que `.env` ou `.env.dev` sont versionnés dans Git :

```bash
# 1. Retirer du suivi Git (les fichiers restent localement)
git rm --cached .env .env.dev

# 2. Vérifier que .gitignore contient bien /.env.*
# 3. Commiter la suppression du suivi
git commit -m "security: Remove .env files from Git tracking"

# 4. ⚠️ IMPORTANT : Si des secrets ont été commités, ils sont dans l'historique Git
#    Vous devrez peut-être régénérer les secrets compromis
```

---

## 🛠️ Commandes Utiles

### Générer un nouveau secret Symfony

```bash
task console php
php bin/console secrets:generate-keys
```

### Vérifier les secrets en dur

```bash
# Rechercher des mots de passe en dur
grep -r "password.*=" --include="*.yml" --include="*.yaml" --include="*.sh" . | grep -v ".env" | grep -v "vendor" | grep -v ".git"
```

---

## 📚 Documentation

- [Symfony Secrets](https://symfony.com/doc/current/configuration/secrets.html)
- [Best Practices OWASP](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)

