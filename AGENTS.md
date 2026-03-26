# Instructions Agent (Cursor)

Ce projet utilise des **Project Rules Cursor** dans `.cursor/rules/` (format `.mdc`) et une doc support dans `docs/`.

- **Règles Cursor** : `.cursor/rules/` (courtes, actionnables, scoppées par contexte/fichiers)
- **Référentiel humain** : `docs/STANDARDS_SYMFONY.md`
- **Comment ça marche / maintenance** : `docs/CURSOR_RULES.md`

Principes clés :
- Logique métier dans des **services**, contrôleurs = orchestration.
- Code technique en **anglais** (y compris schéma DB).
- PSR-12 + conventions Symfony, lisibilité d’abord.

