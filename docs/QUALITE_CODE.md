# Qualité de Code - PHPStan & Rector

Ce projet utilise **PHPStan** (niveau max) et **Rector** pour garantir la qualité et la modernité du code.

## 📦 Installation

Les outils sont déjà configurés dans `composer.json`. Pour les installer dans le conteneur Docker :

```bash
# Démarrer les conteneurs Docker
task start

# Installer les dépendances dans le conteneur
task update
# ou directement
docker compose exec php composer install
```

**Important** : Tout s'exécute dans Docker, rien n'est installé sur votre machine locale.

## 🔍 PHPStan - Analyse Statique

PHPStan analyse votre code sans l'exécuter et détecte les erreurs potentielles au **niveau maximum** (niveau 10).

### Configuration

Le fichier `phpstan.neon` configure PHPStan avec :
- **Niveau max** : Analyse la plus stricte possible
- **Extension Symfony** : Comprend le conteneur Symfony
- **Extension Doctrine** : Comprend les entités Doctrine
- **Toutes les vérifications activées** : Code inutilisé, types manquants, etc.

### Utilisation (Dockerisé)

Toutes les commandes s'exécutent dans le conteneur Docker :

```bash
# Analyser le code
task phpstan

# Générer un baseline (si trop d'erreurs au départ)
task phpstan:baseline
```

### Utilisation directe dans le conteneur

Si vous préférez exécuter directement dans le conteneur :

```bash
# Accéder au conteneur
task console php

# Dans le conteneur
vendor/bin/phpstan analyse
composer phpstan
```

### Résolution progressive

Si vous avez beaucoup d'erreurs au départ, vous pouvez :
1. Générer un baseline : `composer phpstan:baseline`
2. Corriger progressivement les erreurs
3. Réduire le baseline au fil du temps

## 🔧 Rector - Refactoring Automatique

Rector modernise automatiquement votre code PHP en appliquant des règles prédéfinies.

### Configuration

Le fichier `rector.php` configure Rector avec :
- **PHP 8.2** : Toutes les fonctionnalités modernes de PHP 8.2
- **Symfony 8** : Règles spécifiques Symfony 8
- **Doctrine** : Améliorations Doctrine (si utilisé)
- **Auto-corrections** : Dead code, qualité de code, types, etc.

### Utilisation (Dockerisé)

Toutes les commandes s'exécutent dans le conteneur Docker :

```bash
# Voir ce qui sera modifié (sans modifier)
task rector:dry-run

# Appliquer les modifications
task rector

# Nettoyer le cache
task rector:clear-cache
```

### Utilisation directe dans le conteneur

Si vous préférez exécuter directement dans le conteneur :

```bash
# Accéder au conteneur
task console php

# Dans le conteneur
vendor/bin/rector process --dry-run
composer rector
```

### Workflow recommandé

1. **Vérifier** : `task rector:dry-run`
2. **Appliquer** : `task rector`
3. **Vérifier PHPStan** : `task phpstan`
4. **Commit** : Les modifications sont prêtes

## 🚀 Commandes Task (Recommandé - Dockerisé)

Toutes les commandes s'exécutent dans Docker via Task :

```bash
# PHPStan
task phpstan              # Analyser le code
task phpstan:baseline     # Générer un baseline

# Rector
task rector               # Appliquer les modifications
task rector:dry-run       # Voir sans modifier
task rector:clear-cache   # Nettoyer le cache

# Tout vérifier
task quality              # PHPStan + Rector (dry-run)
```

## 📦 Commandes Composer (Alternative)

Les scripts Composer sont également disponibles si vous êtes dans le conteneur :

```bash
# Accéder au conteneur
task console php

# Dans le conteneur
composer phpstan              # Analyser le code
composer phpstan:baseline     # Générer un baseline
composer rector               # Appliquer les modifications
composer rector:dry-run       # Voir sans modifier
composer rector:clear-cache   # Nettoyer le cache
composer quality              # PHPStan + Rector (dry-run)
```

## 📝 Intégration CI/CD

Ces outils peuvent être intégrés dans votre pipeline CI/CD pour garantir la qualité à chaque commit.

### Exemple GitHub Actions

```yaml
name: Quality Check

on: [push, pull_request]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: php-actions/composer@v6
        with:
          php_version: '8.2'
      - name: Install dependencies
        run: composer install --no-progress --prefer-dist
      - name: Run PHPStan
        run: vendor/bin/phpstan analyse
      - name: Run Rector (dry-run)
        run: vendor/bin/rector process --dry-run
```

## 🎯 Bonnes Pratiques

1. **Avant chaque commit** : Exécutez `task quality`
2. **Rector en premier** : Laissez Rector moderniser le code avec `task rector`
3. **PHPStan ensuite** : Vérifiez qu'il n'y a pas d'erreurs avec `task phpstan`
4. **Baseline progressif** : Si trop d'erreurs, utilisez `task phpstan:baseline` et réduisez-le progressivement
5. **Tout dans Docker** : Toutes les commandes s'exécutent dans le conteneur, rien n'est installé sur votre machine

## 📚 Documentation

- [PHPStan Documentation](https://phpstan.org/)
- [Rector Documentation](https://getrector.com/)
- [PHPStan Symfony Extension](https://github.com/phpstan/phpstan-symfony)
- [Rector Symfony Sets](https://github.com/rectorphp/rector-symfony)

