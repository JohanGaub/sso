# Templates de mails (partage docs & formation)

Objectif : centraliser les mails prêts à envoyer, avec la liste des fichiers à transmettre.

## Pourquoi ici ?
- Le dossier `docs/` est déjà la source de vérité documentaire du projet.
- Ce fichier reste versionné, relisible et améliorable par l’équipe.
- On évite de re-demander "quoi envoyer" à chaque itération.

---

## Template 1 — Envoi pack formation Cursor à Romain

### Sujet
Pack formation : bonnes pratiques dev avec Cursor (rules + subagents)

### Corps du mail
Hello Romain,

Je te partage le pack applicable pour la formation "bonnes pratiques dev avec Cursor", avec un focus simple et actionnable.

Ordre recommandé de lecture :
1. `AGENTS.md` (point d’entrée rapide)
2. `docs/CURSOR_RULES.md` (fonctionnement et maintenance des rules)
3. `docs/SUBAGENTS_CURSOR.md` (création/usage des subagents)
4. `docs/STANDARDS_SYMFONY.md` (référentiel standards Symfony + décisions d’équipe)
5. `.github/pull_request_template.md` (template review)

Fichiers Cursor appliqués dans le projet :
- Rules :
  - `.cursor/rules/symfony-core.mdc`
  - `.cursor/rules/doctrine-and-persistence.mdc`
  - `.cursor/rules/security.mdc`
  - `.cursor/rules/git-commit-messages.mdc`
  - `.cursor/rules/pull-request-template.mdc`
- Subagents projet :
  - `.cursor/agents/verifier.md`
  - `.cursor/agents/security-reviewer.md`
  - `.cursor/agents/doc-curator.md`

À noter : la partie hooks est plus avancée. Elle sert à déclencher automatiquement des actions à un moment précis du process (exemple possible plus tard : génération automatique d’un brouillon de PR).

Objectif de la formation : savoir quand utiliser
- rules (standards stables),
- subagents (tâches procédurales/audit),
- docs (référence humaine).

---

## Checklist avant envoi
- Vérifier que les chemins de fichiers sont toujours valides.
- Vérifier que les documents pointés sont à jour.
- Retirer la section hooks si on reste en mode "ultra léger".

