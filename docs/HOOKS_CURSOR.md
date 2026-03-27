# Hooks Cursor — guide pratique (**avancé**)

Objectif : comprendre rapidement comment les hooks complètent rules/subagents.

Référence officielle : `https://cursor.com/docs/hooks`

---

## 1) À quoi servent les hooks ?

Les hooks permettent d’exécuter automatiquement des contrôles/traitements autour du cycle agent.

Exemples utiles :
- lancer un format/check après édition,
- bloquer des commandes shell risquées,
- injecter du contexte au démarrage de session,
- contrôler des actions avant/après outils.

---

## 2) Où configurer ?

- **Projet** : `.cursor/hooks.json` (recommandé pour partager avec l’équipe)
- **Global utilisateur** : `~/.cursor/hooks.json`

Dans un projet, les scripts sont généralement placés dans `.cursor/hooks/`.

---

## 3) Deux types de hooks

- **Command-based** : script shell (stdin JSON → stdout JSON)
- **Prompt-based** : décision par prompt LLM (politique simple sans script)

Pour démarrer proprement en équipe : privilégier des hooks **simples, lisibles, non bloquants**.

---

## 4) Hooks pertinents pour ce projet (recommandation)

### Priorité 1 — observabilité sans risque
- `afterFileEdit` : log léger / rappel de vérification docs-index si fichiers docs modifiés.

### Priorité 2 — garde-fou shell
- `beforeShellExecution` : détecter commandes potentiellement dangereuses et demander confirmation.

### Priorité 3 — qualité post-réponse
- `stop` ou `afterAgentResponse` : générer un mini-récap de checks à exécuter (`task quality`, tests).

### Implémentation actuelle dans ce repo
- Config : `.cursor/hooks.json`
- Script : `.cursor/hooks/generate-pr-draft.sh`
- Sortie générée automatiquement : `.cursor/pr-draft.md`

Comportement :
- À la fin d’un run agent (`stop`), si des changements git existent, un brouillon PR est généré.
- Le brouillon réutilise le template `.github/pull_request_template.md`.
- Le fichier inclut aussi un contexte auto-collecté (fichiers modifiés, derniers commits, diff stat).

---

## 5) Enchaînement avec docs/rules/subagents

1. **Docs (`docs/`)** : explique le standard/process pour humains.
2. **Rules (`.cursor/rules/`)** : rappelle les standards de façon courte et stable.
3. **Subagents (`.cursor/agents/`)** : délègue des tâches spécialisées (verifier, security, doc-curator).
4. **Hooks (`.cursor/hooks.json`)** : automatise des contrôles techniques au bon moment.
5. **PR template (`.github/pull_request_template.md`)** : normalise la review finale.

---

## 6) Ce qu’on évite

- Hooks trop intrusifs au début (bloquants partout).
- Logique métier dans les hooks.
- Multiplication de scripts non maintenus.

Commencer petit (1-2 hooks), mesurer la valeur, puis étendre.

