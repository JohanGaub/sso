# Cursor Rules (projet) — fonctionnement & maintenance

## 1) Comment ça fonctionne (très concis)

Cursor charge des **instructions persistantes** pour l’Agent via :

- **Project Rules** : fichiers dans `.cursor/rules/` (versionnés dans git).
  - Les règles peuvent être :
    - **Always Apply** : appliquées à chaque session.
    - **Apply Intelligently** : appliquées si l’Agent juge pertinent (via `description`).
    - **Apply to Specific Files** : appliquées quand des fichiers correspondants sont en contexte (`globs`).
    - **Apply Manually** : appliquées quand on les @mentionne en chat.
- **AGENTS.md** : alternative simple (sans metadata), supportée à la racine et en sous-dossiers.

Référence officielle Cursor : `https://cursor.sh/docs/rules`

Note projet : la source de vérité des instructions Agent est `.cursor/rules/` (Project Rules) et `AGENTS.md`.

## 2) Comment actualiser (pragmatique et “éclairé”)

### Ce qu’on ne fait pas
Ne pas tenter un script “magique” qui **lit Internet et modifie le code automatiquement sans revue**.
Ça crée des régressions, mélange des opinions, et n’est pas un contrôle qualité fiable.

### Ce qu’on fait (recommandé)
Mettre en place une routine **automatisée + PR** :

- **(A) Mise à jour des standards / règles**
  - Modifier `docs/STANDARDS_SYMFONY.md` et/ou `.cursor/rules/*.mdc` uniquement quand :
    - on observe une erreur récurrente de l’Agent,
    - ou une évolution Symfony impacte réellement le projet (upgrade, deprecation majeure).
  - Règle d’or Cursor : garder les rules **courtes** et pointer vers la doc canonique.

- **(B) Mise à jour “codebase” automatisée, mais revue via PR**
  - Tous les jours/semaines (cron CI), exécuter :
    - `composer update` (selon politique : patch/minor)
    - `rector` (dry-run puis apply selon choix)
    - `phpstan`
    - tests
  - Puis ouvrir une **pull request** avec les diffs (revue obligatoire).

L’objectif réaliste n’est pas “implémenter automatiquement les nouvelles best practices Symfony”, mais :
**appliquer mécaniquement** ce qui est automatisable (deps + Rector + QA) et **documenter** ce qui est décisionnel.

### Variante “journalière” sûre
- Job quotidien : dépendances + QA + PR.
- Job mensuel (ou lors d’un ticket) : revue des best practices Symfony pertinentes pour le projet, puis ajustement des rules/docs.

## 3) Où modifier quoi (raccourci)
- Besoin d’un rappel IA actionnable → `.cursor/rules/*.mdc`
- Besoin d’un référentiel complet pour humains → `docs/STANDARDS_SYMFONY.md`
- Besoin d’expliquer le système → ce fichier `docs/CURSOR_RULES.md`

Voir aussi : `docs/SUBAGENTS_CURSOR.md` (guide complet subagents).
Voir aussi : `docs/HOOKS_CURSOR.md` (**avancé** : hooks, triggers automatiques).

## 4) Enchaînement simple (à retenir)
1. **Doc humaine** : formaliser la règle/procédure dans `docs/`.
2. **Rule Cursor** : extraire les points stables et courts dans `.cursor/rules/`.
3. **Subagent** : créer un spécialiste dans `.cursor/agents/` si la tâche est lourde/procédurale.
4. **Hook (avancé)** : automatiser un contrôle/traitement technique au bon moment (ex: génération auto de brouillon PR).
5. **PR template** : standardiser la review via `.github/pull_request_template.md`.

## 5) Sources (URLs)
- Cursor Rules : `https://cursor.sh/docs/rules`
- Cursor Hooks : `https://cursor.com/docs/hooks`
- Symfony Docs : `https://symfony.com/doc`
- Symfony Best Practices : `https://symfony.com/doc/current/best_practices.html`

