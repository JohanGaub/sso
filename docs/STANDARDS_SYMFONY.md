# Standards de développement — Symfony 8.0 / 7.4 LTS

Ce document définit les standards de développement pour nos projets Symfony.

Références officielles :
- Documentation Symfony : `https://symfony.com/doc`
- Best Practices : `https://symfony.com/doc/current/best_practices.html`

---

## A. Règles non négociables

### A1) Principes
- Appliquer **KISS**, **DRY** et **SOLID** sans sur-abstraction.
- Concevoir le **code métier** dans des services dédiés, pas dans les contrôleurs.
- Favoriser la **lisibilité** avant l’optimisation prématurée.
- Garder une architecture explicite par briques Symfony, avec un classement métier interne si nécessaire.

### A2) Standards de code
- Respecter **PSR-12** et les conventions Symfony.
- **Langue du code : anglais uniquement** (classes, méthodes, variables, commentaires utiles, fichiers, schéma DB).
- Convention : `camelCase` pour variables / propriétés / méthodes ; noms explicites partout.
- Limiter la taille des classes et des méthodes.
- Commentaires uniquement s’ils ajoutent un contexte non évident.
- S’appuyer sur **PHPStan** et **Rector** comme garde-fous continus.

---

## B. Standards Symfony (pratiques recommandées)

### B1) Structure de projet
- `src/` contient les briques essentielles (ex: `Entity`, `Controller`, `Service`, `Repository`, `EventListener`, `Command`, `Security`).
- Ne pas organiser `src/` en racine par contexte métier (`src/Customer`, `src/Billing`, etc.).
- Si besoin, créer des sous-répertoires métier **à l’intérieur** de chaque brique (`src/Controller/Billing`, `src/Service/Billing`, etc.).
- `src/Controller` = points d’entrée HTTP (orchestration), pas de métier.
- Éviter les classes utilitaires globales ; préférer des services injectés.

### B2) Services & injection de dépendances
- Utiliser **autowiring** et **autoconfiguration** par défaut.
- Préférer l’injection par constructeur.
- Définir des interfaces seulement si besoin réel (polymorphisme, substitution).
- Éviter les services “god object”.

### B3) Contrôleurs
- Un contrôleur orchestre, il ne contient pas la logique métier.
- Utiliser des **DTO** d’entrée/sortie pour les cas complexes.
- Retourner des réponses cohérentes (`JsonResponse`, `Response`) et des codes HTTP corrects.
- Gérer les erreurs métiers via exceptions dédiées + mapping HTTP centralisé.

### B4) Enums PHP
- Privilégier les **Enums** pour remplacer constantes et chaînes “en dur” représentant des états/types.
- Localisation : `src/Enum`.
- Doctrine : utiliser `enumType` dans le mapping quand pertinent.
- Formulaires : utiliser `EnumType` natif de Symfony.
- Validation : utiliser `Assert\\Enum` pour valider les données entrantes (notamment dans les DTO).
- Encapsuler la logique liée aux états (labels, transitions autorisées, etc.) dans l’Enum si cela clarifie la responsabilité.

### B5) Validation interne & programmation défensive
- Préconiser `webmozart/assert` pour sécuriser services et méthodes métier (pré-conditions, invariants).
- Objectif : **fail-fast** avec exceptions explicites.
- Installation : `composer require webmozart/assert`.

---

## C. Standards d’architecture internes (décisions d’équipe)

### C1) Administration (EasyAdmin)
- Pour tout backend d’administration : **EasyAdmin** par défaut.
- Toute alternative nécessite une validation d’architecture.

### C2) E-commerce (Sylius)
- Pour les sites e-commerce : **Sylius** est préconisé (flexible, orienté composant, aligné Symfony).
- Sylius supporte aussi le headless via son API.

### C3) API Platform
- Préconiser **API Platform** dès lors que son usage reste proportionné au besoin.
- Vigilance : complexité de mise en œuvre vs valeur apportée.

### C4) CMS (Sulu)
- Pour gestion de contenu complexe / multi-sites : **Sulu** recommandé.
- Headless possible via `sulu/headless-bundle`.

---

## D. Annexes pratiques

