# Subagents Cursor — guide simple (création & usage)

Objectif : comprendre **facilement** comment créer et utiliser des subagents Cursor dans ce projet.

Référence officielle : `https://cursor.com/docs/context/subagents`

---

## 1) Mental model (à retenir)

- **Rules** (`.cursor/rules/`) : “lois” courtes et stables (standards, conventions).
- **Docs** (`docs/`) : référentiel humain détaillé (pour apprendre / arbitrer).
- **Subagents** (`.cursor/agents/`) : “spécialistes” qui exécutent des tâches (audit, recherche, tests) avec **contexte isolé**.

Les subagents sont utiles quand la tâche :
- produit beaucoup de sortie (recherche, logs),
- nécessite une expertise “rôle” (sécurité, vérification),
- ou doit tourner en parallèle d’une autre.

---

## 2) Où les mettre (dans le repo)

Créer des subagents projet dans :
- **`.cursor/agents/`** (recommandé, versionné, partagé à l’équipe)

Chaque subagent est un fichier Markdown (ex: `.cursor/agents/verifier.md`) contenant :
- un frontmatter YAML (nom, description, modèle, readonly, etc.)
- puis un prompt clair et court.

---

## 3) Format d’un subagent (template)

Copier/coller puis adapter :

```markdown
---
name: verifier
description: Validates completed work. Use after tasks are marked done to confirm implementations are functional.
model: fast
readonly: true
---

You are a skeptical validator.

When invoked:
1. Restate what should be true (requirements / acceptance criteria)
2. Check that the implementation exists in the codebase
3. Run relevant verification steps (tests, lint, static analysis) if available
4. Report issues with concrete file paths and exact failures

Output:
- Passed checks
- Failed checks (with evidence)
- What remains to do
```

Notes :
- `readonly: true` est souvent une bonne idée pour un verifier (il audite, il ne modifie pas).
- `model: fast` est utile pour les audits/recherches et garder un coût bas.

---

## 4) Exemples recommandés pour ce projet

### 4.1 `verifier` (qualité / cohérence)
But : vérifier que les changements respectent :
- `docs/STANDARDS_SYMFONY.md`
- les rules `.cursor/rules/*.mdc`
- la cohérence docs/index

### 4.2 `security-reviewer` (auth, secrets, accès)
But : revue sécurité ciblée quand on touche :
- `config/packages/security*.yaml`
- `src/Security/**`
- `Voter`, authenticator, login flows, JWT, etc.

Template minimal :

```markdown
---
name: security-reviewer
description: Security specialist. Use when touching authentication, authorization, secrets, or user data.
model: inherit
readonly: true
---

You are a security reviewer for Symfony applications.

When invoked:
1. Identify security-sensitive changes
2. Check authn/authz logic (firewalls, voters, roles)
3. Check secrets handling (no hardcoded credentials, use Symfony secrets)
4. Check input validation and error exposure

Report by severity: Critical / High / Medium / Low.
```

---

## 5) Comment les utiliser (pratique)

Cursor peut déléguer automatiquement, mais pour être explicite (recommandé au début) :

- Dans le chat, demander :
  - “Utilise le subagent **verifier** pour valider que cette PR est OK”
  - “Utilise le subagent **security-reviewer** sur les changements d’auth”

Selon la doc Cursor, on peut aussi les invoquer via une syntaxe `/name` (ex: `/verifier ...`) quand disponible.

---

## 6) Bonnes pratiques (à ne pas rater)

- Un subagent = **une responsabilité claire**.
- Descriptions précises : c’est ce qui aide Cursor à choisir quand l’utiliser.
- Prompts courts, orientés résultats (checklist + format de sortie).
- Versionner les subagents du projet dans git pour que toute l’équipe en profite.

