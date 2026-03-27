# Skills Cursor — ultra léger (formation)

Objectif : utiliser des **skills** comme “commandes” simples, faciles à enseigner.

Référence officielle : `https://cursor.com/docs/context/skills`

---

## 1) À quoi ça sert ?

Un **skill** est un petit paquet versionné qui apprend à l’agent un workflow précis.  
Contrairement aux rules (standards toujours vrais), les skills servent surtout à des actions “à la demande”.

Dans Cursor, on les invoque via `/skill-name` dans le chat.

---

## 2) Où sont les skills du projet ?

Ils sont stockés dans :
- `.cursor/skills/`

Chaque skill est un dossier contenant un fichier `SKILL.md`.

---

## 3) Skills inclus (projet)

### `/pr-draft`
Génère un **brouillon de PR** basé sur :
- `.github/pull_request_template.md`
- l’état git (fichiers modifiés, derniers commits, diff stat)

### `/review-pack`
Produit un “pack review” court (résumé + test plan + fichiers à regarder) pour demander une review à un collègue.

---

## 4) Pourquoi c’est idéal pour la formation ?

- Simple : pas de config JSON, pas de scripts.
- Prévisible : on l’active explicitement.
- Facile à standardiser : même format pour toute l’équipe.