### D1) Doctrine & persistance
- Définir explicitement les contraintes DB (unique, index, foreign keys).
- Éviter N+1 (fetch join, repository ciblé, pagination).
- Migrations : versionnées, relues ; la description doit inclure le numéro de ticket (ex: Jira).
- Ne pas exposer directement les entités Doctrine dans l’API publique quand un DTO est plus approprié.

### D2) Validation, sérialisation & normalisation
- Utiliser le Validator Symfony avec contraintes explicites.
- Centraliser les règles de validation au plus proche des objets d’entrée (DTOs, entités si pertinent).
- Serializer :
  - Utiliser le composant Serializer pour normaliser/dénormaliser (et formater JSON/XML).
  - Privilégier des DTOs pour API plutôt que d’exposer les entités.
  - Utiliser les attributs `#[Groups]`, `#[SerializedName]`, `#[Ignore]`.
  - Contrôler l’exposition par groupes (ex: `list`, `detail`, `admin`).
  - Éviter les normalizers custom sauf cas complexes.
  - Attention aux références circulaires (`#[MaxDepth]`, groupes distincts) et à la performance.

### D3) Sécurité & gestion des utilisateurs
- Modèle utilisateur : implémenter `UserInterface` et `PasswordAuthenticatedUserInterface`.
- Identifiant unique pertinent (email par défaut) et indexé en DB.
- Authentification :
  - Utiliser `PasswordHasher`.
  - Pour API stateless : JWT (ex: `lexik/jwt-authentication-bundle`) selon le contexte.
  - Firewalls stricts, éviter les configurations trop permissives.
- Autorisation :
  - Privilégier les **Voters** pour logique métier liée aux objets.
  - Utiliser `#[IsGranted]` pour la lisibilité côté contrôleur.
  - Hiérarchie de rôles claire (`role_hierarchy`) si nécessaire.
- Bonnes pratiques :
  - Moindre privilège.
  - Pas de secrets en clair (utiliser `bin/console secrets:set`).
  - CSRF sur formulaires + en-têtes de sécurité (HSTS/CSP) via infra/app.

### D4) Configuration & environnements
- Config claire par env (`dev`, `test`, `prod`).
- Paramètres d’environnement au strict nécessaire.
- Ne jamais commiter de secret.

### D5) API & standards HTTP
- Conventions stables (routes, ressources, payloads).
- Formats d’erreur standardisés.
- Versionner l’API si exposition externe long terme.
- Documenter les endpoints (OpenAPI/Swagger) pour APIs publiques.

### D6) Messenger & asynchronisme
- Utiliser Symfony Messenger async pour les traitements non critiques pour la réponse HTTP :
  - notifications (email/SMS/push)
  - appels API tierces (sync, webhooks)
  - traitements lourds (PDF, images)
  - calculs/statistiques
- Choisir un transport robuste selon criticité/volume (RabbitMQ, Redis, Doctrine).
- Gérer retry + failed transport.

### D7) Qualité, analyse statique, modernisation
- Tests : PHPUnit.
- Couvrir la logique métier critique (unitaires + fonctionnels/intégration).
- Utiliser `WebTestCase` / `KernelTestCase` selon les besoins.
- Tester les cas d’erreur autant que les cas nominaux.
- PHPStan :
  - Niveau strict adapté au socle.
  - Les erreurs sont des problèmes de qualité, pas à ignorer.
- Rector :
  - Appliquer les transformations automatiques.
  - Revoir les changements avant fusion.

### D8) Performance & observabilité
- Mesurer avant d’optimiser.
- Mettre en cache ce qui est coûteux et stable.
- Logs structurés et corrélables.
- Déporter les traitements lourds en async (Messenger).

### D9) Logging & observabilité (Monolog & LogViewer)
- Monolog :
  - Injecter `LoggerInterface`.
  - Niveaux PSR-3 cohérents (info/error/critical).
  - Contexte structuré (`['user_id' => $id, ...]`) plutôt que concaténer des variables.
- Log viewer :
  - En dev/staging, possible (ex: `depictr/log-viewer-bundle`) si accès sécurisé (`ROLE_ADMIN`).
  - Ne pas exposer publiquement en prod sans protection forte (auth/IP).
- Par environnement :
  - Dev : sortie détaillée et lisible.
  - Prod : logs structurés (JSON) pour agrégation (ELK/Graylog/Datadog).

