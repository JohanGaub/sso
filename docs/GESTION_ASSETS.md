# 🎨 Gestion des Assets (CSS & JavaScript)

> **Objectif** : Documenter la gestion des fichiers CSS et JavaScript dans le projet SSO.  
> **Approche** : AssetMapper (recommandé par Symfony 8) - Simple, sans build step, tout en PHP.

---

## 📋 Table des matières

- [Choix technique : AssetMapper](#-choix-technique-assetmapper)
- [Structure des fichiers](#-structure-des-fichiers)
- [Utilisation dans les templates Twig](#-utilisation-dans-les-templates-twig)
- [Workflow de développement](#-workflow-de-développement)
- [Bonnes pratiques](#-bonnes-pratiques)

---

## 🎯 Choix technique : AssetMapper

### Pourquoi AssetMapper ?

Selon la [documentation officielle Symfony](https://symfony.com/doc/current/frontend.html), **AssetMapper est recommandé** pour les nouveaux projets Symfony 8.

**Avantages :**
- ✅ **Pas de Node.js requis** : Tout fonctionne en PHP
- ✅ **Pas de build step** : Pas besoin de compiler les assets
- ✅ **Versioning automatique** : Les assets sont automatiquement versionnés
- ✅ **Simple** : Configuration minimale
- ✅ **Compatible Stimulus/Turbo** : Si besoin plus tard
- ✅ **Support Sass/Tailwind** : Possible si nécessaire

**Inconvénients :**
- ❌ Pas de minification automatique (nécessite un bundle supplémentaire)
- ❌ Moins adapté aux projets frontend très complexes

### Alternative : Webpack Encore

Si vous avez besoin de fonctionnalités avancées (minification automatique, support complet de Sass/Less, etc.), vous pouvez utiliser **Webpack Encore**, mais cela nécessite Node.js et un build step.

**Pour ce projet SSO** : AssetMapper est parfaitement adapté car nous n'avons pas besoin de fonctionnalités frontend complexes.

---

## 📁 Structure des fichiers

### Organisation recommandée

```
projet/
├── assets/                    # Dossier source des assets
│   ├── styles/               # Fichiers CSS
│   │   ├── app.css          # CSS principal de l'application
│   │   └── test.css         # CSS spécifique à la page /test
│   └── app.js                # JavaScript principal (si nécessaire)
├── public/                   # Dossier public (servi par le serveur web)
│   └── assets/              # Assets compilés (générés automatiquement)
│       ├── app-abc123.css   # Versionné automatiquement
│       └── app-xyz789.js    # Versionné automatiquement
└── templates/                # Templates Twig
    ├── base.html.twig       # Template de base
    └── test/
        └── index.html.twig  # Template de la page /test
```

### Règles importantes

1. **Source** : Les fichiers CSS/JS sources sont dans `assets/`
2. **Compilation** : AssetMapper génère automatiquement les fichiers versionnés dans `public/assets/`
3. **Templates** : Les templates Twig incluent les assets via les fonctions `asset()` ou `importmap()`

---

## 🔧 Configuration AssetMapper

### Fichier de configuration

`config/packages/framework.yaml` :

```yaml
framework:
    asset_mapper:
        enabled: true
        paths:
            - '%kernel.project_dir%/assets'
        public_prefix: '/assets/'
```

### Structure des dossiers

- **`assets/`** : Dossier source des fichiers CSS et JavaScript
- **`public/assets/`** : Dossier de destination (généré automatiquement)

---

## 📝 Utilisation dans les templates Twig

### Template de base (`base.html.twig`)

```twig
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>{% block title %}Welcome!{% endblock %}</title>
    
    {# Inclusion des assets CSS via AssetMapper #}
    {% block stylesheets %}
        {{ importmap('app') }}
    {% endblock %}
</head>
<body>
    {% block body %}{% endblock %}
    
    {# Inclusion des assets JavaScript via AssetMapper #}
    {% block javascripts %}
        {{ importmap('app') }}
    {% endblock %}
</body>
</html>
```

### Template spécifique (`test/index.html.twig`)

```twig
{% extends 'base.html.twig' %}

{% block title %}Test de Configuration{% endblock %}

{% block stylesheets %}
    {{ parent() }}
    {# Inclusion du CSS spécifique à la page /test #}
    <link rel="stylesheet" href="{{ asset('styles/test.css') }}">
{% endblock %}

{% block body %}
    {# Contenu de la page #}
{% endblock %}
```

### Fonctions Twig disponibles

- **`{{ asset('styles/test.css') }}`** : Inclut un fichier CSS depuis `assets/`
- **`{{ importmap('app') }}`** : Inclut les assets JavaScript via importmap (pour les modules ES6)

---

## 🔄 Workflow de développement

### 1. Créer un fichier CSS

1. Créer le fichier dans `assets/styles/nom-du-fichier.css`
2. Écrire le CSS normalement
3. AssetMapper le détecte automatiquement

### 2. Inclure dans un template

1. Dans le template Twig, utiliser `{{ asset('styles/nom-du-fichier.css') }}`
2. Ou étendre `base.html.twig` et surcharger le block `stylesheets`

### 3. Voir les changements

- **En développement** : Les changements sont visibles immédiatement (pas de build)
- **En production** : Les assets sont automatiquement versionnés pour le cache

---

## ✅ Bonnes pratiques

### Organisation des fichiers CSS

1. **CSS global** : `assets/styles/app.css` (styles communs à toute l'application)
2. **CSS par page** : `assets/styles/nom-page.css` (styles spécifiques à une page)
3. **CSS par composant** : `assets/styles/components/nom-composant.css` (styles réutilisables)

### Nommage

- Utiliser des noms descriptifs : `test.css`, `login.css`, `dashboard.css`
- Éviter les noms génériques : `style.css`, `main.css` (sauf pour `app.css`)

### Séparation des préoccupations

- **CSS dans les templates** : ❌ Éviter (sauf cas exceptionnels)
- **CSS dans des fichiers séparés** : ✅ Recommandé
- **CSS inline** : ❌ À éviter absolument

### Performance

- **Minification** : Optionnelle en développement, recommandée en production
- **Versioning** : Automatique avec AssetMapper (gestion du cache navigateur)

---

## 🚀 Migration depuis CSS inline

### Étape 1 : Extraire le CSS

1. Identifier le CSS inline dans le template
2. Créer un fichier `assets/styles/nom-page.css`
3. Copier le CSS dans ce fichier

### Étape 2 : Nettoyer le template

1. Supprimer la balise `<style>` du template
2. Ajouter l'inclusion du fichier CSS via `{{ asset('styles/nom-page.css') }}`

### Étape 3 : Vérifier

1. Recharger la page
2. Vérifier que le style est toujours appliqué
3. Vérifier dans les DevTools que le CSS est bien chargé

---

## 📚 Documentation officielle

- [Symfony - Front-end Tools](https://symfony.com/doc/current/frontend.html)
- [Symfony - AssetMapper](https://symfony.com/doc/current/frontend/asset_mapper.html)

---

## 🔗 Liens utiles

- [AssetMapper Documentation](https://symfony.com/doc/current/frontend/asset_mapper.html)
- [Twig - Asset Function](https://twig.symfony.com/doc/3.x/functions/asset.html)

---

## 📝 Notes

- AssetMapper est activé par défaut dans Symfony 8
- Pas besoin de configuration supplémentaire pour commencer
- Les assets sont servis directement depuis `public/assets/` en développement
- Le versioning automatique gère le cache navigateur
