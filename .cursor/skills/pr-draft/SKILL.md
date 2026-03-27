---
name: pr-draft
description: Generate a reviewer-friendly pull request draft based on .github/pull_request_template.md and current git changes. Use when preparing a PR.
disable-model-invocation: true
---

# PR Draft

## When to use
- Use this skill when the user asks to prepare a pull request description.
- This is intentionally manual (`/pr-draft`) for simplicity in training sessions.

## Instructions
1. Check `git status --short`. If empty, explain there is nothing to draft.
2. Read `.github/pull_request_template.md`.
3. Produce a PR body that follows the template sections:
   - Summary (why + goal)
   - Changes (high impact only)
   - Test plan (commands + what was validated)
   - Risks and rollback
   - Checklist (only items that apply)
4. Add an "Auto-collected context" appendix:
   - changed files list
   - last 5 commits (`git log --oneline -n 5`)
   - diff stat (`git diff --stat`)
5. Keep it concise and review-friendly. Prefer concrete facts over generic text.

