# Guide de Contribution

Ce document décrit les conventions et les bonnes pratiques pour contribuer à ce projet.

## 📋 Table des matières

- [Conventions de Commit](#conventions-de-commit)
- [Qualité du Code](#qualité-du-code)
- [Workflow de Développement](#workflow-de-développement)
- [Outils et Commandes](#outils-et-commandes)

---

## 🔖 Conventions de Commit

### Format : Conventional Commits

Nous utilisons le format **Conventional Commits** pour garantir un historique Git propre et cohérent.

### Structure

```
<type>(<scope>): <description>

[corps optionnel]

[footer optionnel]
```

### Types de commits

| Type | Description | Exemple |
|------|-------------|---------|
| `feat` | Nouvelle fonctionnalité | `feat(quality): add PHPStan level max` |
| `fix` | Correction de bug | `fix(phpstan): exclude reference.php` |
| `docs` | Documentation | `docs: update CONTRIBUTING.md` |
| `style` | Formatage (pas de changement de code) | `style: fix indentation` |
| `refactor` | Refactoring | `refactor: simplify authentication logic` |
| `perf` | Amélioration de performance | `perf: optimize database queries` |
| `test` | Ajout/modification de tests | `test: add unit tests for UserService` |
| `chore` | Tâches de maintenance | `chore(docker): update docker-compose` |
| `ci` | Configuration CI/CD | `ci: add GitHub Actions workflow` |
| `build` | Système de build | `build: update composer dependencies` |

### Scope (optionnel)

Le scope indique la partie du projet concernée :
- `quality` : Outils de qualité (PHPStan, Rector)
- `docker` : Configuration Docker
- `config` : Configuration Symfony
- `auth` : Authentification
- `api` : API
- etc.

### Description

- **Doit** commencer par une minuscule
- **Doit** être au présent ("add" pas "added")
- **Ne doit pas** se terminer par un point
- **Recommandation** : maximum 72 caractères

### Exemples valides

```bash
# Simple
feat: add user authentication
fix: resolve database connection issue

# Avec scope
feat(quality): add PHPStan level max configuration
fix(phpstan): exclude auto-generated reference.php
docs(api): update API documentation

# Avec corps (pour plus de détails)
feat(quality): add PHPStan level max configuration

- Configure PHPStan at maximum level (9)
- Add Symfony and Doctrine extensions
- Exclude auto-generated reference.php file
- Add dockerized task commands for quality checks
```

### Exemples invalides ❌

```bash
# Pas de type
Add PHPStan configuration

# Type invalide
feature: add PHPStan

# Description trop longue
feat(quality): add PHPStan level max configuration with Symfony and Doctrine extensions and exclude reference.php

# Description avec point
feat: add PHPStan.
```

### Validation automatique

Un hook Git valide automatiquement le format de vos commits. Si le format est incorrect, vous verrez un message d'erreur avec des exemples.

---

## ✅ Qualité du Code

### Vérifications automatiques

Avant chaque commit, les outils suivants sont exécutés automatiquement :

1. **PHPStan** (niveau max) - Analyse statique
2. **Rector** (dry-run) - Détection d'améliorations possibles

### Si des erreurs sont détectées

Le commit sera bloqué. Vous devrez :

1. **Corriger les erreurs PHPStan** :
   ```bash
   task phpstan
   ```

2. **Voir les améliorations Rector** :
   ```bash
   task rector:dry-run
   ```

3. **Appliquer les corrections Rector** (si souhaité) :
   ```bash
   task rector
   ```

4. **Réessayer le commit** :
   ```bash
   git commit -m "fix: correct PHPStan errors"
   ```

### Contourner les vérifications (⚠️ exceptionnel)

**Ne contournez les vérifications que dans des cas exceptionnels** (ex: commit de configuration urgente).

```bash
git commit --no-verify -m "chore: emergency config fix"
```

---

## 🔄 Workflow de Développement

### 1. Avant de commencer

```bash
# S'assurer que tout est à jour
git pull origin main

# Vérifier que Docker est démarré
task start
```

### 2. Créer une branche (si nécessaire)

```bash
git checkout -b feat/ma-nouvelle-fonctionnalite
```

### 3. Développer

- Écrire le code
- Tester localement
- Vérifier la qualité : `task quality`

### 4. Commiter

```bash
# Ajouter les fichiers
git add .

# Commiter (le hook vérifiera automatiquement)
git commit -m "feat(scope): description"
```

### 5. Pousser

```bash
git push origin main
# ou
git push origin feat/ma-nouvelle-fonctionnalite
```

---

## 🛠️ Outils et Commandes

### Qualité du code

```bash
# Vérifier tout (PHPStan + Rector)
task quality

# PHPStan uniquement
task phpstan

# Rector (voir sans modifier)
task rector:dry-run

# Rector (appliquer les corrections)
task rector
```

### Docker

```bash
# Démarrer la stack
task start

# Arrêter
task stop

# Redémarrer
task restart

# Accéder au conteneur PHP
task console php
```

### Git

```bash
# Voir l'historique des commits
git log --oneline

# Voir les changements
git status
git diff

# Annuler le dernier commit (garder les changements)
git reset --soft HEAD~1
```

---

## 📚 Ressources

- [Conventional Commits](https://www.conventionalcommits.org/)
- [PHPStan Documentation](https://phpstan.org/)
- [Rector Documentation](https://getrector.com/)
- [Documentation Qualité du Code](./docs/QUALITE_CODE.md)

---

## ❓ Questions ?

Si vous avez des questions sur les conventions ou le workflow, n'hésitez pas à ouvrir une issue ou à contacter l'équipe.

